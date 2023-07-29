import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:project_uas/views/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_uas/viewmodels/user_vm.dart';
// ignore: unused_import
import '../models/model.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController deskController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final ApiService apiService = ApiService();
  File? _pickedImage;
  String url = '';

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: deskController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            // Show picked image if available
            if (_pickedImage != null)
              Image.file(_pickedImage!, height: 150, width: 150),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await apiService.saveProduct(
                    nameController.text,
                    int.parse(
                        priceController.text), // Parse the price text to int
                    deskController.text,
                    categoryController.text,
                    _pickedImage?.path,
                    url, // Use image path if available, or empty string if not picked
                  );
                  Navigator.pop(
                      context); // Go back to the home page after successful creation
                } catch (e) {
                  print('Error creating product: $e');
                  Fluttertoast.showToast(
                    msg: 'Failed to create product. Please try again later.',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
