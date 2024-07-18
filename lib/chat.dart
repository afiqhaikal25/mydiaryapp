import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final bool isDarkMode;

  Chat({required this.isDarkMode});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _isDarkMode = false;

  @override
  void initState() {
    _isDarkMode = widget.isDarkMode;
    super.initState();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _navigateToChatScreen(String contactName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          contactName: contactName,
          isDarkMode: _isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Conversation'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => _navigateToChatScreen('My Mom'),
            child: ChatItem(
              name: 'My Mom',
              message: 'How are you doing?',
              isDarkMode: _isDarkMode,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToChatScreen('My Sweetheart Nafisa'),
            child: ChatItem(
              name: 'My Sweetheart Nafisa',
              message: 'Miss you!',
              isDarkMode: _isDarkMode,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToChatScreen('My Bestfriend Nik'),
            child: ChatItem(
              name: 'My Bestfriend Nik',
              message: 'Let\'s catch up soon.',
              isDarkMode: _isDarkMode,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final bool isDarkMode;

  ChatItem({required this.name, required this.message, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  final bool isDarkMode;

  ChatScreen({required this.contactName, required this.isDarkMode});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];

  void _sendMessage(String text) {
    setState(() {
      _messages.add(Message(sender: 'Me', text: text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  text: message.text,
                  isSentByMe: message.sender == 'Me',
                  isDarkMode: widget.isDarkMode,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage('Test Message'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByMe;
  final bool isDarkMode;

  ChatBubble({required this.text, required this.isSentByMe, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
