class SignupRequest {
  final String username;
  final String name;
  final String email;
  final String firebaseUid;

  SignupRequest({
    required this.username,
    required this.name,
    required this.email,
    required this.firebaseUid,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'firebase_uid': firebaseUid,
    };
  }

  @override
  String toString() {
    return 'SignupRequest{username: $username, name: $name, email: $email, firebaseUid: $firebaseUid}';
  }
} 