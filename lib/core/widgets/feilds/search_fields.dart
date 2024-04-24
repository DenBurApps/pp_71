// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String titleHint;
  void Function(String)? onChanged;
  void Function() onPressed;
  final Icon icons;
  SearchFieldWidget({
    super.key, // добавьте ключ
    required this.controller,
    required this.titleHint,
    required this.onPressed,
    required this.icons,
    this.onChanged,
  }); // инициализация ключа

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 55,
      
      child: Center(
        child: TextFormField(
          cursorHeight: 15,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.background),
          cursorColor: Theme.of(context).colorScheme.shadow,
          decoration: InputDecoration(
            hintText: widget.titleHint,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
            errorText: isError ? 'Enter ${widget.titleHint}' : null,
            errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.error,
                ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: const EdgeInsets.all(15),
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            
          ),
          controller: widget.controller,
          keyboardType: TextInputType.text,
          onChanged: widget.onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                isError = true;
              });
              return 'Enter ${widget.titleHint}';
            }
            return null;
          },
           enableInteractiveSelection: true, 
        ),
      ),
    );
  }
}
