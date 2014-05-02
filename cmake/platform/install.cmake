# Copyright (C) 2012-2013  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.


# http://www.cmake.org/Wiki/CMake_Useful_Variables
# Since CMake 2.1 the install rule depends on all,
# i.e. everything will be built before installing.
# If you don't like this, set this one to true.
set (CMAKE_SKIP_INSTALL_ALL_DEPENDENCY YES)


include_directories (${CMAKE_BINARY_DIR}/_headers_)


function (__setup_global_headers)
    set (_GLOBAL_HEADERS ${CMAKE_BINARY_DIR}/_headers_)
    set (_PROJECT_GLOBAL_HEADERS ${_GLOBAL_HEADERS}/${PROJECT_NAME})

    file (MAKE_DIRECTORY ${_PROJECT_GLOBAL_HEADERS})

    set (GLOBAL_HEADERS ${_GLOBAL_HEADERS} PARENT_SCOPE)
    set (PROJECT_GLOBAL_HEADERS ${_PROJECT_GLOBAL_HEADERS} PARENT_SCOPE)
endfunction ()


function (__install_header_files_with_prefix NAME PREFIX OUTPUT_FILES ...)
    set (ARGS ${ARGV})
    if ("${PREFIX}" STREQUAL "")
    list (REMOVE_AT ARGS 0 1)
    else ()
        list (REMOVE_AT ARGS 0 1 2)
        set (PREFIX_ORIG ${PREFIX})
        set (PREFIX "${PREFIX}/")
    endif ()

    foreach (ARG IN LISTS ARGS)
        if (${ARG} MATCHES "^[\\/].+:[^:]+$")
            string (REGEX REPLACE "^(.+):[^:]+$"       "\\1" HEADER_SRC     "${ARG}")
            string (REGEX REPLACE "^.+:([^:]+)$"       "\\1" HEADER_DST     "${ARG}")
            string (REGEX REPLACE "^((.+[\\/])*).+$"   "\\1" HEADER_DST_DIR "${PREFIX}${HEADER_DST}")
        elseif (${ARG} MATCHES "^.+:[^:]+$")
            string (REGEX REPLACE "^(.+):[^:]+$"       "\\1" HEADER_SRC     "${ARG}")
            string (REGEX REPLACE "^.+:([^:]+)$"       "\\1" HEADER_DST     "${ARG}")
            string (REGEX REPLACE "^((.+[\\/])*).+$"   "\\1" HEADER_DST_DIR "${PREFIX}${HEADER_DST}")
            set (HEADER_SRC "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_SRC}")
        elseif (${ARG} MATCHES "^[\\/].+$")
            string (REGEX REPLACE "^(.+)$"             "\\1" HEADER_SRC     "${ARG}")

            if (IS_DIRECTORY ${HEADER_SRC})
                set (HEADER_DST)
                set (HEADER_DST_DIR ${PREFIX})
            else ()
                string (REGEX REPLACE "^.*[\\/]([^\\/]+)$" "\\1" HEADER_DST     "${ARG}")
                string (REGEX REPLACE "^((.+[\\/])*).+$"   "\\1" HEADER_DST_DIR "${PREFIX}${HEADER_DST}")
            endif ()
        elseif (${ARG} MATCHES "^.+$")
            string (REGEX REPLACE "^(.+)$"             "\\1" HEADER_SRC     "${ARG}")
            set (HEADER_SRC "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_SRC}")

            if (IS_DIRECTORY ${HEADER_SRC})
                set (HEADER_DST)
                set (HEADER_DST_DIR ${PREFIX})
            else ()
                string (REGEX REPLACE "^.*[\\/]([^\\/]+)$" "\\1" HEADER_DST     "${ARG}")
                string (REGEX REPLACE "^((.+[\\/])*).+$"   "\\1" HEADER_DST_DIR "${PREFIX}${HEADER_DST}")
            endif ()
        else ()
            message (FATAL_ERROR "Invalid argument: ${ARG}\nShould be '<path to source header file or directory>[:<destination file name or directory>]'")
        endif ()

        if (IS_DIRECTORY ${HEADER_SRC})
            set (ARGS_RECURSION)

            if (NOT ${HEADER_DST} STREQUAL "")
                set (HEADER_DST "${HEADER_DST}/")
            endif ()

            foreach (extension "*.h" "*.hpp" "*.hxx")
                file (GLOB CHILDREN RELATIVE ${HEADER_SRC} ${HEADER_SRC}/${extension})

                foreach (child ${CHILDREN})
                    list (APPEND ARGS_RECURSION "${HEADER_SRC}/${child}:${HEADER_DST}${child}")
                endforeach ()
            endforeach ()

            if (ARGS_RECURSION)
                __install_header_files_with_prefix (${NAME} "${PREFIX_ORIG}" LOCAL_OUTPUT_FILES ${ARGS_RECURSION})
            endif ()
        else ()
            add_custom_command (OUTPUT ${GLOBAL_HEADERS}/${PREFIX}${HEADER_DST}
                                COMMAND cmake -E copy ${HEADER_SRC} ${GLOBAL_HEADERS}/${PREFIX}${HEADER_DST}
                                DEPENDS ${HEADER_SRC})

            list (APPEND GENERATED_FILES "${GLOBAL_HEADERS}/${PREFIX}${HEADER_DST}")

            if (CMAKE_CROSSCOMPILING)
                install (FILES ${GLOBAL_HEADERS}/${PREFIX}${HEADER_DST}
                         DESTINATION ${TARGET}/include/${HEADER_DST_DIR})
            else ()
                install (FILES ${GLOBAL_HEADERS}/${PREFIX}${HEADER_DST}
                         DESTINATION include/${HEADER_DST_DIR})
            endif ()
        endif ()

        set (${OUTPUT_FILES}
             ${${OUTPUT_FILES}}
             ${LOCAL_OUTPUT_FILES}
             ${GENERATED_FILES}
             PARENT_SCOPE)
    endforeach ()
endfunction ()


function (install_header_files_with_prefix NAME PREFIX ...)
    if (NOT TARGET ${NAME}_headers)
        __setup_global_headers ()

        set (ARGS ${ARGV})
        if ("${PREFIX}" STREQUAL "")
            list (REMOVE_AT ARGS 0)
        else ()
            list (REMOVE_AT ARGS 0 1)
        endif ()

        __install_header_files_with_prefix (${NAME} "${PREFIX}" GENERATED_FILES ${ARGS})

        add_custom_target (${NAME}_headers DEPENDS ${GENERATED_FILES})
        add_dependencies (${NAME} ${NAME}_headers)
    else ()
        message (FATAL_ERROR "Function 'install_header_files_with_prefix' can be called only once in each directory!")
    endif ()
endfunction ()


function (install_header_files NAME ...)
    if (NOT TARGET ${NAME}_headers)
        set (ARGS ${ARGV})
        list (REMOVE_AT ARGS 0)
        install_header_files_with_prefix (${NAME} ${PROJECT_NAME} ${ARGS})
    else ()
        message (FATAL_ERROR "Function 'install_header_files' can be called only once in each directory!")
    endif ()
endfunction ()


function (install_cmake_files ...)
    foreach (ARG IN LISTS ARGV)
        if (${ARG} MATCHES "^[\\/].+:[^:]+$")
            string (REGEX REPLACE "^(.+):[^:]+$" "\\1" HEADER_SRC "${ARG}")
        elseif (${ARG} MATCHES "^.+:[^:]+$")
            string (REGEX REPLACE "^(.+):[^:]+$" "\\1" HEADER_SRC "${ARG}")
            set (HEADER_SRC "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_SRC}")
        else ()
            message (FATAL_ERROR "Invalid argument: ${ARG}\nShould be '<path to CMake file>:<destination file name>'")
        endif ()

        string (REGEX REPLACE "^.+:([^:]+)$"     "\\1" HEADER_DST     "${ARG}")
        string (REGEX REPLACE "^((.+[\\/])*).+$" "\\1" HEADER_DST_DIR "${HEADER_DST}")

        install (FILES ${HEADER_SRC} DESTINATION share/cmake/Modules/${HEADER_DST_DIR})
    endforeach ()
endfunction ()


function (install_target NAME)
    if (CMAKE_CROSSCOMPILING)
        install (TARGETS ${NAME}
                 RUNTIME DESTINATION bin
                 LIBRARY DESTINATION ${TARGET}/lib
                 ARCHIVE DESTINATION ${TARGET}/lib)
    else ()
        install (TARGETS ${NAME}
                 RUNTIME DESTINATION bin
                 LIBRARY DESTINATION lib
                 ARCHIVE DESTINATION lib)
    endif ()
endfunction ()
