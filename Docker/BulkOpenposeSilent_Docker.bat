@echo off
rem --- 
rem ---  映像データからOpenposeで姿勢推定する
rem --- 


echo ------------------------------------------
echo Openpose 解析
echo ------------------------------------------

rem --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

rem -----------------------------------
rem --- 入力映像パス
FOR %%1 IN (%INPUT_VIDEO%) DO (
    rem -- 入力映像パスの親ディレクトリと、ファイル名+_jsonでパス生成
    set INPUT_VIDEO_DIR=%%~dp1
    set INPUT_VIDEO_FILENAME=%%~n1
    set INPUT_VIDEO_FILENAME_EXT=%%~nx1
)

echo --------------

rem ------------------------------------------------
rem -- JSON出力ディレクトリ
set OUTPUT_JSON_DIR=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_json
rem -- echo %OUTPUT_JSON_DIR%

rem -- JSON出力ディレクトリ生成
mkdir %OUTPUT_JSON_DIR%
echo 解析結果JSONディレクトリ：%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- 映像出力ディレクトリ
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_openpose.avi
echo 解析結果aviファイル：%OUTPUT_VIDEO_PATH%

echo --------------
echo Openpose解析を開始します。
echo 解析を中断したい場合、ESCキーを押下して下さい。
echo --------------

rem -- exe実行
set C_INPUT_VIDEO=/data/%INPUT_VIDEO_FILENAME_EXT%
set C_JSON_DIR=/data/%INPUT_VIDEO_FILENAME%_%DTTM%/%INPUT_VIDEO_FILENAME%_json
set C_OUTPUT_VIDEO=/data/%INPUT_VIDEO_FILENAME%_%DTTM%/%INPUT_VIDEO_FILENAME%_openpose.avi
set OPENPOSE_ARG=--video %C_INPUT_VIDEO% --model_pose COCO --write_json %C_JSON_DIR% --write_video %C_OUTPUT_VIDEO% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST% --display 0
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd:%IMAGE_TAG% bash -c "cd /openpose && ./build/examples/openpose/openpose.bin %OPENPOSE_ARG%"

echo --------------
echo Done!!
echo Openpose解析終了

exit /b
