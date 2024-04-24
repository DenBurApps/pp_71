import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class NumericField extends StatefulWidget {
  NumericField({
    super.key,
    required this.controller,
    required this.titleHint,
    this.onChanged,
    this.anotherType,
    this.validator,
  });

  final TextEditingController controller;
  final String titleHint;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  bool? anotherType;

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  bool isFocused = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.all(
          (widget.anotherType != null
              ? const Radius.circular(10)
              : const Radius.circular(30)),
        ),
      ),
      height: 55,
      child: TextFormField(
        cursorHeight: 15,
        style: Theme.of(context).textTheme.bodyLarge,
        autofocus: true,
        cursorColor: Theme.of(context).colorScheme.shadow,
        decoration: InputDecoration(
          hintText: widget.titleHint,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey),
          errorText: isError ? 'Enter ${widget.titleHint}' : null,
          errorStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.error),

          contentPadding: EdgeInsets.zero,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          // fillColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
          // filled: true,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(widget.anotherType != null
                  ? const Radius.circular(10)
                  : const Radius.circular(30)),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(widget.anotherType != null
                  ? const Radius.circular(10)
                  : const Radius.circular(30)),
              borderSide: BorderSide.none),
        ),
        controller: widget.controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        validator: widget.validator,
        enableInteractiveSelection: true, 
        onTap: () {
          setState(() {
            isFocused = true;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            isFocused = false;
          });
        },
        onChanged: (value) {
          setState(() {
            isFocused = false;
          });
        },
      ),
    );
  }
}
