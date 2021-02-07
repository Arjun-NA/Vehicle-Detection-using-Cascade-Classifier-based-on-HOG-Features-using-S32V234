// --------------------------------------------------------------------------
// COPYRIGHT (c) Freescale 2009
// Freescale Confidential Proprietary
//  All Rights Reserved
// --------------------------------------------------------------------------
//!\file    typedefs.h
//!\brief   This file contains various type defines for datatypes
//
// TYPE: Header File
// DEPARTMENT: MSG
// CREATED BY: Jeff Loeliger  (B04629)
// --------------------------------------------------------------------------
// PURPOSE:  This file contains various type defines for datatypes
// --------------------------------------------------------------------------
// $Log: typedefs.h.rca $
// 
//  Revision: 1.1 Wed Mar  5 16:57:28 2014 B34391
//  *** empty comment string ***
// 
//  Revision: 1.3 Wed Jun 26 18:42:36 2013 amiteshk
//  dos2unix
// 
//  Revision: 1.2 Mon Jun 24 15:32:04 2013 amiteshk
//  ran dos2unix
// 
//  Revision: 1.1 Fri Jun 14 23:38:23 2013 amiteshk
//  initial version
// 
//  Revision: 1.1 Tue Apr 19 04:10:02 2011 AijazFatimaFSL
//  Initial version
// 
//  Revision: 1.3 Wed Jan  5 00:44:54 2011 B22414
//  *** empty comment string ***
// 
//  Revision: 1.2 Wed Dec 29 03:27:53 2010 B22414
//  *** empty comment string ***
// 
//  Revision: 1.1 Thu Mar  5 18:02:56 2009 AnkurSharmaFSL
//  Initial Check In
// --------------------------------------------------------------------------

#ifndef _TYPEDEFS_H_
#define _TYPEDEFS_H_

#ifdef __MWERKS__    //Metrowerk CodeWarrior
    #include <stdint.h>

    // Standard typedefs used by header files, based on ISO C standard
    typedef volatile int8_t vint8_t;
    typedef volatile uint8_t vuint8_t;

    typedef volatile int16_t vint16_t;
    typedef volatile uint16_t vuint16_t;

    typedef volatile int32_t vint32_t;
    typedef volatile uint32_t vuint32_t;

#else
#ifdef __ghs__    //GreenHills
    #include <stdint.h>

    // Standard typedefs used by header files, based on ISO C standard
    typedef volatile int8_t vint8_t;
    typedef volatile uint8_t vuint8_t;

    typedef volatile int16_t vint16_t;
    typedef volatile uint16_t vuint16_t;

    typedef volatile int32_t vint32_t;
    typedef volatile uint32_t vuint32_t;

    typedef int32_t int24_t;
    typedef uint32_t uint24_t;
    typedef vint32_t vint24_t;
    typedef vuint32_t vuint24_t;

    typedef signed char int8;
    typedef unsigned char uint8;
    typedef volatile signed char vint8;
    typedef volatile unsigned char vuint8;

    typedef signed short int16;
    typedef unsigned short uint16;
    typedef volatile signed short vint16;
    typedef volatile unsigned short vuint16;

    typedef signed int int32;
    typedef unsigned int uint32;
    typedef volatile signed int vint32;
    typedef volatile unsigned int vuint32;
#else
    #include <stdint.h>
    // This is needed for compilers that don't have a stdint.h file

//    typedef signed char int8_t;
//    typedef unsigned char uint8_t;
    typedef volatile signed char vint8_t;
    typedef volatile unsigned char vuint8_t;

//    typedef signed short int16_t;
//    typedef unsigned short uint16_t;
    typedef volatile signed short vint16_t;
    typedef volatile unsigned short vuint16_t;

//    typedef signed int int32_t;
//    typedef unsigned int uint32_t;
    typedef volatile signed int vint32_t;
    typedef volatile unsigned int vuint32_t;

#endif
#endif

typedef unsigned long  boolean;  /* Machine representation of a boolean */
#define SUCCESS  0
#define FAILURE  1
#endif  /*_TYPEDEFS_H_*/

/*********************************************************************
 *
 * Copyright:
 *	Freescale Semiconductor, INC. All Rights Reserved.
 *  You are hereby granted a copyright license to use, modify, and
 *  distribute the SOFTWARE so long as this entire notice is
 *  retained without alteration in any modified and/or redistributed
 *  versions, and that such modified versions are clearly identified
 *  as such. No licenses are granted by implication, estoppel or
 *  otherwise under any patents or trademarks of Freescale
 *  Semiconductor, Inc. This software is provided on an "AS IS"
 *  basis and without warranty.
 *
 *  To the maximum extent permitted by applicable law, Freescale
 *  Semiconductor DISCLAIMS ALL WARRANTIES WHETHER EXPRESS OR IMPLIED,
 *  INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A
 *  PARTICULAR PURPOSE AND ANY WARRANTY AGAINST INFRINGEMENT WITH
 *  REGARD TO THE SOFTWARE (INCLUDING ANY MODIFIED VERSIONS THEREOF)
 *  AND ANY ACCOMPANYING WRITTEN MATERIALS.
 *
 *  To the maximum extent permitted by applicable law, IN NO EVENT
 *  SHALL Freescale Semiconductor BE LIABLE FOR ANY DAMAGES WHATSOEVER
 *  (INCLUDING WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
 *  BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER
 *  PECUNIARY LOSS) ARISING OF THE USE OR INABILITY TO USE THE SOFTWARE.
 *
 *  Freescale Semiconductor assumes no responsibility for the
 *  maintenance and support of this software
 *
 ********************************************************************/


