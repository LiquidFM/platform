# - Find platform
# Find the platform library
#
#  This module defines the following variables:
#     PLATFORM_FOUND   - True if PLATFORM_INCLUDE is found
#     PLATFORM_INCLUDE - where to find header files


if (NOT PLATFORM_FOUND)
    find_path (PLATFORM_INCLUDE
               NAMES "platform/platform.h"
               PATH_SUFFIXES include
               DOC "Platform include directory")

    # handle the QUIETLY and REQUIRED arguments and set PLATFORM_FOUND to TRUE if all listed variables are TRUE
    include (FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS (Platform DEFAULT_MSG PLATFORM_INCLUDE)

    mark_as_advanced (PLATFORM_INCLUDE)
endif ()
