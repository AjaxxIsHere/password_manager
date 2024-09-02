import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:password_manager/Models/note_model.dart';
import '../Models/password_model.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class PasswordService {
  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();
  final _password =
      'LeressaILoveYouSoMuchPleaseMarryMe143@@USoHotNGL'; // This should be a secure password
  // Generate a key from a password
  // encrypt.Key _generateKey() {
  //   final key = encrypt.Key.fromUtf8(
  //       _password.padRight(32, '')); // Ensure key is 32 bytes
  //   return key;
  // }

  encrypt.Key _generateKey() {
    // Pad or trim the password to ensure it is 32 characters long (256 bits)
    final keyString = _password.padRight(32).substring(0, 32);
    final key = encrypt.Key.fromUtf8(keyString);
    return key;
  }

  String _encrypt(String plainText) {
    final iv = encrypt.IV.fromLength(16); // Generate a random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(_generateKey()));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Combine the IV and the encrypted text
    final encryptedData = "${iv.base64}:${encrypted.base64}";
    return encryptedData;
  }

  String _decrypt(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw ArgumentError('Invalid encrypted text format');
      }

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = parts[1];

      final encrypter = encrypt.Encrypter(encrypt.AES(_generateKey()));
      final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print('Decryption error: $e');
      }
      throw ArgumentError('Decryption failed: $e');
    }
  }

  String decryptPassword(String encryptedPassword) {
    return _decrypt(encryptedPassword);
  }

  Future<void> addPassword(String title, String email, String password) async {
    final id = _uuid.v4();
    final encryptedPassword = _encrypt(password);
    final passwordData = Password(
        id: id, title: title, email: email, password: encryptedPassword);
    await _storage.write(key: id, value: jsonEncode(passwordData.toMap()));
  }

  Future<List<Password>> getPasswords() async {
    final allData = await _storage.readAll();
    return allData.entries
        .where((entry) => entry.value.contains('"password"'))
        .map((entry) {
      final data = jsonDecode(entry.value);
      return Password.fromMap(data);
    }).toList();
  }

  Future<void> deletePassword(String id) async {
    await _storage.delete(key: id);
  }

  Future<void> updatePassword(
      String id, String title, String email, String password) async {
    final encryptedPassword = _encrypt(password);
    final passwordData = Password(
        id: id, title: title, email: email, password: encryptedPassword);
    await _storage.write(key: id, value: jsonEncode(passwordData.toMap()));
  }

  /*-------------------------------------------------------------------------*/

  Future<void> addNote(String title, String content) async {
    final id = _uuid.v4();
    final encryptedContent = content;
    final noteData = Note(id: id, title: title, content: encryptedContent);
    await _storage.write(key: id, value: jsonEncode(noteData.toMap()));
  }

  Future<List<Note>> getNotes() async {
    final allData = await _storage.readAll();
    return allData.entries
        .where((entry) => entry.value.contains('"content"'))
        .map((entry) {
      final data = jsonDecode(entry.value);
      return Note.fromMap(data);
    }).toList();
  }

  Future<void> deleteNote(String id) async {
    await _storage.delete(key: id);
  }

  Future<void> updateNote(String id, String title, String content) async {
    final encryptedContent = content;
    final noteData = Note(id: id, title: title, content: encryptedContent);
    await _storage.write(key: id, value: jsonEncode(noteData.toMap()));
  }
}
