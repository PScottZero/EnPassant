import 'package:flutter/cupertino.dart';

import '../../view_constants.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Image.asset(ViewConstants.LOGO_IMG_DIR),
    );
  }
}
