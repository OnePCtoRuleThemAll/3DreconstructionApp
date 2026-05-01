@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ====== GUI/Runner inputs (optional) ======
if not defined PROJECT_ROOT set "PROJECT_ROOT=%~dp0.."
if not defined DATASET_ID   set "DATASET_ID=dataset_05"

if not defined DATASET_DIR  set "DATASET_DIR=%PROJECT_ROOT%\datasets\%DATASET_ID%"
if not defined IMAGES_DIR   set "IMAGES_DIR=%DATASET_DIR%\images"
if not defined OUT_ROOT     set "OUT_ROOT=%PROJECT_ROOT%\outputs\%DATASET_ID%"

rem ====== Local paths for this tool ======
if not defined ROOT         set "ROOT=%PROJECT_ROOT%"
if not defined DATASET_NAME set "DATASET_NAME=%DATASET_ID%"
if not defined DATASET      set "DATASET=%DATASET_DIR%"
if not defined IMAGES       set "IMAGES=%IMAGES_DIR%"

if not defined OUT          set "OUT=%OUT_ROOT%\colmap"
if not defined DB           set "DB=%OUT%\database.db"
if not defined SPARSE       set "SPARSE=%OUT%\sparse"
if not defined DENSE        set "DENSE=%OUT%\dense"
if not defined LOGS         set "LOGS=%OUT%\logs"

if not defined COLMAP       set "COLMAP=%ROOT%\tools\colmap\COLMAP.bat"

if not defined MAX_IMAGE_SIZE set "MAX_IMAGE_SIZE=2000"
if not defined GPU_INDEX      set "GPU_INDEX=0"

if not defined DO_POISSON set "DO_POISSON=1"
if not defined DO_DELAUNAY set "DO_DELAUNAY=1"

rem ========= sanity checks =========
if not exist "%IMAGES%" (
  echo [COLMAP] ERROR: Images folder not found: "%IMAGES%"
  exit /b 1
)
if not exist "%COLMAP%" (
  echo [COLMAP] ERROR: COLMAP launcher not found: "%COLMAP%"
  exit /b 1
)

rem --- reset output
if exist "%OUT%" rmdir /s /q "%OUT%"
mkdir "%OUT%" "%SPARSE%" "%DENSE%" "%LOGS%"

echo [COLMAP] Dataset: %DATASET_NAME%
echo [COLMAP] Images:  %IMAGES%
echo [COLMAP] Output:  %OUT%

call "%COLMAP%" -h > "%LOGS%\00_colmap_version.txt" 2>&1

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
if exist "%SPARSE%" rmdir /s /q "%SPARSE%"
mkdir "%SPARSE%"

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

rem ---- Fallback Profile B ----
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

echo [COLMAP] Undistort for dense...
call "%COLMAP%" image_undistorter ^
  --image_path "%IMAGES%" ^
  --input_path "%SPARSE_MODEL%" ^
  --output_path "%DENSE%" ^
  --output_type COLMAP ^
  > "%LOGS%\04_image_undistorter.log" 2>&1
if errorlevel 1 goto :fail

echo [COLMAP] PatchMatch stereo (GEOMETRIC)...
call "%COLMAP%" patch_match_stereo ^
  --workspace_path "%DENSE%" ^
  --workspace_format COLMAP ^
  --PatchMatchStereo.gpu_index %GPU_INDEX% ^
  --PatchMatchStereo.max_image_size %MAX_IMAGE_SIZE% ^
  --PatchMatchStereo.geom_consistency 1 ^
  --PatchMatchStereo.filter 1 ^
  --PatchMatchStereo.write_consistency_graph 1 ^
  > "%LOGS%\05_patch_match_stereo.log" 2>&1
if errorlevel 1 goto :fail

echo [COLMAP] Stereo fusion (GEOMETRIC -> dense point cloud)...
call "%COLMAP%" stereo_fusion ^
  --workspace_path "%DENSE%" ^
  --workspace_format COLMAP ^
  --input_type geometric ^
  --StereoFusion.max_image_size %MAX_IMAGE_SIZE% ^
  --StereoFusion.min_num_pixels 5 ^
  --StereoFusion.max_depth_error 0.02 ^
  --StereoFusion.max_normal_error 10 ^
  --StereoFusion.max_reproj_error 2 ^
  --output_path "%OUT%\fused.ply" ^
  > "%LOGS%\06_stereo_fusion_geometric.log" 2>&1
if errorlevel 1 goto :fail

if not exist "%OUT%\fused.ply" (
  echo [COLMAP] ERROR: fused.ply missing. Check logs.
  exit /b 1
)

echo [COLMAP] Dense cloud size:
for %%B in ("%OUT%\fused.ply") do echo   fused.ply = %%~zB bytes

echo [COLMAP] DONE.
echo Sparse model: %SPARSE_MODEL%
echo Dense cloud:  %OUT%\fused.ply
echo Logs:         %LOGS%
exit /b 0


rem =======
rem Helpers 
rem =======

:pick_best_model
set "BEST_MODEL="
set /a BEST_COUNT=-1

for /d %%D in ("%SPARSE%\*") do (
  if exist "%%D\cameras.bin" (
    call :count_registered_images "%%D" COUNT
    if not defined COUNT set "COUNT=0"
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
echo [COLMAP] FAILED. See logs in: %LOGS%
exit /b 1
