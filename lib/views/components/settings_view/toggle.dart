import 'package:flutter/cupertino.dart';

import '../shared/text_variable.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool? toggle;
  final Function(bool)? setFunc;

  Toggle(this.label, {this.toggle, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        children: [
          TextRegular(label),
          Spacer(),
          CupertinoSwitch(
            value: toggle ?? false,
            onChanged: setFunc,
          ),
        ],
      ),
    );
  }
}
