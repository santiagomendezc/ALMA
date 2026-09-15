import 'package:flutter/material.dart';
import 'package:aplicacion/core/error/failures.dart';
import 'package:aplicacion/features/user_management/domain/entities/user.dart';
import 'package:aplicacion/features/user_management/domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;

  UserProvider({required this.repository});
  
  List<User> _users = [];
  List<User> get users => _users;
  
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getUsers();
    
    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (users) {
        _users = users;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<bool> createUser(String nickname) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.createUser(nickname);
    
    return result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _users.add(user);
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  void selectUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
  
  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
