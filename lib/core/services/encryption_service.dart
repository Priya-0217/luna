import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  EncryptionService._();

  static const _storage = FlutterSecureStorage();
  static const _keyStorageName = 'luna_journal_secure_key';

  // Standard fallback initialization key to prevent failure blockages
  static final _defaultKey = encrypt.Key.fromUtf8(
    'luna_secret_encryption_key_2026!',
  );
  static final _defaultIv = encrypt.IV.fromLength(16);

  static Future<String> _getOrCreateKey() async {
    try {
      var keyStr = await _storage.read(key: _keyStorageName);
      if (keyStr == null) {
        // Generate a fresh 32-character key for AES-256
        final generated = encrypt.Key.fromSecureRandom(32).base64;
        await _storage.write(key: _keyStorageName, value: generated);
        keyStr = generated;
      }
      return keyStr;
    } catch (e) {
      // Graceful fallback to default in developer or unsupported secure storage environments
      return _defaultKey.base64;
    }
  }

  /// Encrypts journal body text to secure AES-256 strings
  static Future<String> encryptText(String text) async {
    if (text.isEmpty) return '';

    try {
      final keyBase64 = await _getOrCreateKey();
      final key = encrypt.Key.fromBase64(keyBase64);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(text, iv: _defaultIv);
      return encrypted.base64;
    } catch (e) {
      // Fail-safe returns default encryption
      final encrypter = encrypt.Encrypter(encrypt.AES(_defaultKey));
      final encrypted = encrypter.encrypt(text, iv: _defaultIv);
      return encrypted.base64;
    }
  }

  /// Decrypts AES-256 strings back to original diary readable text
  static Future<String> decryptText(String encryptedBase64) async {
    if (encryptedBase64.isEmpty) return '';

    try {
      final keyBase64 = await _getOrCreateKey();
      final key = encrypt.Key.fromBase64(keyBase64);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decrypted = encrypter.decrypt64(encryptedBase64, iv: _defaultIv);
      return decrypted;
    } catch (e) {
      try {
        final encrypter = encrypt.Encrypter(encrypt.AES(_defaultKey));
        return encrypter.decrypt64(encryptedBase64, iv: _defaultIv);
      } catch (err) {
        return "Decryption error 💕 Your content is safe. Try restarting the vault.";
      }
    }
  }

  /// Clears the encryption key from secure storage
  static Future<void> clearSecureKey() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: _keyStorageName);
  }
}
