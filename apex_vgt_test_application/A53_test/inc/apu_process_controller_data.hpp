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
*  @file    apu_process_controller_data.hpp
*  @brief   Process controller data class
***********************************************************************************/

#ifndef APUPROCESSCONTROLLERDATA_HPP
#define APUPROCESSCONTROLLERDATA_HPP

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <umat.hpp>

namespace apugen{

/*!*********************************************************************************
*  @brief    Process controller data
*  @details  Object of this class represents I/O data for APEX2 Process Controller.
***********************************************************************************/

  template<typename SourceDataType, typename ConversionPolicy>
  class InputProcessControllerData : public ConversionPolicy
  {
    using ConversionPolicy::Conversion;
  public:
    /**
    * @brief    Constructs UMat for description of contigous data region
    * @param [in]   aRows        Number of rows (height)
    * @param [in]   aCols        Number of cols (width)
    * @param [in]   aType        Type of element: CV_8UC1, CV_64FC3, CV_32SC(12) etc.
    * @param [in]   aUsageFlags        Usage flags, if need to be specified
    */
    InputProcessControllerData(int32_t aRows, int32_t aCols, int32_t aType,
      const ConversionPolicy& aConvert = ConversionPolicy())
      : ConversionPolicy(aConvert), mGraphDescr(aRows, aCols, aType)
    {
    }

    void SetData(SourceDataType& data)
    {
      this->mData = &data;
      this->Conversion(this->mData, this->mGraphDescr);
    }

    SourceDataType * GetDataPtr()
    {
      return this->mData;
    }

    /**
    * @brief    Description of contiguous data region for graph
    */
    vsdk::UMat mGraphDescr;

    /**
    * @brief    Data that is associated with UMat
    */
    SourceDataType * mData;
  };

  /*!*********************************************************************************
  *  @brief    Process controller data
  *  @details  Object of this class represents I/O data for APEX2 Process Controller.
  ***********************************************************************************/
  template<typename SinkDataType, typename ConversionPolicy>
  class OutputProcessControllerData : public ConversionPolicy
  {
    using ConversionPolicy::Conversion;
  public:
    /**
    * @brief    Constructs UMat for description of contigous data region
    * @param [in]   aRows        Number of rows (height)
    * @param [in]   aCols        Number of cols (width)
    * @param [in]   aType        Type of element: CV_8UC1, CV_64FC3, CV_32SC(12) etc.
    * @param [in]   aUsageFlags        Usage flags, if need to be specified
    */
    OutputProcessControllerData(int32_t aRows, int32_t aCols, int32_t aType,
      const ConversionPolicy& aConvert = ConversionPolicy())
      : ConversionPolicy(aConvert), mGraphDescr(aRows, aCols, aType)
    {
      memset(this->mGraphDescr.getMat(cv::ACCESS_WRITE | OAL_USAGE_CACHED).data, 0, aRows * aCols * this->mGraphDescr.elemSize());
    }

    OutputProcessControllerData(const vsdk::UMat& m, const ConversionPolicy& aConvert = ConversionPolicy())
      : ConversionPolicy(aConvert), mGraphDescr(m)
    {
    }

    void GetData(SinkDataType& data)
    {
      this->Conversion(&data, this->mGraphDescr);
    }

    /**
    * @brief    Description of contiguous data region for graph
    */
    vsdk::UMat mGraphDescr;
  };
} /* namespace apugen */
#endif /* APUPROCESSCONTROLLERDATA_HPP */
