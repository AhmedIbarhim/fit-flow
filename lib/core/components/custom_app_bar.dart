import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

AppBar buildCustomAppBar(BuildContext context,
    {required String title, bool leading = true}) {
  return AppBar(
    centerTitle: true,
    title: Text(title, style: AppTextStyles.bold19),
    leading: Visibility(
      visible: leading,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
