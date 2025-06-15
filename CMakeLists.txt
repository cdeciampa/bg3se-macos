cmake_minimum_required(VERSION 3.16)
project(bg3se_macos VERSION 0.0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Example: send all built libs to their respective build dirs
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/External)

if(APPLE)
  list(APPEND CMAKE_PREFIX_PATH /opt/homebrew /usr/local)
endif()

include(FetchContent)

# Include headers
include_directories(include)

FetchContent_Declare(
  lua
  URL https://www.lua.org/ftp/lua-5.3.6.tar.gz
  URL_HASH SHA256=fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60
)

FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 10.1.1
)

FetchContent_Declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG v1.90.9
)

FetchContent_Declare(
  tinycrypt
  GIT_REPOSITORY https://github.com/intel/tinycrypt.git
  GIT_TAG b1fed54ce0f79e0e2ffbec7684bb4988a5f20607
)

FetchContent_MakeAvailable(lua fmt imgui tinycrypt)

# Lua
add_library(lua STATIC
  ${lua_SOURCE_DIR}/src/lapi.c
  ${lua_SOURCE_DIR}/src/lcode.c
  ${lua_SOURCE_DIR}/src/lctype.c
  ${lua_SOURCE_DIR}/src/ldebug.c
  ${lua_SOURCE_DIR}/src/ldo.c
  ${lua_SOURCE_DIR}/src/ldump.c
  ${lua_SOURCE_DIR}/src/lfunc.c
  ${lua_SOURCE_DIR}/src/lgc.c
  ${lua_SOURCE_DIR}/src/llex.c
  ${lua_SOURCE_DIR}/src/lmem.c
  ${lua_SOURCE_DIR}/src/lobject.c
  ${lua_SOURCE_DIR}/src/lopcodes.c
  ${lua_SOURCE_DIR}/src/lparser.c
  ${lua_SOURCE_DIR}/src/lstate.c
  ${lua_SOURCE_DIR}/src/lstring.c
  ${lua_SOURCE_DIR}/src/ltable.c
  ${lua_SOURCE_DIR}/src/ltm.c
  ${lua_SOURCE_DIR}/src/lundump.c
  ${lua_SOURCE_DIR}/src/lvm.c
  ${lua_SOURCE_DIR}/src/lzio.c
  ${lua_SOURCE_DIR}/src/lauxlib.c
  ${lua_SOURCE_DIR}/src/lbaselib.c
  ${lua_SOURCE_DIR}/src/lbitlib.c
  ${lua_SOURCE_DIR}/src/lcorolib.c
  ${lua_SOURCE_DIR}/src/ldblib.c
  ${lua_SOURCE_DIR}/src/liolib.c
  ${lua_SOURCE_DIR}/src/lmathlib.c
  ${lua_SOURCE_DIR}/src/loslib.c
  ${lua_SOURCE_DIR}/src/lstrlib.c
  ${lua_SOURCE_DIR}/src/ltablib.c
  ${lua_SOURCE_DIR}/src/loadlib.c
  ${lua_SOURCE_DIR}/src/linit.c
)
target_include_directories(lua PUBLIC ${lua_SOURCE_DIR})

# TinyCrypt
add_library(tinycrypt STATIC
  ${tinycrypt_SOURCE_DIR}/lib/source/aes_decrypt.c
  ${tinycrypt_SOURCE_DIR}/lib/source/aes_encrypt.c
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

# Gather sources
file(GLOB_RECURSE PROJECT_SRC CONFIGURE_DEPENDS
  SetupScripts/*.cpp
  BG3Extender/*.cpp
  BG3Udater/*.cpp
  CoreLib/*.cpp
  CrashReporter/*.cpp
  Docs/*.cpp
  LuaDebugger/*.cpp
  ResourceBundler/*.cpp
  SymbolTableGenerator/*.cpp
  UpdateSigner/*.cpp
)

# Shared library (MacOS .dylib) because Script Extender
add_library(bg3se-macos SHARED ${PROJECT_SRC})

# Ensure proper output file extension and name
set_target_properties(bg3se-macos PROPERTIES
    OUTPUT_NAME "bg3se_macos"
    SUFFIX ".dylib"
    INSTALL_NAME_DIR "@rpath"
)

# Link everything
target_link_libraries(bg3se-macos PRIVATE
    lua
    fmt::fmt
    imgui
    tinycrypt
    ${JSONCPP_LIBRARIES}
    ZLIB::ZLIB
    BZip2::BZip2
    CURL::libcurl
    SDL2::SDL2
    Vulkan::Vulkan
)

target_include_directories(bg3se-macos PRIVATE
  include
  ${ZLIB_INCLUDE_DIRS}
  ${BZIP2_INCLUDE_DIRS}
  ${JSONCPP_INCLUDE_DIRS}
)
