import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

class SeriesDetailUsecase {
  final SeriesDatasource seriesDatasource;
  SeriesDetailUsecase({required this.seriesDatasource});
  Future<Series?>call({required String id})async{
    return await seriesDatasource.seriesDetail(id: id);
  }
}