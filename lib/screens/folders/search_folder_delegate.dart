import 'package:flutter/material.dart';

import '../../../../resources/colors/colors.dart';
import '../../../../resources/fonts/enum_text_styles.dart';
import '../../../../resources/fonts/text_styles.dart';
import '../../../../utils/routes/routes.dart';
import '../../models/folder.dart';
import 'folder.widget.dart';

// import 'note
class BuildSearchFoldersDelegate extends SearchDelegate<String> {
  List<Folder> folders;
  BuildSearchFoldersDelegate({this.folders = const []});

  List<Folder> suggestionNow = [];

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
    return Container(
      child: const Center(child: Text("Hello world")),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(builder: ((context, setState) {
      suggestionNow = folders.where((element) {
        final names = element.name.toLowerCase();
        final input = query.toLowerCase();

        return names.contains(input);
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
    List<Folder> suggestions,
  ) {
    return GridView.builder(
      itemCount: suggestions.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: ((context, index) {
        Folder folder = suggestions[index];
        return FolderWidget(
          folder: folder,
          isShowMore: false,
          onTapSetting: () {},
          onTap: () => Navigator.of(context).pushNamed(Routes.notes,
              arguments: {"folderId": folder.folderId}),
        );
      }),
    );
  }
}
