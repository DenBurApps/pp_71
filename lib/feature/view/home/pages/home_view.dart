import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/utils/show_custom_snack_bar.dart';
import 'package:pp71/core/widgets/drawer.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:pp71/feature/controller/client_bloc/client_bloc.dart';
import 'package:pp71/feature/controller/order_bloc/order_bloc.dart';
import 'package:pp71/feature/view/home/pages/customers_view.dart';
import 'package:pp71/feature/view/home/pages/new_cleint.dart';
import 'package:pp71/feature/view/home/pages/new_order.dart';
import '../../widgets/select_device.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  bool isTab1 = true;
  bool isTab2 = false;
  List<Client?> clients = [];
  List<Order?> orders = [];
  List<Order?> newListOrder = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    BlocProvider.of<ClientBloc>(context).add(GetAllClient());
    BlocProvider.of<OrderBloc>(context).add(GetAllOrder());
    super.initState();
  }

  String _formatActiveOrders(String count) {
    if (count.length == 1) {
      return '0$count';
    } else {
      return count;
    }
  }

  String countBeforeOrders(List<Order?>? orders) {
    if (orders == null || orders.isEmpty) {
      return '0';
    }

    DateTime now = DateTime.now();
    int activeOrders = 0;

    for (Order? order in orders) {
      if (order!.endTime.isBefore(now)) {
        activeOrders++;
      }
    }

    return activeOrders.toString();
  }

  String countActiveOrders(List<Order?>? orders) {
    if (orders == null || orders.isEmpty) {
      return '0';
    }

    DateTime now = DateTime.now();
    int activeOrders = 0;

    for (Order? order in orders) {
      if (order!.endTime.isAfter(now)) {
        activeOrders++;
      }
    }

    return activeOrders.toString();
  }

  String countClientActiveOrders(
      List<Client?> clientss, List<Order?> orderList) {
    // print(orders?.length);
    if (orders.isEmpty) {
      return '0';
    }

    DateTime now = DateTime.now();
    int activeOrders = 0;

    for (Client? client in clientss) {
      List<Order?> newListOrder =
          filterOrdersByClient(orderList, client!.orderIds);

      List<Order?> oredeeers = newListOrder;
      if (orderList.isNotEmpty) {
        for (Order? order in oredeeers) {
          if (order!.endTime.isAfter(now)) {
            activeOrders++;
          }
        }
      }
    }

    return activeOrders.toString();
  }

  String numberOfOrders(List<Order?> orderList) {
    // print(orders?.length);
    if (orderList.isEmpty) {
      return '0';
    }

    int activeOrders = 0;

    // ignore: unused_local_variable
    for (Order? order in orderList) {
      activeOrders = activeOrders + orderList.length;
    }
    return activeOrders.toString();
  }

  List<Order?> filterOrdersByClient(
      List<Order?> listOrder, List<int> orderIds) {
    return listOrder
        .where((order) => order != null && orderIds.contains(order.clientId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(listener: (context, state) {
      if (state is ClientLoaded) {
        setState(() {
          clients = state.response;
        });
      } else if (state is ClientErrorState) {
        showCustomSnackBar(context, state.message);
      }
    }, builder: (context, snapshot) {
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
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leadingWidth: 65,
            leading: CustomIconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Assets.icons.settingLine,
            ),
            actions: [
              CustomIconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: isTab1
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        const TopStatck(),
                                        const SizedBox(height: 20),
                                        StatickContainers(
                                          value1: _formatActiveOrders(
                                              clients.length.toString())[0],
                                          value2: _formatActiveOrders(
                                              clients.length.toString())[1],
                                          isBlack: false,
                                        ),
                                        const SizedBox(height: 30),
                                        StatickContainerSecond(
                                          value1: _formatActiveOrders(
                                              countClientActiveOrders(
                                                  clients, orders))[0],
                                          value2: _formatActiveOrders(
                                              countClientActiveOrders(
                                                  clients, orders))[1],
                                          value3: _formatActiveOrders(
                                              numberOfOrders(orders))[0],
                                          value4: _formatActiveOrders(
                                              numberOfOrders(orders))[1],
                                          name: 'Client Name',
                                        ),
                                      ])
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const TopStatck(),
                                      const SizedBox(height: 20),
                                      StatickContainers(
                                        value1: _formatActiveOrders(
                                            orders.length.toString())[0],
                                        value2: _formatActiveOrders(
                                            orders.length.toString())[1],
                                        isBlack: false,
                                      ),
                                      const SizedBox(height: 30),
                                      StatickContainerOrderSecond(
                                        value1: _formatActiveOrders(
                                            countBeforeOrders(orders))[0],
                                        value2: _formatActiveOrders(
                                            countBeforeOrders(orders))[1],
                                        value3: _formatActiveOrders(
                                            countActiveOrders(orders))[1],
                                      ),
                                    ],
                                  ),
                          ));
                },
                icon: Assets.icons.statistics,
              ),
              const SizedBox(width: 20)
            ],
          ),
          drawer: const CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                BlocProvider.of<ClientBloc>(context)
                                    .add(GetAllClient());
                                isTab1 = true;
                                isTab2 = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isTab1
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                  child: Text(
                                'Customers',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        color: isTab1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : Theme.of(context)
                                                .colorScheme
                                                .shadow),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                BlocProvider.of<OrderBloc>(context)
                                    .add(GetAllOrder());
                                isTab2 = true;
                                isTab1 = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isTab2
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                  child: Text('Orders',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                              color: isTab1
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .background))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (isTab1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NewClientView(isBack: true)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NewOrderView(isBack: true)));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Assets.icons.plusBig.svg(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isTab1)
                    clients.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 22.0,
                                    childAspectRatio: 0.9),
                            itemCount: clients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DeviceContainer(
                                client: clients[index],
                                onPressed: () {
                                  if (clients.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomersListView(
                                                  client: clients[index]!,
                                                )));
                                  }
                                },
                                selected: false,
                                orders: filterOrdersByClient(
                                    orders, clients[index]!.orderIds),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Assets.icons.boxempty.svg(
                                    // ignore: deprecated_member_use_from_same_package
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                                const SizedBox(height: 20),
                                Text("You haven't added clients yet",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .shadow)),
                              ],
                            ),
                          ),
                  if (isTab2)
                    orders.isNotEmpty && clients.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OrderContainer(
                                  client: clients.firstWhere(
                                    (client) =>
                                        client != null &&
                                        client.id == orders[index]!.clientId,
                                  ),
                                  order: orders[index]!,
                                  onPressed: () async {
                                    setState(() {
                                      // selectedIndex = index;
                                      // widget.onPressed.call(index);
                                    });
                                  },
                                  selected: false);
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Assets.icons.boxempty.svg(
                                    // ignore: deprecated_member_use_from_same_package
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                                const SizedBox(height: 20),
                                Text("You haven't added orders yet",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .shadow)),
                              ],
                            ),
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

class TopStatck extends StatelessWidget {
  const TopStatck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Assets.icons.escblacksvg,
          ),
          Text('Statistics',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Theme.of(context).colorScheme.background)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class StatickContainerOrderSecond extends StatelessWidget {
  final String value1;
  final String value2;
  final String value3;

  const StatickContainerOrderSecond({
    super.key,
    required this.value1,
    required this.value2,
    required this.value3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            height: 225,
            width: 0.5 * MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value1,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value2,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Assets.icons.fair.svg(width: 50, height: 50),
                const SizedBox(height: 10),
                Text('Completed\norders',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Theme.of(context).colorScheme.shadow)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            height: 225,
            width: 0.5 * MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value3,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Assets.icons.energy.svg(),
                const SizedBox(height: 10),
                Text('Active orders',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Theme.of(context).colorScheme.shadow)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatickContainerSecond extends StatelessWidget {
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String name;

  const StatickContainerSecond({
    super.key,
    required this.value1,
    required this.value2,
    required this.name,
    required this.value3,
    required this.value4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            height: 225,
            width: 0.5 * MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value1,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value2,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Assets.icons.userAltLight.svg(width: 50, height: 50),
                const SizedBox(height: 10),
                Text('Customers\nwith active\norders',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Theme.of(context).colorScheme.shadow)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            height: 225,
            width: 0.5 * MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value3,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: 50,
                      width: 35,
                      child: Center(
                        child: Text(value4,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(name,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.background)),
                ),
                const SizedBox(height: 10),
                Text('The largest\nnumber of\norders',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Theme.of(context).colorScheme.shadow)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatickContainers extends StatelessWidget {
  final String value1;
  final String value2;
  final bool isBlack;

  const StatickContainers({
    super.key,
    required this.value1,
    required this.value2,
    required this.isBlack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isBlack
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                height: 50,
                width: 35,
                child: Center(
                  child: Text(value1,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Theme.of(context).colorScheme.background)),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                decoration: BoxDecoration(
                  color: isBlack
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                height: 50,
                width: 35,
                child: Center(
                  child: Text(value2,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Theme.of(context).colorScheme.background)),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          Text('Total number of clients',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.shadow)),
        ],
      ),
    );
  }
}
