import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/gold_item.dart';

/// ألوان PDF مطابقة لألوان الموقع
const _pdfGold      = PdfColor.fromInt(0xFF8B6914);
const _pdfGoldLight = PdfColor.fromInt(0xFFC9A84C);
const _pdfBg        = PdfColor.fromInt(0xFFFFFDF5);
const _pdfBorder    = PdfColor.fromInt(0xFFF0E8D0);
const _pdfRowAlt    = PdfColor.fromInt(0xFFFFFFFF);
const _pdfText      = PdfColor.fromInt(0xFF1A1500);
const _pdfMuted     = PdfColor.fromInt(0xFF888888);

class PdfExportService {
  PdfExportService._();

  static const Map<String, String> _typeIconsAr = {
    'ring':    'خاتم 💍',
    'bar':     'سبيكة 🏅',
    'necklace':'سلسال 📿',
    'other':   'أخرى ✨',
  };
  static const Map<String, String> _typeIconsEn = {
    'ring':    'Ring',
    'bar':     'Bar',
    'necklace':'Necklace',
    'other':   'Other',
  };

  /// تصدير وعرض نافذة الطباعة — نفس منطق الموقع
  static Future<void> exportAndPrint({
    required List<GoldItem> items,
    required double goldPrice24,
    required bool isAr,
    required BuildContext context,
  }) async {
    if (items.isEmpty) return;

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.cairoRegular(),
        bold: await PdfGoogleFonts.cairoBold(),
      ),
    );

    final dateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final totalWeight = items.fold(0.0, (s, i) => s + i.weight);
    final totalValue  = items.fold(
      0.0,
      (s, i) => s + (i.weight * (i.karat / 24.0) * goldPrice24),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) => [
          // ── Header ──────────────────────────────────
          _buildHeader(isAr, dateStr, goldPrice24),
          pw.SizedBox(height: 24),

          // ── Table ───────────────────────────────────
          _buildTable(items, isAr, goldPrice24),
          pw.SizedBox(height: 20),

          // ── Summary ─────────────────────────────────
          _buildSummary(items.length, totalWeight, totalValue, isAr),
          pw.SizedBox(height: 24),

          // ── Footer ──────────────────────────────────
          _buildFooter(isAr),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: 'Golden_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  // ── Header ────────────────────────────────────────────
  static pw.Widget _buildHeader(
      bool isAr, String dateStr, double goldPrice24) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _pdfGoldLight, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left: title
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Golden ✦',
                style: pw.TextStyle(
                  color: _pdfGold,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                isAr ? 'سجل الذهب الشخصي' : 'Personal Gold Registry',
                style: pw.TextStyle(color: _pdfMuted, fontSize: 11),
              ),
            ],
          ),
          // Right: date + price
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                isAr ? 'تاريخ التقرير:' : 'Report date:',
                style: pw.TextStyle(color: _pdfMuted, fontSize: 9),
              ),
              pw.Text(
                dateStr,
                style: pw.TextStyle(
                  color: _pdfGold,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${isAr ? 'سعر عيار 24:' : '24K price:'} ${goldPrice24.toStringAsFixed(1)} ${isAr ? 'ريال' : 'SAR'}',
                style: pw.TextStyle(color: _pdfMuted, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Table ─────────────────────────────────────────────
  static pw.Widget _buildTable(
      List<GoldItem> items, bool isAr, double goldPrice24) {
    final headers = isAr
        ? ['الاسم', 'النوع', 'العيار', 'الوزن', 'سعر الشراء', 'القيمة الحالية']
        : ['Name', 'Type', 'Karat', 'Weight', 'Purchase', 'Current Value'];

    final typeMap = isAr ? _typeIconsAr : _typeIconsEn;

    return pw.Table(
      border: pw.TableBorder.all(color: _pdfBorder, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.5),
        1: pw.FlexColumnWidth(1.5),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1.2),
        4: pw.FlexColumnWidth(1.8),
        5: pw.FlexColumnWidth(2),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            gradient: pw.LinearGradient(
              colors: [_pdfGold, _pdfGoldLight],
            ),
          ),
          children: headers
              .map(
                (h) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 10),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...items.asMap().entries.map((entry) {
          final idx  = entry.key;
          final item = entry.value;
          final currentValue =
              item.weight * (item.karat / 24.0) * goldPrice24;
          final bg = idx.isEven ? _pdfBg : _pdfRowAlt;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: bg),
            children: [
              _cell(item.name, bold: true),
              _cell(typeMap[item.type] ?? item.type),
              _cell('${item.karat}K',
                  color: _pdfGold, bold: true),
              _cell('${item.weight}${isAr ? 'جم' : 'g'}'),
              _cell(
                item.purchasePrice > 0
                    ? '${item.purchasePrice.toStringAsFixed(0)} ${isAr ? 'ريال' : 'SAR'}'
                    : '—',
              ),
              _cell(
                '${currentValue.toStringAsFixed(0)} ${isAr ? 'ريال' : 'SAR'}',
                color: _pdfGold,
                bold: true,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _cell(
    String text, {
    bool bold = false,
    PdfColor? color,
  }) =>
      pw.Padding(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color ?? _pdfText,
          ),
          textAlign: pw.TextAlign.center,
        ),
      );

  // ── Summary ───────────────────────────────────────────
  static pw.Widget _buildSummary(
    int count,
    double totalWeight,
    double totalValue,
    bool isAr,
  ) {
    final currency = isAr ? 'ريال' : 'SAR';
    final gram     = isAr ? 'جم'   : 'g';

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _pdfBg,
        border: pw.Border.all(color: _pdfGoldLight, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          _summaryBox(
            isAr ? 'عدد القطع' : 'Items',
            '$count',
          ),
          _divider(),
          _summaryBox(
            isAr ? 'إجمالي الوزن' : 'Total Weight',
            '${totalWeight.toStringAsFixed(1)} $gram',
          ),
          _divider(),
          _summaryBox(
            isAr ? 'القيمة الإجمالية' : 'Total Value',
            '${totalValue.toStringAsFixed(0)} $currency',
            valueColor: _pdfGold,
          ),
        ],
      ),
    );
  }

  static pw.Widget _summaryBox(
    String label,
    String value, {
    PdfColor? valueColor,
  }) =>
      pw.Column(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(color: _pdfMuted, fontSize: 9),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: valueColor ?? _pdfText,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      );

  static pw.Widget _divider() => pw.Container(
        width: 1,
        height: 40,
        color: _pdfBorder,
      );

  // ── Footer ────────────────────────────────────────────
  static pw.Widget _buildFooter(bool isAr) => pw.Center(
        child: pw.Text(
          'Golden App — ${isAr ? 'تطبيق تتبع الذهب وحساب الزكاة' : 'Gold Tracking & Zakat App'}',
          style: pw.TextStyle(color: _pdfMuted, fontSize: 8),
        ),
      );
}
