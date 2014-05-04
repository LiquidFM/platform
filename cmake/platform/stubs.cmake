# Copyright (C) 2014  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


macro (add_library_stub NAME)
    file (WRITE ${CMAKE_CURRENT_BINARY_DIR}/stub.c "int __${NAME}_just_a_stub_for_cmake__(void);\nint __${NAME}_just_a_stub_for_cmake__(void) { return 123; }")
    add_library (${NAME} STATIC stub.c)
endmacro ()
