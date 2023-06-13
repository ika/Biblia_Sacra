
import 'package:bibliasacra/cubit/cub_settings.dart';
import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/cubit/cub_textsize.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor? palette;

SharedPrefs _sharedPrefs = SharedPrefs();
Utilities utilities = Utilities();
GetLists _lists = GetLists();
VkQueries _vkQueries = VkQueries();
BookLists bookLists = BookLists();

void getActiveVersionsCount() async {
  Globals.activeVersionCount = await _vkQueries.getActiveVersionCount();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  //   // Change the default factory
  //   databaseFactory = databaseFactoryFfi;
  // }

  utilities.getDialogeHeight();

  _sharedPrefs.getIntPref('colorsList').then((p) {
    Globals.colorListNumber = (p != null) ? p : 12;
    _sharedPrefs.getIntPref('version').then(
      (a) {
        Globals.bibleVersion = (a != null) ? a : 1;
        _lists.updateActiveLists('all', Globals.bibleVersion);
        // language
        _sharedPrefs.getStringPref('language').then(
          (b) {
            Globals.bibleLang = (b != null) ? b : 'eng';
            // version abbreviation
            _sharedPrefs.getStringPref('verabbr').then(
              (c) {
                Globals.versionAbbr = (c != null) ? c : 'KVJ';
                // Book
                _sharedPrefs.getIntPref('book').then(
                  (d) {
                    Globals.bibleBook = (d != null) ? d : 43;
                    // Chapter
                    _sharedPrefs.getIntPref('chapter').then(
                      (e) {
                        Globals.bookChapter = (e != null) ? e : 1;
                        // Verse
                        _sharedPrefs.getIntPref('verse').then(
                          (f) {
                            Globals.chapterVerse = (f != null) ? f : 0;
                            // Book Name
                            bookLists.readBookName(Globals.bibleBook).then(
                              (g) {
                                Globals.bookName = g;
                                _sharedPrefs
                                    .getDoublePref('textSize')
                                    .then((t) {
                                  Globals.initialTextSize =
                                      (t != null) ? t : 16;
                                  _sharedPrefs
                                      .getStringPref('fontSel')
                                      .then((f) {
                                    Globals.initialFont =
                                        (f != null) ? f : 'Roboto';
                                    getActiveVersionsCount();
                                  });
                                });
                                runApp(
                                  const BibleApp(),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  });
}

class BibleApp extends StatelessWidget {
  const BibleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChapterCubit>(
          create: (context) => ChapterCubit()..getChapter(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit()..getSearchAreaKey(),
        ),
        BlocProvider<TextSizeCubit>(
          create: (context) => TextSizeCubit()..getSize(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        )
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: ((context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bible App',
            theme: state.themeData,
            home: const MainPage(),
          );
        }),
      ),
    );
  }
}
