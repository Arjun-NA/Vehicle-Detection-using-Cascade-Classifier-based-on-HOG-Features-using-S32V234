/*****************************************************************************
 *
 * Copyright 2018 NXP
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
 ****************************************************************************/

#ifndef APEXVGTTESTGRAPHKERNELLIST_H
#define APEXVGTTESTGRAPHKERNELLIST_H

#include "upsample_acf.h"
#include "downsample_acf.h"

KERNEL_INFO kernelInfoConcat(UPSAMPLE_K)
(
  UPSAMPLE_KN,
  2,
  __port(__index(0),
         __identifier(UPSAMPLE_KN_IN),
         __attributes(ATTR_IN|ATTR_CMEM|ATTR_NONSTATIC|ATTR_NONFIXED|ATTR_REG),
         __spatial_dep(1,1,1,1),
         __e0_data_type(d08u),
         __e0_size(1, 1),
         __ek_size(1, 1)),
  __port(__index(1),
         __identifier(UPSAMPLE_KN_OUT),
         __attributes(ATTR_OUT|ATTR_CMEM|ATTR_NONSTATIC|ATTR_NONFIXED|ATTR_REG),
         __spatial_dep(0,0,0,0),
         __e0_data_type(d08u),
         __e0_size(1, 1),
         __ek_size(2, 2))
);

KERNEL_INFO kernelInfoConcat(DOWNSAMPLE_K)
(
  DOWNSAMPLE_KN,
  2,
  __port(__index(0),
         __identifier(DOWNSAMPLE_KN_IN),
         __attributes(ATTR_IN|ATTR_CMEM|ATTR_NONSTATIC|ATTR_NONFIXED|ATTR_REG),
         __spatial_dep(0,0,0,0),
         __e0_data_type(d08u),
         __e0_size(1, 1),
         __ek_size(2, 2)),
  __port(__index(1),
         __identifier(DOWNSAMPLE_KN_OUT),
         __attributes(ATTR_OUT|ATTR_CMEM|ATTR_NONSTATIC|ATTR_NONFIXED|ATTR_REG),
         __spatial_dep(0,0,0,0),
         __e0_data_type(d08u),
         __e0_size(1, 1),
         __ek_size(1, 1))
);

#endif /* APEXVGTTESTGRAPHKERNELLIST_H */
