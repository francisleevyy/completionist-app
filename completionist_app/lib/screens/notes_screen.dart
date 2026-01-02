import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/note.dart';

class NotesScreen extends StatefulWidget {
  final String steamId;
  const NotesScreen({super.key, required this.steamId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

// STATE CLASS
class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // LOAD NOTES METHOD
  Future<void> _loadNotes() async {
    try {
      final notes = await ApiService.fetchNotes(widget.steamId);
      if (mounted) {
        setState(() {
          _notes = notes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // SHOW SNACKBAR METHOD
  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // ADD NOTE DIALOG
  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF4527A0),
              title: Text(
                'New Completionist Note',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // DIALOG CONTENT
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Game Title',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: contentController,
                        style: const TextStyle(color: Colors.white),
                        minLines: 3,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Note Content',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      // LOADING INDICATOR
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: LinearProgressIndicator(color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
              // DIALOG ACTIONS
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                  ),
                  // SAVE BUTTON ACTION
                  onPressed: isLoading
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);

                          String titleToSave = titleController.text.trim();
                          String contentToSave = contentController.text.trim();

                          // DEFAULT TITLE IF EMPTY
                          if (titleToSave.isEmpty) {
                            titleToSave = "Untitled";
                          }
                          // DEFAULT CONTENT IF EMPTY
                          try {
                            await ApiService.createNote(
                              widget.steamId,
                              titleToSave,
                              contentToSave,
                            );
                            if (mounted) {
                              Navigator.pop(context);
                              _loadNotes();
                              _showSnackBar("Note Saved!");
                            }
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                          }
                        },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xFF2C003E),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _notes.isEmpty
              ? const Center(
                  // NO NOTES MESSAGE
                  child: Text(
                    'No Completionist Notes found.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 80),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  // NOTES GRID ITEMS
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Card(
                      color: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailScreen(note: note),
                            ),
                          );
                          // REFRESH NOTES AFTER RETURNING
                          _loadNotes();

                          // SHOW DELETION SNACKBAR
                          if (result == 'deleted') {
                            _showSnackBar("Completionist Note deleted.");
                          }
                        },
                        // NOTE CARD CONTENT
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      note.gameTitle,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: note.isCompleted
                                            ? Colors.white38
                                            : Colors.white,
                                        fontSize: 14,
                                        decoration: note.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: Colors.white38,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1.1,
                                    // COMPLETION CHECKBOX
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: note.isCompleted,
                                        activeColor: Colors.greenAccent,
                                        checkColor: Colors.black,
                                        side: const BorderSide(
                                          color: Colors.white54,
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        onChanged: (bool? val) async {
                                          final newValue = val ?? false;
                                          setState(() {
                                            final updatedNote = Note(
                                              id: note.id,
                                              steamId: note.steamId,
                                              gameTitle: note.gameTitle,
                                              noteContent: note.noteContent,
                                              isCompleted: newValue,
                                            );
                                            _notes[index] = updatedNote;
                                          });
                                          // API CALL TO UPDATE STATUS
                                          try {
                                            await ApiService.toggleNoteStatus(
                                              note.id,
                                              newValue,
                                            );
                                          } catch (e) {
                                            // REVERT ON FAILURE
                                            if (mounted) {
                                              setState(() {
                                                final revertedNote = Note(
                                                  id: note.id,
                                                  steamId: note.steamId,
                                                  gameTitle: note.gameTitle,
                                                  noteContent: note.noteContent,
                                                  isCompleted: !newValue,
                                                );
                                                _notes[index] = revertedNote;
                                              });
                                              _showSnackBar(
                                                "Failed to save status. Check your internet connection.",
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // NOTE CONTENT PREVIEW
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  note.noteContent,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: note.isCompleted
                                        ? Colors.white24
                                        : Colors.white70,
                                    fontSize: 12,
                                    decoration: note.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.white24,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // ADD NOTE BUTTON
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddNoteDialog,
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// NOTE DETAIL SCREEN
class NoteDetailScreen extends StatefulWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

// STATE CLASS
class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
  }
  // SHOW SNACKBAR METHOD
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C003E),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // APP BAR TITLE & ACTIONS
        title: Text(
          'Completionist Note',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () => _showEditDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      // NOTE DETAIL BODY
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            // NOTE CONTENT
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentNote.gameTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: _currentNote.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 20),
                Text(
                  _currentNote.noteContent,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                if (_currentNote.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    // COMPLETED LABEL
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Completed!",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DELETE CONFIRMATION DIALOG
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF4527A0),
        title: const Text(
          'Delete Completionist Note?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this note? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ApiService.deleteNote(_currentNote.id);
              if (mounted) {
                Navigator.pop(context, 'deleted');
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // EDIT NOTE DIALOG
  void _showEditDialog() {
    final titleController = TextEditingController(text: _currentNote.gameTitle);
    final contentController = TextEditingController(
      text: _currentNote.noteContent,
    );
    bool isLoading = false;
    // DISPLAY DIALOG
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF4527A0),
              title: const Text(
                'Edit Completionist Note',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Game Title',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // NOTE CONTENT TEXTFIELD
                      TextField(
                        controller: contentController,
                        style: const TextStyle(color: Colors.white),
                        minLines: 3,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Note Content',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      // LOADING INDICATOR
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: LinearProgressIndicator(color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
              // DIALOG ACTIONS
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                  ),
                  // UPDATE BUTTON ACTION
                  onPressed: isLoading
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);
                          try {
                            await ApiService.updateNote(
                              _currentNote.id,
                              titleController.text,
                              contentController.text,
                            );

                            // UPDATE LOCAL NOTE
                            setState(() {
                              _currentNote = Note(
                                id: _currentNote.id,
                                steamId: _currentNote.steamId,
                                gameTitle: titleController.text,
                                noteContent: contentController.text,
                                isCompleted: _currentNote.isCompleted,
                              );
                            });
                            
                            // CLOSE DIALOG & SHOW SNACKBAR
                            if (mounted) {
                              Navigator.pop(context);
                              _showSnackBar(
                                context,
                                'Completionist Note updated successfully!',
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                          }
                        },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
