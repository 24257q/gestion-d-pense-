import 'package:intl/intl.dart';

/// Formatage monétaire et dates selon la locale active.
abstract final class AppFormatters {
  static NumberFormat currency(String localeCode) => NumberFormat.currency(
        locale: localeCode,
        decimalDigits: 2,
        symbol: localeCode.startsWith('fr') ? ' €' : r' $',
      );

  static DateFormat shortDate(String localeCode) =>
      DateFormat.MMMd(localeCode);

  static DateFormat fullDate(String localeCode) =>
      DateFormat.yMMMd(localeCode);
}
