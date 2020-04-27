import 'package:charts_common/common.dart' as charts;
import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get recovered => const Color(0xFF28a745);
  Color get confirmed => const Color(0xFF000000);
  Color get died => const Color(0xFFdc3545);

  Color get note => const Color(0xFFffc107);
}

extension ConvertFunctions on Color {
  charts.Color toChartColor() {
    return charts.Color(a: this.alpha, r: this.red, g: this.green, b: this.blue);
  }
}
