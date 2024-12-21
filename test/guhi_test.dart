import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:your_app/guhi.dart'; // Update the import path accordingly
import 'package:your_app/config.dart'; // Update the import path accordingly

class MockSocket extends Mock implements IO.Socket {}

void main() {
  group('MyHomePage', () {
    late MockSocket mockSocket;
    late StreamSocket streamSocket;

    setUp(() {
      mockSocket = MockSocket();
      streamSocket = StreamSocket();
    });

    testWidgets('should display the title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('DEMO APP'), findsOneWidget);
    });

    testWidgets('should send text to server and clear TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyHomePage(title: 'DEMO APP'),
      ));

      await tester.enterText(find.byType(TextField), 'test message');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      verify(mockSocket.emit('gotoserver', 'test message')).called(1);
      expect(find.text('test message'), findsNothing);
    });

    testWidgets('should display received data from pico', (WidgetTester tester) async {
      streamSocket.addResponse('data from pico');

      await tester.pumpWidget(MaterialApp(
        home: MyHomePage(title: 'DEMO APP'),
      ));

      await tester.pump(); // Rebuild the widget with the new stream data

      expect(find.text('data from pico'), findsOneWidget);
    });

    test('should connect to the server', () {
      final socket = IO.io(Config.serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();
      expect(socket.connected, isTrue);
    });
  });
}
