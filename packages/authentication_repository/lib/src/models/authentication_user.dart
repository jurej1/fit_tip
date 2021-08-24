import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationUser extends Equatable {
  final UserInfo firebaseUser;

  const AuthenticationUser(this.firebaseUser);

  String get uid => firebaseUser.uid;
  String? get displayName => firebaseUser.displayName;
  String? get email => firebaseUser.email;

  @override
  List<Object?> get props => [firebaseUser];

  AuthenticationUser copyWith({
    UserInfo? firebaseUser,
  }) {
    return AuthenticationUser(
      firebaseUser ?? this.firebaseUser,
    );
  }
}
