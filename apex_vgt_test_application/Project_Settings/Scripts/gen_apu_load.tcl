

proc make_int {vnm} {
   upvar $vnm v

   if {![string length $v]} {
      set v 0
   }
}

# Procedure to remove an element from a list
proc lremove {listVariable value} {
    upvar 1 $listVariable var
    set idx [lsearch -exact $var $value]
    set var [lreplace $var $idx $idx]
}

proc dump_segments_info {seg} {
   set s_memory_name  [dict get $seg memory_name]
   set s_vaddr        [dict get $seg vaddr]
   set s_paddr        [dict get $seg paddr]
   set s_align        [dict get $seg align]
   set s_file_size    [dict get $seg file_size]
   set s_mem_size     [dict get $seg mem_size]

   set s_f_exec       [dict get $seg f_exec]
   set s_f_write      [dict get $seg f_write]
   set s_f_read       [dict get $seg f_read]
   set s_f_rwinit     [dict get $seg f_rwinit]
   
   if ($s_f_exec)    { set s_f_exec   "E" } else { set s_f_exec   " " }
   if ($s_f_write)   { set s_f_write  "W" } else { set s_f_write  " " }
   if ($s_f_read)    { set s_f_read   "R" } else { set s_f_read   " " }
   if ($s_f_rwinit)  { set s_f_rwinit "I" } else { set s_f_rwinit " " }
   
   puts [ format {// %-8s %08X (%08X) %4i %8i %8i %s%s%s%s }  $s_memory_name $s_paddr $s_vaddr $s_align $s_file_size $s_mem_size $s_f_exec $s_f_write $s_f_read $s_f_rwinit]
}

proc is_segment_data_zero {seg}  {
   foreach { val } [dict get $seg data] {
      make_int val;
      if {$val != 0} {
         return 1;
      }
   }
   return 0;
}


# Load command line arguments: load name
# Load command line arguments
set argsd [dict create]
foreach a $readelf::command_line_args {
dict set argsd {*}[split $a =]
}

# Usage
proc usage { } {
puts stderr "Usage:"
puts stderr " -Tload_name=<name>"
exit 1
}
# Check command line arguments
if {![dict exists $argsd load_name]} { usage }

# Loop over sections

set headerstring {
/************************************************************************************************** 
 *                                                                                                  
 * NXP Confidential Proprietary                                                                     
 *                                                                                                  
 * Copyright 2017 NXP                                                                               
 * All Rights Reserved                                                                              
 *                                                                                                  
 *****************************************************************************                      
 *                                                                                                  
 * THIS SOFTWARE IS PROVIDED BY NXP "AS IS" AND ANY EXPRESSED OR                                  
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES                        
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.                          
 * IN NO EVENT SHALL NXP OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT,                              
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES                               
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR                               
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)                               
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,                              
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING                            
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF                                   
 * THE POSSIBILITY OF SUCH DAMAGE.                                                                  
 *                                                                                                  
 **************************************************************************************************/
}

puts "$headerstring"

puts [ format "#ifndef _%s_APU_LOAD_H_" [dict get $argsd load_name] ]
puts [ format "#define _%s_APU_LOAD_H_" [dict get $argsd load_name] ]
puts  "#include <stdint.h>"
puts  "#ifndef SEG_HOST_TYPE"
puts  "typedef int64_t  SEG_HOST_TYPE;"
puts  "typedef uint32_t SEG_MEM_TYPE;"
puts  "#endif"
puts  "// =============================================================="
puts  "// SECTIONS"
puts  "// --------------------------------------------------------------"
set sec_nbr      0

foreach ss [readelf::sections] {
   # Print segment information
   set s_section_name [dict get $ss name]
   set s_memory_name  [dict get $ss memory_name]
   set s_section_size [dict get $ss section_size]
   puts [ format {// SEC[%2i] %-12s %-12s %-12s} $sec_nbr $s_section_name $s_memory_name $s_section_size ]
   incr sec_nbr
}

set seg_nbr      0
set sec_nbr      0

# Loop over segments
puts  "// =============================================================="
puts  "// SEGMENTS"
puts  "// --------------------------------------------------------------"
foreach s [readelf::segments] {
   # Print section information
   set s_memory_name  [dict get $s memory_name]
   set s_vaddr        [dict get $s vaddr]
   set s_paddr        [dict get $s paddr]
   set s_align        [dict get $s align]
   set s_file_size    [dict get $s file_size]
   set s_mem_size     [dict get $s mem_size]

   set s_f_exec       [dict get $s f_exec]
   set s_f_write      [dict get $s f_write]
   set s_f_read       [dict get $s f_read]
   set s_f_rwinit     [dict get $s f_rwinit]
   
   if ($s_f_exec)    { set s_f_exec   "E" } else { set s_f_exec   " " }
   if ($s_f_write)   { set s_f_write  "W" } else { set s_f_write  " " }
   if ($s_f_read)    { set s_f_read   "R" } else { set s_f_read   " " }
   if ($s_f_rwinit)  { set s_f_rwinit "I" } else { set s_f_rwinit " " }
   
   puts [format {// SEG[%2i] %-8s %08X (%08X) %4i %8i %8i %s%s%s%s }  \
      $seg_nbr \
      $s_memory_name $s_paddr $s_vaddr $s_align $s_file_size $s_mem_size $s_f_exec $s_f_write $s_f_read $s_f_rwinit]
      incr seg_nbr
}

# Configuration
puts  "// =============================================================="
# DMEM RANGE
set dm_beg       0
set dm_end   69632
# puts [format {// DMEM [ %06X %06X ] } $dm_beg $dm_end ]

# Segment Information
set pmem_seg_nbr 0
set pmem_data {}
set pmem_size    0

set dmem_seg_nbr 0
set dmem_data {}
# array unset dmem_data
set dmem_size    0

array unset bank_addr
array unset bank_data
array unset bank_indx

set vmem_seg_nbr 0
set vmem_data {}
set vmem_size    0

# ==========================================================================================
# PMEM

# PMEM SEGMENTS
puts "// =============================================================="
foreach seg [readelf::segments] {

   switch -exact -- [dict get $seg memory_name] {

      PMh {
      
         dump_segments_info $seg

         # aligned start address (128-bits)
         set seg_addr [dict get $seg paddr]
         set seg_size [dict get $seg mem_size]
         
         set pmem_seg_addr($pmem_seg_nbr) $seg_addr
         set pmem_seg_size($pmem_seg_nbr) $seg_size
         set pmem_seg_offs($pmem_seg_nbr) $pmem_size
         set pmem_seg_type($pmem_seg_nbr) P
         incr pmem_seg_nbr

         set addr $seg_addr
         foreach { val0 } [dict get $seg data] {
          
            make_int val0;

            lappend pmem_data $addr; lappend pmem_data $val0; incr addr 4
            
            incr pmem_size 1
         }
      }
   }
}


# PMEM DATA
if {$pmem_seg_nbr > 0 } {

 
puts [ format {const int32_t %s_LOAD_PMEM_SIZE = %8i;} [dict get $argsd load_name] $pmem_size ]

if {$pmem_size > 0} {
   
   # 
   set w [ expr { ((($pmem_size + 3) >> 2) << 2) } ]
   puts [ format {const SEG_MEM_TYPE %s_LOAD_PMEM[%8i] = } [dict get $argsd load_name] $w ]
   puts "\{"

   set offset 0
   foreach {add0 val0 add1 val1 add2 val2 add3 val3} $pmem_data {

      make_int add0; make_int add1; make_int add2; make_int add3;
      make_int val0; make_int val1; make_int val2; make_int val3;

      puts [format { 0x%08XU, 0x%08XU, 0x%08XU, 0x%08XU, // (%8i) %08X} $val0 $val1 $val2 $val3 $offset $add0 ]
      incr offset 4
   }
   puts "\};"
}
}

# ==========================================================================================
# DMEM

# DMEM SEGMENTS
puts "// =============================================================="
foreach seg [readelf::segments] {

   switch -exact -- [dict get $seg memory_name] {

      DMb {
      
         dump_segments_info $seg

         # Get segment addresses + sizes
         set seg_addr [dict get $seg paddr]
         set seg_size [dict get $seg mem_size]

         set seg_beg $seg_addr
         set seg_end [ expr { $seg_beg + $seg_size } ]

         set addr_beg $seg_addr 
         set addr_end [ expr { $addr_beg + $seg_size } ]
         
         puts [ format {//    [ %08X %08X ] (%6i) } $addr_beg $addr_end $seg_size ]

         # Range DMEM (not now)
         # if {$addr_beg <  $dm_beg} { set addr_beg $dm_beg }
         # if {$addr_beg >  $dm_end} { set addr_beg $dm_end }
         # if {$addr_end <  $dm_beg} { set addr_end $dm_beg }
         # if {$addr_end >  $dm_end} { set addr_end $dm_end }

         # Align data (128-bit, 16 bytes)
         set addr_beg [ expr {(($addr_beg     )>>4)<<4} ]
         set addr_end [ expr {(($addr_end + 15)>>4)<<4} ]
         
         # is size a multiple of word size (128-bits)
         set addr_size [ expr { $addr_end - $addr_beg }]
         
         puts [ format {//    [ %08X %08X ] (%6i) } $addr_beg $addr_end $addr_size ]
         
         # is this a valid segments?
         
         
         # Find all zero segments
         set seg_zero 1
         foreach { val } [dict get $seg data] {
           make_int val;
           if {$val != 0} {
              set seg_zero 0
              break;
           }
         }
         

         if {$seg_zero == 1} {
            # Zero Segment
            set dmem_seg_addr($dmem_seg_nbr) $seg_beg
            set dmem_seg_size($dmem_seg_nbr) $seg_size
            set dmem_seg_offs($dmem_seg_nbr) 0
            set dmem_seg_type($dmem_seg_nbr) d
            incr dmem_seg_nbr
            
            # Pad the first/last words of the zero segment 
            # not required as the non zero segment will do it anyway
            
         } else {
            # if { ($seg_beg >= $dm_beg) && ($seg_beg < $dm_end) } 
            
               # Data Segment
               set dmem_seg_addr($dmem_seg_nbr) $seg_beg
               set dmem_seg_size($dmem_seg_nbr) $seg_size
               set dmem_seg_offs($dmem_seg_nbr) 0
               set dmem_seg_type($dmem_seg_nbr) D
               incr dmem_seg_nbr
               
               # Create an array with all addresses, initialize data to 0
               set addr $addr_beg
               while {$addr < $addr_end} {
                  # set band_addr($addr) $addr
                  if {[info exists bank_data($addr)] == 0 } {
                     set bank_data($addr) 0
                  }
                  incr addr 1
               }
               
               # Populate with data
               set addr $seg_addr         
               foreach { val } [dict get $seg data] {
                  make_int val;
                  set bank_data($addr) $val
                  incr addr 1
               }
            
         }
      }
   }
}

if {$dmem_seg_nbr > 0 } {

   puts [ format {// %6i } [array size bank_data ] ]
   # set bank_data_ [lsort -integer [array names bank_data]]
      
   # Create index
   set k 0
   foreach { addr data } [lsort -integer -stride 2 [array get bank_data]] {
   # foreach { addr data } $bank_data_  
      set bank_indx($addr) $k
      incr k
   }

   set dmem_size $k
   puts [ format {// %6i } $dmem_size ]
    
   # foreach { i addr } [ array get dmem_seg_addr ] 
   foreach { i addr } [lsort -integer -stride 2 [array get dmem_seg_addr]] {
      # set addr $dmem_seg_addr($i)
      puts [ format {// %-2s: %6i %6i } $dmem_seg_type($i) $i $addr ]
      if { $dmem_seg_type($i) == "D" } {
         set offset [ expr { ($bank_indx($addr)) } ]
         set dmem_seg_offs($i) [ expr { ($offset) >> 2 } ]
      }
   }
   
   # foreach { add0 val0 add1 val1 add2 val2 add3 val3 } [ array get bank_data_ ] 
   # foreach { add0 val0 add1 val1 add2 val2 add3 val3 } $bank_data_   
   foreach { add0 val0 add1 val1 add2 val2 add3 val3 } [lsort -integer -stride 2 [array get bank_data]] {
      set addr $add0
      make_int val0; make_int val1; make_int val2; make_int val3;
      set word [ expr {(((((($val3<<8)+$val2)<<8)+$val1)<<8)+$val0)} ]

      if { ($addr >= $dm_beg) && ($addr < $dm_end) } {
         lappend dmem_data $addr; lappend dmem_data $word;
      }
   }
}

# DMEM DATA
if { $dmem_seg_nbr > 0 } {
 
   puts [ format {const int32_t %s_LOAD_DMEM_SIZE = %8i;} [dict get $argsd load_name] $dmem_size ]

   if { $dmem_size > 0 } {
      
      # padding is already included, conversion from 8-bits to 32-bits words
      set w [ expr { ($dmem_size >> 2) } ]
      puts [ format {const SEG_MEM_TYPE %s_LOAD_DMEM[%8i] = } [dict get $argsd load_name] $w ]
      puts "\{"

      set offset 0
      # foreach { add0 val0 add1 val1 add2 val2 add3 val3 } [ array get bank_data ] 
      foreach {add0 val0 add1 val1 add2 val2 add3 val3} $dmem_data  {
         make_int add0; make_int add1; make_int add2; make_int add3;
         make_int val0; make_int val1; make_int val2; make_int val3;

         puts [format { 0x%08XU, 0x%08XU, 0x%08XU, 0x%08XU, // (%6i) %08X} $val0 $val1 $val2 $val3 $offset $add0 ]
         
         incr offset 4
      }
      puts "\};"
   }
}

# ==========================================================================================
# VMEM

# VMEM SEGMENTS
# DATA FORMAT: 256 = 32 x  8-bit
# PHYSICALLY,  512 = 32 x 16-bit
# So we need to interleaved 2 words

# VMEM SEGMENTS
puts "// =============================================================="
foreach seg [readelf::segments] {

   switch -exact -- [dict get $seg memory_name] {

      VMb {
         dump_segments_info $seg
         
         set seg_addr [dict get $seg paddr]
         set seg_size [dict get $seg mem_size]
         
         # Find all zero segment
         set seg_zero 1
         foreach { val } [dict get $seg data] {
            make_int val;
            if {$val != 0} {
               set seg_zero 0
               break;
            }
         }
         
         if {$seg_zero == 1} {
            set  vmem_seg_addr($vmem_seg_nbr) $seg_addr
            set  vmem_seg_size($vmem_seg_nbr) $seg_size
            set  vmem_seg_offs($vmem_seg_nbr) $vmem_size
            set  vmem_seg_type($vmem_seg_nbr) c
            incr vmem_seg_nbr
         } else {
            # 
            set  vmem_seg_addr($vmem_seg_nbr) $seg_addr
            set  vmem_seg_size($vmem_seg_nbr) $seg_size
            set  vmem_seg_offs($vmem_seg_nbr) $vmem_size
            set  vmem_seg_type($vmem_seg_nbr) C
            incr vmem_seg_nbr
            
            set addr $addr_beg
            set index 0
            foreach {val0 val1} [dict get $seg data] {
            
               make_int val0
               make_int val1

               puts stderr [ format { [%4i](%08X) } $index $addr ]
               for {set c 0} {$c < 16} {incr c} {
                   set b0 [expr {$val0 & 0xff}]; set val0 [expr {$val0 >> 8}]
                   set b2 [expr {$val0 & 0xff}]; set val0 [expr {$val0 >> 8}]
                   set b1 [expr {$val1 & 0xff}]; set val1 [expr {$val1 >> 8}]
                   set b3 [expr {$val1 & 0xff}]; set val1 [expr {$val1 >> 8}]

                  set word [ expr {(((((($b3<<8)+$b2)<<8)+$b1)<<8)+$b0)} ]
                  
                  lappend vmem_data $addr; lappend vmem_data $word;
                  incr vmem_size
                  incr addr 4
                  
                  puts -nonewline stderr [format {%08X } $word ]
               }
               puts stderr ""
               incr index
            }            
         }
      }
   }
}

# VMEM DATA
if {$vmem_seg_nbr > 0 } {
 
puts [ format {const int32_t %s_LOAD_CMEM_SIZE = %8i;} [dict get $argsd load_name] $vmem_size ]

if {$vmem_size > 0} {
   
   # 
   set w [ expr { ((($vmem_size + 3) >> 2) << 2) } ]
   puts [ format {const SEG_MEM_TYPE %s_LOAD_CMEM[%8i] = } [dict get $argsd load_name] $w ]
   puts "\{"

   set offset 0
   foreach {add00 val00 add01 val01 add02 val02 add03 val03 \
            add10 val10 add11 val11 add12 val12 add13 val13 \
            add20 val20 add21 val21 add22 val22 add23 val23 \
            add30 val30 add31 val31 add32 val32 add33 val33 } $vmem_data {

      make_int add00; make_int add01; make_int add02; make_int add03;
      make_int val00; make_int val01; make_int val02; make_int val03;
      
      make_int add10; make_int add11; make_int add12; make_int add13;
      make_int val10; make_int val11; make_int val12; make_int val13;

      make_int add20; make_int add21; make_int add22; make_int add23;
      make_int val20; make_int val21; make_int val22; make_int val23;

      make_int add30; make_int add31; make_int add32; make_int add33;
      make_int val30; make_int val31; make_int val32; make_int val33;
      
      
      puts [format { 0x%08X, 0x%08X, 0x%08X, 0x%08X, \
                     0x%08X, 0x%08X, 0x%08X, 0x%08X, \
                     0x%08X, 0x%08X, 0x%08X, 0x%08X, \
                     0x%08X, 0x%08X, 0x%08X, 0x%08X, \
                           // (%6i) %08X} \
                           $val00 $val01 $val02 $val03 \
                           $val10 $val11 $val12 $val13 \
                           $val20 $val21 $val22 $val23 \
                           $val30 $val31 $val32 $val33 \
                           $offset $add00 ]
      
      incr offset 16
   }
   puts "\};"
}
}

# Documentation - Segment Table
puts "// =============================================================="
puts "// SEGMENTS"
for { set i 0 } { $i < $pmem_seg_nbr } { incr i } {
   puts [ format {// %-2s: %8i, 0x%08X, %8i, } $pmem_seg_type($i) $pmem_seg_offs($i) $pmem_seg_addr($i) $pmem_seg_size($i)  ]
}

for { set i 0 } { $i < $dmem_seg_nbr } { incr i } {
   puts [ format {// %-2s: %8i, 0x%08X, %8i, } $dmem_seg_type($i) $dmem_seg_offs($i) $dmem_seg_addr($i) $dmem_seg_size($i)  ]
}

for { set i 0 } { $i < $vmem_seg_nbr } { incr i } {
   puts [ format {// %-2s: %8i, 0x%08X, %8i, } $vmem_seg_type($i) $vmem_seg_offs($i) $vmem_seg_addr($i) $vmem_seg_size($i) ]
}

set seg_nbr [ expr {$pmem_seg_nbr + $dmem_seg_nbr + $vmem_seg_nbr} ]

puts "// =============================================================="
set pmem_name 0
set dmem_name 1
set vmem_name 2

if {$seg_nbr > 0 } {

   # set load name
   set ln [dict get $argsd load_name];

   puts "// TABLE FORMAT"
   puts "// MEMORY <$pmem_name>: IMEM | <$dmem_name>: DMEM | <$vmem_name>: CMEM | <-1>: END OF TABLE"
   puts "// SOURCE ADDRESS (or 0: BSS SECTION (ZERO INITIALIZE))"
   puts "// DESTINATION OFFSET   (BYTES)"
   puts "// TRANSFER SIZE        (BYTES)"
   
   puts [ format {const SEG_HOST_TYPE %s_LOAD_SEGMENTS[%i][4] = } $ln [ expr {$seg_nbr + 1} ] ]
   
   puts "\{"

   for { set i 0 } { $i < $pmem_seg_nbr } { incr i } {
      # puts [ format {// PM: %8i, 0x%08X, %8i, } $pmem_seg_offs($i) $pmem_seg_addr($i) $pmem_seg_size($i)  ]
      puts -nonewline "\{"
      if {$pmem_seg_type($i) == {P}} {
         puts -nonewline [ format { %2s,  (SEG_HOST_TYPE)(&%s_LOAD_PMEM[%4i]), 0x%08X, %6i }  $pmem_name    $ln       $pmem_seg_offs($i) $pmem_seg_addr($i) $pmem_seg_size($i) ] 
      } else {
         puts -nonewline [ format { %2s,                        0, 0x%08X, %6i }    $pmem_name              $pmem_seg_addr($i) $pmem_seg_size($i) ] 
      }
      puts            "\},"
   }

   for { set i 0 } { $i < $dmem_seg_nbr } { incr i } {
      # puts [ format {// DM: %8i, 0x%08X, %8i, } $dmem_seg_offs($i) $dmem_seg_addr($i) $dmem_seg_size($i)  ]
      puts -nonewline "\{"
      if {$dmem_seg_type($i) == {D}} {
         puts -nonewline [ format { %2s,  (SEG_HOST_TYPE)(&%s_LOAD_DMEM[%4i]), 0x%08X, %6i }  $dmem_name $ln $dmem_seg_offs($i)   $dmem_seg_addr($i) $dmem_seg_size($i) ]
      } else {
         puts -nonewline [ format { %2s,                        0, 0x%08X, %6i } $dmem_name                          $dmem_seg_addr($i) $dmem_seg_size($i) ]
      }
      puts            "\},"
   }

   for { set i 0 } { $i < $vmem_seg_nbr } { incr i } {
      # puts [ format {// VM: %8i, 0x%08X, %8i, } $vmem_seg_offs($i) $vmem_seg_addr($i) $vmem_seg_size($i)  ]
      puts -nonewline "\{"
      if {$vmem_seg_type($i) == {C}} {
         puts -nonewline [ format { %2s,  (SEG_HOST_TYPE)(&%s_LOAD_CMEM[%4i]), 0x%08X, %6i }  $vmem_name  $ln            $vmem_seg_offs($i) $vmem_seg_addr($i) $vmem_seg_size($i) ]
      } else {
         puts -nonewline [ format { %2s,                        0, 0x%08X, %6i } $vmem_name                    $vmem_seg_addr($i) $vmem_seg_size($i) ]
      }
      puts            "\},"
   }

   puts -nonewline "\{"
   puts -nonewline " -1, 0, 0, 0 "
   puts            "\},"
   
   puts "\};"
}

if {0} {

# Process each segments (no data)
puts stderr "// =============================================================="
foreach seg [readelf::segments] {

   switch -exact -- [dict get $seg memory_name] {

      DMb {

         dump_segments_info $seg

         set dmem_seg_addr [dict get $seg paddr]
         set dmem_seg_size [dict get $seg mem_size]
         
         set dmem_addr_beg $dmem_seg_addr
         set dmem_addr_end [ expr { $dmem_seg_addr + $dmem_seg_size }]
         
         puts [ format {//    [ %08X %08X ] (%6i) } $dmem_addr_beg $dmem_addr_end $dmem_seg_size ]
         
         # Range DMEM
         if {$dmem_addr_beg <  $dm_beg} { set dmem_addr_beg $dm_beg }
         if {$dmem_addr_beg >  $dm_end} { set dmem_addr_beg $dm_end }
         
         if {$dmem_addr_end <  $dm_beg} { set dmem_addr_end $dm_beg }
         if {$dmem_addr_end >  $dm_end} { set dmem_addr_end $dm_end }

         # start address is aligned?
         # is size a multiple of word size (128-bits)
         set dmem_seg_size [ expr { $dmem_addr_end - $dmem_addr_beg }]
         
         puts [ format {//    [ %08X %08X ] (%6i) } $dmem_addr_beg $dmem_addr_end $dmem_seg_size ]
         
         # ARRAY FORMAT?
         set dmem_addr($seg_nbr_dmem) $dmem_seg_addr
         set dmem_size($seg_nbr_dmem) $dmem_seg_size
         
         incr seg_nbr_dmem
      }

      PM {
      
         dump_segments_info $seg

         # start address is aligned?
         # is size a multiple of word size (128-bits)

         set pmem_seg_addr [dict get $seg paddr]
         set pmem_seg_size [dict get $seg mem_size]
         
         set pmem_addr($seg_nbr_pmem) $pmem_seg_addr
         set pmem_size($seg_nbr_pmem) $pmem_seg_size
         
         incr seg_nbr_pmem
      }

      VMb {
         dump_segments_info $seg
         
         set vmem_seg_addr [dict get $seg paddr]
         set vmem_seg_size [dict get $seg mem_size]
         
         set vmem_addr($seg_nbr_vmem) $vmem_seg_addr
         set vmem_size($seg_nbr_vmem) $vmem_seg_size
         
         incr seg_nbr_vmem
         
      }
   }
}
}


if {0} {

# DMEM DATA
if {$seg_nbr_dmem > 0 } {

   foreach seg [readelf::segments] {

      switch -exact -- [dict get $seg memory_name] {

         DMb {

            dump_segments_info $seg

            set dmem_tmp {}
            
            set addr [dict get $seg paddr]
            
            if {$dm_beg <= $addr && $addr < $dm_end} {
            
               foreach {val00 val01 val02 val03 val10 val11 val12 val13 val20 val21 val22 val23 val30 val31 val32 val33} [dict get $seg data] {

                  if {$dm_beg <= $addr && $addr < $dm_end} {
                  
                     make_int val00; make_int val01; make_int val02; make_int val03;
                     make_int val10; make_int val11; make_int val12; make_int val13;
                     make_int val20; make_int val21; make_int val22; make_int val23;
                     make_int val30; make_int val31; make_int val32; make_int val33;

                     set val0 [ expr {((((($val03*256)+$val02)*256)+$val01)*256+$val00)} ]
                     set val1 [ expr {((((($val13*256)+$val12)*256)+$val11)*256+$val10)} ]
                     set val2 [ expr {((((($val23*256)+$val22)*256)+$val21)*256+$val20)} ]
                     set val3 [ expr {((((($val33*256)+$val32)*256)+$val31)*256+$val30)} ]
                     
                     set dmem_data($addr) $val0; incr addr 1
                     set dmem_data($addr) $val1; incr addr 1
                     set dmem_data($addr) $val2; incr addr 1
                     set dmem_data($addr) $val3; incr addr 1
                  }
               }
            }
         }
      }
   }
}

# PMEM DATA
if {$seg_nbr_pmem > 0 } {

   foreach seg [readelf::segments] {

      switch -exact -- [dict get $seg memory_name] {

         PM {
         
            dump_segments_info $seg

            set addr [dict get $seg paddr]
               
            foreach { val0 val1 val2 val3 } [dict get $seg data] {
             
               make_int val0; make_int val1; make_int val2; make_int val3;

               set pmem_data($addr) $val0; incr $addr 1
               set pmem_data($addr) $val1; incr $addr 1
               set pmem_data($addr) $val2; incr $addr 1
               set pmem_data($addr) $val3; incr $addr 1 
            }
         }
      }
   }
}

}

if {0} {

foreach {a v} [ array get pmem_data ] {
puts [ format { %8i, %08X } $a $v ]
}

}


if {0} {

# set size [llength $dmem_data]
# set elem [lindex  $dmem_data 1]

set addr 0

set dm_size [ array size dmem_data ]

puts [ format {const uint32_t LOAD_DMEM_SIZE = %8i;} $dm_size ]

if {$dm_size > 0} {
   
   puts [ format {const uint32_t LOAD_DMEM[%8i] = } $dm_size ]
   puts "\{"
   
   
   for { set a 0 } { $a < $dm_size } { incr a 4 } {
   
      set a0 [ expr {$a + 0} ]
      set a1 [ expr {$a + 1} ]
      set a2 [ expr {$a + 2} ]
      set a3 [ expr {$a + 3} ]
      
      # make_int val0; make_int val1; make_int val2; make_int val3;
      set val0 [ $dmem_data($a0) ]; make_int val0; 
      set val1 [ $dmem_data($a1) ]; make_int val1; 
      set val2 [ $dmem_data($a2) ]; make_int val2; 
      set val3 [ $dmem_data($a3) ]; make_int val3; 
      
      puts [format {0x%08X, 0x%08X, 0x%08X, 0x%08X, // %08X} \
         $val0 $val1 $val2 $val3 \
         $a]
         
   }
   
   puts "\};"
}

# set pm_size [ expr { [llength $pmem] } ]
set pm_size [ array size pmem_data ]

set addr 0

puts [ format {const uint32_t LOAD_PMEM_SIZE = %8i;} $pm_size ]
if {$pm_size > 0} {
   
   puts [ format {const uint32_t LOAD_PMEM[%8i] = } $pm_size ]
   puts "\{"

   foreach {val0 val1 val2 val3} [ array get pmem_data ] {

      make_int val0; make_int val1; make_int val2; make_int val3;

      puts [format {%08X, %08X, %08X, %08X, // %08X} $val0 $val1 $val2 $val3 $addr ]
   
      incr addr 16
   }
}
}

proc do_nothing_data_vmem {} {
foreach seg [readelf::segments] {

   switch -exact -- [dict get $seg memory_name] {

      DMb {

         dump_segments_info $seg

         set dmem_tmp {}
         
         set addr [dict get $seg paddr]
         
         if {$dm_beg <= $addr && $addr < $dm_end} {
         
            foreach {val00 val01 val02 val03 val10 val11 val12 val13 val20 val21 val22 val23 val30 val31 val32 val33} [dict get $seg data] {

               if {$dm_beg <= $addr && $addr < $dm_end} {
               
                  make_int val00
                  make_int val01
                  make_int val02
                  make_int val03

                  make_int val10
                  make_int val11
                  make_int val12
                  make_int val13

                  make_int val20
                  make_int val21
                  make_int val22
                  make_int val23

                  make_int val30
                  make_int val31
                  make_int val32
                  make_int val33
                  
                  lappend dmem_tmp $val00 
                  lappend dmem_tmp $val01 
                  lappend dmem_tmp $val02 
                  lappend dmem_tmp $val03

                  lappend dmem_tmp $val10 
                  lappend dmem_tmp $val11 
                  lappend dmem_tmp $val12 
                  lappend dmem_tmp $val13

                  lappend dmem_tmp $val20 
                  lappend dmem_tmp $val21 
                  lappend dmem_tmp $val22 
                  lappend dmem_tmp $val23

                  lappend dmem_tmp $val30 
                  lappend dmem_tmp $val31 
                  lappend dmem_tmp $val32 
                  lappend dmem_tmp $val33
                  
                  # puts [format {0x%02X%02X%02X%02X, // %08X} $val3 $val2 $val1 $val0 $addr]
               }
               
               incr addr 16
             }
         }
         
         set dmem_data [ concat $dmem_data $dmem_tmp ]
         
         set dmem_seg_addr [dict get $seg paddr]
         set dmem_seg_size [ expr { [llength $dmem_tmp] / 4 } ]
         
         set dmem_addr($seg_nbr_dmem) $dmem_seg_addr
         set dmem_size($seg_nbr_dmem) $dmem_seg_size
         
         incr seg_nbr_dmem
         incr seg_nbr        
      }

      PM {
      
         dump_segments_info $seg

         set addr [dict get $seg paddr]
            
         # puts [format {PM@%04x} [dict get $seg paddr]]

         set pmem_tmp {}
         
         foreach { val0 val1 val2 val3 } [dict get $seg data] {
          
            make_int val0; make_int val1; make_int val2; make_int val3;

            # puts [format {%08x, //} $val0 $val1 $val2 $val3 $addr ]
            
            lappend pmem_tmp $val0 
            lappend pmem_tmp $val1 
            lappend pmem_tmp $val2 
            lappend pmem_tmp $val3
            
            incr $addr 16
         }
         
         set pmem_data [ concat $pmem_data $pmem_tmp ]
         
         set pmem_seg_addr [dict get $seg paddr]
         set pmem_seg_size [llength $pmem_tmp]
         
         set pmem_addr($seg_nbr_pmem) $pmem_seg_addr
         set pmem_size($seg_nbr_pmem) $pmem_seg_size
         
         incr seg_nbr_pmem
         incr seg_nbr        
      }

      VMb {

         puts [format {VMb@%04x} [dict get $seg paddr]]
         foreach {val0 val1} [dict get $seg data] {

            make_int val0
            make_int val1

            set bytes0 {}
            set bytes1 {}

            for {set i 0} {$i < 32} {incr i} {

                lappend bytes0 [expr {$val0 & 0xff}]
                set val0 [expr {$val0 >> 8}]
                lappend bytes1 [expr {$val1 & 0xff}]
                set val1 [expr {$val1 >> 8}]
            }

            set n 0

            # pattern { # foreach byte0 [lreverse $bytes0] byte1 [lreverse $bytes1] {    }
            # pattern { #     puts -nonewline [format {%02x%02x} $byte1 $byte0]          }
            # pattern { # }                                                              }
            # puts ""
         }
      }
   }
}
}
puts "#endif"
