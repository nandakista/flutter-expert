import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/data/models/movie_detail_model.dart';

import 'package:submission/data/models/wrapper/movie_wrapper.dart';

import '../../../core/error/exception.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import 'movie_server_source.dart';

class MovieServerSourceImpl extends MovieServerSource {
  final IOClient client;

  MovieServerSourceImpl({required this.client});

  @override
  Future<MovieDetail> getMovieDetail(int id) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/movie/$id?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> getRecommendedMovies(int id) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/movie/$id/recommendations?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return MovieWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/movie/now_playing?api_key=${Constant.apiKey}',
      ),
    );
    if (response.statusCode == 200) {
      return MovieWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/movie/popular?api_key=${Constant.apiKey}',
      ),
    );
    if (response.statusCode == 200) {
      return MovieWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/movie/top_rated?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return MovieWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/search/movie?api_key=${Constant.apiKey}&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      return MovieWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }
}
