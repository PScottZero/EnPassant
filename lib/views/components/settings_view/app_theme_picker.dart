import 'package:en_passant/model/app_model.dart';
import 'package:en_passant/model/app_themes.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('App Theme'),
            padding: EdgeInsets.all(10),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0x20000000),
            ),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: appModel.themeIndex,
              ),
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: Color(0x20000000),
              ),
              itemExtent: 50,
              onSelectedItemChanged: appModel.setTheme,
              children: themeList
                  .map(
                    (theme) => Container(
                      padding: EdgeInsets.all(10),
                      child: TextRegular(theme.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
