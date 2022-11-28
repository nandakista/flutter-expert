import 'dart:convert';

import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/data/models/tv_detail_model.dart';
import 'package:submission/data/models/wrapper/tv_wrapper.dart';
import 'package:submission/data/sources/server/tv_server_source.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:http/http.dart' as http;

class TvServerSourceImpl extends TvServerSource {
  final http.Client client;

  TvServerSourceImpl({required this.client});

  @override
  Future<List<Tv>> getOnAirTv() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/tv/on_the_air?api_key=${Constant.apiKey}',
      ),
    );
    if (response.statusCode == 200) {
      return TvWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Tv>> getPopularTv() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/tv/popular?api_key=${Constant.apiKey}',
      ),
    );
    if (response.statusCode == 200) {
      return TvWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Tv>> getRecommendedTv(int id) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/tv/$id/recommendations?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return TvWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Tv>> getTopRatedTv() async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/tv/top_rated?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return TvWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetail> getTvDetail(int id) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/tv/$id?api_key=${Constant.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Tv>> searchTv(String query) async {
    final response = await client.get(
      Uri.parse(
        '${Constant.baseUrl}/search/tv?api_key=${Constant.apiKey}&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      return TvWrapper.fromJson(json.decode(response.body)).data;
    } else {
      throw ServerException();
    }
  }
}
