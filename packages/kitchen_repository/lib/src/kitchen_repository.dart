import 'package:web_socket_client/web_socket_client.dart';

/// {@template kitchen_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class KitchenRepository {
  /// {@macro client_repository}
  KitchenRepository({WebSocket? socket})
      : _ws = socket ?? WebSocket(Uri.parse('ws://localhost:8080/kitchen'));

  final WebSocket _ws;

  // /// Return a stream of real-time count updates from the server.
  Stream<String> get count => _ws.messages.cast<String>();

  /// Close the connection.
  void close() => _ws.close();
}
