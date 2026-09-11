import 'package:flutter/material.dart';

class InvalidBookRoute extends StatelessWidget {
  const InvalidBookRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Text('Invalid book route. Please check the link and try again.'),
    );
  }
}
