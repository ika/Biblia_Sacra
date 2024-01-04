import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class SearchEvent {}

class InitiateSearchArea extends SearchEvent {}

class UpdateSearchArea extends SearchEvent {
  UpdateSearchArea({required this.area});
  final int area;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class SearchState {
  int area;
  SearchState({required this.area});
}

class InitiateSearchState extends SearchState {
  InitiateSearchState({required super.area});
}

class UpdateSearchState extends SearchState {
  UpdateSearchState({required super.area});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitiateSearchState(area: 5)) {
    on<InitiateSearchArea>(
        (InitiateSearchArea event, Emitter<SearchState> emit) async {
      emit(InitiateSearchState(area: await sharedPrefs.getSearchAreaPref()));
    });

    on<UpdateSearchArea>((UpdateSearchArea event, Emitter<SearchState> emit) {
      sharedPrefs.setSearchAreaPref(event.area);
      emit(UpdateSearchState(area: event.area));
    });
  }
}
