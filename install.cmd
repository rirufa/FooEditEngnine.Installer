setlocal

set IDE_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE
set BUILD_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin
set BUILD_TYPE=%1
set CPU_TYPE=Any CPU
set BATCH_FILE_FOLDER=%~dp0

if "%1"=="" set BUILD_TYPE=Release

pushd ..\Windows\FooTextBox
"%BUILD_PATH%\msbuild" -t:pack -p:Configuration=%BUILD_TYPE%"
copy bin\%BUILD_TYPE%\*.nupkg "%BATCH_FILE_FOLDER%dist"
popd

pushd ..\DotNetTextStore
"%BUILD_PATH%\msbuild" -t:pack -p:Configuration=%BUILD_TYPE%"
copy bin\%BUILD_TYPE%\*.nupkg "%BATCH_FILE_FOLDER%dist"
popd

pushd ..\WPF\FooTextBox
"%BUILD_PATH%\msbuild" -t:pack -p:Configuration=%BUILD_TYPE%"
copy bin\%BUILD_TYPE%\*.nupkg "%BATCH_FILE_FOLDER%dist"
popd

pushd ..\UWP\FooTextBox
"%IDE_PATH%\devenv" /build "%BUILD_TYPE%|%CPU_TYPE%" ..\UWP.sln
nuget pack FooEditEngine.UWP.nuspec -Prop Configuration=%BUILD_TYPE% -Suffix %BUILD_TYPE% -Symbols -OutputDirectory "%BATCH_FILE_FOLDER%\dist"
popd

:copy_dist
md dist
copy ..\Help\Help\Documentation.chm dist

:end
endlocal
pause
