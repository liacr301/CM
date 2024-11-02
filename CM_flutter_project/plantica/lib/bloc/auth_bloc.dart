import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:plantica/database.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppDatabase database;

  // Flags to prevent re-entrant calls
  bool _isRegistering = false;
  bool _isLoggingIn = false;

  AuthBloc({required this.database}) : super(AuthInitial()) {
    on<RegisterRequested>(_handleRegisterRequested);
    on<LoginRequested>(_handleLoginRequested);
  }

  Future<void> _handleRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_isRegistering) return; // Prevent re-entrance
    _isRegistering = true;

    try {
      emit(AuthLoading());

      if (event.username.isEmpty ||
          event.password.isEmpty ||
          event.name.isEmpty ||
          event.birthdate.isEmpty) {
        emit(const AuthFailure('Please fill all the fields!'));
        return;
      }

      await database.registerUser(
        event.name,
        event.username,
        event.birthdate,
        event.password,
      );

      emit(const RegistrationSuccess());
    } catch (e) {
      emit(AuthFailure('Registration failed: ${e.toString()}'));
    } finally {
      _isRegistering = false;
    }
  }

  Future<void> _handleLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_isLoggingIn) return; // Prevent re-entrance
    _isLoggingIn = true;

    try {
      emit(AuthLoading());

      if (event.username.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure('Please fill all the fields!'));
        return;
      }

      final user = await database.loginUser(event.username, event.password);

      if (user != null) {
        emit(LoginSuccess(user));
      } else {
        emit(const AuthFailure('Invalid username or password'));
      }
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
    } finally {
      _isLoggingIn = false;
    }
  }
}
