import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/get_watchlist_exist_status.dart';

import 'get_watchlist_exist_status_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetWatchlistExistStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistExistStatus(repository: mockMovieRepository);
  });

  test('''Should check Watchlist existing status in database from repository''',
      () async {
    // Arrange
    when(mockMovieRepository.hasAddedToWatchlist(1)).thenAnswer(
      (_) async => true,
    );
    // Act
    final result = await usecase(1);
    // Assert
    verify(mockMovieRepository.hasAddedToWatchlist(1));
    expect(result, true);
    verifyNoMoreInteractions(mockMovieRepository);
  });
}
