import 'package:flutter/material.dart';
import 'package:untitled5/database/dbHelper.dart';
import 'package:untitled5/model/model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _controller = TextEditingController();

  List<Note> _notes = [];
  String _searchOrNewNote = '';

  @override
  void initState() {
    super.initState();
    _loadNotesFromDB();
  }

  void _loadNotesFromDB() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() async {
    final noteText = _controller.text.trim();
    if (noteText.isEmpty) return;

    final newNote = Note(text: noteText);
    await _dbHelper.insertNote(newNote);
    _controller.clear();
    _searchOrNewNote = '';
    _loadNotesFromDB();
  }

  void _deleteNote(Note note) async {
    if (note.id != null) {
      await _dbHelper.deleteNote(note.id!);
      _loadNotesFromDB();
    }
  }

  void _toggleDone(Note note) async {
    note.isDone = !note.isDone;
    await _dbHelper.updateNote(note);
    _loadNotesFromDB();
  }

  List<Note> get _filteredNotes {
    if (_searchOrNewNote.isEmpty) return _notes;
    return _notes
        .where(
          (note) => note.text.toLowerCase().contains(_searchOrNewNote.toLowerCase()),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Search or type a note...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchOrNewNote = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addNote,
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: 'Add Note',
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredNotes.isEmpty
                ? const Center(child: Text('No matching notes.'))
                : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: note.isDone,
                      onChanged: (_) => _toggleDone(note),
                    ),
                    title: Text(
                      note.text,
                      style: TextStyle(
                        decoration: note.isDone ? TextDecoration.lineThrough : null,
                        color: note.isDone ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(note),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
