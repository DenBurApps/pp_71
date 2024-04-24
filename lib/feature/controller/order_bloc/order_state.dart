part of 'order_bloc.dart';

sealed class OrderState {
  const OrderState();
}

final class InitialState extends OrderState {}

final class OrderLoaded extends OrderState {
  final List<Order?> response;
  const OrderLoaded({required this.response});
}

final class LoadingState extends OrderState {}

final class ErrorState extends OrderState {
  final String message;
  const ErrorState({required this.message});
}
