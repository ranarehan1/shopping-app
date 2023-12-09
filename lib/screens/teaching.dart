import 'package:flutter/material.dart';

class Teaching extends StatefulWidget {
  const Teaching({super.key});

  @override
  State<Teaching> createState() => _TeachingState();
}

class _TeachingState extends State<Teaching> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torch light'),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            // width: MediaQuery.of(context).size.width * 0.2,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Text('My Name is Rehan.')
        ],
      ),
    );
  }
}

