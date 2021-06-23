
import 'package:intl/intl.dart';

String formatMoney(String money){
  String cash = '';
  var formatPesos = new NumberFormat.currency(locale: "es_CO", symbol: r"", decimalDigits: 0);
  cash = formatPesos.format(double.parse(money??'0'));
  return r"$ "+cash;
}