import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/domain/usecases/get_categories_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/create_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/update_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/delete_category_usecase.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_event.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_state.dart';

class MockGetCategories extends Mock implements GetCategoriesUsecase {}
class MockCreateCategory extends Mock implements CreateCategoryUsecase {}
class MockUpdateCategory extends Mock implements UpdateCategoryUsecase {}
class MockDeleteCategory extends Mock implements DeleteCategoryUsecase {}

const tCategory = CategoryEntity(id: 1, categoryName: 'Electronics');

void main() {
  late MockGetCategories mockGet;
  late MockCreateCategory mockCreate;
  late MockUpdateCategory mockUpdate;
  late MockDeleteCategory mockDelete;

  setUp(() {
    mockGet = MockGetCategories();
    mockCreate = MockCreateCategory();
    mockUpdate = MockUpdateCategory();
    mockDelete = MockDeleteCategory();
  });

  CategoryBloc buildBloc() => CategoryBloc(
        getCategories: mockGet,
        createCategory: mockCreate,
        updateCategory: mockUpdate,
        deleteCategory: mockDelete,
      );

  group('LoadCategories', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => const Right([tCategory]));
        return buildBloc();
      },
      act: (b) => b.add(const LoadCategories()),
      expect: () => [isA<CategoryLoading>(), isA<CategoryLoaded>()],
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc();
      },
      act: (b) => b.add(const LoadCategories()),
      expect: () => [isA<CategoryLoading>(), isA<CategoryError>()],
    );
  });

  group('CreateCategory', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [Loading, ActionSuccess] on success',
      build: () {
        when(() => mockCreate(any())).thenAnswer((_) async => const Right(tCategory));
        when(() => mockGet()).thenAnswer((_) async => const Right([tCategory]));
        return buildBloc();
      },
      act: (b) => b.add(const CreateCategory({'category_name': 'Electronics'})),
      expect: () => [isA<CategoryLoading>(), isA<CategoryActionSuccess>()],
    );
  });

  group('DeleteCategory', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [Loading, ActionSuccess] on success',
      build: () {
        when(() => mockDelete(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGet()).thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (b) => b.add(const DeleteCategory(1)),
      expect: () => [isA<CategoryLoading>(), isA<CategoryActionSuccess>()],
    );
  });
}
