import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/exceptions.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource.dart';
import 'package:nasa_clean_architecture/features/data/repositories/space_media_repository_implementation.dart';
import '../../mocks/date_mock.dart';
import '../../mocks/space_media_model_mock.dart';

class MockSpaceMediaDatasource extends Mock implements ISpaceMediaDatasource {}

void main() {
  late ISpaceMediaDatasource datasource;
  late SpaceMediaRepositoryImplementation repository;

  setUp(() {
    datasource = MockSpaceMediaDatasource();
    repository = SpaceMediaRepositoryImplementation(datasource);
  });


  test('should return SpaceMediaModel when calls the datasource', () async {
    when(() => datasource.getSpaceMediaFromDate(dateMock))
        .thenAnswer((_) async => spaceMediaModelMock);
    final result = await repository.getSpaceMediaFromDate(dateMock);
    expect(result, Right(spaceMediaModelMock));
    verify(() => datasource.getSpaceMediaFromDate(dateMock)).called(1);
  });

  test(
      'should return a ServerFailure when the call to datasource is unsuccessfull',
      () async {
    when(() => datasource.getSpaceMediaFromDate(dateMock))
        .thenThrow(ServerException());
    final result = await repository.getSpaceMediaFromDate(dateMock);
    expect(result, Left(ServerFailure()));
    verify(() => datasource.getSpaceMediaFromDate(dateMock)).called(1);
  });
}