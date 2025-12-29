import 'package:flutter/material.dart' show Size, MediaQuery, BuildContext;

Size realScreenSize = const Size(0, 0);
Size screenSize = const Size(0, 0);
const defaultScreenSize = Size(400, 870);

double deviceBottomPadding = 0;
double customBottomPadding = 0;

final defaultAspectRatio = defaultScreenSize.width / defaultScreenSize.height;
bool isTablet = false;

void initScreenSize({required BuildContext context}) {
  screenSize = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final topPadding = padding.top;
  deviceBottomPadding = padding.bottom;
  customBottomPadding = deviceBottomPadding + 4;
  final safeArea = topPadding + deviceBottomPadding;
  realScreenSize = screenSize;
  screenSize = Size(screenSize.width, screenSize.height - safeArea);
  if (screenSize.width > 550) {
    screenSize = Size(550, screenSize.height);
    isTablet = true;
  }
  // if (screenSize.height < screenSize.width * 2) {
  //   screenSize = Size((screenSize.height / 2).clamp(0, 550), screenSize.height);
  // }
}

//====================Responsive Extension on double====================//
extension ToResponsiveDouble on double {
  double w() {
    final percentageValue = this / defaultScreenSize.width;

    final maxWidth = screenSize.width * percentageValue;

    final currentAspectRatio = screenSize.width / screenSize.height;

    final finalAspectRatio = currentAspectRatio / defaultAspectRatio;

    double calculatedWidth = (maxWidth / finalAspectRatio).clamp(
      -maxWidth.abs(),
      maxWidth.abs(),
    );
    return calculatedWidth;
  }

  double h() {
    final percentageValue = this / defaultScreenSize.height;

    final maxHeight = screenSize.height * percentageValue;

    final currentAspectRatio = screenSize.width / screenSize.height;

    final finalAspectRatio = currentAspectRatio / defaultAspectRatio;

    double calculatedHeight = (maxHeight / finalAspectRatio).clamp(
      -maxHeight.abs(),
      maxHeight.abs(),
    );
    return calculatedHeight;
  }
}

//====================Responsive Extension on int====================//
extension ToResponsiveInt on int {
  double w() {
    final percentageValue = this / defaultScreenSize.width;

    final maxWidth = screenSize.width * percentageValue;

    final currentAspectRatio = screenSize.width / screenSize.height;

    final finalAspectRatio = currentAspectRatio / defaultAspectRatio;

    double calculatedWidth = (maxWidth / finalAspectRatio).clamp(
      -maxWidth.abs(),
      maxWidth.abs(),
    );
    return calculatedWidth;
  }

  double h() {
    final percentageValue = this / defaultScreenSize.height;

    final maxHeight = screenSize.height * percentageValue;

    final currentAspectRatio = screenSize.width / screenSize.height;

    final finalAspectRatio = currentAspectRatio / defaultAspectRatio;

    double calculatedHeight = (maxHeight / finalAspectRatio).clamp(
      -maxHeight.abs(),
      maxHeight.abs(),
    );

    return calculatedHeight;
  }
}
