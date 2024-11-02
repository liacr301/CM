import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String username;
  final String birthdate;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.username,
    required this.birthdate,
    required this.password,
  });

  @override
  List<Object?> get props => [name, username, birthdate, password];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}