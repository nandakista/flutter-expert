import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_now_playing_movies.dart';

import 'get_now_playing_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(repository: mockMovieRepository);
  });

  test('''Should get Now Playing Movie and then 
  return MovieList from the repository''', () async {
    final tMovieList = <Movie>[];
    // Arrange
    when(mockMovieRepository.getNowPlayingMovies()).thenAnswer(
      (_) async => Right(tMovieList),
    );
    // Act
    final result = await usecase();
    // Assert
    verify(mockMovieRepository.getNowPlayingMovies());
    expect(result, Right(tMovieList));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}
