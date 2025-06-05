# MIT License
#
# Copyright (c) 2025 Aleksa Radomirovic
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if(NOT TARGET test)
    add_custom_target(test)
endif()

function(easytest_add_test _NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        ""
        ""
        "TARGET;PARENT"
        "ARGS"
    )

    if(NOT DEFINED _PARENT)
        set(_PARENT "test")
    endif()

    if((DEFINED _TARGET) OR (DEFINED _COMMAND))
        add_custom_target(
            "${_NAME}" 
            "${_TARGET}" ${_ARGS}
            DEPENDS "${_TARGET}"
        )
    else()
        add_custom_target(
            "${_NAME}"
        )
    endif()

    add_dependencies("${_PARENT}" "${_NAME}")
endfunction()

function(easytest_add_test_category _NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        ""
        ""
        "PARENT"
        ""
    )
    
    if(DEFINED _PARENT)
        easytest_add_test("${_NAME}" PARENT "${_PARENT}")
    else()
        easytest_add_test("${_NAME}")
    endif()
endfunction()

function(easytest_add_gtest _NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        ""
        ""
        "SUFFIX;PARENT"
        "SOURCES"
    )
    if(NOT DEFINED _SUFFIX)
        set(_SUFFIX "test")
    endif()

    add_executable(
        "${_NAME}"
        EXCLUDE_FROM_ALL
            ${_SOURCES}
            ${_UNPARSED_ARGUMENTS}
    )
    target_link_libraries(
        "${_NAME}"
        PRIVATE
            GTest::gtest_main
    )

    set(_TEST_NAME "${_NAME}_${_SUFFIX}")
    if(DEFINED _PARENT)
        easytest_add_test("${_TEST_NAME}" TARGET "${_NAME}" PARENT "${_PARENT}")
    else()
        easytest_add_test("${_TEST_NAME}" TARGET "${_NAME}")
    endif()
endfunction()
