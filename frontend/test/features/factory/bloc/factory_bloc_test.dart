import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/domain/usecases/get_factories_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/create_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/update_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/delete_factory_usecase.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_bloc.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_event.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_state.dart';

class MockGetFactories extends Mock implements GetFactoriesUsecase {}
class MockCreateFactory extends Mock implements CreateFactoryUsecase {}
class MockUpdateFactory extends Mock implements UpdateFactoryUsecase {}
class MockDeleteFactory extends Mock implements DeleteFactoryUsecase {}

const tFactory = FactoryEntity(id: 1, name: 'Test Factory', factoryCategoryId: 1);

void main() {
  late MockGetFactories mockGet;
  late MockCreateFactory mockCreate;
  late MockUpdateFactory mockUpdate;
  late MockDeleteFactory mockDelete;

  setUp(() {
    mockGet = MockGetFactories();
    mockCreate = MockCreateFactory();
    mockUpdate = MockUpdateFactory();
    mockDelete = MockDeleteFactory();
  });

  FactoryBloc buildBloc() => FactoryBloc(
        getFactories: mockGet,
        createFactory: mockCreate,
        updateFactory: mockUpdate,
        deleteFactory: mockDelete,
      );

  group('LoadFactories', () {
    blocTest<FactoryBloc, FactoryState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGet(name: any(named: 'name'), productName: any(named: 'productName'), category: any(named: 'category')))
            .thenAnswer((_) async => const Right([tFactory]));
        return buildBloc();
      },
      act: (b) => b.add(const LoadFactories()),
      expect: () => [isA<FactoryLoading>(), isA<FactoryLoaded>()],
    );

    blocTest<FactoryBloc, FactoryState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGet(name: any(named: 'name'), productName: any(named: 'productName'), category: any(named: 'category')))
            .thenAnswer((_) async => const Left(ServerFailure('fail')));
        return buildBloc();
      },
      act: (b) => b.add(const LoadFactories()),
      expect: () => [isA<FactoryLoading>(), isA<FactoryError>()],
    );
  });

  group('DeleteFactory', () {
    blocTest<FactoryBloc, FactoryState>(
      'emits [Loading, ActionSuccess] on success',
      build: () {
        when(() => mockDelete(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGet(name: any(named: 'name'), productName: any(named: 'productName'), category: any(named: 'category')))
            .thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (b) => b.add(const DeleteFactory(1)),
      expect: () => [isA<FactoryLoading>(), isA<FactoryActionSuccess>()],
    );
  });
}
