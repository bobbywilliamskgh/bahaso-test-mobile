import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  const LoggedIn({required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => "LoggedIn {$token}";
}

class Registered extends AuthenticationEvent {
  final String userEmail;
  const Registered({required this.userEmail});

  @override
  List<Object> get props => [userEmail];

  @override
  String toString() => "LoggedIn {$userEmail}";
}

class LoggedOut extends AuthenticationEvent {}
