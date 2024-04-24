import 'package:hive/hive.dart';

part 'cleint.g.dart';

@HiveType(typeId: 0)
class Client extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String surname;

  @HiveField(3)
  String notes;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String email;

  // Список заказов данного клиента
  @HiveField(6)
  List<int> orderIds;

  Client({
    this.id,
    required this.name,
    required this.surname,
    required this.notes,
    required this.phone,
    required this.email,
    required this.orderIds,
  });
}