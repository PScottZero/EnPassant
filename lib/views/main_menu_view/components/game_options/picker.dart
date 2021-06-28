import 'package:en_passant/views/components/text_variable.dart';
import 'package:flutter/cupertino.dart';

class Picker<T> extends StatelessWidget {
  final String label;
  final Map<T, Text> options;
  final T selection;
  final Function setFunc;

  Picker({this.label, this.options, this.selection, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(fontFamily: 'Jura', fontSize: 8),
                ),
              ),
              child: CupertinoSlidingSegmentedControl<T>(
                children: options,
                groupValue: selection,
                onValueChanged: (T val) {
                  setFunc(val);
                },
                padding: EdgeInsets.all(8),
                thumbColor: Color(0x66FFFFFF),
                backgroundColor: Color(0x20000000),
              ),
            ),
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
