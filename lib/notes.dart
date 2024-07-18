import 'package:flutter/material.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Montserrat',
      ),
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];
  List<String> favoriteNotes = [];
  String? lastDeletedNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              _addToFavorites();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wee.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2.0,
                child: ListTile(
                  title: Text(notes[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          favoriteNotes.contains(notes[index])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favoriteNotes.contains(notes[index])
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () {
                          _toggleFavorite(notes[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditNoteDialog(context, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) async {
    String newNote = await showDialog(
      context: context,
      builder: (context) {
        String note = '';
        return AlertDialog(
          title: Text('Add New Diary'),
          content: TextField(
            onChanged: (value) {
              note = value;
            },
            decoration: InputDecoration(hintText: 'Enter your diary...'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(note);
              },
            ),
          ],
        );
      },
    );

    if (newNote != null && newNote.isNotEmpty) {
      setState(() {
        notes.add(newNote);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diary Successfully Added'),
        ),
      );
    }
  }

  void _showEditNoteDialog(BuildContext context, int index) async {
    String editedNote = await showDialog(
      context: context,
      builder: (context) {
        String note = notes[index];
        return AlertDialog(
          title: Text('Edit Note'),
          content: TextField(
            onChanged: (value) {
              note = value;
            },
            decoration: InputDecoration(hintText: 'Enter your note...'),
            controller: TextEditingController(text: notes[index]),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(note);
              },
            ),
          ],
        );
      },
    );

    if (editedNote != null && editedNote.isNotEmpty) {
      setState(() {
        notes[index] = editedNote;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diary Successfully Edited'),
        ),
      );
    }
  }

  void _toggleFavorite(String note) {
    setState(() {
      if (favoriteNotes.contains(note)) {
        favoriteNotes.remove(note);
      } else {
        favoriteNotes.add(note);
      }
    });
  }

 void _showDeleteConfirmationDialog(BuildContext context, int index) {
  String deletedNote = notes[index];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              _deleteNote(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _deleteNote(int index) {
  String deletedNote = notes[index];

  bool isCancelled = false;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Note Deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            notes.insert(index, deletedNote);
            isCancelled = true;
          });
        },
      ),
    ),
  );

  Future.delayed(Duration(seconds: 2), () {
    if (!isCancelled) {
      setState(() {
        lastDeletedNote = deletedNote;
        notes.removeAt(index);
      });
    }
  });
}


  void _addToFavorites() {
    // You can implement the logic to add the current note to favorites here.
    // For simplicity, this example toggles the favorite status using _toggleFavorite.
    // You can add your own logic to handle favorites permanently.
  }
}
