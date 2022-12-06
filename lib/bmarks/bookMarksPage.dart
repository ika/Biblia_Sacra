import 'package:bibliasacra/cubit/chapters_cubit.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bookmarks

BmQueries _bmQueries = BmQueries();
Dialogs _dialogs = Dialogs();

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMarksPage> {
  List<BmModel> list = List<BmModel>.empty();

  SnackBar bmDeletedSnackBar = const SnackBar(
    content: Text('Book Mark Deleted!'),
  );

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(context);
      },
    );
  }

  // backButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       Navigator.push(
  //         context,
  //         CupertinoPageRoute(
  //           builder: (context) => const MainPage(),
  //         ),
  //       );
  //     },
  //   );
  // }

  onBookMarkTap(WriteVarsModel model) {
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(2, '');
    arr[0] = "Delete this Bookmark?";
    arr[1] = sb.toString();

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _bmQueries.deleteBookMark(list[index].id).then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(bmDeletedSnackBar);
              setState(() {});
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  Widget bookMarksList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              list[index].title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.linear_scale, color: Colors.amber),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        text: ' ${list[index].subtitle}'),
                  ),
                ),
              ],
            ),
            onTap: () {
              BlocProvider.of<ChapterCubit>(context)
                  .setChapter(list[index].chapter);

              final model = WriteVarsModel(
                lang: list[index].lang,
                version: list[index].version,
                abbr: list[index].abbr,
                book: list[index].book,
                chapter: list[index].chapter,
                verse: list[index].verse,
                name: list[index].name,
              );

              onBookMarkTap(model);
            },
          ),
        );

    Card makeCard(list, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: makeListTile(list, index),
          ),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(list, index);
      },
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      title: const Text('Bookmarks'),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: topAppBar,
      body: makeBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    Globals.scrollToVerse = Globals.initialScroll = true;
    return WillPopScope(
      onWillPop: () async {
        Globals.scrollToVerse = false;
        Navigator.pop(context);
        return false;
      },
      child: FutureBuilder<List<BmModel>>(
        future: _bmQueries.getBookMarkList(),
        builder: (context, AsyncSnapshot<List<BmModel>> snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data;
            return bookMarksList(list, context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
