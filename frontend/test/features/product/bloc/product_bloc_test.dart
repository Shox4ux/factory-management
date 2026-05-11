import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/usecases/get_products_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/create_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/update_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:factory_management/features/product/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/product/presentation/bloc/product_event.dart';
import 'package:factory_management/features/product/presentation/bloc/product_state.dart';

class MockGetProducts extends Mock implements GetProductsUsecase {}
class MockCreateProduct extends Mock implements CreateProductUsecase {}
class MockUpdateProduct extends Mock implements UpdateProductUsecase {}
class MockDeleteProduct extends Mock implements DeleteProductUsecase {}

const tProduct = ProductEntity(id: 1, name: 'Widget', factoryId: 1);

void main() {
  late MockGetProducts mockGet;
  late MockCreateProduct mockCreate;
  late MockUpdateProduct mockUpdate;
  late MockDeleteProduct mockDelete;

  setUp(() {
    mockGet = MockGetProducts();
    mockCreate = MockCreateProduct();
    mockUpdate = MockUpdateProduct();
    mockDelete = MockDeleteProduct();
  });

  ProductBloc buildBloc() => ProductBloc(
        getProducts: mockGet,
        createProduct: mockCreate,
        updateProduct: mockUpdate,
        deleteProduct: mockDelete,
      );

  group('LoadProducts', () {
    blocTest<ProductBloc, ProductState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => const Right([tProduct]));
        return buildBloc();
      },
      act: (b) => b.add(const LoadProducts()),
      expect: () => [isA<ProductLoading>(), isA<ProductLoaded>()],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => const Left(ServerFailure('fail')));
        return buildBloc();
      },
      act: (b) => b.add(const LoadProducts()),
      expect: () => [isA<ProductLoading>(), isA<ProductError>()],
    );
  });
}
