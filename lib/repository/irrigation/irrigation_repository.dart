// repository/irrigation/irrigation_repository.dart

import 'package:fasalguru/local/irrigation_local.dart';
import 'package:fasalguru/local/weather_entity.dart';
import 'package:fasalguru/model/irrigationmodel/irrigation_result_model.dart';
import 'package:fasalguru/repository/weather/weather_repository.dart';
import 'package:fasalguru/services/irrigationLOgic/irrigation_engine_service.dart';

class IrrigationRepository {
  final IrrigationDao irrigationDao;
  final WeatherRepository weatherRepository;
  final IrrigationEngineService _engine = IrrigationEngineService();

  IrrigationRepository({
    required this.irrigationDao,
    required this.weatherRepository,
  });

  Future<IrrigationResultModel> getRecommendation({
    required String cropDropdownValue,
    
    required String soilCardValue,
    required DateTime sowingDate,
  }) async {

    // 1. Offline weather from Floor
    final List<WeatherEntity> weatherList =
        await weatherRepository.getOfflineWeather();

    if (weatherList.isEmpty) {
      throw Exception("Offline weather data not available.");
    }

    // Today's weather
    final WeatherEntity todayWeather = weatherList.first;

    final double et0 = todayWeather.et0;
    final double rainfallMm = todayWeather.rain;

    // 2. Crop key
    final String cropKey =
        IrrigationEngineService.cropNameMap[
            cropDropdownValue.toLowerCase()]!;

    // 3. Previous deficit
    final existing = await irrigationDao.getForCrop(
      cropKey,
      sowingDate,
    );

    final double previousDeficit =
        existing?.previousDeficitMm ?? 0.0;

    // 4. Calculate irrigation
    final IrrigationResultModel result =
        _engine.getDailyRecommendation(
      cropDropdownValue: cropDropdownValue,
      soilCardValue: soilCardValue,
      sowingDate: sowingDate,
      et0: et0,
      rainfallMm: rainfallMm,
      previousDeficitMm: previousDeficit,
    );

    // 5. Save today's deficit
    final IrrigationEntity entity = IrrigationEntity(
      id: existing?.id,
      cropName: cropKey,
      soilTexture: IrrigationEngineService
          .soilCardMap[soilCardValue.toLowerCase()]!,
      sowingDate: sowingDate,
      previousDeficitMm: result.depletionMm,
      lastUpdated: DateTime.now(),
    );

    if (existing == null) {
      await irrigationDao.insertEntry(entity);
    } else {
      await irrigationDao.updateEntry(entity);
    }

    return result;
  }
}