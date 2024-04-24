// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/utils/show_custom_snack_bar.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/feilds/names.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/controller/client_bloc/client_bloc.dart';
import 'package:pp71/feature/controller/order_bloc/order_bloc.dart';

import 'package:pp71/feature/view/home/pages/new_cleint.dart';
import 'package:pp71/feature/view/home/pages/new_order2.dart';
import 'package:pp71/feature/view/widgets/select_device.dart';

// ignore: must_be_immutable
class NewOrderView extends StatefulWidget {
  final bool isBack;
  final Order? order;
  const NewOrderView({super.key, required this.isBack, this.order});

  @override
  State<NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends State<NewOrderView> {
  late TextEditingController deviceController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> _formKeys;
  bool contr1 = false;
  bool contr2 = false;
  int? selectedIndex;
  List<Client> clients = [];
  List<Order?> orders = [];
  @override
  void initState() {
    _formKeys = GlobalKey<FormState>();

    deviceController = TextEditingController();
    descriptionController = TextEditingController();

    if (widget.order != null) {
      int? clientId = widget.order!.clientId;
      // Поиск клиента с указанным идентификатором в списке клиентов
      int index = clients.indexWhere((client) => client.id == clientId);

      // Если клиент найден, установите индекс
      if ((index + 1) != -1) {
        selectedIndex = (index + 1);
      }

      deviceController.text = widget.order!.device;
      descriptionController.text = widget.order!.description ?? '';
    }
    deviceController.addListener(_updateControllerState);
    BlocProvider.of<ClientBloc>(context).add(GetAllClient());

    super.initState();
  }

  void _updateControllerState() {
    setState(() {
      contr2 = deviceController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(listener: (context, state) {
      if (state is ClientLoaded) {
        clients = state.response;
      } else if (state is ClientErrorState) {
        showCustomSnackBar(context, state.message);
      }
    }, builder: (context, state) {
      return BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
        if (state is OrderLoaded) {
          setState(() {
            orders = state.response;
          });
        } else if (state is ErrorState) {
          showCustomSnackBar(context, state.message);
        }
      }, builder: (context, snapshot) {
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
              'New order',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppButton(
              onPressed: () {
                if (_formKeys.currentState!.validate()) {
                  if (selectedIndex != null) {
                    if (widget.order != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrderSecondView(
                                  order: widget.order,
                                  client: clients[selectedIndex!],
                                  isBack: true,
                                  device: deviceController.text,
                                  decs: descriptionController.text)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrderSecondView(
                                  client: clients[selectedIndex!],
                                  isBack: true,
                                  device: deviceController.text,
                                  decs: descriptionController.text)));
                    }
                  } else {
                    showCustomSnackBar(context, 'please select a client');
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
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          progressColor:
                              Theme.of(context).colorScheme.secondary,
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
                          selectedIndex != null
                              ? Row(
                                  children: [
                                    CustomIconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedIndex = null;
                                        });
                                      },
                                      icon: Assets.icons.trash,
                                    ),
                                    const SizedBox(width: 50),
                                    DeviceContainer(
                                      client: clients.isNotEmpty
                                          ? clients[selectedIndex!]
                                          : null,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          barrierColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.3),
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: SelectDeviceWidget(
                                                  orders: orders,
                                                    onPressed: (index) {
                                                      setState(() {
                                                        selectedIndex = index;
                                                      });
                                                    },
                                                    clients: clients));
                                          },
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      selected: selectedIndex != null,
                                      orders: filterOrdersByClient(
                                          orders,  clients.isNotEmpty ? clients.last.orderIds.isNotEmpty ? clients.last.orderIds : [] : []),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    DeviceButton(
                                      chooseOrAdd: true,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          barrierColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.3),
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: SelectDeviceWidget(
                                                  orders: orders,
                                                  onPressed: (index) {
                                                    setState(() {
                                                      selectedIndex = index;
                                                    });
                                                  },
                                                  clients: clients,
                                                ));
                                          },
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    DeviceButton(
                                      chooseOrAdd: false,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NewClientView(
                                                      isBack: true,
                                                    )));
                                      },
                                    ),
                                  ],
                                )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKeys,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Device:',
                                style: Theme.of(context).textTheme.bodyLarge!),
                            const SizedBox(height: 10),
                            NamesFieldWidget(
                              controller: deviceController,
                              titleHint: 'Add name device',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'please fill in the “device” field';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Description of the problem:',
                          style: Theme.of(context).textTheme.bodyLarge!),
                      DescriptionFieldWidget(
                        controller: descriptionController,
                        titleHint: 'Add description',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class DeviceButton extends StatelessWidget {
  final bool chooseOrAdd;
  final Function() onPressed;
  const DeviceButton({
    super.key,
    required this.chooseOrAdd,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            border: chooseOrAdd
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: chooseOrAdd
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent),
        child: Center(
          child: Text(
              chooseOrAdd ? 'Choose from existing ones:' : 'Add a new one',
              style: Theme.of(context).textTheme.labelMedium!),
        ),
      ),
    );
  }
}
