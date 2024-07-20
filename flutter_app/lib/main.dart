import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lit Image Compiler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'Upload an image Or write code!';
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.text = _message;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _imageUpload() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _message = 'Loading...';
        _messageController.text = _message;
      });
      String responseMsg = await ApiService().uploadImage(pickedFile.path);
      setState(() {
        _message =
            '//Read Output:\n\n $responseMsg  \n\n// You can fix or change errors if any \n// Click run when you are done';
        _messageController.text = _message;
      });
    }
  }

  void _runCode() async {
    String code = _messageController.text;
    String output = await ApiService().compileAndRunCode(code);
    setState(() {
      _message = output;
      _messageController.text = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Compiler C/C++'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                maxLines: null,
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Handle text field changes if needed
                },
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: _imageUpload,
                child: const Text('Press Me'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _runCode,
                child: const Text('Run'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
