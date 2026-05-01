{
    "header": {
        "releaseVersion": "2025.1.0",
        "fileVersion": "2.0",
        "nodesVersions": {
            "CameraInit": "12.0",
            "ConvertSfMFormat": "2.0",
            "DepthMap": "5.0",
            "DepthMapFilter": "4.0",
            "FeatureExtraction": "1.3",
            "FeatureMatching": "2.0",
            "ImageMatching": "2.0",
            "Meshing": "7.0",
            "PrepareDenseScene": "3.1",
            "Publish": "1.3",
            "StructureFromMotion": "3.3"
        }
    },
    "graph": {
        "CameraInit_1": {
            "nodeType": "CameraInit",
            "position": [
                0,
                0
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 16,
                "split": 1
            },
            "uid": "b13e824510df2e83a064d842c8fa16504cc209bc",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "viewpoints": [
                    {
                        "viewId": 88354767,
                        "poseId": 88354767,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0435.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:42\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:42\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:42\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"70\", \"Exif:SubsecTimeDigitized\": \"70\", \"Exif:SubsecTimeOriginal\": \"70\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 170467749,
                        "poseId": 170467749,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0434.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:38\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:38\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:38\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"50\", \"Exif:SubsecTimeDigitized\": \"50\", \"Exif:SubsecTimeOriginal\": \"50\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 307290278,
                        "poseId": 307290278,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0424.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:34\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:34\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:34\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"80\", \"Exif:SubsecTimeDigitized\": \"80\", \"Exif:SubsecTimeOriginal\": \"80\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 325329485,
                        "poseId": 325329485,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0427.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:48\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:48\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:48\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"70\", \"Exif:SubsecTimeDigitized\": \"70\", \"Exif:SubsecTimeOriginal\": \"70\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 365031676,
                        "poseId": 365031676,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0432.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:21\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:21\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:21\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"50\", \"Exif:SubsecTimeDigitized\": \"50\", \"Exif:SubsecTimeOriginal\": \"50\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 479461064,
                        "poseId": 479461064,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0433.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:29\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:29\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:29\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"30\", \"Exif:SubsecTimeDigitized\": \"30\", \"Exif:SubsecTimeOriginal\": \"30\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 649386830,
                        "poseId": 649386830,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0437.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:52\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:52\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:52\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"10\", \"Exif:SubsecTimeDigitized\": \"10\", \"Exif:SubsecTimeOriginal\": \"10\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 650739295,
                        "poseId": 650739295,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0423.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:32\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:32\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:32\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"50\", \"Exif:SubsecTimeDigitized\": \"50\", \"Exif:SubsecTimeOriginal\": \"50\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 763954905,
                        "poseId": 763954905,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0426.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:44\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:44\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:44\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"30\", \"Exif:SubsecTimeDigitized\": \"30\", \"Exif:SubsecTimeOriginal\": \"30\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1001736853,
                        "poseId": 1001736853,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0436.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:48\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:48\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:48\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"00\", \"Exif:SubsecTimeDigitized\": \"00\", \"Exif:SubsecTimeOriginal\": \"00\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1053122817,
                        "poseId": 1053122817,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0438.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:09:00\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:09:00\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:09:00\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"10\", \"Exif:SubsecTimeDigitized\": \"10\", \"Exif:SubsecTimeOriginal\": \"10\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1167415354,
                        "poseId": 1167415354,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0425.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:37\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:37\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:37\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"10\", \"Exif:SubsecTimeDigitized\": \"10\", \"Exif:SubsecTimeOriginal\": \"10\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1441793064,
                        "poseId": 1441793064,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0430.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:06\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:06\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:06\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"80\", \"Exif:SubsecTimeDigitized\": \"80\", \"Exif:SubsecTimeOriginal\": \"80\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1452250132,
                        "poseId": 1452250132,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0428.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:07:56\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:07:56\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:07:56\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"70\", \"Exif:SubsecTimeDigitized\": \"70\", \"Exif:SubsecTimeOriginal\": \"70\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1492991465,
                        "poseId": 1492991465,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0429.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:02\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:02\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:02\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"40\", \"Exif:SubsecTimeDigitized\": \"40\", \"Exif:SubsecTimeOriginal\": \"40\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1985942291,
                        "poseId": 1985942291,
                        "path": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images/DSC_0431.JPG",
                        "intrinsicId": 105511678,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"23.200000\", \"DateTime\": \"2019:07:11 15:08:14\", \"Exif:ColorSpace\": \"1\", \"Exif:CompressedBitsPerPixel\": \"1\", \"Exif:Contrast\": \"0\", \"Exif:CustomRendered\": \"0\", \"Exif:DateTimeDigitized\": \"2019:07:11 15:08:14\", \"Exif:DateTimeOriginal\": \"2019:07:11 15:08:14\", \"Exif:DigitalZoomRatio\": \"1\", \"Exif:ExifVersion\": \"0230\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"0\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"40\", \"Exif:FocalLengthIn35mmFilm\": \"60\", \"Exif:GainControl\": \"1\", \"Exif:LightSource\": \"0\", \"Exif:MaxApertureValue\": \"4.6\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"400\", \"Exif:PixelXDimension\": \"3008\", \"Exif:PixelYDimension\": \"2000\", \"Exif:Saturation\": \"0\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:SensitivityType\": \"2\", \"Exif:Sharpness\": \"0\", \"Exif:SubjectDistanceRange\": \"0\", \"Exif:SubsecTime\": \"00\", \"Exif:SubsecTimeDigitized\": \"00\", \"Exif:SubsecTimeOriginal\": \"00\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"2\", \"ExposureTime\": \"0.0125\", \"FNumber\": \"5\", \"GPS:VersionID\": \"2, 3, 0, 0\", \"Make\": \"NIKON CORPORATION\", \"Model\": \"NIKON D3200\", \"Orientation\": \"1\", \"ResolutionUnit\": \"none\", \"Software\": \"Ver.1.03 \", \"XResolution\": \"300\", \"YResolution\": \"300\", \"jpeg:subsampling\": \"4:2:2\", \"oiio:ColorSpace\": \"sRGB\"}"
                    }
                ],
                "intrinsics": [
                    {
                        "intrinsicId": 105511678,
                        "initialFocalLength": 40.00000000000001,
                        "focalLength": 40.00000000000001,
                        "pixelRatio": 1.0,
                        "pixelRatioLocked": true,
                        "scaleLocked": false,
                        "offsetLocked": false,
                        "distortionLocked": false,
                        "type": "pinhole",
                        "distortionType": "radialk3",
                        "width": 3008,
                        "height": 2000,
                        "sensorWidth": 23.2,
                        "sensorHeight": 15.425531914893616,
                        "serialNumber": "C:/Users/cerve/VS/DP/prakticka/datasets/dataset_05/images_NIKON CORPORATION_NIKON D3200",
                        "principalPoint": {
                            "x": 0.0,
                            "y": 0.0
                        },
                        "initializationMode": "estimated",
                        "distortionInitializationMode": "none",
                        "distortionParams": [
                            0.0,
                            0.0,
                            0.0
                        ],
                        "undistortionOffset": {
                            "x": 0.0,
                            "y": 0.0
                        },
                        "undistortionParams": [],
                        "locked": false
                    }
                ],
                "sensorDatabase": "${ALICEVISION_SENSOR_DB}",
                "lensCorrectionProfileInfo": "${ALICEVISION_LENS_PROFILE_INFO}",
                "lensCorrectionProfileSearchIgnoreCameraModel": true,
                "defaultFieldOfView": 45.0,
                "groupCameraFallback": "folder",
                "rawColorInterpretation": "LibRawWhiteBalancing",
                "colorProfileDatabase": "${ALICEVISION_COLOR_PROFILE_DB}",
                "errorOnMissingColorProfile": true,
                "viewIdMethod": "metadata",
                "viewIdRegex": ".*?(\\d+)",
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}/cameraInit.sfm"
            }
        },
        "ConvertSfMFormat_1": {
            "nodeType": "ConvertSfMFormat",
            "position": [
                1761,
                -34
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 1,
                "split": 1
            },
            "uid": "8fad7c1719a53344e48442d0fd92ab5984e57795",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{Meshing_1.output}",
                "fileExt": "ply",
                "describerTypes": [
                    "dspsift",
                    "unknown"
                ],
                "imageWhiteList": [],
                "views": false,
                "intrinsics": false,
                "extrinsics": false,
                "structure": true,
                "observations": false,
                "surveys": false,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}/sfm.{fileExtValue}"
            }
        },
        "DepthMapFilter_1": {
            "nodeType": "DepthMapFilter",
            "position": [
                1400,
                0
            ],
            "parallelization": {
                "blockSize": 24,
                "size": 16,
                "split": 1
            },
            "uid": "31df7a8101d2af51694cd8761969ecc9c8cac4ee",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{DepthMap_1.input}",
                "depthMapsFolder": "{DepthMap_1.output}",
                "minViewAngle": 2.0,
                "maxViewAngle": 70.0,
                "nNearestCams": 10,
                "minNumOfConsistentCams": 3,
                "minNumOfConsistentCamsWithLowSimilarity": 4,
                "pixToleranceFactor": 2.0,
                "pixSizeBall": 0,
                "pixSizeBallWithLowSimilarity": 0,
                "computeNormalMaps": false,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}",
                "depth": "{nodeCacheFolder}/<VIEW_ID>_depthMap.exr",
                "sim": "{nodeCacheFolder}/<VIEW_ID>_simMap.exr",
                "normal": "{nodeCacheFolder}/<VIEW_ID>_normalMap.exr"
            }
        },
        "DepthMap_1": {
            "nodeType": "DepthMap",
            "position": [
                1200,
                0
            ],
            "parallelization": {
                "blockSize": 12,
                "size": 16,
                "split": 2
            },
            "uid": "b23748c0ff311fbf695f8b06cbb54e09f59c3cad",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{PrepareDenseScene_1.input}",
                "imagesFolder": "{PrepareDenseScene_1.output}",
                "downscale": 2,
                "minViewAngle": 2.0,
                "maxViewAngle": 70.0,
                "tiling": {
                    "tileBufferWidth": 1024,
                    "tileBufferHeight": 1024,
                    "tilePadding": 64,
                    "autoAdjustSmallImage": true
                },
                "chooseTCamsPerTile": true,
                "maxTCams": 10,
                "sgm": {
                    "sgmScale": 2,
                    "sgmStepXY": 2,
                    "sgmStepZ": -1,
                    "sgmMaxTCamsPerTile": 4,
                    "sgmWSH": 4,
                    "sgmUseSfmSeeds": true,
                    "sgmSeedsRangeInflate": 0.2,
                    "sgmDepthThicknessInflate": 0.0,
                    "sgmMaxSimilarity": 1.0,
                    "sgmGammaC": 5.5,
                    "sgmGammaP": 8.0,
                    "sgmP1": 10.0,
                    "sgmP2Weighting": 100.0,
                    "sgmMaxDepths": 1500,
                    "sgmFilteringAxes": "YX",
                    "sgmDepthListPerTile": true,
                    "sgmUseConsistentScale": false
                },
                "refine": {
                    "refineEnabled": true,
                    "refineScale": 1,
                    "refineStepXY": 1,
                    "refineMaxTCamsPerTile": 4,
                    "refineSubsampling": 10,
                    "refineHalfNbDepths": 15,
                    "refineWSH": 3,
                    "refineSigma": 15.0,
                    "refineGammaC": 15.5,
                    "refineGammaP": 8.0,
                    "refineInterpolateMiddleDepth": false,
                    "refineUseConsistentScale": false
                },
                "colorOptimization": {
                    "colorOptimizationEnabled": true,
                    "colorOptimizationNbIterations": 100
                },
                "customPatchPattern": {
                    "sgmUseCustomPatchPattern": false,
                    "refineUseCustomPatchPattern": false,
                    "customPatchPatternSubparts": [],
                    "customPatchPatternGroupSubpartsPerLevel": false
                },
                "intermediateResults": {
                    "exportIntermediateDepthSimMaps": false,
                    "exportIntermediateNormalMaps": false,
                    "exportIntermediateVolumes": false,
                    "exportIntermediateCrossVolumes": false,
                    "exportIntermediateTopographicCutVolumes": false,
                    "exportIntermediateVolume9pCsv": false,
                    "exportTilePattern": false
                },
                "nbGPUs": 0,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}",
                "depth": "{nodeCacheFolder}/<VIEW_ID>_depthMap.exr",
                "sim": "{nodeCacheFolder}/<VIEW_ID>_simMap.exr",
                "tilePattern": "{nodeCacheFolder}/<VIEW_ID>_tilePattern.obj",
                "depthSgm": "{nodeCacheFolder}/<VIEW_ID>_depthMap_sgm.exr",
                "depthSgmUpscaled": "{nodeCacheFolder}/<VIEW_ID>_depthMap_sgmUpscaled.exr",
                "depthRefined": "{nodeCacheFolder}/<VIEW_ID>_depthMap_refinedFused.exr"
            }
        },
        "FeatureExtraction_1": {
            "nodeType": "FeatureExtraction",
            "position": [
                200,
                0
            ],
            "parallelization": {
                "blockSize": 40,
                "size": 16,
                "split": 1
            },
            "uid": "a57146ecfffe13cdcccea0651ea3d4610b531dfc",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{CameraInit_1.output}",
                "masksFolder": "",
                "maskExtension": "png",
                "maskInvert": false,
                "describerTypes": [
                    "dspsift"
                ],
                "describerPreset": "normal",
                "maxNbFeatures": 0,
                "describerQuality": "normal",
                "contrastFiltering": "GridSort",
                "relativePeakThreshold": 0.01,
                "gridFiltering": true,
                "workingColorSpace": "sRGB",
                "forceCpuExtraction": true,
                "maxThreads": 0,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}"
            }
        },
        "FeatureMatching_1": {
            "nodeType": "FeatureMatching",
            "position": [
                600,
                0
            ],
            "parallelization": {
                "blockSize": 20,
                "size": 16,
                "split": 1
            },
            "uid": "ea5c861fce8e320582ead98b766c26bc896ae849",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{ImageMatching_1.input}",
                "featuresFolders": "{ImageMatching_1.featuresFolders}",
                "imagePairsList": "{ImageMatching_1.output}",
                "describerTypes": "{FeatureExtraction_1.describerTypes}",
                "photometricMatchingMethod": "ANN_L2",
                "geometricEstimator": "acransac",
                "geometricFilterType": "fundamental_matrix",
                "distanceRatio": 0.8,
                "maxIteration": 50000,
                "geometricError": 0.0,
                "knownPosesGeometricErrorMax": 5.0,
                "minRequired2DMotion": -1.0,
                "maxMatches": 0,
                "savePutativeMatches": false,
                "crossMatching": false,
                "guidedMatching": false,
                "matchFromKnownCameraPoses": false,
                "exportDebugFiles": false,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}"
            }
        },
        "ImageMatching_1": {
            "nodeType": "ImageMatching",
            "position": [
                400,
                0
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 16,
                "split": 1
            },
            "uid": "5ec131a4ae0942aa2b2ef7aa59510219f38960f3",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{FeatureExtraction_1.input}",
                "featuresFolders": [
                    "{FeatureExtraction_1.output}"
                ],
                "method": "SequentialAndVocabularyTree",
                "tree": "${ALICEVISION_VOCTREE}",
                "weights": "",
                "minNbImages": 200,
                "maxDescriptors": 500,
                "nbMatches": 40,
                "nbNeighbors": 5,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}/imageMatches.txt"
            }
        },
        "Meshing_1": {
            "nodeType": "Meshing",
            "position": [
                1600,
                0
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 1,
                "split": 1
            },
            "uid": "2ac1bcfbda58307616fc6cff9d78837ed02c1064",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{DepthMapFilter_1.input}",
                "depthMapsFolder": "{DepthMapFilter_1.output}",
                "outputMeshFileType": "obj",
                "useBoundingBox": false,
                "boundingBox": {
                    "bboxTranslation": {
                        "x": 0.0,
                        "y": 0.0,
                        "z": 0.0
                    },
                    "bboxRotation": {
                        "x": 0.0,
                        "y": 0.0,
                        "z": 0.0
                    },
                    "bboxScale": {
                        "x": 1.0,
                        "y": 1.0,
                        "z": 1.0
                    }
                },
                "estimateSpaceFromSfM": true,
                "estimateSpaceMinObservations": 3,
                "estimateSpaceMinObservationAngle": 10.0,
                "maxInputPoints": 50000000,
                "maxPoints": 5000000,
                "maxPointsPerVoxel": 1000000,
                "minStep": 2,
                "partitioning": "singleBlock",
                "repartition": "multiResolution",
                "angleFactor": 15.0,
                "simFactor": 15.0,
                "minVis": 2,
                "pixSizeMarginInitCoef": 2.0,
                "pixSizeMarginFinalCoef": 4.0,
                "voteMarginFactor": 4.0,
                "contributeMarginFactor": 2.0,
                "simGaussianSizeInit": 10.0,
                "simGaussianSize": 10.0,
                "minAngleThreshold": 1.0,
                "refineFuse": true,
                "helperPointsGridSize": 10,
                "densify": false,
                "densifyNbFront": 1,
                "densifyNbBack": 1,
                "densifyScale": 20.0,
                "nPixelSizeBehind": 4.0,
                "fullWeight": 1.0,
                "voteFilteringForWeaklySupportedSurfaces": true,
                "addLandmarksToTheDensePointCloud": false,
                "invertTetrahedronBasedOnNeighborsNbIterations": 10,
                "minSolidAngleRatio": 0.2,
                "nbSolidAngleFilteringIterations": 2,
                "colorizeOutput": true,
                "addMaskHelperPoints": false,
                "maskHelperPointsWeight": 1.0,
                "maskBorderSize": 4,
                "maxNbConnectedHelperPoints": 50,
                "saveRawDensePointCloud": false,
                "exportDebugTetrahedralization": false,
                "seed": 0,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "outputMesh": "{nodeCacheFolder}/mesh.{outputMeshFileTypeValue}",
                "output": "{nodeCacheFolder}/densePointCloud.abc"
            }
        },
        "PrepareDenseScene_1": {
            "nodeType": "PrepareDenseScene",
            "position": [
                1000,
                0
            ],
            "parallelization": {
                "blockSize": 40,
                "size": 16,
                "split": 1
            },
            "uid": "73078e9a5a6a1c596f201ec30c66655b7ddd931f",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{StructureFromMotion_1.output}",
                "imagesFolders": [],
                "masksFolders": [],
                "maskExtension": "png",
                "outputFileType": "exr",
                "saveMetadata": true,
                "saveMatricesTxtFiles": false,
                "evCorrection": false,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}",
                "undistorted": "{nodeCacheFolder}/<VIEW_ID>.{outputFileTypeValue}"
            }
        },
        "Publish_1": {
            "nodeType": "Publish",
            "position": [
                1923,
                90
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 1,
                "split": 1
            },
            "uid": "b8be9e790051a1d0b9be34df72bfd82e805d156d",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "inputFiles": [
                    "{ConvertSfMFormat_1.output}"
                ],
                "output": "",
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {}
        },
        "StructureFromMotion_1": {
            "nodeType": "StructureFromMotion",
            "position": [
                800,
                0
            ],
            "parallelization": {
                "blockSize": 0,
                "size": 16,
                "split": 1
            },
            "uid": "940315f10838e80a4215e60232e54b2329383734",
            "internalFolder": "{cache}/{nodeType}/{uid}",
            "inputs": {
                "input": "{FeatureMatching_1.input}",
                "featuresFolders": "{FeatureMatching_1.featuresFolders}",
                "matchesFolders": [
                    "{FeatureMatching_1.output}"
                ],
                "describerTypes": "{FeatureMatching_1.describerTypes}",
                "localizerEstimator": "acransac",
                "observationConstraint": "Scale",
                "localizerEstimatorMaxIterations": 50000,
                "localizerEstimatorError": 0.0,
                "lockScenePreviouslyReconstructed": false,
                "useLocalBA": true,
                "localBAGraphDistance": 1,
                "nbFirstUnstableCameras": 30,
                "maxImagesPerGroup": 30,
                "bundleAdjustmentMaxOutliers": 50,
                "maxNumberOfMatches": 0,
                "minNumberOfMatches": 0,
                "minInputTrackLength": 2,
                "minNumberOfObservationsForTriangulation": 2,
                "minAngleForTriangulation": 3.0,
                "minAngleForLandmark": 2.0,
                "maxReprojectionError": 4.0,
                "minAngleInitialPair": 5.0,
                "maxAngleInitialPair": 40.0,
                "useOnlyMatchesFromInputFolder": false,
                "useRigConstraint": true,
                "rigMinNbCamerasForCalibration": 20,
                "lockAllIntrinsics": false,
                "minNbCamerasToRefinePrincipalPoint": 3,
                "filterTrackForks": false,
                "computeStructureColor": true,
                "useAutoTransform": true,
                "initialPairA": "",
                "initialPairB": "",
                "interFileExtension": ".abc",
                "logIntermediateSteps": false,
                "verboseLevel": "info"
            },
            "internalInputs": {
                "invalidation": "",
                "comment": "",
                "label": "",
                "color": ""
            },
            "outputs": {
                "output": "{nodeCacheFolder}/sfm.abc",
                "outputViewsAndPoses": "{nodeCacheFolder}/cameras.sfm",
                "extraInfoFolder": "{nodeCacheFolder}"
            }
        }
    }
}