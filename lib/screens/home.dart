import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:meshy/screens/imgPreview.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meshy - 2D Image to 3D Mesh'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: (){
          showDialog(context: context,
              builder: (BuildContext context){
                return infoDialog(context);
              }
          );
        },)],
        brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.network(
              'https://assets3.lottiefiles.com/packages/lf20_80x6ptki.json',
              height: 300,
              width: 300,
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 180,
              child: Tooltip(
                message: 'Try Out',
                child: ElevatedButton.icon(
                  icon: Icon(Icons.sentiment_very_satisfied),
                  label: Text('Try Out'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImgPreview()),
                    );
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
        ),
      ),
    );
  }
}


Widget infoDialog(context) {
return Dialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
elevation: 0,
backgroundColor: Colors.transparent,
child: contentBox(context),
);
}
contentBox(context){
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 20,top: 45.0
            + 20, right: 20,bottom: 20),
        margin: EdgeInsets.only(top: 45),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
                  blurRadius: 10
              ),
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('About',style: TextStyle(fontSize: 22,),),
            SizedBox(height: 10,),
            Text('Meshy v1.0',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),textAlign: TextAlign.justify,),
            SizedBox(height: 15,),
            Text('A 2D image to 3D object mesh reconstruction application developed as a part of Final year project for Bachelor\'s Degree requirement',style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Text('Made by Ganesh Kumar T K (MSM17B034)',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
            SizedBox(height: 22,),
            Align(
              alignment: Alignment.bottomRight,
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',style: TextStyle(fontSize: 18),)),
            ),
          ],
        ),
      ),
      Positioned(
        left: 20,
        right: 20,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 45,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(color: Colors.blue,),
          ),
        ),
      ),
    ],
  );
}


