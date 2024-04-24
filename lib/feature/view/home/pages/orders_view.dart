import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/utils/show_custom_snack_bar.dart';
import 'package:pp71/core/widgets/feilds/names.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/controller/client_bloc/client_bloc.dart';
import 'package:pp71/feature/controller/order_bloc/order_bloc.dart';
import 'package:pp71/feature/view/home/pages/customers_view.dart';
import 'package:pp71/feature/view/home/pages/home_view.dart';
import 'package:pp71/feature/view/home/pages/new_order.dart';
import 'package:pp71/feature/view/widgets/select_device.dart';

class OrdersListView extends StatefulWidget {
  final Client? client;
  final Order order;
  const OrdersListView({super.key, required this.client, required this.order});

  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {
  late TextEditingController descriptionController;
  List<Client> clients = [];
  List<Order?> orders = [];

  @override
  void initState() {
    BlocProvider.of<ClientBloc>(context).add(GetAllClient());

    descriptionController = TextEditingController();
    descriptionController.text = widget.order.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
      if (state is OrderLoaded) {
        setState(() {
          orders = state.response;
        });
      } else if (state is ErrorState) {
        showCustomSnackBar(context, state.message);
      }
    }, builder: (context, state) {
      return BlocConsumer<ClientBloc, ClientState>(listener: (context, state) {
        if (state is ClientLoaded) {
          clients = state.response;
        } else if (state is ClientErrorState) {
          showCustomSnackBar(context, state.message);
        }
      }, builder: (context, snapshot) {
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
            actions: [
              CustomIconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewOrderView(
                                  isBack: true,
                                  order: widget.order,
                                )));
                  },
                  icon: Assets.icons.edit),
              const SizedBox(width: 20)
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomIconButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (contex) => Center(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Do you really want to\ndelete this client?',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground)),
                                Text('All information about her will be lost.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .shadow)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        height: 50,
                                        width: 0.4 *
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                        ),
                                        child: Center(
                                          child: Text('No',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        height: 50,
                                        width: 0.4 *
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: Center(
                                          child: Text('Yes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background)),
                                        ),
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<OrderBloc>(context).add(
                                          DeleteOrder(model: widget.order),
                                        );

                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Homeview()),
                                            (Route route) => false);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
              },
              colorIcons: Assets.icons.trash.svg(width: 35, height: 35),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DeviceContainer(
                        onPressed: () {
                          if (widget.client != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomersListView(
                                          client: widget.client!,
                                        )));
                          }
                        },
                        selected: false,
                        client: widget.client,
                        orders: orders,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(widget.order.device,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.displayLarge!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: widget.order.photos.isNotEmpty
                        ? Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.order.photos.length,
                              itemBuilder: (context, index) => Container(
                                height: 110,
                                width: 110,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.1),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      child: Image.file(
                                        File(widget.order.photos[index]),
                                        fit: BoxFit.fill,
                                        height: 110,
                                        width: 110,
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 35,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                const SizedBox(height: 10),
                                Text('No Image',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background)),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text('Description of the problem',
                      style: Theme.of(context).textTheme.displayLarge!),
                  const SizedBox(height: 10),
                  DescriptionFieldWidget(
                    readOnly: true,
                    controller: descriptionController,
                    titleHint: 'empty',
                  ),
                  const SizedBox(height: 20),
                  Text('Start date',
                      style: Theme.of(context).textTheme.displayLarge!),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                          DateFormat('dd MMMM, yyyy')
                              .format(widget.order.startTime),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium!),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('End date',
                      style: Theme.of(context).textTheme.displayLarge!),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                          DateFormat('dd MMMM, yyyy')
                              .format(widget.order.endTime),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium!),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
