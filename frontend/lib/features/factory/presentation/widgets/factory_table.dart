import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_strings.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';

class FactoryTable extends StatelessWidget {
  final List<FactoryEntity> factories;
  final bool isLoading;
  final String? error;
  final void Function(FactoryEntity) onEdit;
  final void Function(FactoryEntity) onDelete;

  const FactoryTable({
    super.key,
    required this.factories,
    required this.onEdit,
    required this.onDelete,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return AppTableWrapper(
      columns: const [
        AppStrings.id,
        AppStrings.name,
        AppStrings.categoryHeader,
        AppStrings.phoneHeader,
        AppStrings.wechatHeader,
        AppStrings.addressHeader,
        AppStrings.productsHeader,
        AppStrings.actions,
      ],
      isLoading: isLoading,
      error: error,
      rows: factories.map((f) => DataRow(cells: [
        DataCell(Text('${f.id}', style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary))),
        DataCell(Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(f.factoryCategory?.categoryName ?? '—', style: const TextStyle(fontSize: AppFonts.base))),
        DataCell(Text(f.phone ?? '—', style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary))),
        DataCell(Text(f.wechatId ?? '—', style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary))),
        DataCell(Text(f.address ?? '—', style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary))),
        DataCell(
          Wrap(
            spacing: 4,
            children: f.products
                .take(3)
                .map((p) => Chip(
                      label: Text(p.name, style: TextStyle(fontSize: AppFonts.xs, color: c.chipText)),
                      backgroundColor: c.chipBg,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList()
              ..addAll(f.products.length > 3
                  ? [Chip(
                      label: Text('+${f.products.length - 3}', style: TextStyle(fontSize: AppFonts.xs, color: c.textSecondary)),
                      backgroundColor: c.tableHeader,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )]
                  : []),
          ),
        ),
        DataCell(actionCell(context, onEdit: () => onEdit(f), onDelete: () => onDelete(f))),
      ])).toList(),
    );
  }
}
