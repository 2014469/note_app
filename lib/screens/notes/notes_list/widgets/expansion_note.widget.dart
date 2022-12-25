import 'package:flutter/material.dart';

import '../../../../resources/colors/colors.dart';
import '../../../../resources/fonts/enum_text_styles.dart';
import '../../../../resources/fonts/text_styles.dart';
import 'expansion_tile.dart';

class ExpansionNoteWidget extends StatelessWidget {
  final List<Widget> childs;
  final String title;
  const ExpansionNoteWidget({
    super.key,
    required this.childs,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCustom(
      initiallyExpanded: true,
      iconColor: AppColors.gray[80],
      collapsedIconColor: AppColors.gray[80],
      collapsedTextColor: AppColors.gray[80],
      textColor: AppColors.gray[80],
      title: Text(
        title,
        style: AppTextStyles.h5[TextWeights.extrabold],
      ),
      onExpansionChanged: ((value) {}),
      children: childs,
    );
  }
}
