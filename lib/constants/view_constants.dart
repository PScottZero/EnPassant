import 'dart:ui';

class ViewConstants {
  // ui sizing
  static const double blurRadius = 10;
  static const double borderRadius = 30;
  static const double largeBorderWidth = 4;
  static const double smallBorderWidth = 2;
  static const double buttonHeight = 60;
  static const double gameInfoMaxHeight = 204;
  static const double gameInfoMinHeight = 134;
  static const double gameWidgetSizeTrim = 68;
  static const double largeGap = 30;
  static const double smallGap = 10;
  static const double indicatorHeight = 12;
  static const double largePadding = 20;
  static const double smallPadding = 10;
  static const double pickerHeight = 140;
  static const double pickerItemExtent = 50;
  static const double PIECE_PREVIEW_TILE_WIDTH = PIECE_PREVIEW_WIDTH / 2;
  static const double PIECE_PREVIEW_WIDTH = pickerHeight * 2 / 3;
  static const double PIECE_PREVIEW_SPRITE_ADJUST =
      PIECE_PREVIEW_SPRITE_OFFSET * 2;
  static const double PIECE_PREVIEW_SPRITE_OFFSET = 8;
  static const double PROMOTION_DIALOG_HEIGHT = 66;
  static const double SEGMENTED_CONTROL_PADDING_LR = 16;
  static const double SEGMENTED_CONTROL_PADDING_TB = 8;
  static const double SMALL_SCREEN_CUTOFF = 800;
  static const double TOGGLE_HEIGHT = 55;

  // font size constants
  static const double TEXT_DIALOG = 16;
  static const double TEXT_LARGE = 36;
  static const double TEXT_REGULAR = 24;
  static const double TEXT_SMALL = 20;
  static const double TEXT_SEGMENTED_CONTROL = 8;

  // color constants
  static const Color BACKGROUND_COLOR = Color(0x20000000);
  static const Color PICKER_THUMB_COLOR = Color(0x50FFFFFF);
  static const Color SHADOW_COLOR = Color(0x88000000);
  static const Color WHITE = Color(0xffffffff);

  // url constants
  static const String LOGO_IMG_DIR = 'assets/images/logo.png';
}
