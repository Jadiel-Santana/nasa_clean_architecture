import 'dart:convert';

import 'package:nasa_clean_architecture/core/errors/exceptions.dart';
import 'package:nasa_clean_architecture/core/http_client/http_client.dart';
import 'package:nasa_clean_architecture/core/utils/converters/date_to_string_converter.dart';
import 'package:nasa_clean_architecture/core/utils/keys/nasa_api_keys.dart';
import 'package:nasa_clean_architecture/features/data/datasources/nasa_endpoints.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource.dart';
import 'package:nasa_clean_architecture/features/data/models/space_media_model.dart';

class SpaceMediaDatasouceImplementation implements ISpaceMediaDatasource {
  final HttpClient client;
  final DateToStringConverter converter;

  SpaceMediaDatasouceImplementation({
    required this.client,
    required this.converter,
  });

  @override
  Future<SpaceMediaModel> getSpaceMediaFromDate(DateTime date) async {
    final response = await client.get(
      NasaEndpoints.apod(
        NasaApiKeys.apiKey,
        converter.converter(date),
      ),
    );
    if (response.statusCode == 200) {
      return SpaceMediaModel.fromJson(jsonDecode(response.data));
    } else {
      throw ServerException();
    }
  }
}
