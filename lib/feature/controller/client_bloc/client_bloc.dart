import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/feature/services/cleint_datasoruce.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final DataSource _dataSource = GetIt.instance<DataSource>();
  ClientBloc() : super(InitialState()) {
    on<GetAllClient>((event, emit) async {
      emit(LoadingState());
      final loadLessons = await _dataSource.getClients();

      emit(ClientLoaded(response: loadLessons));
    });
    on<DeleteClient>((event, emit) async {
      emit(LoadingState());
      await _dataSource.deleteClient(event.model);
      final loadLessons = await _dataSource.getClients();

      emit(ClientLoaded(response: loadLessons));
    });
    on<AddClient>((event, emit) async {
      emit(LoadingState());
      await _dataSource.insertClient(event.model);
      final loadLessons = await _dataSource.getClients();

      emit(ClientLoaded(response: loadLessons));
    });
    on<UpdateClient>((event, emit) async {
      emit(LoadingState());

      await _dataSource.updateClient(event.model);
      final loadLessons = await _dataSource.getClients();

      emit(ClientLoaded(response: loadLessons));
    });
  }
}
