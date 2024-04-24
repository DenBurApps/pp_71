import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NamesFieldWidget extends StatefulWidget {
  NamesFieldWidget({
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
  State<NamesFieldWidget> createState() => _NamesFieldWidgetState();
}

class _NamesFieldWidgetState extends State<NamesFieldWidget> {
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
      child: Center(
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
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
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
          keyboardType: TextInputType.text,
          onChanged: widget.onChanged,
          validator: widget.validator,
           enableInteractiveSelection: true, 
          onTap: () {
            setState(() {
              isFocused = true;
            });
          },
        ),
      ),
    );
  }
}

class DescriptionFieldWidget extends StatefulWidget {
  const DescriptionFieldWidget({
    super.key,
    required this.controller,
    required this.titleHint,
    this.onChanged,
    this.readOnly = false, // Добавленный параметр для запрета ввода текста
  });

  final TextEditingController controller;
  final String titleHint;
  final void Function(String)? onChanged;
  final bool readOnly; // Добавленный параметр для запрета ввода текста

  @override
  State<DescriptionFieldWidget> createState() => _DescriptionFieldWidgetState();
}

class _DescriptionFieldWidgetState extends State<DescriptionFieldWidget> {
  bool isFocused = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      height: 150,
      child: TextFormField(
        readOnly: widget.readOnly, // Устанавливаем значение readOnly из параметра виджета
        cursorHeight: 15,
        style: Theme.of(context).textTheme.bodyLarge,
        autofocus: true,
        cursorColor: Theme.of(context).colorScheme.shadow,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: widget.titleHint,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey),
          errorText: isError ? 'Enter ${widget.titleHint}' : null,
          errorStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.red),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
        onTap: () {
          setState(() {
            isFocused = true;
          });
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class EmailFieldWidget extends StatefulWidget {
  EmailFieldWidget({
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
  State<EmailFieldWidget> createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
  bool isFocused = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      height: 55,
      child: Center(
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
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: EdgeInsets.zero,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
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
          keyboardType: TextInputType.text,
          onChanged: widget.onChanged,
          validator: widget.validator,
          
           enableInteractiveSelection: true, 
          onTap: () {
            setState(() {
              isFocused = true;
            });
          },
        ),
      ),
    );
  }
}
