import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:meshy/utils/SpUtil.dart';

class ObjmeshPage extends StatefulWidget {
  ObjmeshPage({Key key}) : super(key: key);

  @override
  _ObjmeshPageState createState() => _ObjmeshPageState();
}

class _ObjmeshPageState extends State<ObjmeshPage>
    with SingleTickerProviderStateMixin {
  Scene _scene;
  Object _obj;
  AnimationController _controller;
  double _ambient = 0.1;
  double _diffuse = 0.8;
  double _specular = 0.5;
  double _shininess = 1.0;
  String objFile;
  bool loaded=false;

  void initAsync() async {
    await SpUtil.getInstance();
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 10;
    scene.camera.zoom = 3;
    scene.light.position.setFrom(Vector3(0, 10, 10));
    scene.light.setColor(Colors.grey, _ambient, _diffuse, _specular);
    _obj = Object(
        position: Vector3(0, -1.0, 0),
        scale: Vector3(10.0, 10.0, 10.0),
        lighting: true,
        fileName: kIsWeb?'/dir/out.obj':objFile,
        isAsset: false);
    _obj.mesh.material.shininess = _shininess;
    scene.world.add(_obj);
  }

  @override
  void initState() {
    super.initState();
    initAsync();
    objFile = SpUtil.getString('filepath');
    print(objFile);
    _controller = AnimationController(
        duration: Duration(milliseconds: 3000000), vsync: this)
      ..addListener(() {
        if (_obj != null) {
          _obj.rotation.x = _controller.value * 180;
          _obj.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
          setState(() {
      loaded=true;
    });
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
        title: Text('Rendered Mesh'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: Center(
        child: loaded?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            /*Container(
              height: 200,
              width: 200,
              child: Placeholder(),
            ),
            SizedBox(height: 20),*/
            Container(
              height: 400,
              width: kIsWeb?600:300,
              color: Colors.grey[300],
              child:
                  /*Cube(
          onSceneCreated: (Scene scene) {
            scene.world.add(Object(fileName: 'assets/out.obj'));
            scene.camera.zoom=5;
            scene.light.setColor(Colors.grey, _ambient, _diffuse, _specular);
          },
        ),*/
                  Cube(onSceneCreated: _onSceneCreated),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              width: 150,
              child: Tooltip(
                message: 'Send to email',
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Send to email'),
                  onPressed: () {
                    print(objFile);
                  },
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
        ):Container(height:50, width:50, child:CircularProgressIndicator()),
      ),
    );
  }
}
