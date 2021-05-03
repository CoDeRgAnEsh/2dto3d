import 'dart:async';
import 'dart:core' hide print;
import 'dart:core' as core;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' hide FileSystem, File;
import 'package:fs_shim/fs_browser.dart';
import 'package:fs_shim/fs_idb.dart';
import 'package:path/path.dart';

FileSystem fs = fileSystemIdb;

PreElement outElement;

Directory dir;

void print(msg) {
  outElement = (outElement ?? querySelector('#output') as PreElement);
  outElement.text = '${outElement.text}$msg\n';
}

Future createDir() async {
  dir = fs.directory('/dir');
  // delete its content if exits
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
}

Future<String> writeFile(String objContents) async{
await createDir();
final file = fs.file(join(dir.path, 'out.obj'));
await file.create(recursive: true);
await file.writeAsString(objContents);
print('file: ${file.path}');
return file.path;
}

/*Future main() async {
  // Create a top level directory
  final dir = fs.directory('/dir');

  // delete its content
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }

  // and a file in it
  final file = fs.file(join(dir.path, 'out.obj'));

  // create a file
  await file.create(recursive: true);
  await file.writeAsString('Hello world!');

  // read a file
  _print('file: $file');
  _print('content: ${await file.readAsString()}');

  // use a file link if supported
  if (fs.supportsFileLink) {
    final link = fs.link(join(dir.path, 'link'));
    await link.create(file.path);

    _print('link: $link target ${await link.target()}');
    _print('content: ${await fs.file(link.path).readAsString()}');
  }

  // list dir content
  _print('Listing dir: $dir');
  for (var fse in await dir.list(recursive: true, followLinks: true).toList()) {
    _print('  found: $fse');
  }
}*/