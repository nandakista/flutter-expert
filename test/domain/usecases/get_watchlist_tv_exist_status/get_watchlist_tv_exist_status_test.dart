import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/get_watchlist_tv_exist_status.dart';

import 'get_watchlist_tv_exist_status_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late GetWatchlistTvExistStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvExistStatus(repository: mockTvRepository);
  });

  test('''Should check Watchlist existing status in database from repository''',
      () async {
    // Arrange
    when(mockTvRepository.hasAddedToWatchlist(1)).thenAnswer(
      (_) async => true,
    );
    // Act
    final result = await usecase(1);
    // Assert
    verify(mockTvRepository.hasAddedToWatchlist(1));
    expect(result, true);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
