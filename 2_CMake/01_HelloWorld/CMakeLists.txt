# 0.) Create Source and CMakeFile
# 1.) mkdir build
# 2.) cd build
# 3.) cmake ..   -  Generting the Build Files / Configure the Project
# 4.) cmake --build .
# 5.) ./Executable

cmake_minimum_required(VERSION 3.22)

project(
    CppProjectTemplate
    VERSION 1.0.0
    LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#Set this to ON, for unit test target to be generated; and testing to be carried out
option(ENABLE_TESTING "Enable a Unit Testing Build" ON)

option(ENABLE_WARNINGS "Enable Warnings" ON)
option(ENABLE_WARNINGS_AS_ERRORS "Enable Warnings as Errors" OFF)
#Run Warnings as Error would abort the compilation on 1 single Error

option(ENABLE_SANITIZE_ADDR "Enable ..." ON)
option(ENABLE_SANITIZE_UNDEF "Enable ..." OFF)

option(ENABLE_LTO "Enable ..." ON)

set(LIBRARY_NAME Library)
set(EXECUTABLE_NAME Executable)

#option(COMPILE_EXECUTABLE "Whether to compile the executable" OFF)
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")
include(addGitSubmodule)
include(docs)

#if you want to use a library that is not Cmake in a Cmake project
#add_git_submodule(external/json) 

#if it is a Cmake project to be included in Cmake project
include(FetchContent)

if(ENABLE_WARNINGS)
    include(warnings)
endif()

if(ENABLE_SANITIZE_ADDR OR ENABLE_SANITIZE_UNDEF)
    include(sanitizer)
    add_sanitizer_flags()
endif()

if(ENABLE_LTO)
    include(LTO)
endif()

FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json
    GIT_TAG v3.11.2
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(nlohmann_json)

FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt
    GIT_TAG 10.1.1
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(fmt)

FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog
    GIT_TAG v1.12.0
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(spdlog)

FetchContent_Declare(
    cxxopts
    GIT_REPOSITORY https://github.com/jarro2783/cxxopts
    GIT_TAG v3.1.1
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(cxxopts)

FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2
    GIT_TAG v2.13.9
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(Catch2)


add_subdirectory(configured)
add_subdirectory(external)
add_subdirectory(src)
add_subdirectory(app)
add_subdirectory(tests)

#if(COMPILE_EXECUTABLE)
#   add_subdirectory(app)
#else()
#    message("W/o exe. compiling")
#endif()
