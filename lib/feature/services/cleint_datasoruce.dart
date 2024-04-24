import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';

class DataSource {
  Future<DataSource> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    return this;
  }

  Future<int> _getNextOrderId() async {
    final orderBox = await Hive.openBox<Order>('orders');
    if (orderBox.isEmpty) {
      return 1;
    } else {
      int maxId = orderBox.values
          .map((order) => order.id ?? 0)
          .reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    }
  }

  Future<int> _getNextClientId() async {
    final clientBox = await Hive.openBox<Client>('clients');
    if (clientBox.isEmpty) {
      return 1;
    } else {
      int maxId = clientBox.values
          .map((client) => client.id ?? 0)
          .reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    }
  }

  Future<List<Client>> getClients() async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
      return clientBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');

      return orderBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print(e);
        }
      }
      return [];
    }
  }

  Future<int> insertClient(Client client) async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
      int nextId = await _getNextClientId();
      client.id = nextId;
      await clientBox.put(nextId, client);
      return nextId;
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print(e);
        }
      }
      return -1;
    }
  }

  Future<int> deleteClient(Client client) async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
      final orderBox = await Hive.openBox<Order>('orders');

      // Удаление всех заказов данного клиента
      final List<Order> ordersToDelete = await getOrdersByClientId(client.id!);
      for (final order in ordersToDelete) {
        await orderBox.delete(order.id);
      }

      // Обновление списка заказов у остальных клиентов
      final List<Client> allClients =  clientBox.values.toList();
      for (final c in allClients) {
        if (c.orderIds.contains(client.id)) {
          c.orderIds.remove(client.id);
          await clientBox.put(c.id, c);
        }
      }

      // Удаление самого клиента
      await clientBox.delete(client.id);

      return 1;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<List<Order>> getOrdersByClientId(int clientId) async {
    final orderBox = await Hive.openBox<Order>('orders');
    final List<Order> orders = [];
    for (final order in orderBox.values) {
      if (order.clientId == clientId) {
        orders.add(order);
      }
    }
    return orders;
  }

  Future<Client?> getClientById(int id) async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
      return clientBox.get(id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<int> updateClient(Client client) async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
     
      await clientBox.put(client.id, client);
      return 1;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<int> updateClientByOrder(Order order) async {
    try {
      final clientBox = await Hive.openBox<Client>('clients');
      final Order? updatedOrder = await getOrderById(order.id!);
      if (updatedOrder != null) {
        final Client? client = await getClientById(updatedOrder.clientId);
        if (client != null) {
          final int clientIndex = client.orderIds.indexOf(order.id!);
          if (clientIndex != -1) {
            client.orderIds[clientIndex] = order.clientId;
            await clientBox.put(client.id, client);
            return 1;
          }
        }
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  // Методы для работы с заказами
  Future<int> insertOrder(Order order) async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');
      int nextId = await _getNextOrderId();
      order.id = nextId;
      await orderBox.put(nextId, order);
      return nextId;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<int> updateOrderByClient(Client client) async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');
      final Client? updatedClient = await getClientById(client.id!);
      if (updatedClient != null) {
        for (final orderId in updatedClient.orderIds) {
          final Order? order = await getOrderById(orderId);
          if (order != null) {
            order.clientId = client.id!;
            await orderBox.put(order.id, order);
          }
        }
        return 1;
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<int> updateOrder(Order order) async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');
      await orderBox.put(order.id, order);
      return 1;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<int> deleteOrder(Order order) async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');
      final clientBox = await Hive.openBox<Client>('clients');

      final Client client = await getClientById2(order.clientId);
      client.orderIds.remove(order.id);
      await clientBox.put(client.id, client);

      await orderBox.delete(order.id);

      return 1;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  Future<Client> getClientById2(int clientId) async {
    final clientBox = await Hive.openBox<Client>('clients');
    return clientBox.get(clientId)!;
  }

  Future<Order?> getOrderById(int id) async {
    try {
      final orderBox = await Hive.openBox<Order>('orders');
      return orderBox.get(id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
