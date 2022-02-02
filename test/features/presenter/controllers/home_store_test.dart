import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/domain/usecases/get_space_media_from_date_usecase.dart';
import 'package:nasa_clean_architecture/features/presenter/controllers/home_store.dart';

import '../../mocks/date_mock.dart';
import '../../mocks/space_media_model_mock.dart';

class MockGetSpaceMediaFromDateUsecase extends Mock implements GetSpaceMediaFromDateUsecase {}

void main() {
  late HomeStore homeStore;
  late GetSpaceMediaFromDateUsecase usecase;

  setUp(() {
    usecase = MockGetSpaceMediaFromDateUsecase();
    homeStore = HomeStore(usecase);
    registerFallbackValue(DateTime(0, 0, 0));
  });

  test('should return a SpaceMedia from the usecase', () async {
    when(() => usecase(any())).thenAnswer((_) async => Right(spaceMediaModelMock));
    homeStore.getSpaceMediaFromDate(dateMock);
    homeStore.observer(
      onState: (state) {
        expect(state, spaceMediaModelMock);
        verify(() => usecase(dateMock)).called(1);
      }
    );
  });

  final failure = ServerFailure();

  test('should return a Failure from the usecase when there is an error', () async {
    when(() => usecase(any())).thenAnswer((_) async => Left(failure));
    homeStore.getSpaceMediaFromDate(dateMock);
    homeStore.observer(
      onError: (e) {
        expect(e, failure);
        verify(() => usecase(dateMock)).called(1);
      },
    );
  });
}