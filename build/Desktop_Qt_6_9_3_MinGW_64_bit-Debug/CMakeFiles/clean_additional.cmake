# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appCalc_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appCalc_autogen.dir\\ParseCache.txt"
  "appCalc_autogen"
  )
endif()
