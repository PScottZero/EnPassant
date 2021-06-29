import 'dart:ui';

class ViewConstants {
  // string constants
  static const String AI_DIFFICULTY_STRING = 'AI Difficulty';
  static const String APP_NAME = 'En Passant';
  static const String APP_THEME_STRING = 'App Theme';
  static const String BACK_STRING = 'Back';
  static const String BLACK_STRING = 'black';
  static const String CANCEL_STRING = 'Cancel';
  static const String EXIT_STRING = 'Exit';
  static const String FLIP_STRING = 'Flip Board For Black';
  static const String FONT_NAME = 'Jura';
  static const String GAME_MODE_STRING = 'Game Mode';
  static const String GITHUB_STRING = 'GitHub';
  static const String MOVE_HISTORY_STRING = 'Show Move History';
  static const String PIECE_THEME_STRING = 'Piece Theme';
  static const String RESTART_STRING = 'Restart';
  static const String SETTINGS_STRING = 'Settings';
  static const String SHOW_HINTS_STRING = 'Show Hints';
  static const String SIDE_STRING = 'Side';
  static const String SOUND_ENABLED_STRING = 'Sound Enabled';
  static const String START_STRING = 'Start';
  static const String TIME_LIMIT_STRING = 'Time Limit';
  static const String UNDO_REDO_STRING = 'Allow Undo/Redo';
  static const String VIDEO_CHESS_THEME_NAME = 'Video Chess';
  static const String WHITE_STRING = 'white';

  // url constants
  static const String GITHUB_URL = 'https://github.com/PScottZero/EnPassant';
  static const String LOGO_IMG_DIR = 'assets/images/logo.png';

  // sizing constants
  static const double BLUR_RADIUS = 10;
  static const double BORDER_RADIUS = 30;
  static const double BORDER_WIDTH_LARGE = 4;
  static const double BORDER_WIDTH_SMALL = 2;
  static const double BUTTON_HEIGHT = 60;
  static const double GAME_INFO_MAX_HEIGHT = 204;
  static const double GAME_INFO_MIN_HEIGHT = 134;
  static const double GAME_WIDGET_SIZE_TRIM = 68;
  static const double GAP_LARGE = 30;
  static const double GAP_SMALL = 10;
  static const double PADDING_LARGE = 20;
  static const double PADDING_SMALL = 10;
  static const double PICKER_HEIGHT = 140;
  static const double PICKER_ITEM_EXTENT = 50;
  static const double PIECE_PREVIEW_TILE_WIDTH = PIECE_PREVIEW_WIDTH / 2;
  static const double PIECE_PREVIEW_WIDTH = PICKER_HEIGHT * 2 / 3;
  static const double PROMOTION_DIALOG_HEIGHT = 66;
  static const double SEGMENTED_CONTROL_PADDING_LR = 16;
  static const double SEGMENTED_CONTROL_PADDING_TB = 8;
  static const double SMALL_SCREEN_CUTOFF = 700;
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
}
