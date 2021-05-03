import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:meshy/utils/SpUtil.dart';
import 'package:meshy/utils/webFile.dart';
import 'package:path_provider/path_provider.dart';

void initAsync() async {
  await SpUtil.getInstance();
}

Future<String> getObject(File image) async {
  String url;
  var headers = {'token': '413b60ba-7fd5-4ed2-9344-5507e064e55f'};
  var urlRequest = http.Request(
      'GET',
      Uri.parse(
          'https://app.easydb.io/database/5436a5c3-6b8c-43c4-81f3-1b7327f68952/url'));
  urlRequest.headers.addAll(headers);
  var urlResponse = await urlRequest.send();
  if (urlResponse.statusCode == 200) {
    url=await urlResponse.stream.bytesToString();
    url=url.replaceAll('"', '');
    print(url);
  } else {
    print(urlResponse.reasonPhrase);
  }
  var request = http.MultipartRequest(
      'POST', Uri.parse(url+'/convert/'));
  request.files.add(await http.MultipartFile.fromPath('image', image.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    print('Success');
    var downloaded = await response.stream.bytesToString();
    print(downloaded);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath/out.obj');
    await file.writeAsString(downloaded);
    SpUtil.putString("filepath", file.path);
    print(SpUtil.getString('filepath'));
    print('Done!');
    return 'Success';
  } else {
    print(response.statusCode);
    print(response.headers);
    print(response.reasonPhrase);
    return 'Failed';
  }
}


Future<String> getObjectWeb(Uint8List image) async {
  String url;
  var headers = {'token': '413b60ba-7fd5-4ed2-9344-5507e064e55f'};
  var urlRequest = http.Request(
      'GET',
      Uri.parse(
          'https://app.easydb.io/database/5436a5c3-6b8c-43c4-81f3-1b7327f68952/url'));
  urlRequest.headers.addAll(headers);
  var urlResponse = await urlRequest.send();
  if (urlResponse.statusCode == 200) {
    url=await urlResponse.stream.bytesToString();
    url=url.replaceAll('"', '');
    print(url);
  } else {
    print(urlResponse.reasonPhrase);
  }
  var request = http.MultipartRequest(
      'POST', Uri.parse(url+'/convert/'));
  request.files.add(http.MultipartFile.fromBytes('image', image, filename: 'input.png'));
  var response = await request.send();
  if (response.statusCode == 200) {
    print('Success');
    var downloaded = await response.stream.bytesToString();
    print(downloaded);
    var objWrite = await writeFile(downloaded);
    SpUtil.putString("filepath", objWrite);
    print(SpUtil.getString('filepath'));
    /*Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath/out.obj');
    await file.writeAsString(downloaded);
    SpUtil.putString("filepath", file.path);
    print(SpUtil.getString('filepath'));*/
    print('Done!');
    return 'Success';
  } else {
    print(response.statusCode);
    print(response.headers);
    print(response.reasonPhrase);
    return 'Failed';
  }
}
