import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pp71/core/config/remote_config.dart';
import 'package:pp71/core/models/cleint.dart';
import 'package:pp71/core/models/order.dart';
import 'package:pp71/core/storage/storage_service.dart';
import 'package:pp71/feature/controller/client_bloc/client_bloc.dart';
import 'package:pp71/feature/controller/order_bloc/order_bloc.dart';
import 'package:pp71/feature/services/cleint_datasoruce.dart';

class ServiceLocator {
  static Future<void> setup() async {
    GetIt.I.registerSingletonAsync<RemoteConfigService>(
        () => RemoteConfigService().init());
    await GetIt.I.isReady<RemoteConfigService>();

    Hive.registerAdapter(ClientAdapter());
    Hive.registerAdapter(OrderAdapter());

    GetIt.I
        .registerSingletonAsync<StorageService>(() => StorageService().init());
    await GetIt.I.isReady<StorageService>();

    GetIt.I.registerSingletonAsync<DataSource>(() => DataSource().init());
    await GetIt.I.isReady<DataSource>();

    GetIt.I.registerLazySingleton<ClientBloc>(() => ClientBloc());

    GetIt.I.registerLazySingleton<OrderBloc>(() => OrderBloc());
  }
}
