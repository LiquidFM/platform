project (platform)

# Tools
include (platform/stubs)

# Project header
project_cxx_library_header_default ()

# Target
add_library_stub (platform)

# Documentation
add_documentation ("platform" 1.2.0 "Platform definition header-only library")

# Install rules
install_header_files (platform "src/compiler.h:compiler.h"
                               "src/platform.h:platform.h"
                               "src/utils.h:utils.h")

install_cmake_files ("cmake/${PROJECT_NAME}/collect_files.cmake:${PROJECT_NAME}/collect_files.cmake"
                     "cmake/${PROJECT_NAME}/collect_sources.cmake:${PROJECT_NAME}/collect_sources.cmake"
                     "cmake/${PROJECT_NAME}/compiler_flags.cmake:${PROJECT_NAME}/compiler_flags.cmake"
                     "cmake/${PROJECT_NAME}/doxygen.cmake:${PROJECT_NAME}/doxygen.cmake"
                     "cmake/${PROJECT_NAME}/doxygen.conf.in:${PROJECT_NAME}/doxygen.conf.in"
                     "cmake/${PROJECT_NAME}/exclude_files.cmake:${PROJECT_NAME}/exclude_files.cmake"
                     "cmake/${PROJECT_NAME}/install.cmake:${PROJECT_NAME}/install.cmake"
                     "cmake/${PROJECT_NAME}/options.cmake:${PROJECT_NAME}/options.cmake"
                     "cmake/${PROJECT_NAME}/project_build_type.cmake:${PROJECT_NAME}/project_build_type.cmake"
                     "cmake/${PROJECT_NAME}/project_header.cmake:${PROJECT_NAME}/project_header.cmake"
                     "cmake/${PROJECT_NAME}/stubs.cmake:${PROJECT_NAME}/stubs.cmake"
                     "cmake/${PROJECT_NAME}/tests.cmake:${PROJECT_NAME}/tests.cmake"
                     "cmake/${PROJECT_NAME}/version.cmake:${PROJECT_NAME}/version.cmake"
                     "cmake/${PROJECT_NAME}/xrpc.cmake:${PROJECT_NAME}/xrpc.cmake"
                     "cmake/FindPlatform.cmake:FindPlatform.cmake")
