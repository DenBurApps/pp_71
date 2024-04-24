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
import 'package:pp71/feature/view/home/pages/home_view.dart';
import 'package:pp71/feature/view/home/pages/new_cleint.dart';
import 'package:pp71/feature/view/home/pages/orders_view.dart';

class CustomersListView extends StatefulWidget {
  final Client client;
  const CustomersListView({super.key, required this.client});

  @override
  State<CustomersListView> createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<CustomersListView> {
  late TextEditingController descriptionController;
  @override
  void initState() {
    BlocProvider.of<OrderBloc>(context).add(GetAllOrder());

    descriptionController = TextEditingController();
    descriptionController.text = widget.client.notes;
    super.initState();
  }

  List<Order?> listOrder = [];

  int countActiveOrders(List<Order?>? orders) {
    if (orders == null || orders.isEmpty) {
      return 0;
    }

    DateTime now = DateTime.now();
    int activeOrders = 0;

    for (Order? order in orders) {
      if (order!.endTime.isAfter(now)) {
        activeOrders++;
      }
    }

    return activeOrders;
  }

  List<Order?> filterOrdersByClient(
      List<Order?> listOrder, List<int> orderIds) {
    return listOrder
        .where((order) => order != null && orderIds.contains(order.clientId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
      if (state is OrderLoaded) {
        setState(() {
          listOrder =
              filterOrdersByClient(state.response, widget.client.orderIds);
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
          leading: CustomIconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Assets.icons.esc),
          title: Text(
            widget.client.name,
            style: Theme.of(context).textTheme.displayMedium!,
          ),
          actions: [
            CustomIconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewClientView(
                                isBack: true,
                                cleint: widget.client,
                              )));
                },
                icon: Assets.icons.edit),
            const SizedBox(width: 20)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: CustomIconButton(
            onPressed: () {
              showDialog(
                  context: context,
                 barrierColor: Theme.of(context).colorScheme.background,
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
                              Text('Do you really want to\ndelete this client?',
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      height: 50,
                                      width:
                                          0.4 * MediaQuery.of(context).size.width,
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
                                      width:
                                          0.4 * MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        color:
                                            Theme.of(context).colorScheme.primary,
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
                                      // final List<Order?> newListOrders = [];
          
                                      // for (final order in listOrder) {
                                      //   if (order!.client.id ==
                                      //       widget.client.id) {
                                      //     newListOrders.add(order);
                                      //   }
                                      // }
          
                                      // for (final order in newListOrders) {
                                      //   BlocProvider.of<OrderBloc>(context).add(
                                      //     DeleteOrder(model: order!),
                                      //   );
                                      // }
                                      BlocProvider.of<ClientBloc>(context).add(
                                          DeleteClient(model: widget.client));
          
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
                Text('Customers',
                    style: Theme.of(context).textTheme.displayLarge!),
                const SizedBox(height: 15),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Assets.icons.phone.svg(),
                      Text(widget.client.phone,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium!),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Assets.icons.message.svg(),
                      Text(widget.client.email,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium!),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text('Notes', style: Theme.of(context).textTheme.displayLarge!),
                const SizedBox(height: 20),
                DescriptionFieldWidget(
                  readOnly: true,
                  controller: descriptionController,
                  titleHint: 'empty',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total orders',
                        style: Theme.of(context).textTheme.displayLarge!),
                    Container(
                      height: 70,
                      width: 160,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          widget.client.orderIds.length.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active orders',
                        style: Theme.of(context).textTheme.displayLarge!),
                    Container(
                      height: 70,
                      width: 160,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          '${countActiveOrders(listOrder)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrdersListView(
                                  client: widget.client,
                                  order: listOrder.last!,
                                )));
                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listOrder.isNotEmpty ? listOrder.last!.device : '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                        listOrder.isNotEmpty
                            ? listOrder.last!.photos.isNotEmpty
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: listOrder.last!.photos.length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        height:
                                            100, // Устанавливаем фиксированную высоту
                                        width: 100,
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
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
                                              File(listOrder
                                                  .last!.photos[index]),
                                              fit: BoxFit.fill,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.image_not_supported,
                                          size: 35,
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
                                  )
                            : Center(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.image_not_supported,
                                      size: 35,
                                      color: Colors.black,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 0.3 * MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Assets.icons.userAltLight.svg(),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(widget.client.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 0.3 * MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Assets.icons.tumer.svg(),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                        listOrder.isNotEmpty
                                            ? DateFormat('dd MMMM, yyyy')
                                                .format(listOrder.last!.endTime)
                                            : 'no date',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
  }
}
