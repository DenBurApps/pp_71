part of 'order_bloc.dart';

sealed class OrderEvent  {
  const OrderEvent();

}

class GetAllOrder extends OrderEvent {}

class DeleteOrder extends OrderEvent {
  final Order model;


  const DeleteOrder( {required this.model});
}
class UpdateOrder extends OrderEvent {
  final Order model;
 

  const UpdateOrder( {required this.model});
}
class AddOrder extends OrderEvent {
  final Order model;

  const AddOrder({required this.model});
}
