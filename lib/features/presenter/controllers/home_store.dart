import 'package:flutter_triple/flutter_triple.dart';
import 'package:nasa_clean_architecture/core/errors/failures.dart';
import 'package:nasa_clean_architecture/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_architecture/features/domain/usecases/get_space_media_from_date_usecase.dart';

class HomeStore extends NotifierStore<Failure, SpaceMediaEntity> {
  final GetSpaceMediaFromDateUsecase _usecase;

  HomeStore(this._usecase)
      : super(
          SpaceMediaEntity(
            description: '',
            mediaType: '',
            title: '',
            mediaUrl: null,
          ),
        );

  getSpaceMediaFromDate(DateTime? date) async {
    setLoading(true);
    final result = await _usecase(date);
    result.fold((l) => setError(l), (r) => update(r));
    setLoading(false);
  }
}