cmake_minimum_required(VERSION 3.16)
project(bg3se_macOS VERSION 0.0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(APPLE)
  list(APPEND CMAKE_PREFIX_PATH /opt/homebrew /usr/local)
endif()

include(FetchContent)

FetchContent_Declare(
  lua
  URL https://www.lua.org/ftp/lua-5.3.6.tar.gz
  URL_HASH SHA256=fcdf2e7172530f6c2e1c0c9cf0f5cf9f0d41c8cfe8b25c16c49f8db8afff141d
)

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
  GIT_TAG 7bd85a39f1ee22f6cf6f25e0c594bd2c3b013bc9
)

FetchContent_MakeAvailable(lua fmt fishhook imgui tinycrypt)

# Lua
add_library(lua STATIC
  ${lua_SOURCE_DIR}/lapi.c
  ${lua_SOURCE_DIR}/lcode.c
  ${lua_SOURCE_DIR}/lctype.c
  ${lua_SOURCE_DIR}/ldebug.c
  ${lua_SOURCE_DIR}/ldo.c
  ${lua_SOURCE_DIR}/ldump.c
  ${lua_SOURCE_DIR}/lfunc.c
  ${lua_SOURCE_DIR}/lgc.c
  ${lua_SOURCE_DIR}/llex.c
  ${lua_SOURCE_DIR}/lmem.c
  ${lua_SOURCE_DIR}/lobject.c
  ${lua_SOURCE_DIR}/lopcodes.c
  ${lua_SOURCE_DIR}/lparser.c
  ${lua_SOURCE_DIR}/lstate.c
  ${lua_SOURCE_DIR}/lstring.c
  ${lua_SOURCE_DIR}/ltable.c
  ${lua_SOURCE_DIR}/ltm.c
  ${lua_SOURCE_DIR}/lundump.c
  ${lua_SOURCE_DIR}/lvm.c
  ${lua_SOURCE_DIR}/lzio.c
  ${lua_SOURCE_DIR}/lauxlib.c
  ${lua_SOURCE_DIR}/lbaselib.c
  ${lua_SOURCE_DIR}/lbitlib.c
  ${lua_SOURCE_DIR}/lcorolib.c
  ${lua_SOURCE_DIR}/ldblib.c
  ${lua_SOURCE_DIR}/liolib.c
  ${lua_SOURCE_DIR}/lmathlib.c
  ${lua_SOURCE_DIR}/loslib.c
  ${lua_SOURCE_DIR}/lstrlib.c
  ${lua_SOURCE_DIR}/ltablib.c
  ${lua_SOURCE_DIR}/loadlib.c
  ${lua_SOURCE_DIR}/linit.c
)
target_include_directories(lua PUBLIC ${lua_SOURCE_DIR})

# TinyCrypt
add_library(tinycrypt STATIC
  ${tinycrypt_SOURCE_DIR}/lib/source/aes.c
  ${tinycrypt_SOURCE_DIR}/lib/source/ctr_mode.c
  ${tinycrypt_SOURCE_DIR}/lib/source/cbc_mode.c
  ${tinycrypt_SOURCE_DIR}/lib/source/sha256.c
  ${tinycrypt_SOURCE_DIR}/lib/source/hmac.c
  ${tinycrypt_SOURCE_DIR}/lib/source/utils.c
)
target_include_directories(tinycrypt PUBLIC ${tinycrypt_SOURCE_DIR}/lib/include)

# System packages
find_package(PkgConfig REQUIRED)
find_package(ZLIB REQUIRED)
find_package(BZip2 REQUIRED)
find_package(jsoncpp REQUIRED)
find_package(CURL REQUIRED)
find_package(SDL2 REQUIRED)
find_package(Vulkan REQUIRED)
pkg_check_modules(JSONCPP REQUIRED jsoncpp)

# Define your sources
file(GLOB_RECURSE PROJECT_SRC CONFIGURE_DEPENDS
  src/YourProjectSources/*.cpp
)

# Executable
add_executable(bg3se ${PROJECT_SRC})

# Link everything
target_link_libraries(bg3se
  PRIVATE
    lua
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
