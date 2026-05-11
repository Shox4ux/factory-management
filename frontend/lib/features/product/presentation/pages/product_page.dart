import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_strings.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/core/utils/app_toast.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_bloc.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_event.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_state.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/entities/model_entity.dart';
import 'package:factory_management/features/product/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/product/presentation/bloc/product_event.dart';
import 'package:factory_management/features/product/presentation/bloc/product_state.dart';
import 'package:factory_management/features/product/presentation/widgets/product_form_dialog.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
        BlocProvider(create: (_) => sl<FactoryBloc>()..add(const LoadFactories())),
      ],
      child: const _ProductPageContent(),
    );
  }
}

class _ProductPageContent extends StatefulWidget {
  const _ProductPageContent();

  @override
  State<_ProductPageContent> createState() => _ProductPageContentState();
}

class _ProductPageContentState extends State<_ProductPageContent> {
  String _nameFilter = '';
  int? _factoryFilter;

  List<FactoryEntity> _getFactories(FactoryState state) {
    if (state is FactoryLoaded) return state.factories;
    if (state is FactoryActionSuccess) return state.factories;
    return [];
  }

  void _showForm({ProductEntity? product}) {
    final factories = _getFactories(context.read<FactoryBloc>().state);
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        product: product,
        factories: factories,
        onSubmit: (data) {
          if (product == null) {
            context.read<ProductBloc>().add(CreateProduct(data));
          } else {
            context.read<ProductBloc>().add(UpdateProduct(product.id, data));
          }
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  Future<void> _confirmDelete(ProductEntity product) async {
    final confirmed = await showConfirmDialog(context);
    if (confirmed == true && mounted) {
      context.read<ProductBloc>().add(DeleteProduct(product.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          AppToast.success(context, state.message);
        } else if (state is ProductError) {
          AppToast.error(context, state.message);
        }
      },
      child: PageLayout(
        title: AppStrings.products,
        addLabel: AppStrings.addProductItem,
        onAdd: () => _showForm(),
        filterWidgets: [
          FilterField(
            hint: AppStrings.searchByName,
            onChanged: (v) => setState(() => _nameFilter = v.toLowerCase()),
          ),
          BlocBuilder<FactoryBloc, FactoryState>(
            builder: (context, factState) {
              final factories = _getFactories(factState);
              return FilterDropdown<int>(
                hint: 'Filter by factory',
                icon: Icons.factory_outlined,
                value: _factoryFilter,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('All factories')),
                  ...factories.map((f) => DropdownMenuItem<int?>(value: f.id, child: Text(f.name))),
                ],
                onChanged: (v) => setState(() => _factoryFilter = v),
              );
            },
          ),
        ],
        table: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final all = state is ProductLoaded
                ? state.products
                : (state is ProductActionSuccess ? state.products : <ProductEntity>[]);
            final displayed = all.where((p) {
              final matchesName = _nameFilter.isEmpty || p.name.toLowerCase().contains(_nameFilter);
              final matchesFactory = _factoryFilter == null || p.factoryId == _factoryFilter;
              return matchesName && matchesFactory;
            }).toList();
            return AppTableWrapper(
              columns: const [AppStrings.id, AppStrings.name, AppStrings.models, AppStrings.actions],
              isLoading: state is ProductLoading,
              error: state is ProductError ? state.message : null,
              rows: displayed
                  .map((p) => DataRow(cells: [
                        DataCell(Text('${p.id}',
                            style: TextStyle(fontSize: AppFonts.sm, color: AppThemeColors.of(context).textSecondary))),
                        DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(_ModelChips(models: p.models)),
                        DataCell(actionCell(context,
                            onEdit: () => _showForm(product: p),
                            onDelete: () => _confirmDelete(p))),
                      ]))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class _ModelChips extends StatelessWidget {
  final List<ModelEntity> models;
  const _ModelChips({required this.models});

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    if (models.isEmpty) return Text('—', style: TextStyle(color: c.textHint));
    return Wrap(
      spacing: 4,
      children: models.take(3).map((m) => Chip(
        label: Text(m.name, style: TextStyle(fontSize: AppFonts.xs, color: c.chipText)),
        backgroundColor: c.chipBg,
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      )).toList(),
    );
  }
}
