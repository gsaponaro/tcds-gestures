# Copyright: (C) 2017 VisLab, Institute for Systems and Robotics,
#                Instituto Superior Técnico, Universidade de Lisboa, Lisbon, Portugal
# Author: Giovanni Saponaro <gsaponaro@isr.tecnico.ulisboa.pt>
# CopyPolicy: Released under the terms of the GNU GPL v3.0.

cmake_minimum_required(VERSION 2.8.9)

project(humanHandProcessor)

find_package(YARP)
set(YARP_REQUIRED_VERSION 3.1.0)
find_package(ICUBcontrib)

list(APPEND CMAKE_MODULE_PATH ${ICUBCONTRIB_MODULE_PATH})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include(ICUBcontribHelpers)
include(ICUBcontribOptions)
icubcontrib_set_default_prefix()

set(folder_source src/Helpers.cpp
                  src/HumanHandProcessorMain.cpp
                  src/HumanHandProcessorModule.cpp)

set(folder_header include/Helpers.h
                  include/HumanHandProcessorModule.h)

source_group("Header Files" FILES ${folder_header})
source_group("Source Files" FILES ${folder_source})

include_directories(${PROJECT_SOURCE_DIR}/include
                    ${ICUB_INCLUDE_DIRS})

add_executable(${PROJECT_NAME} ${folder_source} ${folder_header})

target_link_libraries(${PROJECT_NAME} ${YARP_LIBRARIES})

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
