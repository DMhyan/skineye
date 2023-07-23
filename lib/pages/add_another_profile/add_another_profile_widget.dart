import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAnotherProfileWidget extends StatefulWidget {
  const AddAnotherProfileWidget({Key? key}) : super(key: key);

  @override
  _AddAnotherProfileWidgetState createState() =>
      _AddAnotherProfileWidgetState();
}

class _AddAnotherProfileWidgetState extends State<AddAnotherProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File? _selectedImageUrl;
  String? message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 80),
              child: Text(
                'Skin Analysis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF437FBB),
                  fontSize: 50,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _selectImage(),
              child: Text('Select Image'),
            ),
          ),
          if (_selectedImageUrl != null)
            Expanded(
              flex: 2,
              child: Image.file(_selectedImageUrl!),
            ),
        ],
      ),
    );
  }

  // Function to select an image using ImagePicker
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _selectedImageUrl = File(pickedFile!.path);
    setState(() {});

    
    uploadImage() async{
    final request =
        http.MultipartRequest("POST", Uri.parse("https://ee0c-122-171-20-212.ngrok-free.app/upload"));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile('image', _selectedImageUrl!.readAsBytes().asStream(),
          _selectedImageUrl!.lengthSync(),
          filename: _selectedImageUrl!.path.split("/").last),
    );
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    setState(() {});
    
  }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddAnotherProfileWidget(),
    );
  }
}
