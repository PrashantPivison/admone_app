import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  late IO.Socket _socket;

  SocketService._internal();

  IO.Socket get socket => _socket;

  void connect(int userId, Function(Map<String, dynamic>) onNotification) {
    _socket = IO.io(
      'https://api.adm-dev.app',
      {
        'transports': ['websocket'], // Use WebSocket only
        'path': '/socket.io', // Must match server path
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 100, // Retry 100 times
        'reconnectionDelay': 1000, // 1s between retries
        'extraHeaders': {'Host': 'api.adm-dev.app'} // Needed for Apache proxy
      },
    );

    print("🌐 Connecting to: ${_socket.io.uri}");

    _socket.onConnect((_) {
      print('🔌 Socket connected');
      _socket.emit('join', userId); // Join user-specific room
    });

    _socket.onReconnect((_) {
      print('🔄 Socket reconnected');
      _socket.emit('join', userId); // Rejoin room on reconnect
    });

    _socket.onDisconnect((reason) {
      print('🔌 Socket disconnected: $reason');
    });

    _socket.onConnectError((data) {
      print('❌ Connect error: $data');
    });

    _socket.onError((data) {
      print('❗ Socket error: $data');
    });

    _socket.on('notification:update', (data) {
      if (_socket.connected && data is Map<String, dynamic>) {
        print('📩 Live notification received: $data');
        onNotification(data); // Pass data to your callback
      }
    });
  }

  void disconnect() {
    _socket.disconnect();
    print("⛔ Socket manually disconnected");
  }

  void reconnectIfNeeded(int userId) {
    if (!_socket.connected) {
      print("🔁 Reconnecting socket...");
      _socket.connect();
      _socket.emit('join', userId);
    }
  }

  bool isConnected() => _socket.connected;
}
