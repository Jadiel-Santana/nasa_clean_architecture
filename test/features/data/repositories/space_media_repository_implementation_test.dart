import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/exceptions.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource.dart';
import 'package:nasa_clean_architecture/features/data/models/space_media_model.dart';
import 'package:nasa_clean_architecture/features/data/repositories/space_media_repository_implementation.dart';

class MockSpaceMediaDatasource extends Mock implements ISpaceMediaDatasource {}

void main() {
  late ISpaceMediaDatasource datasource;
  late SpaceMediaRepositoryImplementation repository;

  setUp(() {
    datasource = MockSpaceMediaDatasource();
    repository = SpaceMediaRepositoryImplementation(datasource);
  });

  final spaceMediaModel = SpaceMediaModel(
    description: 'description',
    mediaType: 'image',
    title: 'title',
    mediaUrl: 'mediaUrl',
  );

  final date = DateTime(2021, 02, 02);

  test('should return SpaceMediaModel when calls the datasource', () async {
    when(() => datasource.getSpaceMediaFromDate(date))
        .thenAnswer((_) async => spaceMediaModel);
    final result = await repository.getSpaceMediaFromDate(date);
    expect(result, Right(spaceMediaModel));
    verify(() => datasource.getSpaceMediaFromDate(date)).called(1);
  });

  test(
      'should return a ServerFailure when the call to datasource is unsuccessfull',
      () async {
    when(() => datasource.getSpaceMediaFromDate(date))
        .thenThrow(ServerException());
    final result = await repository.getSpaceMediaFromDate(date);
    expect(result, Left(ServerFailure()));
    verify(() => datasource.getSpaceMediaFromDate(date)).called(1);
  });
}