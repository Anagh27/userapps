import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String phone;
  String imageUrl;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _imageUrl = '';

  List<User> users = [];

  void _showFormDialog({User? user, int? index}) {
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _imageUrl = user.imageUrl;
    } else {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _imageUrl = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user == null ? "Add User" : "Update User"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _changeImage(),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_imageUrl),
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!value.endsWith('@gmail.com')) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    maxLength: 10,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      } if (value.length < 10) {
                        return "please enter your full number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final newUser = User(
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    imageUrl: _imageUrl,
                  );
                  if (user == null) {
                    setState(() {
                      users.add(newUser);
                    });
                  } else {
                    setState(() {
                      users[index!] = newUser;
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(user == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
  void _changeImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final imageController = TextEditingController();
        return AlertDialog(
          title: const Text("Enter Image URL"),
          content: TextField(
            controller: imageController,
            decoration: const InputDecoration(hintText: "Enter image URL"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (imageController.text.isNotEmpty) {
                  setState(() {
                    _imageUrl = imageController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add Image"),
            ),
          ],
        );
      },
    );
  }
  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }
  void _updateUser(int index) {
    _showFormDialog(user: users[index], index: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text("Users List"),
      ),
      body: users.isEmpty
          ? const Center(child: Text("No users added yet"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading:  CircleAvatar(
              backgroundImage: NetworkImage((user.imageUrl.isNotEmpty
                  ? user.imageUrl
                  : 'https://via.placeholder.com/150'),
              ),
            ),
            title: Text(user.name),
            subtitle: Text("Email: ${user.email}\nPhone: ${user.phone}"),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _updateUser(index),
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
