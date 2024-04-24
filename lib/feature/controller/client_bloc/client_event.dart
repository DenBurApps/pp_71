part of 'client_bloc.dart';

sealed class ClientEvent  {
  const ClientEvent();

}

class GetAllClient extends ClientEvent {}

class DeleteClient extends ClientEvent {
  final Client model;

  const DeleteClient({required this.model});
}
class UpdateClient extends ClientEvent {
  final Client model;


  const UpdateClient({required this.model});
}
class AddClient extends ClientEvent {
  final Client model;

  const AddClient({required this.model});
}
