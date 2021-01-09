setlocal

set IDE_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE
set BUILD_PATH=C:\Windows\Microsoft.NET\Framework64\v4.0.30319
set BUILD_TYPE=%1
set CPU_TYPE=Any CPU
set BATCH_FILE_FOLDER=%~dp0

if "%1"=="" set BUILD_TYPE=Release

"%IDE_PATH%\devenv" /build "%BUILD_TYPE%" ..\Windows\FooEditEngine.sln
if errorlevel 1 goto end
"%IDE_PATH%\devenv" /build "%BUILD_TYPE%" ..\WPF\FooEditEngine.sln
if errorlevel 1 goto end
"%IDE_PATH%\devenv" /build "%BUILD_TYPE%|%CPU_TYPE%" ..\UWP\FooEditEngine.UWP.sln
if errorlevel 1 goto end
"%BUILD_PATH%\MSBuild.exe" /p:Configuration=Release ..\Help\fooeditengine_api.shfbproj
if errorlevel 1 echo "building help file is failed"

pushd ..\Windows\FooEditEngine
nuget pack FooEditEngine.csproj -Prop Configuration=%BUILD_TYPE% -Suffix %BUILD_TYPE% -Symbols -OutputDirectory "%BATCH_FILE_FOLDER%\dist"
popd

pushd ..\WPF\FooEditEngine
nuget pack FooEditEngine.csproj -Prop Configuration=%BUILD_TYPE% -Suffix %BUILD_TYPE% -Symbols -OutputDirectory "%BATCH_FILE_FOLDER%\dist"
popd

pushd ..\UWP\FooEditEngine.UWP
nuget pack FooEditEngine.UWP.csproj -Prop Configuration=%BUILD_TYPE% -Suffix %BUILD_TYPE% -Symbols -OutputDirectory "%BATCH_FILE_FOLDER%\dist"
popd

:copy_dist
md dist
copy ..\Help\Help\Documentation.chm dist

:end
endlocal
pause
