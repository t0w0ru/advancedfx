xcopy "resources\*" "build\Release\bin" /D /E /Y
xcopy "deps\release\Detours\LICENSE.md" "build\Release\bin\LICENSES\Detours\" /D /Y
xcopy "deps\release\rapidxml\license.txt" "build\Release\bin\LICENSES\rapidxml\" /D /Y
xcopy "deps/release/easywsclient\COPYING" "build\Release\bin\LICENSES\easywsclient\" /D /Y
xcopy "LICENSE" "build\Release\bin\LICENSES\advancedfx\" /D /Y
xcopy "shaders\build\*.acs" "build\Release\bin\resources\AfxHookSource\shaders\" /D /Y
powershell .\make_readme.ps1