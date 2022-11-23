import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/search_movie.dart';

import '../search_movie/search_movie_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late SearchMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovie(repository: mockMovieRepository);
  });

  test('''Should get MovieList from the repository''', () async {
    const tQuery = 'test';
    final tMovieList = <Movie>[];
    // Arrange
    when(mockMovieRepository.searchMovies(tQuery)).thenAnswer(
      (_) async => Right(tMovieList),
    );
    // Act
    final result = await usecase(tQuery);
    // Assert
    verify(mockMovieRepository.searchMovies(tQuery));
    expect(result, Right(tMovieList));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}
