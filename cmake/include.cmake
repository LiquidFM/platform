# Copyright (C) 2012-2013  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.


macro (generate_include_file TARGET FILE_NAME_DST FILE_NAME_SRC)
    if (${FILE_NAME_SRC} MATCHES "^[^/].*[^/]$")
        if (${FILE_NAME_DST} MATCHES "^[^/].*[^/]$")
            set (RES)
            string (REGEX MATCHALL "/" RES ${FILE_NAME_DST})
            list (LENGTH RES RES_LEN)
            math (EXPR RES_LEN "${RES_LEN} + 1")

            set (INCLUDE_FILE_PREFIX)
            foreach (_i_ RANGE 1 ${RES_LEN})
                set (INCLUDE_FILE_PREFIX "../${INCLUDE_FILE_PREFIX}")
            endforeach ()

            set (INCLUDE_FILE "#include \"${INCLUDE_FILE_PREFIX}${PROJECT_NAME}/${FILE_NAME_SRC}\"")
            file (WRITE ${CMAKE_SOURCE_DIR}/include/${FILE_NAME_DST} "${INCLUDE_FILE}\n")
            add_dependencies (${TARGET} ${CMAKE_SOURCE_DIR}/include/${FILE_NAME_DST})
        else ()
            message (FATAL_ERROR "Invalid format of target header file path!")
        endif ()
    else ()
        message (FATAL_ERROR "Invalid format of source header file path!")
    endif ()
endmacro ()

# platform/platform.h                         include/platform.h
# workspace/include/platform/platform.h       workspace/platform/include/platform.h
#include ../../


