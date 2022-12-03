import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/data/models/tv_detail_model.dart';
import 'package:submission/data/models/wrapper/tv_wrapper.dart';
import 'package:submission/data/sources/server/tv_server_source_impl.dart';

import '../../../core/fixture/fixture_reader.dart';
import 'tv_server_source_test.mocks.dart';

@GenerateMocks([IOClient])
void main() {
  const apiKey = '4a8d8611a243a3a3d004b0862d00283e';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvServerSourceImpl source;
  late MockIOClient client;

  setUp(() {
    client = MockIOClient();
    source = TvServerSourceImpl(client: client);
  });

  tearDown(() {
    client.close();
  });

  group('''Get Tv On Air''', () {
    final dummyTvList =
        TvWrapper.fromJson(json.decode(fixture('tv_on_air.json'))).data;

    test('''Should return Tv List when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/on_the_air?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_on_air.json'), 200),
      );
      // Act
      final result = await source.getOnAirTv();
      // Assert
      expect(result, equals(dummyTvList));
    });

    test('''Should throw ServerException when status code is not 200''',
        () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/on_the_air?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Error', 400),
      );
      // Act
      final result = source.getOnAirTv();
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Get Popular Tv''', () {
    final dummyTvList =
        TvWrapper.fromJson(json.decode(fixture('tv_popular.json'))).data;

    test('''Should return Tv List when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/popular?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_popular.json'), 200),
      );
      // Act
      final result = await source.getPopularTv();
      // Assert
      expect(result, equals(dummyTvList));
    });

    test('''Should throw ServerException when status code is not 200''',
        () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/popular?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Error', 400),
      );
      // Act
      final result = source.getPopularTv();
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Get Top Rated Tv''', () {
    final dummyTvList =
        TvWrapper.fromJson(json.decode(fixture('tv_top_rated.json'))).data;

    test('''Should return Tv List when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_top_rated.json'), 200),
      );
      // Act
      final result = await source.getTopRatedTv();
      // Assert
      expect(result, equals(dummyTvList));
    });

    test('''Should throw ServerException when status code is not 200''', () {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Error', 400),
      );
      // Act
      final result = source.getTopRatedTv();
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Search or Get Tv By Id''', () {
    final dummySearchTv =
        TvWrapper.fromJson(json.decode(fixture('tv_search.json'))).data;
    const String query = 'Rick';

    test('''Should return Tv List when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$query'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_search.json'), 200),
      );
      // Act
      final result = await source.searchTv(query);
      // Assert
      expect(result, equals(dummySearchTv));
    });

    test('''Should throw ServerException when status code is not 200''', () {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$query'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      // Act
      final result = source.searchTv(query);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Get Detail Tv''', () {
    const id = 1;
    final dummyDetailTv =
        TvDetailModel.fromJson(json.decode(fixture('tv_detail.json')));

    test('''Should return Tv Entity when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/$id?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_detail.json'), 200),
      );

      // Act
      final result = await source.getTvDetail(id);
      // Assert
      expect(result, equals(dummyDetailTv));
    });

    test('''Should throw ServerException when status code is not 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/$id?api_key=$apiKey'),
        ),
      ).thenAnswer(
            (_) async => http.Response('Internal Server Error', 500),
      );
      // Act
      final result = source.getTvDetail(id);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Get Recommended Tv Series''', () {
    final dummyTvList =
        TvWrapper.fromJson(json.decode(fixture('tv_recommendation.json'))).data;
    const id = 1;

    test('''Should return Tv List when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/$id/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('tv_recommendation.json'), 200),
      );
      // Act
      final result = await source.getRecommendedTv(id);
      // Assert
      expect(result, equals(dummyTvList));
    });

    test('''Should throw ServerException when status code is not 200''',
        () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/tv/$id/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );
      // Act
      final result = source.getRecommendedTv(id);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
