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

#include <opencv2/opencv.hpp>
#include <umat.hpp>
#include <iostream>
#include <ostream>

#include "../../A53_gen/inc/apu_apex_vgt_test_graph_process_controller.hpp"

using namespace cv;
using namespace std;
using namespace apugen;

APU_Apex_Vgt_TEST_GRAPH_Process_Controller::APU_Apex_Vgt_TEST_GRAPH_Process_Controller(int32_t apex_id) {
#ifdef APEX2_EMULATE
  pProc = new APEX_VGT_TEST_GRAPH_PI((APEX_ID)apex_id);
#else 
  pProc = new APEX_VGT_TEST_GRAPH_PI(apex_id);
#endif
}

APU_Apex_Vgt_TEST_GRAPH_Process_Controller::~APU_Apex_Vgt_TEST_GRAPH_Process_Controller() {
  delete pProc;
}

int32_t APU_Apex_Vgt_TEST_GRAPH_Process_Controller::Init() {
  int32_t lRetVal = 0;
  lRetVal |= pProc->Initialize();

  return lRetVal;
}

int32_t APU_Apex_Vgt_TEST_GRAPH_Process_Controller::Connect(vsdk::UMat& dataimageInput, vsdk::UMat& dataupsampleOutput, vsdk::UMat& datadownsampleOutput) {
  int32_t lRetVal = 0;
  lRetVal |= pProc->ConnectIO(GR_IMAGE_INPUT_IN, dataimageInput);
  lRetVal |= pProc->ConnectIO(GR_UPSAMPLE_OUTPUT_OUT, dataupsampleOutput);
  lRetVal |= pProc->ConnectIO(GR_DOWNSAMPLE_OUTPUT_OUT, datadownsampleOutput);


  return lRetVal;
}

int32_t APU_Apex_Vgt_TEST_GRAPH_Process_Controller::Start() {
  return pProc->Start();
}

int32_t APU_Apex_Vgt_TEST_GRAPH_Process_Controller::Wait() {
  return pProc->Wait();
}

