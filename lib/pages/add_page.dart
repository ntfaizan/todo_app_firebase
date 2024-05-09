import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Add'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(hintText: "Enter Your Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: "Enter Description"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    bool isValid = formkey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    saveData(nameController, descriptionController);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveData(final nameValue, final descriptionValue) async {
    final db = FirebaseFirestore.instance;
    final Map<String, dynamic> data = {
      'name': nameValue.text,
      'description': descriptionValue.text,
    };
    await db.collection('todos').add(data);
    nameValue.clear();
    descriptionValue.clear();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Record successfully added!"),
    ));
  }
}
