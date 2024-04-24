// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/utils/show_custom_snack_bar.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/feilds/names.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/view/home/pages/new_cleint2.dart';

// ignore: must_be_immutable
class NewClientView extends StatefulWidget {
  final bool isBack;
  final Client? cleint;
  const NewClientView({super.key, required this.isBack, this.cleint});

  @override
  State<NewClientView> createState() => _NewClientViewState();
}

class _NewClientViewState extends State<NewClientView> {
  late TextEditingController nameController;
  late TextEditingController surNameController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> _formKeys;
  bool contr1 = false;
  bool contr2 = false;
  @override
  void initState() {
    _formKeys = GlobalKey<FormState>();

    nameController = TextEditingController();
    surNameController = TextEditingController();
    descriptionController = TextEditingController();
    if (widget.cleint != null) {
      nameController.text = widget.cleint!.name;
      surNameController.text = widget.cleint!.surname;
      descriptionController.text = widget.cleint!.notes;
    }
    nameController.addListener(_updateControllerState);
    surNameController.addListener(_updateControllerState);

    super.initState();
  }

  void _updateControllerState() {
    setState(() {
      contr2 = nameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        
        centerTitle: true,
        leading: widget.isBack
            ? CustomIconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Assets.icons.esc)
            : null,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          'New client',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: AppButton(
          onPressed: () {
            if (_formKeys.currentState!.validate()) {
              if (widget.cleint != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewClientSecondView(
                            client: widget.cleint,
                              isBack: widget.isBack,
                              name: nameController.text,
                              surName: surNameController.text,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewClientSecondView(
                              isBack: widget.isBack,
                              name: nameController.text,
                              surName: surNameController.text,
                            )));
              }
            } else {
              showCustomSnackBar(context, 'please fill in the field');
            }
          },
          label: 'Next',
          width: MediaQuery.of(context).size.width,
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fill in the information about the\nclient',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressBar(
                      maxSteps: 10,
                      progressType: LinearProgressBar.progressTypeLinear,
                      currentStep: 5,
                      progressColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary),
                      minHeight: 4.0,
                    ),
                  ),
                  Form(
                    key: _formKeys,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text('Name Client',
                            style: Theme.of(context).textTheme.bodyLarge!),
                        const SizedBox(height: 10),
                        NamesFieldWidget(
                          controller: nameController,
                          titleHint: 'Add name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please fill in the “name” field';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Surname client:',
                            style: Theme.of(context).textTheme.bodyLarge!),
                        const SizedBox(height: 10),
                        NamesFieldWidget(
                          controller: surNameController,
                          titleHint: 'Add surname',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please fill in the "surname" field';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
