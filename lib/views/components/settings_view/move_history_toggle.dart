import 'package:flutter/cupertino.dart';

class MoveHistoryToggle extends StatelessWidget {
  final bool showMoveHistory;
  final Function setFunc;

  MoveHistoryToggle({this.showMoveHistory, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Show Move History',
            style: TextStyle(fontSize: 24)
          ),
          Spacer(),
          CupertinoSwitch(
            value: showMoveHistory,
            onChanged: setFunc,
          )
        ],
      )
    );
  }
}