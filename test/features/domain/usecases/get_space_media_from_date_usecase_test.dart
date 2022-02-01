import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_architecture/features/domain/repositories/space_media_repository.dart';
import 'package:nasa_clean_architecture/features/domain/usecases/get_space_media_from_date_usecase.dart';

class MockSpaceMediaRepository extends Mock implements ISpaceMediaRepository {}

void main() {
  late GetSpaceMediaFromDateUsecase usecase;
  late ISpaceMediaRepository repository;

  setUp(() {
    repository = MockSpaceMediaRepository();
    usecase = GetSpaceMediaFromDateUsecase(repository);
  });

  final spaceMedia = SpaceMediaEntity(
    description: 'description',
    mediaType: 'image',
    title: 'title',
    mediaUrl: 'mediaUrl',
  );

  final date = DateTime(2021, 02, 02);

  test(
      'should get space media entity from for a given date from the repository',
      () async {
    when(() => repository.getSpaceMediaFromDate(date))
        .thenAnswer((_) async => Right<Failure, SpaceMediaEntity>(spaceMedia));
    final result = await usecase(date);
    expect(result, Right(spaceMedia));
    verify(() => repository.getSpaceMediaFromDate(date)).called(1);
  });

  test('should return a ServerFailure when don\'t success', () async {
    when(() => repository.getSpaceMediaFromDate(date)).thenAnswer(
        (_) async => Left<Failure, SpaceMediaEntity>(ServerFailure()));
    final result = await usecase(date);
    expect(result, Left(ServerFailure()));
    verify(() => repository.getSpaceMediaFromDate(date)).called(1);
  });
}