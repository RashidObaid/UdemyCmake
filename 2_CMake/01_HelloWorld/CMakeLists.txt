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

#Specify the Correct Sysroot (required for Error: 'wchar.h' File Not Found):
#It's essential to set the correct sysroot so the compiler looks in the right places for header files. 
#You should specify the macOS SDK path as your sysroot.
set(CMAKE_OSX_SYSROOT /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk)

#Required for macOS support. vcpkg supports microsoft windows by default. 
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build architecture for macOS" FORCE)
endif()

#CPM requires the library to be a CMake project, as it uses Fetch command under the hood
option(USE_CPM "Whether to use CPM" OFF)
option(USE_CONAN "Whether to use Conan" OFF)
option(USE_VCPKG "Whether to use VCPKG" ON)


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

if(USE_CPM)
    message(STATUS "Using CPM")
    include(CPM)
    cpmaddpackage("gh:nlohmann/json#v3.11.2")
    cpmaddpackage("gh:fmtlib/fmt#10.1.1")
    cpmaddpackage("gh:gabime/spdlog#v1.12.0")
    cpmaddpackage("gh:jarro2783/cxxopts#v3.1.1")
    cpmaddpackage("gh:catchorg/Catch2#v2.13.9")
elseif(USE_CONAN)
    message(STATUS "Using Conan")
    include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
    find_package(nlohmann_json REQUIRED)
    find_package(fmt REQUIRED)
    find_package(spdlog REQUIRED)
    find_package(cxxopts REQUIRED)
    find_package(Catch2 REQUIRED)
elseif(USE_VCPKG)
    message(STATUS "Using VCPKG")
    include(${CMAKE_SOURCE_DIR}/external/vcpkg/scripts/buildsystems/vcpkg.cmake)    
    find_package(nlohmann_json CONFIG REQUIRED)
    find_package(fmt CONFIG REQUIRED)
    find_package(spdlog CONFIG REQUIRED)
    find_package(cxxopts CONFIG REQUIRED)
    find_package(Catch2 CONFIG REQUIRED)  
else()
    message(STATUS "Using FetchContent")
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

endif()


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
