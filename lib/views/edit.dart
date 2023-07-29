import 'package:flutter/material.dart';
import 'package:project_uas/models/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_uas/viewmodels/user_vm.dart';
import 'home.dart';

class EditPage extends StatelessWidget {
  final Product product;
  final ApiService apiService = ApiService();
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final TextEditingController imageController;

  EditPage(this.product)
      : nameController = TextEditingController(text: product.name),
        descriptionController = TextEditingController(text: product.desk),
        priceController = TextEditingController(),
        categoryController = TextEditingController(),
        imageController = TextEditingController(text: product.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> updatedProduct = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                };

                try {
                  await apiService.updateProduct(
                    product.id,
                    updatedProduct,
                  );
                  Navigator.pop(
                      context); // Go back to the home page after successful update
                } catch (e) {
                  print(e);
                  // Handle error if needed
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
