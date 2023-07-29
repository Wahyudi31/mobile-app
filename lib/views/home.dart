import 'package:flutter/material.dart';
import 'package:project_uas/viewmodels/user_vm.dart';
import 'package:project_uas/models/model.dart';
import 'package:http/http.dart' as http;
import 'create.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  List dataUser = [];

  void getDataProduct() {
    ApiService().getProducts().then((value) {
      setState(() {
        dataUser = value;
      });
    }).catchError((error) {
      // Handle client exceptions when fetching data
      print('Error fetching data: $error');
      // You can show an error message or take any appropriate action here
    });
  }

  Future<Widget> _fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Image.memory(response.bodyBytes);
      } else {
        // Return a placeholder or default image widget if the request fails
        return const Text('Failed to load image');
      }
    } catch (error) {
      // Handle client exceptions when fetching images
      print('Error fetching image: $error');
      // You can show an error message or take any appropriate action here
      return const Text('Failed to load image');
    }
  }

  Widget personalDetailCard(Product data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                data.price.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              FutureBuilder<Widget>(
                future: _fetchImage(data.url), // Fetch the image
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while the image is being fetched
                    return CircularProgressIndicator();
                  } else {
                    // Show the image or placeholder/default widget
                    return snapshot.data ?? const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataProduct();
  }

  hapusProduct(int id) {
    ApiService().deleteProduct(id).then((value) => getDataProduct());
  }

  updateProduct(Product product) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EditPage(product)));
  }

  showDetailDialog(Product data) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Detail Person'),
            children: <Widget>[
              Text("id : ${data.id}"),
              Text("Name : ${data.name}"),
              Text("Price : ${data.price}"),
              Text("desk: ${data.desk}"),
              Text("image : ${data.url}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        hapusProduct(data.id);
                        Navigator.pop(context);
                      },
                      child: const Text("Hapus")),
                  ElevatedButton(
                      onPressed: () {
                        updateProduct(data);
                      },
                      child: const Text("Edit"))
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Utama"),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, i) {
            return GestureDetector(
                onTap: () {
                  showDetailDialog(dataUser[i]);
                },
                child: personalDetailCard(dataUser[i]));
          },
          // ignore: unnecessary_null_comparison
          itemCount: dataUser == null ? 0 : dataUser.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreatePage()))
        },
        heroTag: 'createNew',
        backgroundColor: const Color(0xFF242569),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
