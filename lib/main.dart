import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? pickedImage;
  XFile? _imageFile;
  Uri url = Uri.parse('http://10.0.2.2:5000/upload');

  Future<String?> uploadImage(filename, url) async {
    print("check7 - $filename");
    var request = http.MultipartRequest('POST', url);
    print("check8 - $filename");
    request.files.add(await http.MultipartFile.fromPath('file', filename.path));
    print("check9 - $filename");
    var res = await request.send();
    print("check10 - $filename");
    // var decodedData = json.decode(res);
    print(res.headers);
    print(res.stream);
    print(res.request);
    print(res.statusCode);
    print(res.toString());
    res.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    return res.reasonPhrase;
  }

  String state = "";

  Future _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return null;
    }

    setState(() {
      pickedImage = File(imageFile.path);
      _imageFile = imageFile;
      print('Original path: ${pickedImage}');
      String dir = path.dirname(_imageFile!.path);

      String newPath = path.join(dir, 'Iris1.jpg');
      print('NewPath: ${newPath}');
      // Future<File> f = File(pickedImage!.path).copy(newPath);
      // print('f:$f');
      // File(_imageFile!.path).rename(newPath);
      // pickedImage = File(_imageFile!.path);
      File(_imageFile!.path).renameSync(newPath);
      print('check2');
      // print('check 1 - ${pickedImage!.path}');
      // pickedImage!.renameSync(newPath);
      pickedImage = File(newPath);
      print('check3 - $pickedImage');
      print('check4 - ${_imageFile!.path}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _pickImage();
          print("check5");
          var res = await uploadImage(pickedImage, url);
          print("check6");
          setState(() {
            state = res!;
            print(res);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
