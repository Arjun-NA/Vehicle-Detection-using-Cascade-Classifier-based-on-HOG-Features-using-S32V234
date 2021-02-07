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
#ifdef APEX2_EMULATE

#ifndef APUAPPCONFIG_HPP
#define APUAPPCONFIG_HPP

#include <string>
#include <map>
#include <sstream>

template <typename T>
static T convertStrToType(std::string const &val) {
  std::istringstream istr(val);
  T returnVal;
  istr >> returnVal;
  return returnVal;
}

template <>
std::string convertStrToType<std::string>(std::string const &val) {
  return val;
}

class APU_App_Config {
private:
  static std::string mCfgName;
  static std::string mLastError;
  static std::map<std::string, std::string> mCfgContents;

  static bool ParseConfig();
  static bool ParseLine(const std::string &line, const size_t nLine);
  static bool ExtractContents(const std::string &line);
  static void ExtractKey(std::string &key, const size_t &sepPos, const std::string &line);
  static void ExtractValue(std::string &value, const size_t &sepPos, const std::string &line);
  static bool IsValidLine(const std::string &line);
  static bool IsOnlyWhitespaceAndEOL(const std::string &line);
  static void RemoveComment(std::string &line);
public:
  static bool LoadConfig(const std::string &cfgName);
  static bool ContainsKey(const std::string &key);
  static std::string GetLastError();

  template<typename TValue>
  static TValue GetValue(const std::string &key, const TValue &defaultValue = TValue()) {
    if (ContainsKey(key) == false) {
      return defaultValue;
    }
    std::string strValue = mCfgContents.find(key)->second;
    TValue retValue = convertStrToType<TValue>(strValue);

    return retValue;
  }
};

#endif /* APUAPPCONFIG_HPP */
#endif /* APEX2_EMULATE */
