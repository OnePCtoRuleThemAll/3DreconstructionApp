@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ====== GUI/Runner inputs (optional) ======
if not defined PROJECT_ROOT set "PROJECT_ROOT=%~dp0.."
if not defined DATASET_ID   set "DATASET_ID=dataset_05"
if not defined GPU_INDEX    set "GPU_INDEX=0"

if not defined DATASET_DIR  set "DATASET_DIR=%PROJECT_ROOT%\datasets\%DATASET_ID%"
if not defined IMAGES_DIR   set "IMAGES_DIR=%DATASET_DIR%\images"
if not defined OUT_ROOT     set "OUT_ROOT=%PROJECT_ROOT%\outputs\%DATASET_ID%"

rem ====== Project structure ======
set "ROOT=%PROJECT_ROOT%"
set "DATASET_NAME=%DATASET_ID%"
set "DATASET=%DATASET_DIR%"
set "IMAGES=%IMAGES_DIR%"

rem ====== Outputs ======
set "OUT=%OUT_ROOT%\MVSNet"
set "COLMAP_OUT=%OUT%\colmap_sfm"
set "PMNET_OUT=%OUT%\PatchmatchNet"
set "LOGS=%OUT%\logs"

rem COLMAP (sfm for PMNet input)
set "COLMAP=%ROOT%\tools\colmap\COLMAP.bat"

rem PatchmatchNet repo
set "PMNET=%ROOT%\tools\PatchmatchNet"

rem Venv activate
set "VENV_ACT=%ROOT%\envs\mvsnet_env\Scripts\activate.bat"

rem ====== IMPORTANT: define DB/SPARSE/DENSE if env didn't ======
if not defined DB     set "DB=%COLMAP_OUT%\database.db"
if not defined SPARSE set "SPARSE=%COLMAP_OUT%\sparse"
if not defined DENSE  set "DENSE=%COLMAP_OUT%\dense"

rem ========= SANITY CHECKS =========
if not exist "%IMAGES%" (
  echo [ERROR] Images folder not found: "%IMAGES%"
  exit /b 1
)

if not exist "%COLMAP%" (
  echo [ERROR] COLMAP.bat not found: "%COLMAP%"
  exit /b 1
)

if not exist "%PMNET%\colmap_input.py" (
  echo [ERROR] PatchmatchNet not found or missing colmap_input.py: "%PMNET%"
  exit /b 1
)

if not exist "%VENV_ACT%" (
  echo [ERROR] venv activate not found: "%VENV_ACT%"
  exit /b 1
)

rem ========= PREPARE OUTPUT DIRS =========
if exist "%OUT%" rmdir /s /q "%OUT%"
mkdir "%OUT%" "%LOGS%" "%COLMAP_OUT%" "%PMNET_OUT%" "%SPARSE%" "%DENSE%"

rem =========================
rem  ADAPTIVE SfM (GUI-like)
rem =========================

set "MIN_REG_IMAGES=12"
set "MAX_FEATURES=8192"
set "CAM_MODEL_A=OPENCV"
set "SINGLE_CAM_A=1"

set "CAM_MODEL_B=SIMPLE_RADIAL"
set "SINGLE_CAM_B=0"
set "SEQ_OVERLAP=15"

echo [COLMAP] Feature extraction (Profile A)...
call "%COLMAP%" feature_extractor ^
  --database_path "%DB%" ^
  --image_path "%IMAGES%" ^
  --ImageReader.single_camera %SINGLE_CAM_A% ^
  --ImageReader.camera_model %CAM_MODEL_A% ^
  --SiftExtraction.use_gpu 1 ^
  --SiftExtraction.max_num_features %MAX_FEATURES% ^
  > "%LOGS%\01_feature_extractor_A.log" 2>&1
if errorlevel 1 goto :fail

echo [COLMAP] Exhaustive matching (Profile A)...
call "%COLMAP%" exhaustive_matcher ^
  --database_path "%DB%" ^
  --SiftMatching.use_gpu 1 ^
  --SiftMatching.guided_matching 1 ^
  > "%LOGS%\02_matcher_A_exhaustive.log" 2>&1
if errorlevel 1 goto :fail

echo [COLMAP] Sparse reconstruction (mapper) (Profile A)...
call "%COLMAP%" mapper ^
  --database_path "%DB%" ^
  --image_path "%IMAGES%" ^
  --output_path "%SPARSE%" ^
  --Mapper.multiple_models 1 ^
  > "%LOGS%\03_mapper_A.log" 2>&1
if errorlevel 1 goto :fail

call :pick_best_model
if errorlevel 1 goto :fail
set "SPARSE_MODEL=%BEST_MODEL%"

call :count_registered_images "%SPARSE_MODEL%" REG_A
if not defined REG_A set "REG_A=0"
echo [COLMAP] Registered images after Profile A: %REG_A%

set "REG_A_NUM=0"
set /a REG_A_NUM=%REG_A% 2>nul
if not defined REG_A_NUM set "REG_A_NUM=0"

echo [COLMAP] REG_A_NUM = !REG_A_NUM!  (min = %MIN_REG_IMAGES%)

if !REG_A_NUM! GEQ %MIN_REG_IMAGES% goto sfm_done

echo [COLMAP] Profile A seems weak (< %MIN_REG_IMAGES%). Trying Profile B fallback...

if exist "%DB%" del /q "%DB%"

echo [COLMAP] Feature extraction (Profile B)...
call "%COLMAP%" feature_extractor ^
  --database_path "%DB%" ^
  --image_path "%IMAGES%" ^
  --ImageReader.single_camera %SINGLE_CAM_B% ^
  --ImageReader.camera_model %CAM_MODEL_B% ^
  --SiftExtraction.use_gpu 1 ^
  --SiftExtraction.max_num_features %MAX_FEATURES% ^
  > "%LOGS%\11_feature_extractor_B.log" 2>&1
if errorlevel 1 goto :fail

echo [COLMAP] Sequential matching (Profile B)...
call "%COLMAP%" sequential_matcher ^
  --database_path "%DB%" ^
  --SiftMatching.use_gpu 1 ^
  --SiftMatching.guided_matching 1 ^
  --SequentialMatching.overlap %SEQ_OVERLAP% ^
  > "%LOGS%\12_matcher_B_sequential.log" 2>&1
if errorlevel 1 goto :fail

if exist "%SPARSE%" rmdir /s /q "%SPARSE%"
mkdir "%SPARSE%"

echo [COLMAP] Sparse reconstruction (mapper) (Profile B - softer thresholds)...
call "%COLMAP%" mapper ^
  --database_path "%DB%" ^
  --image_path "%IMAGES%" ^
  --output_path "%SPARSE%" ^
  --Mapper.multiple_models 1 ^
  --Mapper.min_num_matches 15 ^
  --Mapper.init_min_num_inliers 50 ^
  --Mapper.abs_pose_min_num_inliers 30 ^
  --Mapper.abs_pose_min_inlier_ratio 0.15 ^
  > "%LOGS%\13_mapper_B.log" 2>&1
if errorlevel 1 goto :fail

call :pick_best_model
if errorlevel 1 goto :fail
set "SPARSE_MODEL=%BEST_MODEL%"

call :count_registered_images "%SPARSE_MODEL%" REG_B
if not defined REG_B set "REG_B=0"
echo [COLMAP] Registered images after Profile B: %REG_B%

set "REG_B_NUM=0"
set /a REG_B_NUM=%REG_B% 2>nul
if not defined REG_B_NUM set "REG_B_NUM=0"

echo [COLMAP] REG_B_NUM = !REG_B_NUM!

if !REG_B_NUM! LSS 3 goto :too_few_images
goto sfm_done

:too_few_images
echo [COLMAP] ERROR: Still too few registered images (!REG_B_NUM!).
echo [COLMAP] TIP: Turntable/object datasets often need masks (ImageReader.mask_path).
exit /b 1

:sfm_done
echo [COLMAP] Using sparse model: %SPARSE_MODEL%

rem ========= 2) COLMAP Undistort (MVS workspace) =========
echo [COLMAP] Image undistorter (prepare MVS workspace)...
mkdir "%DENSE%" >nul 2>&1
call "%COLMAP%" image_undistorter ^
  --image_path "%IMAGES%" ^
  --input_path "%SPARSE_MODEL%" ^
  --output_path "%DENSE%" ^
  --output_type COLMAP ^
  > "%LOGS%\04_colmap_image_undistorter.log" 2>&1
if errorlevel 1 goto :fail

rem ========= 3) Convert COLMAP -> PatchmatchNet workspace =========
echo [PMNET] Converting COLMAP results to PatchmatchNet input (colmap_input.py)...
call "%VENV_ACT%"

set "PY=%ROOT%\envs\mvsnet_env\Scripts\python.exe"
if not exist "%PY%" (
  echo [ERROR] venv python not found: "%PY%"
  exit /b 1
)

mkdir "%PMNET_OUT%\results" >nul 2>&1
mkdir "%PMNET_OUT%\results\depth_est" >nul 2>&1
mkdir "%PMNET_OUT%\results\confidence" >nul 2>&1
mkdir "%PMNET_OUT%\results\points" >nul 2>&1
mkdir "%PMNET_OUT%\workspace" >nul 2>&1

pushd "%PMNET%"
"%PY%" colmap_input.py ^
  --input_folder "%DENSE%" ^
  --output_folder "%PMNET_OUT%" ^
  > "%LOGS%\05_pmnet_colmap_input.log" 2>&1
if errorlevel 1 (
  popd
  goto :fail_pmnet
)
popd

rem ========= 4) Run PatchmatchNet (eval.py) =========
echo [PMNET] Running PatchmatchNet eval.py...
pushd "%PMNET%"

"%PY%" eval.py -h > "%LOGS%\06_pmnet_eval_help.txt" 2>&1

if not exist "%PMNET%\checkpoints\params_000007.ckpt" (
  echo [ERROR] Checkpoint not found: "%PMNET%\checkpoints\params_000007.ckpt"
  exit /b 1
)

rem Prefer workspace as input (most repos expect this)
set "PMNET_INPUT=%PMNET_OUT%\workspace"
if not exist "%PMNET_INPUT%" set "PMNET_INPUT=%PMNET_OUT%"

"%PY%" eval.py ^
  --input_folder "%PMNET_OUT%" ^
  --output_folder "%PMNET_OUT%\results" ^
  --checkpoint_path "%PMNET%\checkpoints\params_000007.ckpt" ^
  --input_type params ^
  --output_type both ^
  --image_max_dim 1600 ^
  > "%LOGS%\07_pmnet_eval.log" 2>&1
if errorlevel 1 (
  echo [PMNET] eval.py failed. Check: "%LOGS%\06_pmnet_eval_help.txt" and "%LOGS%\07_pmnet_eval.log"
  goto :fail_pmnet
)

popd

echo [DONE] PatchmatchNet run finished.
echo Outputs:
echo   COLMAP dense workspace: %DENSE%
echo   PatchmatchNet workspace: %PMNET_OUT%\workspace
echo   PatchmatchNet results: %PMNET_OUT%\results
echo Logs: %LOGS%
exit /b 0


:fail_pmnet
echo [FAILED] PatchmatchNet step failed. Check logs in: %LOGS%
exit /b 1


:pick_best_model
set "BEST_MODEL="
set /a BEST_COUNT=-1

for /d %%D in ("%SPARSE%\*") do (
  if exist "%%D\cameras.bin" (
    call :count_registered_images "%%D" COUNT
    echo [COLMAP] Model %%~nxD registered images: !COUNT!
    if !COUNT! gtr !BEST_COUNT! (
      set /a BEST_COUNT=!COUNT!
      set "BEST_MODEL=%%D"
    )
  )
)

if not defined BEST_MODEL (
  echo [COLMAP] ERROR: No valid sparse model found in %SPARSE%.
  exit /b 1
)

exit /b 0


:count_registered_images
set "MODEL_PATH=%~1"
set "OUTVAR=%~2"

set "TXT_OUT=%MODEL_PATH%_txt"
if exist "%TXT_OUT%" rmdir /s /q "%TXT_OUT%"
mkdir "%TXT_OUT%"

call "%COLMAP%" model_converter ^
  --input_path "%MODEL_PATH%" ^
  --output_path "%TXT_OUT%" ^
  --output_type TXT > "%LOGS%\_model_converter_%~nx1.log" 2>&1

if not exist "%TXT_OUT%\images.txt" (
  set "%OUTVAR%=0"
  exit /b 0
)

for /f %%A in ('find /c /v "" ^< "%TXT_OUT%\images.txt"') do set "IMG_LINES=%%A"
set /a IMAGES_COUNT=(IMG_LINES-4)/2
if %IMAGES_COUNT% lss 0 set /a IMAGES_COUNT=0

set "%OUTVAR%=%IMAGES_COUNT%"
exit /b 0


:fail
echo [FAILED] COLMAP step failed. Check logs in: %LOGS%
exit /b 1
