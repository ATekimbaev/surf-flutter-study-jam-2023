import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet(
      {super.key, required this.controller, required this.onPressed});

  final TextEditingController controller;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height * 0.33,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: controller,
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Добавить'),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
