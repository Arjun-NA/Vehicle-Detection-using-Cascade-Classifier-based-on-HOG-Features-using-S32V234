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

#include "apu_app_config.hpp"

#include <iostream>
#include <fstream>

#ifdef APEX2_EMULATE
std::string APU_App_Config::mCfgName;
std::string APU_App_Config::mLastError;
std::map<std::string, std::string> APU_App_Config::mCfgContents;

bool APU_App_Config::LoadConfig(const std::string &cfgName) {
  mCfgName = cfgName;
  return ParseConfig();
}

void APU_App_Config::ExtractKey(std::string &key, const size_t &iSeparator, const std::string &line) {
  key = line.substr(0, iSeparator);
  if (key.find('\t') != line.npos || key.find(' ') != line.npos) {
    key.erase(key.find_first_of("\t "));
  }
}

void APU_App_Config::ExtractValue(std::string &value, const size_t &iSeparator, const std::string &line) {
  value = line.substr(iSeparator + 1);
  value.erase(0, value.find_first_not_of("\t "));
  value.erase(value.find_last_not_of("\t ") + 1);
}

bool APU_App_Config::IsValidLine(const std::string &line) {
  std::string tmpLine = line;
  tmpLine.erase(0, tmpLine.find_first_not_of("\t "));
  if (tmpLine[0] == '=') {
    return false;
  }

  for (size_t i = tmpLine.find('=') + 1; i < tmpLine.length(); i++) {
    if (tmpLine[i] != ' ') {
      return true;
    }
  }

  return false;
}

bool APU_App_Config::IsOnlyWhitespaceAndEOL(const std::string &line) {
  bool isOnlyWspace = (line.find_first_not_of(" \t\n\v\f\r") == line.npos);
  return isOnlyWspace;
}

void APU_App_Config::RemoveComment(std::string &line) {
  if (line.find('#') != line.npos) {
    line.erase(line.find('#'));
  }
}

bool APU_App_Config::ExtractContents(const std::string &line) {
  std::string tmpLine = line;
  tmpLine.erase(0, tmpLine.find_first_not_of("\t "));
  size_t iSeparator = tmpLine.find('=');

  std::string key, value;
  ExtractKey(key, iSeparator, tmpLine);
  ExtractValue(value, iSeparator, tmpLine);

  if (ContainsKey(key) == false) {
    mCfgContents.insert(std::pair<std::string, std::string>(key, value));
    return true;
  } else {
    mLastError = "APU_App_Config: Not unique key.\n";
    return false;
  }
}

bool APU_App_Config::ParseLine(const std::string &line, const size_t nLine) {
  if (line.find('=') == line.npos) {
    std::ostringstream ostr;
    ostr << nLine;
    mLastError = "APU_App_Config: Couldn't find separator on line: " + ostr.str() + "\n";
    return false;
  }

  if (IsValidLine(line) == false) {
    std::ostringstream ostr;
    ostr << nLine;
    mLastError = "APU_App_Config: Wrong format of the line: " + ostr.str() + "\n";
    return false;
  }

  return ExtractContents(line);
}

bool APU_App_Config::ParseConfig() {
  std::ifstream cfg;
  cfg.open(mCfgName.c_str());
  if (!cfg) {
    mLastError = "APU_App_Config: Couldn't fins file " + mCfgName + ".\n";
  }

  bool isNoErrors = false;
  std::string line;
  size_t nLine = 0;

  while (std::getline(cfg, line)) {
    nLine++;
    if (line.empty()) {
      continue;
    }

    std::string tmpLine = line;
    RemoveComment(tmpLine);
    if (IsOnlyWhitespaceAndEOL(tmpLine)) {
      continue;
    }
    isNoErrors = ParseLine(tmpLine, nLine);
    if (isNoErrors == false) {
      break;
    }
  }

  cfg.close();
  return isNoErrors;
}

bool APU_App_Config::ContainsKey(const std::string &key) {
  bool isKeyExists =  (mCfgContents.find(key) != mCfgContents.end());
  return isKeyExists;
}

std::string APU_App_Config::GetLastError() {
  return mLastError;
}
#endif
