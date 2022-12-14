// Mocks generated by Mockito 5.3.2 from annotations
// in submission/test/ui/views/tv_watchlist/view/watchlist_tv_view_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:submission/core/constant/network_state.dart' as _i5;
import 'package:submission/domain/entities/tv.dart' as _i4;
import 'package:submission/domain/usecases/get_watchlist_tv.dart' as _i2;
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetWatchlistTv_0 extends _i1.SmartFake
    implements _i2.GetWatchlistTv {
  _FakeGetWatchlistTv_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WatchlistTvProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistTvProvider extends _i1.Mock
    implements _i3.WatchlistTvProvider {
  MockWatchlistTvProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetWatchlistTv get getWatchlist => (super.noSuchMethod(
        Invocation.getter(#getWatchlist),
        returnValue: _FakeGetWatchlistTv_0(
          this,
          Invocation.getter(#getWatchlist),
        ),
      ) as _i2.GetWatchlistTv);
  @override
  String get message => (super.noSuchMethod(
        Invocation.getter(#message),
        returnValue: '',
      ) as String);
  @override
  List<_i4.Tv> get data => (super.noSuchMethod(
        Invocation.getter(#data),
        returnValue: <_i4.Tv>[],
      ) as List<_i4.Tv>);
  @override
  _i5.RequestState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i5.RequestState.initial,
      ) as _i5.RequestState);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<void> loadData() => (super.noSuchMethod(
        Invocation.method(
          #loadData,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
