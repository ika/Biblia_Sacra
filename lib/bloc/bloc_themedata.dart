import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ThemeEvent {}

class InitiateTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  ChangeTheme(this.isDark);
  final bool isDark;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ThemeBloc extends HydratedBloc<ThemeEvent, bool> {
  ThemeBloc() : super(true) {

    // on<InitiateTheme>((event, emit) {
    //   emit(state);
    // });

    on<ChangeTheme>((event, emit) {
      emit(event.isDark ? false : true);
    });
  }

  @override
  bool? fromJson(Map<String, dynamic> json) => json['theme'] as bool;

  @override
  Map<String, dynamic>? toJson(bool state) => {'theme': state};
}
