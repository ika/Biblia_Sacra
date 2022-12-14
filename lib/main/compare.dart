import 'dart:async';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/vers/vkQueries.dart';

VkQueries vkQueries = VkQueries();
SharedPrefs sharedPrefs = SharedPrefs();

class CompareModel {
  String a; // abbr
  String b; // book name
  int c; // chapter
  int v; // verse
  String t; // text

  CompareModel({this.a, this.b, this.c, this.v, this.t});
}

class Compare {
  Future<List<CompareModel>> activeVersions(Bible model) async {
    List<CompareModel> compareList = [];

    List activeVersions = await vkQueries.getActiveVersionNumbers();

    int initialBibleVersion = Globals.bibleVersion; // save bible version

    for (int x = 0; x < activeVersions.length; x++) {
      Globals.bibleVersion = activeVersions[x]['number'];

      String bookName = bookLists.getBookByNumber(
          Globals.bibleBook, activeVersions[x]['lang']);

      String abbr = activeVersions[x]['abbr'];

      DbQueries dbQueries = DbQueries();
      List<Bible> verse = await dbQueries.getVerse(model.b, model.c, model.v);

      abbr = (abbr.isNotEmpty) ? abbr : 'Unknown';
      bookName = (bookName.isNotEmpty) ? bookName : 'Unknown';
      int c = (verse.first.c != null) ? verse.first.c : 0;
      int v = (verse.first.v != null) ? verse.first.v : 0;
      String t = (verse.first.t.isNotEmpty) ? verse.first.t : 'Unknown';

      final cModel = CompareModel(a: abbr, b: bookName, c: c, v: v, t: t);

      compareList.add(cModel);
    }
    // restore bible version
    Globals.bibleVersion = initialBibleVersion;

    return compareList;
  }
}
