import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS // NEW
          ? kIOSTheme // NEW
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.animationController}); // NEW
  final String text;
  final AnimationController animationController;
  String _name = 'Your Name';
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      // NEW
      sizeFactor: // NEW
          CurvedAnimation(
              parent: animationController, curve: Curves.easeOut), // NEW
      axisAlignment: 0.0, // NEW
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0],style: TextStyle(fontSize: 12.0),)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: TextStyle(fontSize: 13.0),),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('FriendlyChat'),
          elevation: Theme.of(context).platform == TargetPlatform.iOS
              ? 0.0
              : 4.0, // NEW
        ),
        body: Container(
            child: Column(
              // MODIFIED
              children: [
                // NEW
                Flexible(
                  // NEW
                  child: ListView.builder(
                    // NEW
                    padding: EdgeInsets.all(8.0), // NEW
                    reverse: true, // NEW
                    itemBuilder: (_, int index) => _messages[index], // NEW
                    itemCount: _messages.length, // NEW
                  ), // NEW
                ), // NEW
                Divider(height: 1.0), // NEW
                Container(
                  // NEW
                  decoration:
                      BoxDecoration(color: Theme.of(context).cardColor), // NEW
                  child: _buildTextComposer(), // MODIFIED
                ), // NEW
              ], // NEW
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS // NEW
                ? BoxDecoration(
                    // NEW
                    border: Border(
                      // NEW
                      top: BorderSide(color: Colors.grey[200]!), // NEW
                    ), // NEW
                  )
                : null), // NEW
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          // NEW
          children: [
            // NEW
            Flexible(
              // NEW
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  // NEW
                  setState(() {
                    // NEW
                    _isComposing = text.isNotEmpty; // NEW
                  }); // NEW
                }, // NEW
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        // NEW
                        child: Text('Send'), // NEW
                        onPressed: _isComposing // NEW
                            ? () =>
                                _handleSubmitted(_textController.text) // NEW
                            : null,
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _isComposing // MODIFIED
                            ? () => _handleSubmitted(
                                _textController.text) // MODIFIED
                            : null, // MODIFIED
                      )),
          ], // NEW
        ), // NEW
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      // NEW
      _isComposing = false; // NEW
    });
    ChatMessage message = ChatMessage(
      //NEW
      text: text,
      animationController: AnimationController(
        // NEW
        duration: const Duration(milliseconds: 700), // NEW
        vsync: this, // NEW
      ), // NEW
    );
    //NEW                                    //NEW
    setState(() {
      //NEW
      _messages.insert(0, message); //NEW
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
