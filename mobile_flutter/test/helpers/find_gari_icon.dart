import 'package:flutter_test/flutter_test.dart';
import 'package:garilink_mobile/core/theme/icons.dart';

Finder findGariIcon(GariIconData data) => find.byWidgetPredicate(
  (widget) => widget is GariIcon && widget.icon == data,
);
