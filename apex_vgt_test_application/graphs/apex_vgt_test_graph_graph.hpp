
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
*  @file    apex_vgt_test_graph_graph.hpp
*  @brief   ACF graph
***********************************************************************************/

#ifndef APEXVGTTESTGRAPHGRAPH_HPP
#define APEXVGTTESTGRAPHGRAPH_HPP

#include <acf_graph.hpp>

#ifdef APEX2_EMULATE
#include "acf_lib.hpp"
using namespace APEX2;
#endif

#include "apex_vgt_test_graph_graph_names.h"

#include "upsample_acf.h"
#include "downsample_acf.h"

class ApexVgtTestGraphGraph: public ACF_Graph
{
public:
  ApexVgtTestGraphGraph() : ACF_Graph()
  {
    XREGISTER_ACF_KERNEL(UPSAMPLE_K);
    XREGISTER_ACF_KERNEL(DOWNSAMPLE_K);
  }

  void Create()
  {
    //set identifier for graph
    SetIdentifier("ApexVgtTestGraphGraph");

    //add kernels
    const std::string apu_upsample0("apu_upsample0");
    AddKernel(apu_upsample0, UPSAMPLE_KN);
    const std::string apu_downsample0("apu_downsample0");
    AddKernel(apu_downsample0, DOWNSAMPLE_KN);

    //add graph ports
    AddInputPort(GR_IMAGE_INPUT_IN);
    AddOutputPort(GR_UPSAMPLE_OUTPUT_OUT);
    AddOutputPort(GR_DOWNSAMPLE_OUTPUT_OUT);

    //specify connections
    Connect(GraphPort(GR_IMAGE_INPUT_IN), KernelPort(apu_upsample0, UPSAMPLE_KN_IN));
    Connect(GraphPort(GR_IMAGE_INPUT_IN), KernelPort(apu_downsample0, DOWNSAMPLE_KN_IN));
    Connect(KernelPort(apu_upsample0, UPSAMPLE_KN_OUT), GraphPort(GR_UPSAMPLE_OUTPUT_OUT));
    Connect(KernelPort(apu_downsample0, DOWNSAMPLE_KN_OUT), GraphPort(GR_DOWNSAMPLE_OUTPUT_OUT));
  }
};

#endif /* APEXVGTTESTGRAPHGRAPH_HPP */
