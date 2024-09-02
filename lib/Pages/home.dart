import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/Widgets/animated_text.dart';
import 'package:password_manager/Pages/info_screen.dart';
import 'package:password_manager/Pages/note_editor_screen.dart';
import 'package:password_manager/Services/password_service.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../Models/password_model.dart';
import '../Models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PasswordService _passwordService = PasswordService();
  List<Password> _passwords = [];
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
    _loadNotes();
  }

  Future<void> _loadPasswords() async {
    final passwords = await _passwordService.getPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  Future<void> _loadNotes() async {
    final notes = await _passwordService.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _showAddPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddPasswordDialog(
          onSave: (title, email, password) async {
            await _passwordService.addPassword(title, email, password);
            await _loadPasswords();
          },
        );
      },
    );
  }

  void _showEditPasswordDialog(Password password) {
    final titleController = TextEditingController(text: password.title);
    final emailController = TextEditingController(text: password.email);
    final passwordController = TextEditingController(
        text: _passwordService.decryptPassword(password.password));
    bool isEmailEmpty = false;
    bool isPasswordEmpty = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 188, 122, 30),
              title: const Text('Edit Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: isEmailEmpty ? 'Email is required' : null,
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText:
                          isPasswordEmpty ? 'Password is required' : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEmailEmpty = emailController.text.isEmpty;
                      isPasswordEmpty = passwordController.text.isEmpty;
                    });

                    if (!isEmailEmpty && !isPasswordEmpty) {
                      _passwordService.updatePassword(
                        password.id,
                        titleController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      _loadPasswords();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddNoteDialog(
          onSave: (id, title, content) async {
            await _passwordService.addNote(title, content);
            await _loadNotes();
          },
        );
      },
    );
  }

  void _showEditNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return EditNoteDialog(
          note: note,
          onSave: (id, title, content) async {
            await _passwordService.updateNote(id, title, content);
            await _loadNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('LocksBox',
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Pixel.infobox),
            onPressed: () {
              // Add your logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              tabs: [
                Tab(text: 'Passwords', icon: Icon(Pixel.lock)),
                Tab(
                  text: 'Notes',
                  icon: Icon(Pixel.note),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Passwords Tab
                  _passwords.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _passwords.length,
                          itemBuilder: (context, index) {
                            final password = _passwords[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 25, right: 20),
                              title: Text(password.title,
                                  style: const TextStyle(color: Colors.green)),
                              subtitle: Text(password.email,
                                  style: const TextStyle(color: Colors.green)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Pixel.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              _passwordService.decryptPassword(
                                                  password.password)));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              content: AnimatedRainbowText(
                                                text:
                                                    "Password copied to clipboard",
                                                style: TextStyle(fontSize: 16),
                                              )));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Pixel.edit),
                                    onPressed: () =>
                                        _showEditPasswordDialog(password),
                                  ),
                                  IconButton(
                                    icon: const Icon(Pixel.trash),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 159, 11, 11),
                                            title:
                                                const Text('Delete Password'),
                                            content: const Text(
                                                "Are you sure you want to delete this password? You'll never get it back!"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _passwordService
                                                      .deletePassword(
                                                          password.id);
                                                  await _loadPasswords();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  // Notes Tab
                  _notes.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 25, right: 20),
                              title: Text(note.title,
                                  style: const TextStyle(color: Colors.green)),
                              subtitle: Text(note.content,
                                  style: const TextStyle(color: Colors.green)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Pixel.edit),
                                    onPressed: () => _showEditNoteDialog(note),
                                  ),
                                  IconButton(
                                    icon: const Icon(Pixel.trash),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 159, 11, 11),
                                            title: const Text('Delete Note'),
                                            content: const Text(
                                                "Are you sure you want to delete this note? You'll probably need it in the future!"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _passwordService
                                                      .deleteNote(note.id);
                                                  await _loadNotes();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.greenAccent,
            ),
          );

          showModalBottomSheet(
            backgroundColor: Colors.greenAccent,
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Pixel.lock),
                    title: const Text('Add Password'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddPasswordDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Pixel.note),
                    title: const Text('Add Note'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddNoteDialog();
                    },
                  ),
                ],
              );
            },
          ).whenComplete(
            () => SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.black,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Pixel.plus,
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Pixel.moodneutral, // Replace this with an X icon of your choice
            color: Color.fromARGB(255, 42, 42, 42),
            size: 100,
          ),
          SizedBox(height: 20),
          Text(
            'Nothing but chirping crickets...',
            style:
                TextStyle(color: Color.fromARGB(255, 42, 42, 42), fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

class AddPasswordDialog extends StatefulWidget {
  final Function(String, String, String) onSave;
  final PasswordService passwordService = PasswordService();

  AddPasswordDialog({super.key, required this.onSave});

  @override
  _AddPasswordDialogState createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends State<AddPasswordDialog> {
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Password'),
      backgroundColor: Colors.greenAccent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            style: const TextStyle(color: Colors.black),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: _isEmailEmpty ? 'Email is required' : null,
            ),
            style: const TextStyle(color: Colors.black),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _isPasswordEmpty ? 'Password is required' : null,
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isEmailEmpty = _emailController.text.isEmpty;
              _isPasswordEmpty = _passwordController.text.isEmpty;
            });

            if (!_isEmailEmpty && !_isPasswordEmpty) {
              widget.onSave(
                _titleController.text,
                _emailController.text,
                _passwordController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  final Function(String, String, String) onSave;

  const AddNoteDialog({super.key, required this.onSave});

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => NoteEditorScreen(
            onSave: widget.onSave,
          ),
        ),
      )
          .then((_) {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class EditNoteDialog extends StatefulWidget {
  final Note note;
  final Function(String, String, String) onSave;

  const EditNoteDialog({super.key, required this.note, required this.onSave});

  @override
  _EditNoteDialogState createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => NoteEditorScreen(
            note: widget.note,
            onSave: widget.onSave,
          ),
        ),
      )
          .then((_) {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


 // return Scaffold(
    //     backgroundColor: Colors.black,
    //     appBar: AppBar(
    //       backgroundColor: Colors.black,
    //       title: const Text('LocksBox',
    //           style: TextStyle(
    //               color: Colors.green,
    //               fontWeight: FontWeight.bold,
    //               backgroundColor: Colors.black)),
    //     ),
    //     body: DefaultTabController(
    //       length: 2,
    //       child: Column(
    //         children: [
    //           const TabBar(
    //             indicatorColor: Colors.green,
    //             labelColor: Colors.green,
    //             tabs: [
    //               Tab(text: 'Passwords', icon: Icon(Pixel.lock)),
    //               Tab(
    //                 text: 'Notes',
    //                 icon: Icon(Pixel.note),
    //               ),
    //             ],
    //           ),
    //           Expanded(
    //             child: TabBarView(
    //               children: [
    //                 ListView.builder(
    //                   itemCount: _passwords.length,
    //                   itemBuilder: (context, index) {
    //                     final password = _passwords[index];
    //                     return ListTile(
    //                       contentPadding:
    //                           const EdgeInsets.only(left: 25, right: 20),
    //                       title: Text(password.title,
    //                           style: const TextStyle(color: Colors.green)),
    //                       subtitle: Text(password.email,
    //                           style: const TextStyle(color: Colors.green)),
    //                       trailing: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           IconButton(
    //                             icon: const Icon(Pixel.copy),
    //                             onPressed: () {
    //                               Clipboard.setData(ClipboardData(
    //                                   text: _passwordService
    //                                       .decryptPassword(password.password)));
    //                               print(
    //                                   "Encrypted in password.password in clipboard function: " +
    //                                       password.password);
    //                               print(
    //                                   "Decrypted in password.password in clipboard function: " +
    //                                       _passwordService.decryptPassword(
    //                                           password.password));
    //                               ScaffoldMessenger.of(context)
    //                                   .showSnackBar(const SnackBar(
    //                                       backgroundColor: Colors.greenAccent,
    //                                       content: AnimatedRainbowText(
    //                                         text:
    //                                             "Password copied to clipboard",
    //                                         style: TextStyle(fontSize: 16),
    //                                       )));
    //                             },
    //                           ),
    //                           IconButton(
    //                             icon: const Icon(Pixel.edit),
    //                             onPressed: () =>
    //                                 _showEditPasswordDialog(password),
    //                           ),
    //                           IconButton(
    //                             icon: const Icon(Pixel.trash),
    //                             onPressed: () async {
    //                               showDialog(
    //                                 context: context,
    //                                 builder: (context) {
    //                                   return AlertDialog(
    //                                     backgroundColor: const Color.fromARGB(
    //                                         255, 159, 11, 11),
    //                                     title: const Text('Delete Password'),
    //                                     content: const Text(
    //                                         "Are you sure you want to delete this password? You'll Never get it back!"),
    //                                     actions: [
    //                                       TextButton(
    //                                         onPressed: () =>
    //                                             Navigator.of(context).pop(),
    //                                         child: const Text(
    //                                           'Cancel',
    //                                           style: TextStyle(
    //                                               color: Colors.black,
    //                                               fontSize: 20),
    //                                         ),
    //                                       ),
    //                                       TextButton(
    //                                         onPressed: () async {
    //                                           await _passwordService
    //                                               .deletePassword(password.id);
    //                                           await _loadPasswords();
    //                                           Navigator.of(context).pop();
    //                                         },
    //                                         child: const Text(
    //                                           'Delete',
    //                                           style: TextStyle(
    //                                               color: Colors.black,
    //                                               fontSize: 20),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   );
    //                                 },
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     );
    //                   },
    //                 ),
    //                 ListView.builder(
    //                   itemCount: _notes.length,
    //                   itemBuilder: (context, index) {
    //                     final note = _notes[index];
    //                     return ListTile(
    //                       contentPadding:
    //                           const EdgeInsets.only(left: 25, right: 20),
    //                       title: Text(note.title,
    //                           style: const TextStyle(color: Colors.green)),
    //                       subtitle: Text(note.content,
    //                           style: const TextStyle(color: Colors.green)),
    //                       trailing: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           IconButton(
    //                             icon: const Icon(Pixel.edit),
    //                             onPressed: () => _showEditNoteDialog(note),
    //                           ),
    //                           IconButton(
    //                             icon: const Icon(Pixel.trash),
    //                             onPressed: () async {
    //                               await _passwordService.deleteNote(note.id);
    //                               await _loadNotes();
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         SystemChrome.setSystemUIOverlayStyle(
    //           const SystemUiOverlayStyle(
    //             systemNavigationBarColor: Colors.greenAccent,
    //           ),
    //         );

    //         showModalBottomSheet(
    //           backgroundColor: Colors.greenAccent,
    //           context: context,
    //           builder: (context) {
    //             return Wrap(
    //               children: [
    //                 ListTile(
    //                   leading: const Icon(Pixel.lock),
    //                   title: const Text('Add Password'),
    //                   onTap: () {
    //                     Navigator.pop(context);
    //                     _showAddPasswordDialog();
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Pixel.note),
    //                   title: const Text('Add Note'),
    //                   onTap: () {
    //                     Navigator.pop(context);
    //                     _showAddNoteDialog();
    //                   },
    //                 ),
    //               ],
    //             );
    //           },
    //         ).whenComplete(
    //           () => SystemChrome.setSystemUIOverlayStyle(
    //             const SystemUiOverlayStyle(
    //               systemNavigationBarColor: Colors.black,
    //             ),
    //           ),
    //         );
    //       },
    //       backgroundColor: Colors.green,
    //       child: const Icon(
    //         Pixel.plus,
    //         color: Colors.black,
    //       ),
    //     ));