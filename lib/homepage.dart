import 'package:flutter/material.dart';
import 'signin.dart';
import 'notes.dart';
import 'chat.dart';
import 'games.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Heycarl's Diary",
      home: MyHomePage(title: "Heycarl's Diary"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat(isDarkMode: _isDarkMode)),
    );
  }

  void _navigateToGames() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamesPage()),
    );
  }

  void _navigateToNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesApp()),
    );
  }

  Widget _buildButton(String label, String imageAsset, Color color, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.title,
      theme: theme,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _openDrawer,
          ),
          title: Center(
            child: Text(
              "Heycarl's Diary",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8CFF9E), Colors.green],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: UserAccountInfo(),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Change Account'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
              ),
              ListTile(
                leading: _isDarkMode
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
                title: Text(
                  _isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: _toggleDarkMode,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // TODO: Implement settings functionality
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildButton(
                  'My Diary',
                  'assets/notes.jpg',
                  _isDarkMode ? Colors.grey[800] ?? Colors.green : Colors.green,
                  _navigateToNotes,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildButton(
                  'Close Friends',
                  'assets/chat.jpg',
                  _isDarkMode ? Colors.grey[800] ?? Colors.blue : Colors.blue,
                  _navigateToChat,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildButton(
                  'Mini Games',
                  'assets/games.jpg',
                  _isDarkMode ? Colors.grey[800] ?? Colors.orange : Colors.orange,
                  _navigateToGames,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAccountInfo extends StatelessWidget {
  const UserAccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 40,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Afiq Haikal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    );
  }
}
