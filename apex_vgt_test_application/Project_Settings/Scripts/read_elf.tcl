

set segments {}
# memory_name        Segment memory name
# f_exec        Boolean indicating segment is executable
# f_write        Boolean indicating segment is writable
# f_read        Boolean indicating segment is readable
# f_rwinit        Boolean indicating segment is a R/W init segment
# vaddr            Virtual address of segment
# paddr            Physical address of segment
# align            Alignment constraint of segment
# file_size        Segment byte size as occupied in Elf32 file
# mem_size        Segment byte size as occupied in memory after loading
# data            List of values found in the segment, values are passed as unsigned integers

set sections {}
# is_progsection    Boolean indicating section has initialiased data in it
# is_nobitssection    Boolean indicating section has uninitialiased data in it
# f_write        Boolean indicating section is writable
# f_alloc        Boolean indicating section needs to be allocated
# f_execinstr        Boolean indicating section executable
# f_rwinit        Boolean indicating section is a R/W init section
# name            Section name
# memory_name        Section memory name
# addr            Start address of section
# align            Alignment constraint of section
# section_size        Section byte size
# item_size        Byte size of section item
# data            List of values found in the section, values are passed as list of unsigned integers per section item
# symbols        List of symbol name lists per section item

set PF_X        1
set PF_W        2
set PF_R        4

set SHT_NULL        0
set SHT_PROGBITS    1
set SHT_SYMTAB        2
set SHT_STRTAB        3
set SHT_RELA        4
set SHT_HASH        5
set SHT_DYNAMIC        6
set SHT_NOTE        7
set SHT_NOBITS        8
set SHT_REL        9
set SHT_SHLIB        10
set SHT_DYNSYM        11
set SHT_INIT_ARRAY    14
set SHT_FINI_ARRAY    15
set SHT_PREINIT_ARRAY    16
set SHT_GROUP        17
set SHT_SYMTAB_SHNDX    18

set SHF_WRITE        1
set SHF_ALLOC        2
set SHF_EXECINSTR    4

set tctmemtab {}
set verbose 0

proc unsigned {bits args} {
    foreach varname $args {
        upvar 1 $varname var
        set var [ expr {$var}  & ((1 << $bits) - 1)]
    }
}

proc read_segments {chan} {
    seek $chan 28
    binary scan [read $chan 4] I phoff
    unsigned 32 phoff

    seek $chan 42
    binary scan [read $chan 4] SS phentsize phnum
    unsigned 16 phentsize phnum

    set next $phoff
    for {set i 0} {$i < $phnum} {incr i} {
        set seg {}
        seek $chan $next
        binary scan [read $chan $phentsize] IIIIIIII ptype poffset vaddr paddr fsize msize flags align
        set next [tell $chan]
        unsigned 32 ptype poffset vaddr paddr fsize msize flags align
        dict set seg f_exec    [ expr $flags & $::PF_X ]
        dict set seg f_write   [ expr $flags & $::PF_W ]
        dict set seg f_read    [ expr $flags & $::PF_R ]
        dict set seg f_rwinit  0
        dict set seg align     $align
        dict set seg offset    $poffset
        dict set seg file_size $fsize
        dict set seg mem_size  $msize
	set mem_name ""
	if {[llength $::tctmemtab] == 0 || [llength $::tctmemtab] <= $i} {
            foreach sect $::sections {
                if {[dict get $sect memory_name] == ""} { continue }
                    set addr [dict get $sect addr]
                if {[expr {$vaddr <= $addr && $addr < $vaddr+$msize}]} {
                    set mem_name [dict get $sect memory_name]
                    break
                }   
            }
            dict set seg vaddr [expr { $vaddr & 0x1FFFF } ]
            dict set seg paddr [expr { $paddr & 0x1FFFF } ]
            dict set seg memory_name $mem_name
        } else {
            dict set seg vaddr $vaddr
            dict set seg paddr $paddr
            if {[dict get [lindex $::tctmemtab $i] seg_idx] != $i} {
		    puts stderr "wrong mem table index"
		    exit 1
            }
	    set mem_name [dict get [lindex $::tctmemtab $i] seg_name]
	    dict set seg memory_name $mem_name
        }
        if {[string compare $mem_name "VMb"] == 0} {
            dict set seg vaddr [expr { $vaddr >> 7 } ]
            dict set seg paddr [expr { $paddr >> 7 } ]         
        }
        seek $chan $poffset
        set chunk [list]
        set chunksize 1
        set bits 8
        if {[info exists ::mem_width($mem_name)]} {
            set bits $::mem_width($mem_name)
            set chunksize [expr { $bits / 8 } ]
        }
        switch $bits {
            8  {set fmt c}
            16 {set fmt S}
            32 {set fmt I}
            default { set fmt c}
        }
        for {set j 0} {$j < $fsize} {incr j $chunksize } {
            if {$fmt == ""} {
                set val [read $chan $chunksize]
            } else {
                binary scan [read $chan $chunksize] $fmt val
                unsigned $bits val
            }
            lappend chunk $val
        }
        dict set seg data $chunk
        lappend ::segments $seg
    }
    if {$::verbose} {puts -nonewline stderr "seg table : "; puts stderr $::segments }
}

proc seg_compare { a b } {
	return [expr {[dict get $a seg_idx] - [dict get $b seg_idx]}]
}

proc read_sections {chan} {
    seek $chan 32
    binary scan [read $chan 4] I shoff
    unsigned 32 shoff

    seek $chan 46
    binary scan [read $chan 12] SSS shentsize shnum shstrndx
    unsigned 16 shentsize shnum shstrndx

    seek $chan [expr {$shoff + 16 + $shstrndx * $shentsize}]
    binary scan [read $chan 8] II strtaboff strtabsize
    unsigned 32 strtaboff strtabsize

    seek $chan $strtaboff
    set strtab [read $chan $strtabsize]

    set memstrtabidx    0
    set tctmemtabidx    0

    seek $chan $shoff
    for {set i 0} {$i < $shnum} {incr i} {
        binary scan [read $chan $shentsize] IIIIIIIIII name type flags addr offset size link _info align entsize
        unsigned 32 name type flags addr offset size link _info align entsize

        if {[string index $strtab $name] ne "\0"} {
            set end [expr {[string first \0 $strtab $name] - 1}]
            set str [string range $strtab $name $end]
            set sect {}
            dict set sect is_progsection [ expr $type == $::SHT_PROGBITS ]
            dict set sect is_nobitssection [ expr $type == $::SHT_NOBITS ]
            dict set sect f_write      [ expr $flags & $::SHF_WRITE ]
            dict set sect f_alloc      [ expr $flags & $::SHF_ALLOC ]
            dict set sect f_execinstr  [ expr $flags & $::SHF_EXECINSTR ]
            dict set sect f_rwinit     0
            dict set sect addr         $addr
            dict set sect align        $align
            dict set sect offset       $offset
            dict set sect section_size $size
            dict set sect item_size    $entsize
            dict set sect name         $str
            set pos [string last . $str]
            if {[expr {$pos >= 0}]} {
                set mem_name [string range $str [ expr { $pos + 1 } ] [string length $str]]
                dict set sect memory_name $mem_name
                if {[string compare $str ".memstrtab"] == 0} { set memstrtabidx $i }
                if {[string compare $str ".tctmemtab"] == 0} { set tctmemtabidx $i }
              } else {
                dict set sect memory_name $str
            }
        lappend ::sections $sect
        }
    }

    # search for segment to name table
    if {$memstrtabidx != 0 && $tctmemtabidx != 0} {
	set sect        [lindex $::sections [expr {$memstrtabidx - 1}]]
	seek $chan      [dict get $sect offset]
        set memstrtab   [read $chan [dict get $sect section_size]]
        set sect        [lindex $::sections [expr {$tctmemtabidx - 1}]]
        seek $chan      [dict get $sect offset]
        for {set sz 0} {$sz < [dict get $sect section_size]} {incr sz 8} {
            binary scan [read $chan 8] II seg_idx seg_name
	    lappend ::tctmemtab [dict create    \
                seg_idx $seg_idx        \
                seg_name [string range $memstrtab $seg_name        \
                            [expr {[string first \0 $memstrtab $seg_name] - 1}]]]
        }
	set ::tctmemtab [lsort -command seg_compare $::tctmemtab]
        if {$::verbose} {puts -nonewline stderr "mem table : "; puts stderr $::tctmemtab }
    }
}

proc process {filename {pattern ""}} {
    set chan [open $filename rb]
    read $chan 1
    if {[read $chan 3] ne "ELF"} {
    error "unsupported format"
    }
    read_sections $chan
    read_segments $chan
    close $chan
}


namespace eval readelf {
    namespace export segments sections command_line_args
    variable command_line_args

    proc sections {} { return $::sections }
    proc segments {} { return $::segments }
}

set target {}
set elffile {}
array set mem_width {}
set readelf::command_line_args [list]
if {$argc >= 2} {
    for {set i 0} {$i < $argc} {incr i} {
        set arg [lindex $argv $i]
        if {[string first "-t" $arg] == 0} {
            incr i;
            set target [lindex $argv $i]
        } elseif {[string first "-p" $arg] == 0} {
            foreach {k v} [split [string range $arg 2 end] =] {set mem_width($k) $v}
        } elseif {[string first "-m" $arg] == 0} {
            foreach {k v} [split [string range $arg 2 end] =] {set mem_width($k) $v}
	} elseif {[string first "-e" $arg] == 0} {
	} elseif {[string first "-v" $arg] == 0} {
	 	set verbose 1
	} elseif {[string first "-T" $arg] == 0} {
                lappend readelf::command_line_args [string range $arg 2 end]        
        } elseif {$elffile == {}} {
            set elffile $arg
        } else {
            puts "illegal $arg"
            exit 1
        }
    }
    if {[file exists $elffile] != 0} {
        process $elffile
        if {$target != {}} {
        source $target
        }
    }
} else {
    puts "usage: Elffile -t format_script"
}