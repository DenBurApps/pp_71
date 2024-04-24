// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/view/home/pages/orders_view.dart';

class SelectDeviceWidget extends StatefulWidget {
  final Function(int) onPressed;
  final List<Client> clients;
  final List<Order?> orders;
  const SelectDeviceWidget({
    super.key,
    required this.onPressed,
    required this.clients,
    required this.orders,
  });

  @override
  State<SelectDeviceWidget> createState() => _SelectDeviceWidgetState();
}

class _SelectDeviceWidgetState extends State<SelectDeviceWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7 * MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Assets.icons.esc,
              ),
              const SizedBox(width: 10),
              Text(
                'Select a client',
                style: Theme.of(context).textTheme.displayMedium!,
              ),
              selectedIndex != null
                  ? AppButton(
                      height: 40,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.2 * MediaQuery.of(context).size.width,
                      onPressed: () async {
                        widget.onPressed.call(selectedIndex!);
                        Navigator.pop(context);
                      },
                      label: 'Add',
                    )
                  : const SizedBox(width: 70),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
              child: GridClient(
            client: widget.clients,
            onPressed: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            order: widget.orders,
          )),
        ],
      ),
    );
  }
}

class GridClient extends StatefulWidget {
  final Function(int) onPressed;
  final List<Client> client;
  final List<Order?> order;
  const GridClient({
    super.key,
    required this.onPressed,
    required this.client,
    required this.order,
  });

  @override
  State<GridClient> createState() => _GridClientState();
}

class _GridClientState extends State<GridClient> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return widget.client.isNotEmpty
        ? GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 22.0,
                childAspectRatio: 0.9),
            itemCount: widget.client.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < widget.client.length) {
                return DeviceContainer(
                    client: widget.client[index],
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                        widget.onPressed.call(index);
                      });
                    },
                    selected: selectedIndex == index,
                    orders: filterOrdersByClient(
                        widget.order, widget.client[index].orderIds));
              } else {
                return const SizedBox();
              }
            })
        : Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Assets.icons.boxempty
                    // ignore: deprecated_member_use_from_same_package
                    .svg(color: Theme.of(context).colorScheme.shadow),
                const SizedBox(height: 20),
                Text("You haven't added clients yet",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Theme.of(context).colorScheme.shadow)),
              ],
            ),
          );
  }
}

List<Order?> filterOrdersByClient(List<Order?> listOrder, List<int> orderIds) {
  return listOrder
      .where((order) => order != null && orderIds.contains(order.clientId))
      .toList();
}

class DeviceContainer extends StatelessWidget {
  final Client? client;
  final List<Order?> orders;
  final Function() onPressed;

  final bool selected;
  const DeviceContainer(
      {super.key,
      required this.onPressed,
      required this.selected,
      required this.client,
      required this.orders});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: 200,
        width: 163,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            border:
                Border.all(color: Theme.of(context).colorScheme.onBackground)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${countActiveOrders(orders)} active orders',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.shadow)),
            Flexible(
              child: Text(client?.name ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: selected
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.onBackground,
                      )),
            ),
            Text('${client?.orderIds.length} orders',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.shadow)),
          ],
        ),
      ),
    );
  }

  int countOrders(List<Order?>? orders) {
    if (orders == null || orders.isEmpty) {
      return 0;
    }
    return orders.length;
  }

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
}

class OrderContainer extends StatelessWidget {
  final Function() onPressed;
  final Client? client;

  final Order order;

  final bool selected;
  const OrderContainer(
      {super.key,
      required this.onPressed,
      required this.selected,
      required this.client,
      required this.order});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrdersListView(
                      client: client,
                      order: order,
                    )));
      },
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
          height: 220,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.device,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.background)),
              order.photos.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: order.photos.length,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
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
                                      File(order.photos[index]),
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    )),
                              ),
                            ),
                          ],
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
                            color: Theme.of(context).colorScheme.background,
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
                          child: Text(client?.name ?? '',
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
                              DateFormat('dd MMMM, yyyy').format(order.endTime),
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
          )),
    );
  }
}
