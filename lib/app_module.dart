import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_clean_architecture/core/http_client/http_implementation.dart';
import 'package:nasa_clean_architecture/core/utils/converters/date_to_string_converter.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource_implementation.dart';
import 'package:nasa_clean_architecture/features/data/repositories/space_media_repository_implementation.dart';
import 'package:nasa_clean_architecture/features/domain/usecases/get_space_media_from_date_usecase.dart';
import 'package:nasa_clean_architecture/features/presenter/controllers/home_store.dart';
import 'package:nasa_clean_architecture/features/presenter/pages/home_page.dart';
import 'package:nasa_clean_architecture/features/presenter/pages/picture_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeStore(i())),
    Bind((i) => GetSpaceMediaFromDateUsecase(i())),
    Bind((i) => SpaceMediaRepositoryImplementation(i())),
    Bind((i) => SpaceMediaDatasouceImplementation(client: i(), converter: i())),
    Bind((i) => HttpImplementation()),
    Bind((i) => DateToStringConverter()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => HomePage()),
    ChildRoute('/picture', child: (_, __) => PicturePage()),
  ];
}
