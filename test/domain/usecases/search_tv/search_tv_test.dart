import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/search_tv.dart';

import 'search_tv_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(repository: mockTvRepository);
  });

  test('''Should Search Tv and then 
  return TvList from the repository''', () async {
    const tQuery = 'test';
    final tTvList = <Tv>[];
    // Arrange
    when(mockTvRepository.searchTv(tQuery)).thenAnswer(
      (_) async => Right(tTvList),
    );
    // Act
    final result = await usecase(tQuery);
    // Assert
    verify(mockTvRepository.searchTv(tQuery));
    expect(result, Right(tTvList));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
