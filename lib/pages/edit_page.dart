import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.initFunc,
    required this.id,
    required this.name,
    required this.description,
  });
  final Function() initFunc;
  final String id;
  final String name;
  final String description;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Edit'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController..text = widget.name,
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
                  controller: descriptionController..text = widget.description,
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
                    updateData(nameController, descriptionController);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateData(final nameValue, final descriptionValue) async {
    final db = FirebaseFirestore.instance;
    final Map<String, dynamic> data = {
      'name': nameValue.text,
      'description': descriptionValue.text,
    };
    await db.collection('todos').doc(widget.id).update(data);
    nameValue.clear();
    descriptionValue.clear();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Record successfully updated!"),
    ));
    widget.initFunc();
  }
}
