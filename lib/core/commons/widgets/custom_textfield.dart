import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function(String text) onChanged;
  final Function(String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final VoidCallback onSubmit;
  
  CustomTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    super.key, required this.onSubmit,
  });
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => TextFormField(
            onTapOutside: (event) {
              _focusNode.unfocus();
            },
            focusNode: _focusNode,
            maxLines: maxLines,
            controller: controller,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: (value) {
              print("onsubmit text field ${controller.text}");
              onSubmit();
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              alignLabelWithHint: false,
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              hintText: hintText,
              hintMaxLines: 1,
              label: Text(labelText),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
            onChanged: (value) {
              onChanged(value);
            },
            validator: (value) {
              return validationCheck(value!);
            },
          ),
    );
  }
}
