import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui_theme.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    _notes = prefs.getStringList('notes') ?? [];
    setState(() => _loading = false);
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }

  void _addNote() {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.insert(0, text);
    });

    _controller.clear();
    _saveNotes();
  }

  void _delete(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE7D6),

      // SAME HEADER AS TRANSLATE PAGE
      appBar: const AppHeader(title: "AI Assistant App", showBack: true),

      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PAGE BIG TITLE
              const Center(
                child: Text(
                  "Notes",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFFBFD7C7)),
              const SizedBox(height: 18),

              // INPUT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Write your note...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _addNote,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.brandGreen,
                        child:
                            const Icon(Icons.add, color: Colors.white, size: 26),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // NOTES LIST
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _notes.isEmpty
                        ? const Center(
                            child: Text("No notes yet",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textMuted)),
                          )
                        : ListView.builder(
                            itemCount: _notes.length,
                            padding: const EdgeInsets.only(bottom: 16),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Color(0xFFE6F4EA),
                                      child: Icon(Icons.note_alt_outlined,
                                          color: Colors.black87, size: 24),
                                    ),
                                    const SizedBox(width: 12),

                                    // Text
                                    Expanded(
                                      child: Text(
                                        _notes[index],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),

                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _delete(index),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // SAME BOTTOM NAV AS TRANSLATE PAGE
  Widget _bottomBar() {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFFE9F0EB),
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home_outlined, size: 30),
         
          Icon(Icons.settings, size: 30),
        ],
      ),
    );
  }
}
