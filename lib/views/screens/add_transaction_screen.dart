import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/transaction_controller.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';
import '../../models/transaction_type.dart';

// =============================================================================
// Module: Add Transaction Screen (MVC — View)
// Responsabilité: Formulaire validé — création / édition (CRUD)
// =============================================================================

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.initial});

  final Transaction? initial;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  late String _categoryKey;
  DateTime _date = DateTime.now();
  bool _saving = false;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      _type = i.type;
      _categoryKey = i.categoryKey;
      _titleController.text = i.title;
      _amountController.text = _formatAmount(i.amount);
      _date = DateTime(i.date.year, i.date.month, i.date.day);
    } else {
      _categoryKey = CategoryCatalog.keysForType(_type).first;
    }
  }

  String _formatAmount(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }

  List<String> _categoryOptions() {
    final base = List<String>.from(CategoryCatalog.keysForType(_type));
    final i = widget.initial;
    if (i != null && i.type == _type && !base.contains(i.categoryKey)) {
      base.insert(0, i.categoryKey);
    }
    return base;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(Locale locale) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: locale,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(
      _amountController.text.replaceAll(',', '.').trim(),
    );
    if (amount == null || amount <= 0) return;

    setState(() => _saving = true);

    final transaction = Transaction(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      amount: amount,
      categoryKey: _categoryKey,
      type: _type,
      date: _date,
    );

    final tx = context.read<TransactionController>();
    try {
      if (_isEditing) {
        await tx.update(transaction);
      } else {
        await tx.add(transaction);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorGeneric),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final categories = _categoryOptions();
    final dateFmt = AppFormatters.fullDate(l10n.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.editTransaction : l10n.addTransaction,
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primary.withValues(alpha: 0.06),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Text(
                _isEditing ? l10n.editScreenSubtitle : l10n.addScreenSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<TransactionType>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text(l10n.incomeType),
                    icon: const Icon(Icons.trending_up_rounded, size: 20),
                  ),
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text(l10n.expenseType),
                    icon: const Icon(Icons.trending_down_rounded, size: 20),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (s) {
                  if (s.isEmpty) return;
                  final type = s.first;
                  final keys = CategoryCatalog.keysForType(type);
                  setState(() {
                    _type = type;
                    _categoryKey = keys.contains(_categoryKey)
                        ? _categoryKey
                        : keys.first;
                  });
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.titleOptional,
                  hintText: l10n.titleHint,
                ),
              ),
              const SizedBox(height: 14),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    hintText: l10n.amountHint,
                  ),
                  validator: (value) {
                    final raw = value?.replaceAll(',', '.').trim() ?? '';
                    if (raw.isEmpty) return l10n.enterAmount;
                    final n = double.tryParse(raw);
                    if (n == null || n <= 0) return l10n.enterValidAmount;
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 14),
              InputDecorator(
                decoration: InputDecoration(labelText: l10n.category),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _categoryKey,
                    items: [
                      for (final k in categories)
                        DropdownMenuItem(
                          value: k,
                          child: Text(l10n.categoryLabel(k)),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _categoryKey = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.event_rounded, color: scheme.primary),
                title: Text(l10n.date),
                subtitle: Text(
                  dateFmt.format(_date),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton.filledTonal(
                  onPressed: () => _pickDate(locale),
                  tooltip: l10n.pickDateTooltip,
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  _isEditing
                      ? l10n.updateTransaction
                      : l10n.saveTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
