import 'package:intl/intl.dart';

String formatMoney2(String? money){
  print('delivery ${money}');
  String cash = '';
  var formatPesos = new NumberFormat.currency(locale: "es_CO", symbol: r"", decimalDigits: money!.contains(".")?1:0);
  cash = formatPesos.format(double.parse(money));
  return r"$ "+cash;
}


String formatMoney(String? money) {

  if (money == null || money.isEmpty) return "";
  double moneyDouble = double.tryParse(money.replaceAll(",", ".")) ?? 0.0;
  int rounded = moneyDouble.round();
  var formatPesos = new NumberFormat.currency(locale: "es_CO", symbol: r"", decimalDigits: 0);
  String cash = formatPesos.format(rounded);
  return r"$ " + cash;
}

String formatDate(DateTime date,String pattern,String locale){
  String dateReturn = '';
  final formatDateFirst = new DateFormat(pattern,locale);
  dateReturn = formatDateFirst.format(date.toLocal());
  return dateReturn;
}