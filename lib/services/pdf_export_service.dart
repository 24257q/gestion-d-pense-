import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../l10n/app_strings.dart';

class PdfExportService {
  static Future<void> exportTransactions(List<Transaction> transactions, double balance) async {
    final pdf = pw.Document();
    
    final DateFormat dateFormat = DateFormat.yMMMd(AppStrings.currentLang);
    final NumberFormat moneyFormat = NumberFormat.currency(
      locale: AppStrings.currentLang,
      symbol: AppStrings.currentLang == 'fr' ? '€' : r'$',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(moneyFormat.format(balance)),
            pw.SizedBox(height: 20),
            _buildTable(transactions, dateFormat, moneyFormat),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Expense_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.Widget _buildHeader(String totalBalance) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          AppStrings.currentLang == 'fr' ? 'Rapport Financier' : 'Financial Report',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${AppStrings.currentLang == 'fr' ? 'Généré le' : 'Generated on'} ${DateFormat.yMMMd(AppStrings.currentLang).format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            border: pw.Border.all(color: PdfColors.blue200),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                AppStrings.balance,
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                totalBalance,
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTable(List<Transaction> transactions, DateFormat dateFormat, NumberFormat moneyFormat) {
    return pw.TableHelper.fromTextArray(
      headers: [
        AppStrings.date,
        AppStrings.currentLang == 'fr' ? 'Titre' : 'Title',
        AppStrings.category,
        AppStrings.amount,
      ],
      data: List<List<String>>.generate(
        transactions.length,
        (index) {
          final t = transactions[index];
          final isIncome = t.type == TransactionType.income;
          final sign = isIncome ? '+' : '-';
          return [
            dateFormat.format(t.date),
            t.title.isEmpty ? AppStrings.categoryName(t.categoryKey) : t.title,
            AppStrings.categoryName(t.categoryKey),
            '$sign${moneyFormat.format(t.amount)}',
          ];
        },
      ),
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
    );
  }
}
