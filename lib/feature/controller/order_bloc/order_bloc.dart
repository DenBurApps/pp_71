import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/feature/services/cleint_datasoruce.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final DataSource _dataSource = GetIt.instance<DataSource>();
  OrderBloc() : super(InitialState()) {
    on<GetAllOrder>((event, emit) async {
      emit(LoadingState());
      final loadLessons = await _dataSource.getOrders();

      emit(OrderLoaded(response: loadLessons));
    });
    on<DeleteOrder>((event, emit) async {
      emit(LoadingState());
      await _dataSource.deleteOrder(event.model);
      final loadLessons = await _dataSource.getOrders();

      emit(OrderLoaded(response: loadLessons));
    });
    on<AddOrder>((event, emit) async {
      emit(LoadingState());
      await _dataSource.insertOrder(event.model);
      final loadLessons = await _dataSource.getOrders();

      emit(OrderLoaded(response: loadLessons));
    });
    on<UpdateOrder>((event, emit) async {
      emit(LoadingState());
      if (event.model.id != null) {
        await _dataSource.updateOrder(event.model);
        final loadLessons = await _dataSource.getOrders();

        emit(OrderLoaded(response: loadLessons));
      } else {
        // emit(const ErrorState(message: 'try again later'));
      }
    });
  }
}
