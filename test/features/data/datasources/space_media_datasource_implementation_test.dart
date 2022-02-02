import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_architecture/core/errors/exceptions.dart';
import 'package:nasa_clean_architecture/core/http_client/http_client.dart';
import 'package:nasa_clean_architecture/core/utils/converters/date_to_string_converter.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource.dart';
import 'package:nasa_clean_architecture/features/data/datasources/space_media_datasource_implementation.dart';

import '../../mocks/date_mock.dart';
import '../../mocks/space_media_mock.dart';
import '../../mocks/space_media_model_mock.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late ISpaceMediaDatasource datasource;
  late HttpClient client;
  late DateToStringConverter converter;

  setUp(() {
    client = HttpClientMock();
    converter = DateToStringConverter();
    datasource = SpaceMediaDatasouceImplementation(
      client: client,
      converter: converter,
    );
  });

  final urlExpected =
      'https://api.nasa.gov/planetary/apod?hd=true&api_key=DEMO_KEY&date=2021-02-02';

  void successMock() {
    when(() => client.get(any())).thenAnswer(
      (_) async => HttpResponse(
        data: spaceMediaMock,
        statusCode: 200,
      ),
    );
  }

  test('should call the get method with correct url', () async {
    successMock();
    await datasource.getSpaceMediaFromDate(dateMock);
    verify(() => client.get(urlExpected)).called(1);
  });

  test('should return a SpaceMediaModel when is successful', () async {
    successMock();
    final result = await datasource.getSpaceMediaFromDate(dateMock);
    expect(result, spaceMediaModelMock);
  });

  test('should throw a ServerException when the call is unsuccessful', () {
    when(() => client.get(any())).thenAnswer(
      (_) async => HttpResponse(
        data: 'something went wrong',
        statusCode: 400,
      ),
    );
    final result = datasource.getSpaceMediaFromDate(dateMock);
    expect(() => result, throwsA(ServerException()));
  });
}