
import 'package:intl/intl.dart';

String formatMoney(String? money){
  String cash = '';
  var formatPesos = new NumberFormat.currency(locale: "es_CO", symbol: r"", decimalDigits: money!.contains(".")?1:0);
  cash = formatPesos.format(double.parse(money));
  return r"$ "+cash;
}

String formatDate(DateTime date,String pattern,String locale){
  String dateReturn = '';
  final formatDateFirst = new DateFormat(pattern,locale);
  dateReturn = formatDateFirst.format(date);
  return dateReturn;
}