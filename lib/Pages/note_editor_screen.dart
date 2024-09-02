// import 'package:flutter/material.dart';
// import 'package:pixelarticons/pixelarticons.dart';
// import 'note_model.dart';

// class NoteEditorScreen extends StatefulWidget {
//   final Note? note;
//   final Function(String, String, String) onSave;

//   NoteEditorScreen({Key? key, this.note, required this.onSave})
//       : super(key: key);

//   @override
//   _NoteEditorScreenState createState() => _NoteEditorScreenState();
// }

// class _NoteEditorScreenState extends State<NoteEditorScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _contentController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.note?.title ?? '');
//     _contentController = TextEditingController(
//         text: widget.note != null ? widget.note!.content : '');
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Pixel.arrowleft,
//             color: Colors.green,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         backgroundColor: Colors.black,
//         title: Text(widget.note == null ? 'Add Note' : 'Edit Note',
//             style: const TextStyle(color: Colors.green)),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Pixel.save,
//               color: Colors.green,
//             ),
//             onPressed: () {
//               widget.onSave(widget.note?.id ?? '', _titleController.text,
//                   _contentController.text);
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               style: const TextStyle(color: Colors.green),
//               cursorColor: Colors.green,
//               controller: _titleController,
//               decoration: const InputDecoration(
//                   labelText: 'Title',
//                   labelStyle: TextStyle(color: Colors.green),
//                   helperStyle: TextStyle(color: Colors.green),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green),
//                   ),
//               ),
//             ),
//             Expanded(
//               child: TextField(
//                 style: const TextStyle(color: Colors.green),
//                 cursorColor: Colors.green,
//                 controller: _contentController,
//                 decoration: const InputDecoration(
//                   labelText: 'Content',
//                   labelStyle: TextStyle(color: Colors.green),
//                   helperStyle: TextStyle(color: Colors.green),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green),
//                   ),
//                 ),
//                 maxLines: null,
//                 keyboardType: TextInputType.multiline,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:password_manager/Widgets/animated_text.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Models/note_model.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  final Function(String, String, String) onSave;

  const NoteEditorScreen({super.key, this.note, required this.onSave});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
        text: widget.note != null ? widget.note!.content : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _navigateToSpecialPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SpecialPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Pixel.arrowleft,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note',
            style: const TextStyle(color: Colors.green)),
        actions: [
          IconButton(
            icon: const Icon(
              Pixel.save,
              color: Colors.green,
            ),
            onPressed: () {
              if (_titleController.text.contains('143')) {
                _navigateToSpecialPage(context);
              } else {
                widget.onSave(widget.note?.id ?? '', _titleController.text,
                    _contentController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.green),
              cursorColor: Colors.green,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.green),
                helperStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.green),
                cursorColor: Colors.green,
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.green),
                  helperStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SpecialPage extends StatelessWidget {
//   SpecialPage({super.key});

//   final AudioPlayer _audioPlayer = AudioPlayer();

//   void _playSound() async {
//   try {
//     await _audioPlayer.play(AssetSource('audio_assets/rawr.mp3'));
//   } catch (e) {
//     print('Error playing sound: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const AnimatedRainbowText(
//           text: 'Rawr Button 3000!',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Image.asset('image_assets/rawr.jpg'),
//           ),
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
//               child: Text(
//                   'Hello my pookie bear! :3 You found the secret page! Good Job! Im so proud of you, for everything you do! Thank you for being the best girlfriend i could ever ask for. I hope to spend my whole life with you one day, giving you all the love and comfort you deserve. You are amazing to me always leressa, I love you! <3',
//                   style: TextStyle(color: Colors.green)),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _playSound,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//             ),
//             child: const Text(
//               'Click Me',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class SpecialPage extends StatefulWidget {
  const SpecialPage({super.key});

  @override
  _SpecialPageState createState() => _SpecialPageState();
}

class _SpecialPageState extends State<SpecialPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio_assets/rawrrr.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Pixel.arrowleft,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: const AnimatedRainbowText(
          text: 'Rawr Button 3000!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset('image_assets/rawr.jpg'),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Text(
                  'Hello my pookie bear! :3 You found the secret page! Good Job! Im so proud of you, for everything you do! Thank you for being the best girlfriend i could ever ask for. I hope to spend my whole life with you one day, giving you all the love and comfort you deserve. You are amazing to me always leressa, I love you! <3',
                  style: TextStyle(color: Colors.green)),
            ),
          ),
          ElevatedButton(
            onPressed: _playSound,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Click Me',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
