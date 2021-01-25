import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool toggle;
  final Function setFunc;

  Toggle(this.label, {this.toggle, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          TextRegular(label),
          Spacer(),
          CupertinoSwitch(
            value: toggle,
            onChanged: setFunc,
          ),
        ],
      ),
    );
  }
}
