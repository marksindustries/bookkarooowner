import 'package:flutter/material.dart';

class TextFieldBookKaroo extends StatelessWidget {
  final int? maxLength;
  final String text;
  final TextEditingController controllerName;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final TextInputType? type;

  TextFieldBookKaroo(
      {this.type,
        this.maxLength,
        required this.text,
        required this.controllerName,
        this.focusNode,
        this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: maxLength,
        keyboardType: type,
        onChanged: onChanged,
        focusNode: focusNode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controllerName,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          counterText: "",
          label: Text(
            text,
          ),
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}