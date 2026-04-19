import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_ar.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.initial});

  /// When set, the screen edits this transaction (same [Transaction.id] on save).
  final Transaction? initial;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  late String _category;
  DateTime _date = DateTime.now();

  static final _dateFormat = DateFormat.yMMMd('ar');

  bool get _isEditing => widget.initial != null;

  String _formatAmountForField(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2).replaceAll('.', ',');
  }

  List<String> _categoryOptions() {
    final base = List<String>.from(CategoryCatalog.forType(_type));
    final i = widget.initial;
    if (i != null && i.type == _type && !base.contains(i.category)) {
      base.insert(0, i.category);
    }
    return base;
  }

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      _type = i.type;
      _category = i.category;
      _titleController.text = i.title;
      _amountController.text = _formatAmountForField(i.amount);
      _date = DateTime(i.date.year, i.date.month, i.date.day);
    } else {
      _category = CategoryCatalog.forType(_type).first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    final options = CategoryCatalog.forType(type);
    setState(() {
      _type = type;
      _category = options.contains(_category) ? _category : options.first;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(
      _amountController.text.replaceAll(',', '.').trim(),
    );
    if (amount == null || amount <= 0) return;

    final transaction = Transaction(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      amount: amount,
      category: _category,
      type: _type,
      date: _date,
    );

    if (!mounted) return;
    final provider = context.read<TransactionProvider>();
    if (_isEditing) {
      await provider.update(transaction);
    } else {
      await provider.add(transaction);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final categories = _categoryOptions();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? AppAr.editTransaction : AppAr.addTransaction),
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
                _isEditing ? AppAr.editScreenSubtitle : AppAr.addScreenSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              Material(
                color: scheme.surfaceContainerLowest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.45),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SegmentedButton<TransactionType>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment<TransactionType>(
                        value: TransactionType.income,
                        label: const Text(AppAr.incomeType),
                        icon: const Icon(Icons.trending_up_rounded, size: 20),
                      ),
                      ButtonSegment<TransactionType>(
                        value: TransactionType.expense,
                        label: const Text(AppAr.expenseType),
                        icon: const Icon(Icons.trending_down_rounded, size: 20),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      if (selection.isNotEmpty) {
                        _onTypeChanged(selection.first);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: scheme.surfaceContainerLowest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.45),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 22,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppAr.detailsSection,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: AppAr.titleOptional,
                          hintText: AppAr.titleHint,
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
                          decoration: const InputDecoration(
                            labelText: AppAr.amount,
                            hintText: AppAr.amountHint,
                            suffixText: r' $',
                          ),
                          validator: (value) {
                            final raw =
                                value?.replaceAll(',', '.').trim() ?? '';
                            if (raw.isEmpty) return AppAr.enterAmount;
                            final n = double.tryParse(raw);
                            if (n == null || n <= 0) {
                              return AppAr.enterValidAmount;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: AppAr.category,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _category,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              for (final c in categories)
                                DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _category = v);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.event_rounded,
                          color: scheme.primary,
                        ),
                        title: const Text(AppAr.date),
                        subtitle: Text(
                          _dateFormat.format(_date),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton.filledTonal(
                          onPressed: _pickDate,
                          tooltip: AppAr.pickDateTooltip,
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  _isEditing ? AppAr.updateTransaction : AppAr.saveTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
