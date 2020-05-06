import 'package:charts_common/common.dart' as charts;
import 'package:covid19tracker/constants.dart';
import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get recovered => kRecoveredColor;
  Color get confirmed => kConfirmedColor;
  Color get died => kDiedColor;

  Color get note => const Color(0xFFffc107);
}

extension ConvertFunctions on Color {
  charts.Color toChartColor() {
    return charts.Color(a: this.alpha, r: this.red, g: this.green, b: this.blue);
  }
}
