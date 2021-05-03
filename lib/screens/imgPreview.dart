import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meshy/functions/api.dart';
import 'package:meshy/screens/objMesh.dart';
import 'package:meshy/utils/image_picker_handler.dart';
import 'package:meshy/utils/sharedPref.dart';

// ignore: camel_case_types
class ImgPreview extends StatefulWidget {
  @override
  _ImgPreviewState createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview>
    with TickerProviderStateMixin, ImagePickerListener {
  Uint8List _img;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: _image != null
            ? Text('Preview image selected')
            : Text('Select Image'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
              height: 200,
              width: 200,
              child: (_image != null || _img!=null && isLoading == false)
                  ? kIsWeb
                      ? Image.memory(_img, fit: BoxFit.fill)
                      : Image.file(
                          _image,
                          fit: BoxFit.fill,
                        )
                  : isLoading
                      ? CircularProgressIndicator()
                      : Placeholder(),
            ),
            SizedBox(height: 50),
            (_image != null || _img!= null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 152,
                        child: Tooltip(
                          message: 'Change Image',
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: isLoading ? Colors.grey : Colors.blue,
                            ),
                            label: Text(
                              'Change Image',
                              style: TextStyle(
                                  color: isLoading ? Colors.grey : Colors.blue),
                            ),
                            onPressed: () => isLoading == false
                                ? imagePicker.showDialog(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shadowColor:
                                  isLoading ? Colors.grey : Colors.blue,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        child: Tooltip(
                          message: 'Proceed',
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.send),
                            label: Text('Proceed'),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              var sendFile = kIsWeb? await getObjectWeb(_img):await getObject(_image);
                              if (sendFile == 'Success') {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ObjmeshPage()),
                                );
                              } else {
                                print('Error');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 50,
                    width: 180,
                    child: Tooltip(
                      message: 'Select Image',
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add_photo_alternate_rounded),
                        label: Text('Select Image'),
                        onPressed: () => imagePicker.showDialog(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(_image.readAsBytesSync()));
    });
    //throw UnimplementedError();
  }

  @override
  networkImage(Uint8List _img) {
     setState(() {
      this._img = _img;
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(_img));
    });
    //throw UnimplementedError();
  }
}

/* loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        image = ImageSharedPrefs.imageFrom64BaseString(imageString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPrefs();
  }
 */
