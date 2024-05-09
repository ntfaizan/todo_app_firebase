import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/pages/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    final qs = await FirebaseFirestore.instance.collection("todos").get();
    items = qs.docs.map((doc) => doc.data()).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddPage()));
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Text("No Item Found"),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  child: Text("$index"),
                ),
                title: Text(items[index]['name']),
                subtitle: Text(items[index]['description']),
              ),
            ),
    );
  }
}
