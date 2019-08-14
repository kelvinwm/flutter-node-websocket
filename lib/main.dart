import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
//        channel: IOWebSocketChannel.connect('ws://192.168.5.11:3030'),
//        channel:
//            IOWebSocketChannel.connect('ws://192.168.5.11:3030/echo1/James'),
//        channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  WebSocketChannel channel;
  TextEditingController controller;
  final List<String> list = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://192.168.5.11:3030/echo1/James');
    controller = TextEditingController();
//    try {
//      channel.stream.listen((data) {
//        // handling of the incoming messages
//        debugPrint(data);
//        setState(() {
//          list.add(data);
//        });
//      }, onError: (error, StackTrace stackTrace) {
//        // error handling
//      }, onDone: () {
//        // communication has been closed
//        debugPrint("socket was closed");
//        reconnect();
//      });
//    } catch (e) {
//      /// TODO handle connection failure
//    }
  }

  reconnect() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        // Here you can write your code for open new view
        channel =
            IOWebSocketChannel.connect('ws://192.168.5.11:3030/echo1/James');
//        try {
//          channel.stream.listen((data) {
//            // handling of the incoming messages
//            debugPrint(data);
//            setState(() {
//              list.add(data);
//            });
//          }, onError: (error, StackTrace stackTrace) {
//            // error handling
//          }, onDone: () {
//            // communication has been closed
//            debugPrint("socket was closed");
//            reconnect();
//          });
//        } catch (e) {
//          /// TODO handle connection failure
//        }
      });
    });

    debugPrint("Socket closed. Trying to reconnect");
  }

//  var jsonString = json.encode({'kenya':'TukoPamoja', 'Id':'Huduma Number'});
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
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
//            Column(
//              children: list.map((data) => Text(data)).toList(),
//            )
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                print("connection state ${snapshot.connectionState}");
                if (snapshot.connectionState
                    .toString()
                    .contains("ConnectionState.done")) {
                  reconnect();
                }
                debugPrint('VIPI ${snapshot.data}');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
//      widget.channel.sink.add(jsonString);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    debugPrint("The socket closed meeen");
    super.dispose();
  }
}

//["James","ethbrtojgert"]
