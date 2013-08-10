# - Find stlsoft
# Find the stlsoft library
#
#  This module defines the following variables:
#     STLSOFT_FOUND   - True if STLSOFT_INCLUDE are found
#     STLSOFT_INCLUDE - where to find export.h, etc.
#
# Copyright (C) 2012  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.

find_path (STLSOFT_INCLUDE
          NAMES "stlsoft.h"
          PATH_SUFFIXES "stlsoft"
          DOC "The Stlsoft include directory"
)
string (REGEX REPLACE "/stlsoft$" "" STLSOFT_INCLUDE ${STLSOFT_INCLUDE})


# handle the QUIETLY and REQUIRED arguments and set STLSOFT_FOUND to TRUE if all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Stlsoft DEFAULT_MSG STLSOFT_INCLUDE)

mark_as_advanced(STLSOFT_INCLUDE)
