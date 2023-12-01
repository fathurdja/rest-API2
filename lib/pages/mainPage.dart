// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_8/pages/childPage.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

// ignore: camel_case_types
class _mainPageState extends State<mainPage> {
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("appTODO"),
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'];
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(
                  item['title'],
                ),
                subtitle: Text(
                  item['description'],
                ),
                trailing: IconButton(
                  onPressed: () {
                    deleteById(id);
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateTodoPage();
          },
          label: const Text("Todo List")),
    );
  }

  void navigateTodoPage() {
    final route = MaterialPageRoute(builder: (context) => const childPage());
    Navigator.push(context, route);
  }

  Future<void> fetchData() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final result = json['items'] as List;

    setState(() {
      items = result;
    });
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = http.delete(uri);

    final filter = items.where((element) => element['_id'] != id).toList();
    setState(() {
      items = filter;
    });
  }
}
