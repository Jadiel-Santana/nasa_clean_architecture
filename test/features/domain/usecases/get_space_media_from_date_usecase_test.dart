import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_architecture/features/domain/repositories/space_media_repository.dart';
import 'package:nasa_clean_architecture/features/domain/usecases/get_space_media_from_date_usecase.dart';

import '../../mocks/date_mock.dart';
import '../../mocks/space_media_model_mock.dart';

class MockSpaceMediaRepository extends Mock implements ISpaceMediaRepository {}

void main() {
  late GetSpaceMediaFromDateUsecase usecase;
  late ISpaceMediaRepository repository;

  setUp(() {
    repository = MockSpaceMediaRepository();
    usecase = GetSpaceMediaFromDateUsecase(repository);
  });

  test(
      'should get space media entity from for a given date from the repository',
      () async {
    when(() => repository.getSpaceMediaFromDate(dateMock))
        .thenAnswer((_) async => Right<Failure, SpaceMediaEntity>(spaceMediaModelMock));
    final result = await usecase(dateMock);
    expect(result, Right(spaceMediaModelMock));
    verify(() => repository.getSpaceMediaFromDate(dateMock)).called(1);
  });

  test('should return a ServerFailure when don\'t success', () async {
    when(() => repository.getSpaceMediaFromDate(dateMock)).thenAnswer(
        (_) async => Left<Failure, SpaceMediaEntity>(ServerFailure()));
    final result = await usecase(dateMock);
    expect(result, Left(ServerFailure()));
    verify(() => repository.getSpaceMediaFromDate(dateMock)).called(1);
  });
}