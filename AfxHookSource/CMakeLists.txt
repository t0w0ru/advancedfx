cmake_minimum_required (VERSION 3.8)

project ("afxhooksource")


add_custom_command(
    WORKING_DIRECTORY ${afxhooksource_BINARY_DIR}
    OUTPUT "${afxhooksource_BINARY_DIR}/AfxHookSource.dll"
    DEPENDS ilmbase_build openexr_build
    COMMAND ${VS16_MSBUILD} "${CMAKE_CURRENT_SOURCE_DIR}/AfxHookSource.vcxproj" "/p:Configuration=Release" "/p:Platform=Win32" "/p:ILMBASE_BUILD_DIR=${ILMBASE_BUILD_DIR};OPENEXR_BUILD_DIR=${OPENEXR_BUILD_DIR}"
)

add_custom_target(afxhooksource
    DEPENDS "${afxhooksource_BINARY_DIR}/AfxHookSource.dll"
)
