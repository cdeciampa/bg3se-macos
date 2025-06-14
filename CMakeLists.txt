cmake_minimum_required(VERSION 3.16)
project(bg3se_macOS VERSION 0.0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Homebrew search paths
if(APPLE)
  list(APPEND CMAKE_PREFIX_PATH /opt/homebrew /usr/local)
endif()

include(FetchContent)

FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 10.1.1
)
FetchContent_Declare(
  fishhook
  GIT_REPOSITORY https://github.com/facebook/fishhook.git
  GIT_TAG v0.4.0
)
FetchContent_Declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG v1.90.9
)
FetchContent_Declare(
  tinycrypt
  GIT_REPOSITORY https://github.com/intel/tinycrypt.git
  GIT_TAG 7bd85a39f1ee22f6cf6f25e0c594bd2c3b013bc9 # Stable as of June 2025
)

FetchContent_MakeAvailable(fmt fishhook imgui tinycrypt)

find_package(PkgConfig REQUIRED)
find_package(ZLIB REQUIRED)
find_package(BZip2 REQUIRED)
find_package(jsoncpp REQUIRED)
find_package(CURL REQUIRED)
find_package(SDL2 REQUIRED)
find_package(Vulkan REQUIRED)

pkg_check_modules(JSONCPP REQUIRED jsoncpp)

add_executable(bg3se ${THIRD_PARTY_SRC})
target_link_libraries(bg3se
  PRIVATE
    fmt::fmt
    fishhook
    imgui
    tinycrypt
    ${JSONCPP_LIBRARIES}
    ZLIB::ZLIB
    BZip2::BZip2
    CURL::libcurl
    SDL2::SDL2
    Vulkan::Vulkan
)

target_include_directories(bg3se PRIVATE
  ${ZLIB_INCLUDE_DIRS}
  ${BZIP2_INCLUDE_DIRS}
  ${JSONCPP_INCLUDE_DIRS}
)
