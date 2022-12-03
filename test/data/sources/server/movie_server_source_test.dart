import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/data/models/movie_detail_model.dart';
import 'package:submission/data/models/wrapper/movie_wrapper.dart';
import 'package:submission/data/sources/server/movie_server_source_impl.dart';

import '../../../core/fixture/fixture_reader.dart';
import 'movie_server_source_test.mocks.dart';

@GenerateMocks([IOClient])
void main() {
  const apiKey = '4a8d8611a243a3a3d004b0862d00283e';
  const baseUrl = 'https://api.themoviedb.org/3';

  late MovieServerSourceImpl source;
  late MockIOClient client;

  setUp(() {
    client = MockIOClient();
    source = MovieServerSourceImpl(client: client);
  });

  tearDown(() {
    client.close();
  });

  group('''Should perform GET Now Playing Movies from Server''', () {
    final dummyMovieList =
        MovieWrapper.fromJson(json.decode(fixture('now_playing.json'))).data;

    test(
      '''Should perform GET List Playing Movies from Server, 
    then return list of Movie when status code 200 and error is empty''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('now_playing.json'), 200),
        );
        // Act
        final result = await source.getNowPlayingMovies();
        // Assert
        expect(result, equals(dummyMovieList));
      },
    );

    test(
      '''Should perform GET List Playing Movies from Server, 
    then throw ServerException when status code is not 200''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response('Error', 400),
        );
        // Act
        final result = source.getNowPlayingMovies();
        // Assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  group('''Should perform GET Popular Movies from Server''', () {
    final dummyPopularMovie =
        MovieWrapper.fromJson(json.decode(fixture('popular.json'))).data;

    test(
      '''Should perform GET List Popular Movies from Server, 
    then return list of Movie when status code 200''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('popular.json'), 200),
        );
        // Act
        final result = await source.getPopularMovies();
        // Assert
        expect(result, equals(dummyPopularMovie));
      },
    );

    test(
      '''Should perform GET List Playing Movies from Server, 
    then throw ServerException when status code is not 200''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response('Error', 400),
        );
        // Act
        final result = source.getPopularMovies();
        // Assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  group('''Should perform GET Top Rated Movies from Server''', () {
    final dummyTopRatedMovie =
        MovieWrapper.fromJson(json.decode(fixture('top_rated.json'))).data;

    test(
      '''Should perform GET List Top Rated Movies from Server, 
    then return list of Movie when status code 200''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('top_rated.json'), 200),
        );
        // Act
        final result = await source.getTopRatedMovies();
        // Assert
        expect(result, equals(dummyTopRatedMovie));
      },
    );

    test(
      '''Should perform GET List Top Rated Movies from Server, 
    then throw ServerException when status code is not 200''',
      () async {
        // Arrange
        when(
          client.get(
            Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response('Error', 400),
        );
        // Act
        final result = source.getTopRatedMovies();
        // Assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  group('''Should perform GET Method for Search Movie with''', () {
    final dummySearch =
        MovieWrapper.fromJson(json.decode(fixture('search.json'))).data;
    const String query = 'test';

    test('''Should perform Search Movie with query,
    then return Movie List with status code 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('search.json'), 200),
      );
      // Act
      final result = await source.searchMovies(query);
      // Assert
      expect(result, equals(dummySearch));
    });

    test('''Should perform Search Movie 
    then throw ServerException when status code not equal 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      // Act
      final result = source.searchMovies(query);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Should perform GET Detail Movie''', () {
    const id = 1;
    final dummyDetailMovie =
        MovieDetailModel.fromJson(json.decode(fixture('detail.json')));

    test('''Should perform GET Detail Movie, 
        then return Movie when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/movie/$id?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('detail.json'), 200),
      );

      // Act
      final result = await source.getMovieDetail(id);
      // Assert
      expect(result, equals(dummyDetailMovie));
    });

    test('''Should throw ServerException 
    when status code is not equal 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/movie/$id?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );
      // Act
      final result = source.getMovieDetail(id);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('''Should perform GET Recommended Movie''', () {
    final dummyMovieList =
        MovieWrapper.fromJson(json.decode(fixture('recommendation.json'))).data;
    const id = 1;

    test('''Should perform GET Recommended Movie, 
        then return List of Movie when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/movie/$id/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(fixture('recommendation.json'), 200),
      );
      // Act
      final result = await source.getRecommendedMovies(id);
      // Assert
      expect(result, equals(dummyMovieList));
    });

    test('''Should perform GET Recommended Movie, 
        then return List of Movie when status code is 200''', () async {
      // Arrange
      when(
        client.get(
          Uri.parse('$baseUrl/movie/$id/recommendations?api_key=$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );
      // Act
      final result = source.getRecommendedMovies(id);
      // Assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
