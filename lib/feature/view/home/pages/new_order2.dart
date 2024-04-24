// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/utils/show_custom_snack_bar.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/controller/client_bloc/client_bloc.dart';
import 'package:pp71/feature/controller/order_bloc/order_bloc.dart';
import 'package:pp71/feature/view/home/pages/home_view.dart';

import 'package:pp71/feature/view/widgets/selected_date.dart';

// ignore: must_be_immutable
class NewOrderSecondView extends StatefulWidget {
  final bool isBack;
  final String device;
  final String? decs;
  final Client client;
  final Order? order;

  const NewOrderSecondView({
    super.key,
    required this.isBack,
    required this.device,
    required this.client,
    this.decs,
    this.order,
  });

  @override
  State<NewOrderSecondView> createState() => _NewOrderSecondViewState();
}

class _NewOrderSecondViewState extends State<NewOrderSecondView> {
  late DateTime _focusedDay1;
  late DateTime _focusedDay2;
  late DateTime _firstDay;
  late DateTime _lastDay;
  File? _imageFile;
  List<String> _listImageFile = [];

  int? year;
  int? mounth;
  DateTime? _selectedDay1;
  DateTime? _selectedDay2;
  @override
  void initState() {
    _focusedDay1 = DateTime.now();
    _focusedDay2 = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    if (widget.order != null) {
      _focusedDay1 = widget.order!.startTime;
      _selectedDay1 = widget.order!.startTime;
      _focusedDay2 = widget.order!.endTime;
      _selectedDay2 = widget.order!.endTime;
      _listImageFile = widget.order!.photos;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        leading: CustomIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Assets.icons.esc),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          'New order',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: AppButton(
          color: Theme.of(context).colorScheme.primaryContainer,
          isActive: _selectedDay1 != null || _selectedDay2 != null,
          onPressed: () {
            if (_selectedDay1 != null && _selectedDay2 != null) {
              if (_selectedDay1!.isBefore(_selectedDay2!)) {
                List<int> listint = [];
                if (widget.client.orderIds.isNotEmpty) {
                  listint.addAll(widget.client.orderIds);
                  listint.add(widget.client.orderIds.last + 1);
                } else {
                  listint.add(1);
                }

                if (widget.order != null) {
                  BlocProvider.of<OrderBloc>(context).add(
                    UpdateOrder(
                      model: Order(
                        id: widget.order!.id!,
                        clientId: widget.client.id!,
                        device: widget.device,
                        description: widget.decs,
                        startTime: _selectedDay1!,
                        endTime: _selectedDay2!,
                        photos: _listImageFile,
                      ),
                    ),
                  );
                } else {
                  BlocProvider.of<OrderBloc>(context).add(
                    AddOrder(
                      model: Order(
                        clientId: widget.client.id!,
                        device: widget.device,
                        description: widget.decs,
                        startTime: _selectedDay1!,
                        endTime: _selectedDay2!,
                        photos: _listImageFile,
                      ),
                    ),
                  );
                }

                BlocProvider.of<ClientBloc>(context).add(
                  UpdateClient(
                    model: Client(
                      id: widget.client.id,
                      name: widget.client.name,
                      surname: widget.client.surname,
                      notes: widget.client.surname,
                      phone: widget.client.phone,
                      email: widget.client.email,
                      orderIds: listint,
                    ),
                  ),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homeview()),
                  (Route route) => false,
                );
              } else {
                showCustomSnackBar(context,
                    'The start date you choose must be before the end date. Please correct the selected dates.');
              }
            } else {
              showCustomSnackBar(context, 'Please select a date');
            }
          },
          label: 'Save',
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
                'Fill in all the information about the order',
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
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Client:',
                          style: Theme.of(context).textTheme.bodyLarge!),
                      Column(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                barrierColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.3),
                                builder: (BuildContext context) {
                                  _selectedDay1 = DateTime.now();
                                  _focusedDay1 = DateTime.now();
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: SelectDateWidget(
                                      firstDay: _firstDay,
                                      selectedDay:
                                          _selectedDay1 ?? DateTime.now(),
                                      onPressed: (date) {
                                        return true;
                                      },
                                      focusedDay: _focusedDay1,
                                      lastDay: _lastDay,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay1 = DateTime(
                                            year ?? _selectedDay1!.year,
                                            mounth ?? _selectedDay1!.month,
                                            _focusedDay1.day,
                                          );
                                          _focusedDay1 = focusedDay;
                                        });
                                      },
                                      onPressedMounth: (m) {
                                        setState(() {
                                          _selectedDay1 = DateTime(
                                            _selectedDay1!.year,
                                            getMonthIndex(m),
                                            _selectedDay1!.day,
                                          );
                                          mounth = getMonthIndex(m);
                                        });
                                      },
                                      onPressedYear: (y) {
                                        setState(() {
                                          year = y;
                                          _selectedDay1 = DateTime(
                                            y,
                                            _selectedDay1!.month,
                                            _selectedDay1!.day,
                                          );
                                        });
                                      },
                                    ),
                                  );
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 230,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                        _selectedDay1 != null
                                            ? DateFormat('dd MMMM, yyyy')
                                                .format(_selectedDay1!)
                                            : '-',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                barrierColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.3),
                                builder: (BuildContext context) {
                                  _selectedDay2 = DateTime.now();
                                  _focusedDay2 = DateTime.now();
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: SelectDateWidget(
                                      firstDay: _firstDay,
                                      selectedDay:
                                          _selectedDay1 ?? DateTime.now(),
                                      onPressed: (date) {
                                        return true;
                                      },
                                      focusedDay: _focusedDay2,
                                      lastDay: _lastDay,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay2 = DateTime(
                                            year ?? _selectedDay2!.year,
                                            mounth ?? _selectedDay2!.month,
                                            _focusedDay2.day,
                                          );
                                          _focusedDay2 = focusedDay;
                                        });
                                      },
                                      onPressedMounth: (m) {
                                        setState(() {
                                          _selectedDay2 = DateTime(
                                            _selectedDay2!.year,
                                            getMonthIndex(m),
                                            _selectedDay2!.day,
                                          );
                                          mounth = getMonthIndex(m);
                                        });
                                      },
                                      onPressedYear: (y) {
                                        setState(() {
                                          year = y;
                                          _selectedDay2 = DateTime(
                                            y,
                                            _selectedDay2!.month,
                                            _selectedDay2!.day,
                                          );
                                        });
                                      },
                                    ),
                                  );
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 230,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                        _selectedDay2 != null
                                            ? DateFormat('dd MMMM, yyyy')
                                                .format(_selectedDay2!)
                                            : '-',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CupertinoButton(
                    onPressed: _listImageFile.isNotEmpty
                        ? null
                        : () {
                            _pickPhoto();
                          },
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: _listImageFile.isNotEmpty
                          ? Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _listImageFile.length,
                                    itemBuilder: (context, index) => Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
                                                child: Image.file(
                                                  File(_listImageFile[index]),
                                                  fit: BoxFit.fill,
                                                  height: 100,
                                                  width: 100,
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                            right: -10,
                                            top: -10,
                                            child: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    _listImageFile
                                                        .removeAt(index);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                                ))),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CustomIconButton(
                                    onPressed: () {
                                      _pickPhoto();
                                    },
                                    icon: Assets.icons.plus,
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Text('Add photo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!),
                                  const SizedBox(height: 10),
                                  Assets.icons.plus.svg()
                                ],
                              ),
                            ),
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

  Future<void> _pickPhoto() async {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(13))),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 43,
                    child: Center(
                      child: Text(
                        'Change photo',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(125, 125, 125, 1)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: 60,
                      child: Center(
                        child: Text(
                          'Camera',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            'Galerry',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      }),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(13))),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      'Closed',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Widget?> _pickImage(ImageSource source) async {
    FocusScope.of(context).unfocus();
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      String imageName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      Directory appDir = await getApplicationDocumentsDirectory();

      String imagePath = '${appDir.path}/$imageName';

      await File(pickedFile.path).copy(imagePath);

      setState(() {
        _imageFile = File(imagePath);
        _listImageFile.add(_imageFile!.absolute.path);
      });

      return AlertDialog(
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Confirmation',
          // ignore: use_build_context_synchronously
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        content: Text('Do you want to save the selected photo?',
            // ignore: use_build_context_synchronously
            style: Theme.of(context).textTheme.titleSmall!.copyWith()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Yes',
                // ignore: use_build_context_synchronously
                style: Theme.of(context).textTheme.titleSmall!.copyWith()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _imageFile = null;
              });
            },
            child: Text('Change',
                // ignore: use_build_context_synchronously
                style: Theme.of(context).textTheme.titleSmall!.copyWith()),
          ),
        ],
      );
    } else {
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, "You haven't selected a photo");
      return null;
    }
  }
}
