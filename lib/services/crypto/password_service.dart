// ignore_for_file: avoid_print

import 'package:bcrypt/bcrypt.dart';

/// Service for handling password hashing and verification
/// Uses bcrypt algorithm for secure password storage
class PasswordService {
  
  // Cost factor for bcrypt (number of rounds)
  // Higher = more secure but slower
  // 10 = 2^10 = 1024 rounds (good balance)
  static const int _costFactor = 10;
  
  /// Hash a password using bcrypt algorithm
  /// 
  /// Example:
  /// String hash = PasswordService.hashPassword('myPassword123');
  /// // Returns: "$2a$10$N9qo8uLOickgx2ZMRZoMye..."
  /// 
  /// [password] - Plain text password to hash
  /// Returns: Hashed password string
  static String hashPassword(String password) {
    try {
      print('🔐 Hashing password...');
      
      // Step 1: Generate a random salt
      // Salt = random data to make each hash unique
      String salt = BCrypt.gensalt();
      print('🧂 Generated salt with cost factor: $_costFactor');
      
      // Step 2: Hash the password with the salt
      // This combines password + salt and runs bcrypt algorithm
      String hashedPassword = BCrypt.hashpw(password, salt);
      
      print('✅ Password hashed successfully');
      return hashedPassword;
      
    } catch (e) {
      print('❌ Error hashing password: $e');
      rethrow; // Pass error up to caller
    }
  }
  
  /// Verify if a plain password matches a hashed password
  /// 
  /// Example:
  /// bool isValid = PasswordService.verifyPassword(
  ///   'myPassword123',                    // What user typed
  ///   '$2a$10$N9qo8uLOickgx2ZMRZoMye...'  // Stored hash
  /// );
  /// 
  /// [plainPassword] - Plain text password to check
  /// [hashedPassword] - Previously hashed password from database
  /// Returns: true if passwords match, false otherwise
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    try {
      print('🔍 Verifying password...');
      
      // BCrypt.checkpw extracts the salt from hashedPassword
      // and hashes plainPassword with same salt
      // Then compares the results
      bool isMatch = BCrypt.checkpw(plainPassword, hashedPassword);
      
      if (isMatch) {
        print('✅ Password verified successfully');
      } else {
        print('❌ Password verification failed');
      }
      
      return isMatch;
      
    } catch (e) {
      print('❌ Error verifying password: $e');
      return false;
    }
  }
}