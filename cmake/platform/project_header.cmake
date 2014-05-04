# Copyright (C) 2012-2013  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


# Sets up Compiler and Linker flags in temporary variables.
include (platform/compiler_flags)

# Set up BUILD_TYPE variables.
include (platform/project_build_type)


function (set_sysroot_and_target)
    if (CMAKE_C_COMPILER)
        get_filename_component (SYSROOT "${CMAKE_C_COMPILER}" DIRECTORY)
        get_filename_component (SYSROOT "${SYSROOT}/.." ABSOLUTE)

        set (LANG $ENV{LANG})
        set ($ENV{LANG} "C")
        execute_process (COMMAND ${CMAKE_C_COMPILER} -v -c RESULT_VARIABLE RES ERROR_VARIABLE RES_STRING)
        set ($ENV{LANG} ${LANG})

        if (RES EQUAL 0)
            string (REGEX REPLACE "^(.*)Target: ([^\n]+)(.*)$" "\\2" _TARGET_ "${RES_STRING}")
        else ()
            message (FATAL_ERROR "Unable to determine SYSROOT directory!")
        endif ()

        set (TARGET ${_TARGET_} PARENT_SCOPE)
        set (SYSROOT_DIR ${SYSROOT} PARENT_SCOPE)
    else ()
        message (FATAL_ERROR "Unable to determine SYSROOT directory!")
    endif ()
endfunction ()

macro (print_system_info)
    if (WIN32)
        # Fix path delimeters
        file (TO_CMAKE_PATH ${CMAKE_INSTALL_PREFIX} CMAKE_INSTALL_PREFIX)
        # Require at least Windows 2000 (http://msdn.microsoft.com/en-us/library/Aa383745)
        add_definitions (-D_WIN32_WINNT=0x0500 -DWINVER=0x0500)
    endif ()

    if (CMAKE_CROSSCOMPILING)
        message (STATUS "Cross compiling to: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
    else ()
        message (STATUS "System: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
    endif ()
    message (STATUS "Processor: " ${CMAKE_HOST_SYSTEM_PROCESSOR})

    if (MSVC)
        message(STATUS "Compiler: MSVC, version: " ${MSVC_VERSION})
    elseif (BORLAND)
        message(STATUS "Compiler: BCC")
    elseif (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUC)
        message(STATUS "Compiler: GCC")
    else ()
        message (FATAL_ERROR "Unknown compiler")
    endif ()

    message (STATUS "CMake generates " ${CMAKE_GENERATOR})

    set_sysroot_and_target ()
endmacro ()


macro (set_c_flags C_FLAGS C_LINK_FLAGS STRICT_WARNINGS STD11 POSITION_INDEPENDENT_CODE STATIC_CRT COVERAGE PROFILE ABI)
    if (NOT ${ARGC} EQUAL 9)
        message (FATAL_ERROR "Wrong number of arguments passed to \"set_cxx_flags\" macros!")
    endif ()

    # Set up compiler flags
    set_compiler_and_linker_flags ()
    set (${C_FLAGS} "${C_BASE_FLAGS}")

    if (${STRICT_WARNINGS})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_STRICT_WARNINGS_FLAGS}")
    endif ()

    if (${STD11})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_STD11_FLAGS}")
    endif ()

    if (${POSITION_INDEPENDENT_CODE})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_POSITION_INDEPENDENT_CODE_FLAGS}")
    endif ()

    if (${STATIC_CRT})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_STATIC_CRT_FLAGS}")
    else ()
        set (${C_FLAGS} "${${C_FLAGS}} ${C_DYNAMIC_CRT_FLAGS}")
    endif ()

    if (${COVERAGE})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_COVERAGE_FLAGS}")
        set (${C_LINK_FLAGS} "${${C_LINK_FLAGS}} ${C_LINK_COVERAGE_FLAGS}")
    endif ()

    if (${PROFILE})
        set (${C_FLAGS} "${${C_FLAGS}} ${C_PROFILE_FLAGS}")
        set (${C_LINK_FLAGS} "${${C_LINK_FLAGS}} ${C_LINK_PROFILE_FLAGS}")
    endif ()

    if (${ABI})
        if (${ABI} STREQUAL "32")
            set (${C_FLAGS} "${${C_FLAGS}} ${C_ABI_X32_FLAGS}")
        elseif (${ABI} STREQUAL "64")
            set (${C_FLAGS} "${${C_FLAGS}} ${C_ABI_X32_64_FLAGS}")
        endif ()
    endif ()
endmacro ()


macro (set_cxx_flags CXX_FLAGS CXX_LINK_FLAGS STRICT_WARNINGS STD11 EXCEPTIONS POSITION_INDEPENDENT_CODE STATIC_CRT RTTI COVERAGE PROFILE ABI)
    if (NOT ${ARGC} EQUAL 11)
        message (FATAL_ERROR "Wrong number of arguments passed to \"set_cxx_flags\" macros!")
    endif ()

    # Set up compiler flags
    set_compiler_and_linker_flags ()
    set (${CXX_FLAGS} "${CXX_BASE_FLAGS}")

    if (${STRICT_WARNINGS})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_STRICT_WARNINGS_FLAGS}")
    endif ()

    if (${STD11})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_STD11_FLAGS}")
    endif ()

    if (${EXCEPTIONS})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_EXCEPTION_FLAGS}")
    else ()
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_NO_EXCEPTION_FLAGS}")
    endif ()

    if (${POSITION_INDEPENDENT_CODE})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_POSITION_INDEPENDENT_CODE_FLAGS}")
    endif ()

    if (${STATIC_CRT})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_STATIC_CRT_FLAGS}")
    else ()
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_DYNAMIC_CRT_FLAGS}")
    endif ()

    if (${RTTI})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_RTTI_FLAGS}")
    else ()
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_NO_RTTI_FLAGS}")
    endif ()

    if (${COVERAGE})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_COVERAGE_FLAGS}")
        set (${CXX_LINK_FLAGS} "${${CXX_LINK_FLAGS}} ${CXX_LINK_COVERAGE_FLAGS}")
    endif ()

    if (${PROFILE})
        set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_PROFILE_FLAGS}")
        set (${CXX_LINK_FLAGS} "${${CXX_LINK_FLAGS}} ${CXX_LINK_PROFILE_FLAGS}")
    endif ()

    if (${ABI})
        if (${ABI} STREQUAL "32")
            set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_ABI_X32_FLAGS}")
        elseif (${ABI} STREQUAL "64")
            set (${CXX_FLAGS} "${${CXX_FLAGS}} ${CXX_ABI_X32_64_FLAGS}")
        endif ()
    endif ()
endmacro ()


macro (project_cxx_header_with_abi STRICT_WARNINGS STD11 EXCEPTIONS POSITION_INDEPENDENT_CODE STATIC_CRT RTTI COVERAGE PROFILE _ABI)
    set_cxx_flags (CMAKE_CXX_FLAGS
                   CMAKE_CXX_LINK_FLAGS
                   ${STRICT_WARNINGS}
                   ${STD11}
                   ${EXCEPTIONS}
                   ${POSITION_INDEPENDENT_CODE}
                   ${STATIC_CRT}
                   ${RTTI}
                   ${COVERAGE}
                   ${PROFILE}
                   "${_ABI}")
    set_c_flags   (CMAKE_C_FLAGS
                   CMAKE_C_LINK_FLAGS
                   ${STRICT_WARNINGS}
                   ${STD11}
                   ${POSITION_INDEPENDENT_CODE}
                   ${STATIC_CRT}
                   ${COVERAGE}
                   ${PROFILE}
                   "${_ABI}")
endmacro ()


macro (project_cxx_header STRICT_WARNINGS STD11 EXCEPTIONS POSITION_INDEPENDENT_CODE STATIC_CRT RTTI COVERAGE PROFILE)
    project_cxx_header_with_abi (${STRICT_WARNINGS}
                                 ${STD11}
                                 ${EXCEPTIONS}
                                 ${POSITION_INDEPENDENT_CODE}
                                 ${STATIC_CRT}
                                 ${RTTI}
                                 ${COVERAGE}
                                 ${PROFILE}
                                 "${ABI}")
endmacro ()


macro (project_cxx_executable_header_default)
    project_cxx_header (YES YES NO NO YES NO NO NO)
endmacro ()


macro (project_cxx_static_library_header_default)
    if (NOT DEFINED ENABLE_POSITION_INDEPENDENT_CODE)
        set (ENABLE_POSITION_INDEPENDENT_CODE NO)
    endif ()
    if (NOT DEFINED ENABLE_RUNTIME_TYPE_INFORMATION)
        set (ENABLE_RUNTIME_TYPE_INFORMATION NO)
    endif ()

    project_cxx_header (YES YES NO ${ENABLE_POSITION_INDEPENDENT_CODE} YES ${ENABLE_RUNTIME_TYPE_INFORMATION} NO NO)
endmacro ()


macro (project_cxx_shared_library_header_default)
    if (NOT DEFINED ENABLE_POSITION_INDEPENDENT_CODE)
        set (ENABLE_POSITION_INDEPENDENT_CODE NO)
    endif ()
    if (NOT DEFINED ENABLE_RUNTIME_TYPE_INFORMATION)
        set (ENABLE_RUNTIME_TYPE_INFORMATION NO)
    endif ()

    project_cxx_header (YES YES NO ${ENABLE_POSITION_INDEPENDENT_CODE} NO ${ENABLE_RUNTIME_TYPE_INFORMATION} NO NO)
endmacro ()


macro (project_cxx_library_header_default)
    if (NOT DEFINED ENABLE_POSITION_INDEPENDENT_CODE)
        set (ENABLE_POSITION_INDEPENDENT_CODE NO)
    endif ()
    if (NOT DEFINED ENABLE_RUNTIME_TYPE_INFORMATION)
        set (ENABLE_RUNTIME_TYPE_INFORMATION NO)
    endif ()

    if (BUILD_SHARED_LIBS)
        project_cxx_header (YES YES NO ${ENABLE_POSITION_INDEPENDENT_CODE} NO ${ENABLE_RUNTIME_TYPE_INFORMATION} NO NO)
    else ()
        project_cxx_header (YES YES NO ${ENABLE_POSITION_INDEPENDENT_CODE} YES ${ENABLE_RUNTIME_TYPE_INFORMATION} NO NO)
    endif ()
endmacro ()


macro (set_target_cxx_flags_with_abi NAME STRICT_WARNINGS STD11 EXCEPTIONS POSITION_INDEPENDENT_CODE STATIC_CRT RTTI COVERAGE PROFILE _ABI)
    set_cxx_flags (_CXX_FLAGS_ _CXX_LINK_FLAGS_
                   ${STRICT_WARNINGS}
                   ${STD11}
                   ${EXCEPTIONS}
                   ${POSITION_INDEPENDENT_CODE}
                   ${STATIC_CRT}
                   ${RTTI}
                   ${COVERAGE}
                   ${PROFILE}
                   "${_ABI}")
    set_target_properties (${NAME} PROPERTIES COMPILE_FLAGS "${_CXX_FLAGS_}")
    set_target_properties (${NAME} PROPERTIES LINK_FLAGS "${_CXX_LINK_FLAGS_}")
endmacro ()


macro (set_target_cxx_flags NAME STRICT_WARNINGS STD11 EXCEPTIONS POSITION_INDEPENDENT_CODE STATIC_CRT RTTI COVERAGE PROFILE)
    set_target_cxx_flags_with_abi (${NAME}
                                   ${STRICT_WARNINGS}
                                   ${STD11}
                                   ${EXCEPTIONS}
                                   ${POSITION_INDEPENDENT_CODE}
                                   ${STATIC_CRT}
                                   ${RTTI}
                                   ${COVERAGE}
                                   ${PROFILE}
                                   "${ABI}")
endmacro ()
