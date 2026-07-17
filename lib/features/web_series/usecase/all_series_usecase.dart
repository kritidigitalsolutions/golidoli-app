import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

class AllSeriesUsecase {
  final SeriesDatasource seriesDatasource;
  AllSeriesUsecase({required this. seriesDatasource});
  Future<SeriesResponse?>call()async{
    return await seriesDatasource.allSeries();
  }
}