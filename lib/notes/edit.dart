import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
Utilities _utilities = Utilities();
Dialogs _dialogs = Dialogs();
GetLists _lists = GetLists();

int id;
int bid;
String noteFunction;
MaterialColor primarySwatch;

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key key, this.model}) : super(key: key);

  final NtModel model;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentsController = TextEditingController();

  @override
  initState() {
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;

    id = widget.model.id;
    bid = widget.model.bid;

    _titleController.text = widget.model.title;
    _contentsController.text = widget.model.contents;

    (id == null) ? noteFunction = 'Add Note' : noteFunction = 'Edit Note';

    _titleController.addListener(handleOnChange);
    _contentsController.addListener(handleOnChange);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  void handleOnChange() {
    (id == null) ? saveEdit() : updateEdit();
  }

  void saveEdit() async {
    id = await _ntQueries.insertNote(
      NtModel(
          title: _utilities.reduceLength(35, _titleController.text),
          contents: _utilities.reduceLength(256, _contentsController.text),
          bid: bid),
    ); // populate 'id' so that it is not saved more than once
  }

  void updateEdit() async {
    await _ntQueries.updateNote(
      NtModel(
          id: id,
          title: _utilities.reduceLength(35, _titleController.text),
          contents: _utilities.reduceLength(256, _contentsController.text),
          bid: bid),
    );
  }

  // backButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               (back == 'main') ? const MainPage() : const NotesPage(),
  //         ),
  //       );
  //     },
  //   );
  // }

  // delayedSnackbar(context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 400),
  //     () {
  //       ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
  //     },
  //   );
  // }

  // backButton(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const MainPage(),
  //     ),
  //   );
  // }

  deleteWrapper(BuildContext context) {
    var arr = List.filled(4, '');
    arr[0] = "DELETE?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _ntQueries.deleteNote(id).then(
            (value) {
              //backButton(context);
              _lists.updateActiveLists('all', Globals.bibleVersion);
              Navigator.pop(context, 'deleted');
              //delayedSnackbar(context);
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(noteFunction),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteWrapper(context);
                },
              )
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    //prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(5.0),
                        ),
                  ),
                  maxLength: 35,
                  maxLines: 1, // auto line break
                  autofocus: false,
                  // onChanged: (val) {
                  //   title = val;
                  //   handleOnChange();
                  // },
                ),
                TextFormField(
                  controller: _contentsController,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                    //prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(5.0),
                        ),
                  ),
                  maxLength: 256,
                  maxLines: null, // auto line break
                  autofocus: false,
                  // onChanged: (val) {
                  //   contents = val;
                  //   handleOnChange();
                  // },
                ),
              ],
            ),
          ),
        ),
      );
}
