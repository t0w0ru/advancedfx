# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required (VERSION 3.8)

project ("advancedfx")

#
# Get Microsoft Visual Studio related paths:
#

execute_process(
    COMMAND "$ENV{ProgramFiles\(x86\)}\\Microsoft Visual Studio\\Installer\\vswhere.exe" "-latest" "-version" "[16.0,17.0)" "-property" "installationPath"
    OUTPUT_VARIABLE VS16_INSTALLPATH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND "$ENV{ProgramFiles\(x86\)}\\Microsoft Visual Studio\\Installer\\vswhere.exe" "-latest" "-version" "[16.0,17.0)" "-requires" "Microsoft.Component.MSBuild" "-find" "MSBuild\\**\\**\\Bin\\MSBuild.exe"
    OUTPUT_VARIABLE VS16_MSBUILD
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

#
# Include dependencies:
#

include(FetchContent)

add_subdirectory("AfxHook")
add_subdirectory("deps/Release/zlib")
add_subdirectory("deps/Release/OPENEXR")
add_subdirectory("AfxHookSOurce")


#
# Update translation files
#

add_custom_target(l10n_update
    BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/l10n.stamp"
    COMMAND ${CMAKE_SOURCE_DIR}/l10n_update_to_source.bat
    COMMAND ${CMAKE_COMMAND} -E touch l10n.stamp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


#
# HLAE Project
#

add_custom_command(
    DEPENDS l10n_update
    OUTPUT ${CMAKE_BINARY_DIR}/HLAE.exe
    COMMAND ${VS16_MSBUILD} "hlae.csproj" "-property:Configuration=Release" "/p:OutputPath=${CMAKE_BINARY_DIR}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/hlae
)

add_custom_target(hlae
    DEPENDS ${CMAKE_BINARY_DIR}/HLAE.exe
)

#
# advancedfx
#

add_custom_target(advancedfx ALL
	DEPENDS afxhook afxhooksource hlae
)

# Build / copy resources:



add_custom_command(
    TARGET advancedfx POST_BUILD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/bin"

    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/AfxHook/AfxHook_586.dat "${CMAKE_CURRENT_BINARY_DIR}/bin/AfxHook.dat"
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/AfxHook/AfxHook_x64.dat "${CMAKE_CURRENT_BINARY_DIR}/bin/x64/AfxHook.dat"

	COMMAND ${CMAKE_COMMAND} -E copy "${ILMBASE_BUILD_DIR}/bin/Half-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"
	COMMAND ${CMAKE_COMMAND} -E copy "${ILMBASE_BUILD_DIR}/bin/Iex-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"
	COMMAND ${CMAKE_COMMAND} -E copy "${ILMBASE_BUILD_DIR}/bin/IexMath-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"
	COMMAND ${CMAKE_COMMAND} -E copy "${ILMBASE_BUILD_DIR}/bin/IlmThread-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"
	COMMAND ${CMAKE_COMMAND} -E copy "${ILMBASE_BUILD_DIR}/bin/Imath-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"

	COMMAND ${CMAKE_COMMAND} -E copy "${OPENEXR_BUILD_DIR}/bin/IlmImf-2_5.dll" "${CMAKE_CURRENT_BINARY_DIR}/bin/"


    #COMMAND ${CMAKE_SOURCE_DIR}/copy_resources_release.bat
)
