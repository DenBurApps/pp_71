part of 'client_bloc.dart';

sealed class ClientState {
  const ClientState();
}

final class InitialState extends ClientState {}

final class ClientLoaded extends ClientState {
  final List<Client> response;
  const ClientLoaded({required this.response});
}

final class LoadingState extends ClientState {}

final class ClientErrorState extends ClientState {
  final String message;
  const ClientErrorState({required this.message});
}
