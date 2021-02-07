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



/*!*********************************************************************************
*  @file    apex_vgt_test_graph_apu_process_desc.hpp
*  @brief   ACF Process Descriptor
***********************************************************************************/

#ifndef APEXVGTTESTGRAPHAPUPROCESSDESC_HPP
#define APEXVGTTESTGRAPHAPUPROCESSDESC_HPP

#include <acf_process_desc_apu.hpp>
#include "apex_vgt_test_graph_graph.hpp"

class ApexVgtTestGraphApuProcessDesc: public ACF_Process_Desc_APU
{
public:
  void Create()
  {
    Initialize(mGraph, "APEX_VGT_TEST_GRAPH");


  }

  ApexVgtTestGraphGraph mGraph;
};

#endif /* APEXVGTTESTGRAPHAPUPROCESSDESC_HPP */
