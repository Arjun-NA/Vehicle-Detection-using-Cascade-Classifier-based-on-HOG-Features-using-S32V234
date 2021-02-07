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
*  @file    apu_apex_vgt__t_e_s_t__g_r_a_p_h_process_controller_policy.hpp
*  @brief   Policy for APEX2 process controller data
***********************************************************************************/

#ifndef APUAPEXVGTTESTGRAPHPROCESSCONTROLLERPOLICY_HPP
#define APUAPEXVGTTESTGRAPHPROCESSCONTROLLERPOLICY_HPP

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <umat.hpp>

#ifdef APEX2_EMULATE
#include "apu_app_config.hpp"
#endif

namespace apugen {

class apex_vgt_TEST_GRAPHimage_inputConversionPolicy
{
protected:
  void Conversion(cv::Mat* aSource, vsdk::UMat& aGraphDescr)
  {
    aGraphDescr = aSource->getUMat(cv::ACCESS_READ);
  }
};

class apex_vgt_TEST_GRAPHupsample_outputConversionPolicy
{
protected:
  void Conversion(cv::UMat* aSink, vsdk::UMat& aGraphDescr)
  {
    cv::UMat lUMat = (cv::UMat)aGraphDescr;
    *aSink = lUMat.clone();
  }
};

class apex_vgt_TEST_GRAPHdownsample_outputConversionPolicy
{
protected:
  void Conversion(cv::UMat* aSink, vsdk::UMat& aGraphDescr)
  {
    cv::UMat lUMat = (cv::UMat)aGraphDescr;
    *aSink = lUMat.clone();
  }
};

}  /* namespace apugen */

#endif /* APUAPEXVGTTESTGRAPHPROCESSCONTROLLERPOLICY_HPP */
