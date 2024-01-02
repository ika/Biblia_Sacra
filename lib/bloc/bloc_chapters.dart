import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ChapterEvent {}

class InitiateChapter extends ChapterEvent {}

class UpdateChapter extends ChapterEvent {
  UpdateChapter({required this.chapter});
  final int chapter;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class ChapterState {
  int chapter;
  ChapterState({required this.chapter});
}

class InitiateChapterState extends ChapterState {
  InitiateChapterState({required super.chapter});
}

class UpdateChapterState extends ChapterState {
  UpdateChapterState({required super.chapter});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {

  ChapterBloc() : super(InitiateChapterState(chapter: 1)) {
    on<InitiateChapter>(
        (InitiateChapter event, Emitter<ChapterState> emit) async {
      sharedPrefs.getChapterPref().then((value) {
        //Globals.bibleBookChapter = value!;
        //debugPrint('InitiateChapter $value');
        emit(InitiateChapterState(chapter: value!));
      });
    });

    on<UpdateChapter>((UpdateChapter event, Emitter<ChapterState> emit) async {
      sharedPrefs.setChapterPref(event.chapter).then((v) {
        //Globals.bibleBookChapter = event.chapter;
        //debugPrint('UpdateChapter ${event.chapter}');
        emit(UpdateChapterState(chapter: event.chapter));
      });
    });
  }
}