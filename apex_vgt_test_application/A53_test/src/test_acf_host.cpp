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

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <umat.hpp>
#include <iostream>
#include <fstream>
#include <iomanip>

#include "../../A53_gen/inc/apu_apex_vgt_test_graph_process_controller.hpp"
#include "apu_apex_vgt__t_e_s_t__g_r_a_p_h_process_controller_policy.hpp"

#include "apu_process_controller_data.hpp"

using namespace cv;
using namespace std;
using namespace apugen;

#ifdef APEX2_EMULATE
#include "apu_app_config.hpp"
#include "apu_lib.hpp"
#include "apu_extras.hpp"
#include "acf_lib.hpp"
using namespace APEX2;
#else
#include <icp_data.h>
#include <apex.h>
#include <oal.h>
using namespace icp;
#endif
//Start of user code user_define
/*
 * This is the region protected from the source code emitter,
 * all the rest can be changed by the source code emitter without notice.
 */

#if !defined(APEX2_EMULATE)
#include "frame_output_v234fb.h"
#define CHNL_CNT io::IO_DATA_CH3
#endif
//End of user code

int TEST_CALL()
{
#ifdef APEX2_EMULATE
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stderr, NULL, _IONBF, 0);
  APU_App_Config::LoadConfig("./A53_inc/apu_app.cfg");
#endif

  

  #ifdef APEX2_EMULATE
    auto lapex_vgt_TEST_GRAPH0image_inputFileName = APU_App_Config::GetValue<std::string>("INPUT_ROOT") + "in_grey_256x256.png";
  #else
    auto lapex_vgt_TEST_GRAPH0image_inputFileName = "apex_vgt_test_application/in_grey_256x256.png/in_grey_256x256.png";
  #endif
  cv::Mat lImageapex_vgt_TEST_GRAPH0image_input = cv::imread(lapex_vgt_TEST_GRAPH0image_inputFileName, CV_LOAD_IMAGE_COLOR);

  //Start of user code declare_inputs
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  cv::UMat lapex_vgt_TEST_GRAPH0upsample_outputData;
  cv::UMat lapex_vgt_TEST_GRAPH0downsample_outputData;

  //Start of user code declare_outputs
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  //========================================================================
  // Processing part
  //========================================================================
  int32_t retVal = 0;

  APU_Apex_Vgt_TEST_GRAPH_Process_Controller apex_vgt_TEST_GRAPH0ProcessController(0);

  //-------------------------------- apuApexVgtTestGraph0ProcessController --------------------------------

  InputProcessControllerData<cv::Mat, apex_vgt_TEST_GRAPHimage_inputConversionPolicy> lapex_vgt_TEST_GRAPH0image_input(1, 1, VSDK_CV_8UC1);

  //Start of user code input_data_apex_vgt_TEST_GRAPH0
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  
  lapex_vgt_TEST_GRAPH0image_input.SetData(lImageapex_vgt_TEST_GRAPH0image_input);

  // Verification
  if (lapex_vgt_TEST_GRAPH0image_input.GetDataPtr()->empty())
  {
    cout << "Input image " << lapex_vgt_TEST_GRAPH0image_inputFileName << "was not found\n";
    exit(1);
  }
#ifdef APEX2_EMULATE
  imshow("ImageInlet0", *lapex_vgt_TEST_GRAPH0image_input.GetDataPtr());
#endif


  OutputProcessControllerData<cv::UMat, apex_vgt_TEST_GRAPHupsample_outputConversionPolicy> lapex_vgt_TEST_GRAPH0upsample_output(512, 512, VSDK_CV_8UC1);
  OutputProcessControllerData<cv::UMat, apex_vgt_TEST_GRAPHdownsample_outputConversionPolicy> lapex_vgt_TEST_GRAPH0downsample_output(128, 128, VSDK_CV_8UC1);

  //Start of user code output_data_apex_vgt_TEST_GRAPH0
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  retVal |= apex_vgt_TEST_GRAPH0ProcessController.Init();
  retVal |= apex_vgt_TEST_GRAPH0ProcessController.Connect(lapex_vgt_TEST_GRAPH0image_input.mGraphDescr, lapex_vgt_TEST_GRAPH0upsample_output.mGraphDescr, lapex_vgt_TEST_GRAPH0downsample_output.mGraphDescr);
  retVal |= apex_vgt_TEST_GRAPH0ProcessController.Start();
  retVal |= apex_vgt_TEST_GRAPH0ProcessController.Wait();
  
  //Start of user code apex_vgt_TEST_GRAPH0_after_run
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code
  
  if(retVal)
  {
    cout << "apex_vgt_TEST_GRAPH0ProcessController error\n";
    return retVal;
  }

  lapex_vgt_TEST_GRAPH0upsample_output.GetData(lapex_vgt_TEST_GRAPH0upsample_outputData);
  lapex_vgt_TEST_GRAPH0downsample_output.GetData(lapex_vgt_TEST_GRAPH0downsample_outputData);
  //Start of user code processing_part
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  //========================================================================
  // Display part
  //========================================================================
// Output the picture
#ifdef APEX2_EMULATE
  imshow("upsample_out", lapex_vgt_TEST_GRAPH0upsample_outputData);
  waitKey(0);
#endif

#ifdef APEX2_EMULATE
  auto lapex_vgt_TEST_GRAPH0upsample_outputFileName = APU_App_Config::GetValue<std::string>("OUTPUT_ROOT") + "out_gray_512x512.png";
#else
  auto lapex_vgt_TEST_GRAPH0upsample_outputFileName = "apex_vgt_test_application/out_gray_512x512.png";
#endif
  imwrite(lapex_vgt_TEST_GRAPH0upsample_outputFileName, lapex_vgt_TEST_GRAPH0upsample_outputData);
  // Output the picture
#ifdef APEX2_EMULATE
  imshow("downsample_out", lapex_vgt_TEST_GRAPH0downsample_outputData);
  waitKey(0);
#endif

#ifdef APEX2_EMULATE
  auto lapex_vgt_TEST_GRAPH0downsample_outputFileName = APU_App_Config::GetValue<std::string>("OUTPUT_ROOT") + "out_gray_128x128.png";
#else
  auto lapex_vgt_TEST_GRAPH0downsample_outputFileName = "apex_vgt_test_application/out_gray_128x128.png";
#endif
  imwrite(lapex_vgt_TEST_GRAPH0downsample_outputFileName, lapex_vgt_TEST_GRAPH0downsample_outputData);

  //Start of user code display_part
  /*
   * This is the region protected from the source code emitter,
   * all the rest can be changed by the source code emitter without notice.
   */
  
  //End of user code

  

  return 0;
}
