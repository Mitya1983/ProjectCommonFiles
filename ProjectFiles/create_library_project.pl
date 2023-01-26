#!/usr/bin/perl

use warnings;
use strict;
use Cwd;

sub print_help {
    print("[library name] [directory]")
}

if (scalar(@ARGV) == 0) {
    print("Library name and optional directory should be provided\n");
    exit(1);
}

my $project_name = $ARGV[0];
my $project_dir;
print("Project name is set to $project_name\n");
if (scalar(@ARGV) == 2) {
    $project_dir = $ARGV[1];
    unless (-d $project_dir) {
        mkdir($project_dir) or die "Couldn't create $project_dir directory, $!";
    }
    chdir($project_dir) or die "Couldn't change working directory to $project_dir directory, $!";
}
else {
    $project_dir = cwd();
}

print("Generating CMakeLists.txt\n");

mkdir("inc") or die "Couldn't create inc directory, $!";
mkdir("src") or die "Couldn't create src directory, $!";

open(FH, '>', "CMakeLists.txt") or die "Couldn't create file CMakeLists.txt $!";

print(FH "cmake_minimum_required(VERSION 3.17)

project($project_name LANGUAGES CXX DESCRIPTION \"\")

set(CMAKE_CXX_STANDARD 20)

option(BUILD_SHARED \"\" ON)
option(BUILD_STATIC \"\" OFF)
option(GENERATE_DEB_PACKAGE \"\" OFF)

if (\${BUILD_STATIC})
    message(STATUS \"Static library is enabled - switching off shared one\")
    set(BUILD_SHARED OFF)
endif (\${BUILD_STATIC})

if (CMAKE_CXX_COMPILER_ID STREQUAL \"Clang\")
        # using Clang
        if (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
            set(CMAKE_CXX_FLAGS \"-g -g3 -glldb -ggdb -ggdb3 -O0 -Wall -Wextra -Wpedantic -Wfloat-equal -Werror -fsanitize=address\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
        if (CMAKE_BUILD_TYPE STREQUAL \"Release\")
            set(CMAKE_CXX_FLAGS \"-g0 -ggdb0 -glldb0 -O3\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Release\")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL \"GNU\")
        # using GCC
        if (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
            set(CMAKE_CXX_FLAGS \"-g -ggdb3 -O0 -Wall -Wextra -Wpedantic -Wfloat-equal -Werror\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
        if (CMAKE_BUILD_TYPE STREQUAL \"Release\")
            set(CMAKE_CXX_FLAGS \"-g0 -ggdb0 -O3\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Release\")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL \"MSVC\")
        # using Visual Studio C++
        if (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
            set(CMAKE_CXX_FLAGS \"/Zi /Od /JMC /WX\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
        if (CMAKE_BUILD_TYPE STREQUAL \"Release\")
            set(CMAKE_CXX_FLAGS \"/Ot /O2\")
        endif (CMAKE_BUILD_TYPE STREQUAL \"Release\")
    else ()
        message(FATAL_ERROR \"Compiler not supported\")
    endif ()

include_directories(
        inc/
)

file(GLOB_RECURSE INC_FILES CONFIGURE_DEPENDS
            \${PROJECT_SOURCE_DIR}/inc/*.hpp
            )
file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
            \${PROJECT_SOURCE_DIR}/src/*.cpp
            )

set(LIB_VERSION 0.1)

if (\"\${CMAKE_INSTALL_PREFIX}\" STREQUAL \"\")
    message(STATUS \"CMAKE_INSTALL_PREFIX is not set. \$ENV{HOME} directory will be used\")
    set(INSTALL_PREFIX \"\$ENV{HOME}\")
else ()
    set(INSTALL_PREFIX \"\${CMAKE_INSTALL_PREFIX}\")
endif (\"\${CMAKE_INSTALL_PREFIX}\" STREQUAL \"\")

set(PROJECT_INSTALL_DIR \${INSTALL_PREFIX}/\${PROJECT_NAME})
set(LIBRARY_INSTALL_DIR \${PROJECT_INSTALL_DIR}/\${CMAKE_BUILD_TYPE})
message(STATUS \"Library install directory is set to \${LIBRARY_INSTALL_DIR}\")
set(INCLUDE_INSTALL_DIR \${LIBRARY_INSTALL_DIR}/inc)
message(STATUS \"Include install directory is set to \${INCLUDE_INSTALL_DIR}\")
set(CMAKE_CONFIG_INSTALL_DIR \${INSTALL_PREFIX}/cmake/\${CMAKE_BUILD_TYPE})
message(STATUS \"CMake config files install directory is set to \${CMAKE_CONFIG_INSTALL_DIR}\")

if (BUILD_SHARED)
    message(STATUS \"Will build shared library\")
    add_library(\${PROJECT_NAME} SHARED)
else ()
    message(STATUS \"Will build static library\")
    add_library(\${PROJECT_NAME} STATIC)
endif (BUILD_SHARED)

if (CMAKE_BUILD_TYPE STREQUAL \"Debug\")
    target_compile_definitions(\${PROJECT_NAME} PUBLIC TRISTAN_DEBUG)
endif (CMAKE_BUILD_TYPE STREQUAL \"Debug\")

target_sources(
        \${PROJECT_NAME}
        PRIVATE \${SRC_FILES}
        PUBLIC \${INC_FILES}
)

set_target_properties(
        \${PROJECT_NAME}
        PROPERTIES
        VERSION \${LIB_VERSION}
        OUTPUT_NAME \${PROJECT_NAME}
)

if (GENERATE_DEB_PACKAGE)
    add_custom_command(
            TARGET \${PROJECT_NAME}
            POST_BUILD
            WORKING_DIRECTORY \${CMAKE_BINARY_DIR}
            COMMAND cpack .
    )
endif (GENERATE_DEB_PACKAGE)

include(CMakePackageConfigHelpers)

configure_package_config_file(\${CMAKE_CURRENT_SOURCE_DIR}/PackageConfig.cmake.in
        \${CMAKE_CURRENT_BINARY_DIR}/\${PROJECT_NAME}Config.cmake
        INSTALL_DESTINATION \${CMAKE_CONFIG_INSTALL_DIR}
        PATH_VARS INCLUDE_INSTALL_DIR LIBRARY_INSTALL_DIR)

write_basic_package_version_file(
        \${CMAKE_CURRENT_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake
        VERSION \${LIB_VERSION}
        COMPATIBILITY SameMajorVersion
)

install(TARGETS \${PROJECT_NAME}
        CONFIGURATIONS \${CMAKE_BUILD_TYPE}
        LIBRARY DESTINATION \${LIBRARY_INSTALL_DIR})

install(FILES
        \${CMAKE_CURRENT_BINARY_DIR}/\${PROJECT_NAME}Config.cmake
        \${CMAKE_CURRENT_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake
        CONFIGURATIONS \${CMAKE_BUILD_TYPE}
        DESTINATION \${CMAKE_CONFIG_INSTALL_DIR})

install(FILES
        \${INC_FILES}
        CONFIGURATIONS \${CMAKE_BUILD_TYPE}
        DESTINATION \${INCLUDE_INSTALL_DIR})

set(CPACK_GENERATOR \"DEB\")
set(CPACK_PACKAGE_NAME \${PROJECT_NAME})
set(CPACK_DEBIAN_PACKAGE_MAINTAINER \"tristan.it\@outlook.com\")
include(CPack)
");

close(FH);

print("Generating PackageConfig.cmake.in\n");
my $project_name_uc = uc $project_name;
open(FH, '>', "PackageConfig.cmake.in") or die "Couldn't create file PackageConfig.cmake.in $!";
print(FH "set($project_name_uc\_VERSION 0.1)

\@PACKAGE_INIT\@

set_and_check(\@PROJECT_NAME\@_INCLUDE_DIR \"\@PACKAGE_INCLUDE_INSTALL_DIR\@\")
set_and_check(\@PROJECT_NAME\@_LIBRARY_DIR \"\@PACKAGE_LIBRARY_INSTALL_DIR\@\")

check_required_components(\@PROJECT_NAME\@)
");
close(FH);

print("Generating .clang-format\n");

open(FH, '>', ".clang-format") or die "Couldn't create file .clang-format $!";

print(FH "BasedOnStyle: LLVM
AccessModifierOffset: -4
AlignAfterOpenBracket: Align
AlignArrayOfStructures: Left
AlignConsecutiveAssignments: None
AlignConsecutiveBitFields: Consecutive
AlignConsecutiveDeclarations: None
AlignConsecutiveMacros: Consecutive
AlignEscapedNewlines: Left
AlignOperands: AlignAfterOperator
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortBlocksOnASingleLine: Always
AllowShortCaseLabelsOnASingleLine: false
AllowShortEnumsOnASingleLine: false
AllowShortFunctionsOnASingleLine: All
AllowShortIfStatementsOnASingleLine: Never
AllowShortLambdasOnASingleLine: None
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: MultiLine
BinPackArguments: false
BinPackParameters: false
BitFieldColonSpacing: Both
BreakBeforeBraces: Custom
BraceWrapping:
  AfterCaseLabel: false
  AfterClass: false
  AfterControlStatement: Never
  AfterEnum: false
  AfterFunction: false
  AfterNamespace: false
  AfterStruct: false
  AfterUnion: false
  AfterExternBlock: false
  BeforeCatch: false
  BeforeElse: false
  BeforeLambdaBody: false
  BeforeWhile: false
  IndentBraces: false
  SplitEmptyFunction: false
  SplitEmptyRecord: false
  SplitEmptyNamespace: false
BreakBeforeBinaryOperators: All
BreakBeforeConceptDeclarations: true
BreakBeforeTernaryOperators: true
BreakConstructorInitializers: AfterColon
BreakInheritanceList: AfterComma
BreakStringLiterals: true
ColumnLimit: 160
CompactNamespaces: false
ContinuationIndentWidth: 4
EmptyLineAfterAccessModifier: Never
EmptyLineBeforeAccessModifier: LogicalBlock
FixNamespaceComments: true
IncludeBlocks: Regroup
IndentAccessModifiers: false
IndentCaseBlocks: false
IndentCaseLabels: true
IndentExternBlock: Indent
IndentGotoLabels: false
IndentPPDirectives: BeforeHash
IndentWidth: 4
IndentWrappedFunctionNames: true
InsertTrailingCommas: None
KeepEmptyLinesAtTheStartOfBlocks: true
LambdaBodyIndentation: Signature
Language: Cpp
MaxEmptyLinesToKeep: 1
NamespaceIndentation: All
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PPIndentWidth: 2
PackConstructorInitializers: Never
PointerAlignment: Left
QualifierAlignment: Left
#QualifierOrder: ['inline', 'static', 'const', 'volatile', 'type']
ReferenceAlignment: Pointer
ReflowComments: false
RemoveBracesLLVM: false
SeparateDefinitionBlocks: Always
SortIncludes: Never
SortUsingDeclarations: false
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeCaseColon: false
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatements
SpaceBeforeRangeBasedForLoopColon: false
SpaceBeforeSquareBrackets: false
SpaceInEmptyBlock: true
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 2
SpacesInAngles: true
SpacesInCStyleCastParentheses: false
SpacesInConditionalStatement: false
SpacesInContainerLiterals: true
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard: c++20
TabWidth: 4
UseTab: Never
");

close(FH);
exit(0);