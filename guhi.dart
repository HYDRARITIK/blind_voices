import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'config.dart';  // Import configuration

void main() => runApp(const MyApp());

// STEP 1: Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;
  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'DEMO APP';
    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IO.Socket? _socket;
  final myController = TextEditingController();
  final StreamSocket streamSocket = StreamSocket();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    try {
      _socket = IO.io(Config.serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket?.connect();

      _socket?.onConnect((_) {
        print('Connected to server successfully');
      });

      _socket?.on('goToMobile', (data) {
        streamSocket.addResponse(data);
      });

      _socket?.onDisconnect((_) {
        print('Disconnected from server');
      });
    } catch (err) {
      print('Socket error: $err');
    }
  }

  void sendText(String msg) {
    _socket?.emit('gotoserver', msg);
    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextField(
                controller: myController,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Data received from pico:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            StreamBuilder<String>(
              stream: streamSocket.getResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: const TextStyle(fontSize: 20),
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendText(myController.text);
        },
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    streamSocket.dispose();
    super.dispose();
  }
}
