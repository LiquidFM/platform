# Copyright (C) 2013  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


# Target
install (
    TARGETS qfm
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Prerequisites
include (InstallRequiredSystemLibraries)

set (EXECUTABLE_PATH "${CMAKE_INSTALL_PREFIX}/bin/qfm${CMAKE_EXECUTABLE_SUFFIX}")
set (MY_BUNDLE_UTILITIES_PATH "${qfm_SOURCE_DIR}/cmake/MyBundleUtilities.cmake")
configure_file(
    "${qfm_SOURCE_DIR}/cmake/FixBundle.cmake.in"
    "${qfm_BINARY_DIR}/FixBundle.cmake"
    @ONLY
)

install (SCRIPT "${qfm_BINARY_DIR}/FixBundle.cmake")
