import 'package:flutter/material.dart';


class DescriptionTextfield extends StatefulWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final String hintText;
  final String labelText;
  final int? maxLines;
  DescriptionTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    super.key
    });

  @override
  State<DescriptionTextfield> createState() => _DescriptionTextfieldState();
}

class _DescriptionTextfieldState extends State<DescriptionTextfield> {
  final FocusNode _focusNode = FocusNode(); 

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        //maxLines: null, // Allow multi-line input
        maxLines: widget.maxLines,
        controller: widget.controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: widget.hintText,
          label: Text(widget.labelText),
          labelStyle: Theme.of(context).textTheme.titleMedium,
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2
              ),
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          widget.onChanged(value);
          
        },
      ),
    );
  }
}