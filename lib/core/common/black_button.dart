import 'package:flutter/material.dart';

import 'package:receipt_creator/core/common/loading.dart';

class MyButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final String buttonText;
  final double width;

  const MyButton({
    required this.onTap,
    required this.buttonText,
    this.isLoading = false,
    this.width = double.infinity,
    super.key,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: widget.isLoading
              ? const Loader()
              : Text(
                  widget.buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
