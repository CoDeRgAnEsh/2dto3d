import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:meshy/utils/image_pic_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker().getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    cropImage(File(image.path));
  }

  openGallery() async {
    imagePicker.dismissDialog();
    if (kIsWeb) {
      var image = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
      print(image);
      _listener.networkImage(image);
    } else {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      cropImage(File(image.path));
    }
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 60,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your Pic',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
            title: 'Crop your Pic', aspectRatioLockEnabled: true));
    _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
  networkImage(Uint8List _img);
}
