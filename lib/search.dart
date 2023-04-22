import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Searching extends StatefulWidget {
  const Searching({Key? key}) : super(key: key);

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  final controller = TextEditingController();
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        children: [
            TextField(
          controller: controller
        ),

          TextButton(onPressed: (){
            Navigator.of(context).pop(controller.text);
          }, child: Text("search")),
      ],
      ),
      ),

    );
  }
}
