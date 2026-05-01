@echo off
setlocal EnableExtensions DisableDelayedExpansion

rem Optional args: run_meshroom.bat [dataset_id] [project_root]
if not "%~1"=="" set "DATASET_ID=%~1"
if not "%~2"=="" set "PROJECT_ROOT=%~2"

if not defined PROJECT_ROOT set "PROJECT_ROOT=%~dp0.."
if not defined DATASET_ID set "DATASET_ID=dataset_01"

set "DATASET_DIR=%PROJECT_ROOT%\datasets\%DATASET_ID%"
set "IMAGES=%DATASET_DIR%\images"

set "OUT_ROOT=%PROJECT_ROOT%\outputs\%DATASET_ID%\meshroom"
set "CACHE=%OUT_ROOT%\cache"
set "RESULT=%OUT_ROOT%\result"
set "LOGS=%OUT_ROOT%\logs"

set "MESHROOM=%PROJECT_ROOT%\tools\meshroom\Meshroom-2025.1.0\meshroom_batch.exe"

if not exist "%IMAGES%" (
  echo [ERROR] Images folder not found: "%IMAGES%"
  exit /b 1
)
if not exist "%MESHROOM%" (
  echo [ERROR] meshroom_batch.exe not found: "%MESHROOM%"
  exit /b 1
)

rem Ensure proper output directories
mkdir "%OUT_ROOT%" 2>nul
mkdir "%CACHE%" 2>nul
mkdir "%RESULT%" 2>nul
mkdir "%LOGS%" 2>nul

echo [Meshroom] Dataset: %DATASET_ID%
echo [Meshroom] Images:  %IMAGES%
echo [Meshroom] Cache:   %CACHE%
echo [Meshroom] Result:  %RESULT%

rem Run pipeline to generate dense point cloud only
"%MESHROOM%" ^
  -p "%PROJECT_ROOT%\tools\meshroom\photogrammetry_dense_ply.mg" ^
  -i "%IMAGES%" ^
  --cache "%CACHE%" ^
  -o "%RESULT%" ^
  --forceCompute ^
  -v info
  --overrides "%PROJECT_ROOT%\scripts\meshroom_config.json" ^
  > "%LOGS%\meshroom_batch.log" 2>&1

set EC=%ERRORLEVEL%
echo [Meshroom] EXITCODE=%EC%
exit /b %EC%