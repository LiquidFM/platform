# - Find platform
# Find the platform library
#
#  This module defines the following variables:
#     PLATFORM_FOUND   - True if PLATFORM_INCLUDE is found
#     PLATFORM_INCLUDE - where to find header files
#     PLATFORM_LIBS    - the library files


find_path (PLATFORM_INCLUDE
          NAMES "platform/platform.h"
          PATHS ${CMAKE_FIND_ROOT_PATH}
          PATH_SUFFIXES include
          DOC "The Platform include directory"
          NO_CMAKE_FIND_ROOT_PATH)

set (PLATFORM_LIBS platform)

# handle the QUIETLY and REQUIRED arguments and set PLATFORM_FOUND to TRUE if all listed variables are TRUE
include (FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS (Platform DEFAULT_MSG PLATFORM_INCLUDE PLATFORM_LIBS)

mark_as_advanced (PLATFORM_INCLUDE PLATFORM_LIBS)


if (NOT TARGET platform)
    add_library_stub (platform)
endif ()
