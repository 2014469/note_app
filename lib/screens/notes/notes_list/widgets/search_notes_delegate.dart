import 'package:flutter/material.dart';

import '../../../../models/note.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/fonts/enum_text_styles.dart';
import '../../../../resources/fonts/text_styles.dart';
import '../../../../utils/routes/routes.dart';
import '../../type.dart';
import 'note_tile.widget.dart';

// import 'note
class BuildSearchNotesDelegate extends SearchDelegate<String> {
  String folderId;
  List<Note> notes;
  BuildSearchNotesDelegate({required this.folderId, this.notes = const []});

  List<Note> suggestionNow = [];
  List<String> searchResultTitles = [];
  List<String> searchResultBodys = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
      onPressed: () {
        if (query.isEmpty) {
          closeSearch(context);
        } else {
          query = '';
        }
      },
      icon: const Icon(Icons.clear),
    );
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => closeSearch(context),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text("Hello world"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(builder: ((context, setState) {
      searchResultTitles = notes.map((e) => e.title).toList();
      searchResultBodys = notes.map((e) => e.body!).toList();

      suggestionNow = notes.where((element) {
        final titles = element.title.toLowerCase();
        final bodys = element.body!.toLowerCase();
        final input = query.toLowerCase();

        return titles.contains(input) || bodys.contains(input);
      }).toList();
      return buildSuggestionsUI(context, suggestionNow);
    }));
  }

  Widget buildNoSuggestions() => Center(
        child: Text(
          'No suggestions!',
          style: AppTextStyles.h4[TextWeights.bold]!
              .copyWith(color: AppColors.primary),
        ),
      );

  void closeSearch(BuildContext context) async {
    Navigator.of(context).pop();
  }

  Widget buildSuggestionsUI(
    BuildContext context,
    List<Note> suggestions,
  ) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        return noteChild(context, suggestions[index]);
      }),
    );
  }

  Widget noteChild(BuildContext context, Note note) {
    return NoteListTileWidget(
      isDivider: true,
      note: note,
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.editNote,
          arguments: {
            "type": NoteType.editNote,
            "folderId": folderId,
            "note": note,
          },
        );
      },
    );

    //   NoteProvider noteProvider = Provider.of(context);
    //   return ListView(
    //       children: List<Widget>.generate(suggestions.length, (index) {
    //     bool isDivider = true;
    //     Note note = suggestions[index];
    //     if (index == noteProvider.getLengthAllNotes - 1) {
    //       isDivider = false;
    //     }
    //     return noteChild(context, note, isDivider, folderId);
    //   }));
  }
}
