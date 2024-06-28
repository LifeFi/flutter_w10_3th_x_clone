import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;

  late FlashMode _flashMode;
  late Icon _selectedFlashIcon;
  late CameraController _cameraController;

  final List<Map<String, dynamic>> _flashModeList = [
    {
      "flashMode": FlashMode.auto,
      "icon": const Icon(
        Icons.flash_auto_rounded,
        size: Sizes.size28,
      ),
    },
    {
      "flashMode": FlashMode.off,
      "icon": const Icon(
        Icons.flash_off_rounded,
        size: Sizes.size28,
      ),
    },
    {
      "flashMode": FlashMode.always,
      "icon": const Icon(
        Icons.flash_on_rounded,
        size: Sizes.size28,
      ),
    },
    {
      "flashMode": FlashMode.torch,
      "icon": const Icon(
        Icons.flashlight_on_rounded,
        size: Sizes.size28,
      ),
    }
  ];

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
      // dispose 되었는데 setState 하는 오류 방지하기 위해 mounted 체크.
      if (mounted) setState(() {});
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;

    _selectedFlashIcon = _flashModeList[
        _flashModeList.indexWhere((e) => e["flashMode"] == _flashMode)]["icon"];

    // iOS 를 위한 추가 설정
    await _cameraController.prepareForVideoRecording();
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      await initCamera();
      _hasPermission = true;
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _toggleFlashMode() async {
    final index =
        _flashModeList.indexWhere((e) => e["flashMode"] == _flashMode);
    if (index != _flashModeList.length - 1) {
      _flashMode = _flashModeList[index + 1]["flashMode"];
      _selectedFlashIcon = _flashModeList[index + 1]["icon"];
    } else {
      _flashMode = _flashModeList[0]["flashMode"];
      _selectedFlashIcon = _flashModeList[0]["icon"];
    }
    await _cameraController.setFlashMode(_flashMode);
    setState(() {});
  }

  _onCancelTap() {
    Navigator.of(context).pop();
  }

  Future<void> _takePicture() async {
    if (_cameraController.value.isTakingPicture) return;
    final photo = await _cameraController.takePicture();
    final List<XFile> photos = [photo];

    if (!mounted) return;
    Navigator.of(context).pop(photos);
  }

  Future<void> _onPickImagePressed() async {
    print("pressed");
    final photos = await ImagePicker().pickMultiImage();
    if (!mounted) return;
    Navigator.of(context).pop(photos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: !_hasPermission || !_cameraController.value.isInitialized
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Initializing...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                        ),
                      ),
                      Gaps.v20,
                      CircularProgressIndicator.adaptive()
                    ],
                  )
                : Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      CameraPreview(_cameraController),
                      Positioned(
                        bottom: 180,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: IconButton(
                                color: Colors.white,
                                onPressed: _toggleFlashMode,
                                icon: _selectedFlashIcon,
                              ),
                            ),
                            GestureDetector(
                              onTap: _takePicture,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: Sizes.size80 + Sizes.size10,
                                    height: Sizes.size80 + Sizes.size10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 5.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                color: Colors.white,
                                onPressed: _toggleSelfieMode,
                                icon: const FaIcon(
                                  FontAwesomeIcons.cameraRotate,
                                  size: Sizes.size28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: Sizes.size52,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            const Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size20,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _onPickImagePressed,
                                child: const Text(
                                  "Library",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Sizes.size20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: Sizes.size40,
            left: Sizes.size20,
            child: IconButton(
              onPressed: _onCancelTap,
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
