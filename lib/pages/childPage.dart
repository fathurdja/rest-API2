// ignore_for_file: file_names, camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class childPage extends StatefulWidget {
  const childPage({super.key});

  @override
  State<childPage> createState() => _childPageState();
}

class _childPageState extends State<childPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD TodoList"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: title,
              decoration: const InputDecoration(hintText: "Title"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: description,
              decoration: const InputDecoration(hintText: "Description"),
              minLines: 5,
              maxLines: 8,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  void submitData() async {
    //get data from form
    final dataTitle = title.text;
    final dataDesc = description.text;

    final body = {
      "title": dataTitle,
      "description": dataDesc,
      "is_completed": false
    };

    //submit data to Server
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 201) {
      showSuccesMessage("Creation Succes");
    } else {
      showFailedMessage("Creation Failed");
    }

    //show succes or failed
  }

  void showSuccesMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.teal,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showFailedMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
