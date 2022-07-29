import 'dart:ui';

class ViewConstants {
  // ui sizing
  static const double blurRadius = 10.0;
  static const double borderRadius = 30.0;
  static const double largeBorderWidth = 4.0;
  static const double smallBorderWidth = 2.0;
  static const double buttonHeight = 60.0;
  static const double gameInfoMaxHeight = 204.0;
  static const double gameInfoMinHeight = 134.0;
  static const double gameWidgetSizeTrim = 68.0;
  static const double largeGap = 30.0;
  static const double smallGap = 10.0;
  static const double indicatorHeight = 12.0;
  static const double largePadding = 20.0;
  static const double smallPadding = 10.0;
  static const double pickerHeight = 140.0;
  static const double pickerItemExtent = 50.0;
  static const double piecePreviewTitleWidth = piecePreviewWidth / 2.0;
  static const double piecePreviewWidth = pickerHeight * 2.0 / 3.0;
  static const double piecePreviewSpriteAdjust =
      piece_preview_sprite_offset * 2.0;
  static const double piece_preview_sprite_offset = 8.0;
  static const double promotionDialogHeight = 66.0;
  static const double segmentedControlPaddingLR = 16.0;
  static const double segmentedControlPaddingTB = 8.0;
  static const double smallScreenCutoff = 800.0;
  static const double toggleHeight = 55.0;

  // font size constants
  static const double textDialog = 16.0;
  static const double textLarge = 36.0;
  static const double textRegular = 24.0;
  static const double textSmall = 20.0;
  static const double textSegmentedControl = 8.0;

  // color constants
  static const Color backgroundColor = Color(0x20000000);
  static const Color pickerThumbColor = Color(0x50FFFFFF);
  static const Color shadowColor = Color(0x88000000);
}
