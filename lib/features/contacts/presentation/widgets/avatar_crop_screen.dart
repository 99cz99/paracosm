import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/dialogs.dart';

/// Full-screen crop editor. Pops with the cropped PNG bytes ([Uint8List]) on
/// confirm, or null when the user backs out.
class AvatarCropScreen extends StatefulWidget {
  const AvatarCropScreen({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<AvatarCropScreen> createState() => _AvatarCropScreenState();
}

class _AvatarCropScreenState extends State<AvatarCropScreen> {
  final _controller = CropController();
  bool _cropping = false;

  void _confirm() {
    setState(() => _cropping = true);
    _controller.crop();
  }

  void _onCropped(CropResult result) {
    if (!mounted) return;
    switch (result) {
      case CropSuccess(:final croppedImage):
        Navigator.of(context).pop(croppedImage);
      case CropFailure(:final cause):
        setState(() => _cropping = false);
        showErrorDialog(context, '裁剪失败：$cause');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('裁剪头像'),
        actions: [
          TextButton(
            onPressed: _cropping ? null : _confirm,
            child: _cropping
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('确定', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Crop(
          image: widget.imageBytes,
          controller: _controller,
          aspectRatio: 1,
          interactive: true,
          onCropped: _onCropped,
          baseColor: Colors.black,
          maskColor: Colors.black.withValues(alpha: 0.6),
          progressIndicator: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
