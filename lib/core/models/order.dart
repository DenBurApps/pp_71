import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int clientId; 

  @HiveField(2)
  String device;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime startTime;

  @HiveField(5)
  DateTime endTime;

  @HiveField(6)
  List<String> photos;

  Order({
    this.id,
    required this.clientId,
    required this.device,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.photos,
  });
}