# Copyright (C) 2012-2013  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.


include_directories (${CMAKE_CURRENT_BINARY_DIR})

function (build_version_file_ex NAME VERSION_MAJOR VERSION_MINOR VERSION_RELEASE VERSION_BUILD)
    string (TOUPPER ${NAME} UPPER_NAME)
    string (TOLOWER ${NAME} LOWER_NAME)
    set (VERSION_FILE "${VERSION_FILE}#ifndef ${UPPER_NAME}_VERSION_H_")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_H_\n")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_ARCH    \"@VERSION_ARCH@\"")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_MAJOR   @VERSION_MAJOR@")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_MINOR   @VERSION_MINOR@")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_RELEASE @VERSION_RELEASE@")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_BUILD   @VERSION_BUILD@")
    set (VERSION_FILE "${VERSION_FILE}\n#define ${UPPER_NAME}_VERSION_STRING  \"@VERSION_MAJOR@.@VERSION_MINOR@.@VERSION_RELEASE@.@VERSION_BUILD@\"")

    set (VERSION_ARCH ${CMAKE_SYSTEM_PROCESSOR})
    get_target_property(target_type "${NAME}" TYPE)

    if ("${target_type}" STREQUAL "EXECUTABLE")
        set (VERSION_FILE "${VERSION_FILE}\n\nclass Executable;")
        set (VERSION_FILE "${VERSION_FILE}\nconst Executable *${LOWER_NAME}_module();")
    else ()
        set (VERSION_FILE "${VERSION_FILE}\n\nclass Library;")
        set (VERSION_FILE "${VERSION_FILE}\nconst Library *${LOWER_NAME}_module();")
    endif ()

    set (VERSION_FILE "${VERSION_FILE}\n\n#endif /* ${UPPER_NAME}_VERSION_H_ */")
    file (WRITE ${CMAKE_CURRENT_BINARY_DIR}/version.h.in "${VERSION_FILE}\n")

    if ("${target_type}" STREQUAL "EXECUTABLE")
        configure_file (${CMAKE_CURRENT_BINARY_DIR}/version.h.in ${CMAKE_CURRENT_BINARY_DIR}/${NAME}_version.h @ONLY)
    else ()
        __setup_global_headers ()
        string (TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

        configure_file (${CMAKE_CURRENT_BINARY_DIR}/version.h.in ${PROJECT_GLOBAL_HEADERS}/version.h @ONLY)

        if (CMAKE_CROSSCOMPILING)
            __get_compiler_target ()
            install (FILES ${PROJECT_GLOBAL_HEADERS}/version.h
                     DESTINATION ${TARGET}/include/${PROJECT_NAME_LOWER}
                     COMPONENT headers)
        else ()
            install (FILES ${PROJECT_GLOBAL_HEADERS}/version.h
                     DESTINATION include/${PROJECT_NAME_LOWER}
                     COMPONENT headers)
        endif ()
    endif ()
endfunction ()

function (build_version_file NAME VERSION)
    if (${VERSION} MATCHES "^([0-9]+).([0-9]+).([0-9]+)$")
        string (REGEX REPLACE "^([0-9]+).[0-9]+.[0-9]+$" "\\1" VERSION_MAJOR "${VERSION}")
        string (REGEX REPLACE "^[0-9]+.([0-9]+).[0-9]+$" "\\1" VERSION_MINOR "${VERSION}")
        string (REGEX REPLACE "^[0-9]+.[0-9]+.([0-9]+)$" "\\1" VERSION_RELEASE "${VERSION}")
    else ()
        message (FATAL_ERROR "Incorrect format of VERSION argument!")
    endif ()

    if ($ENV{BUILD_NUMBER})
        if ($ENV{BUILD_NUMBER} MATCHES "^[0-9]+$")
            build_version_file_ex (${NAME} ${VERSION_MAJOR} ${VERSION_MINOR} ${VERSION_RELEASE} $ENV{BUILD_NUMBER})
        else ()
            message (FATAL_ERROR "Incorrect format of BUILD_NUMBER environment variable!")
        endif ()
    else ()
        build_version_file_ex (${NAME} ${VERSION_MAJOR} ${VERSION_MINOR} ${VERSION_RELEASE} 0)
    endif ()
endfunction ()
