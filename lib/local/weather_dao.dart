import 'package:fasalguru/local/current_weather_entity.dart';
import 'package:fasalguru/local/weather_entity.dart';
import 'package:floor/floor.dart';



@dao
abstract class WeatherDao {

  // =========================
  // Daily Weather
  // =========================

  @Query('SELECT * FROM weather ORDER BY date ASC')
  Future<List<WeatherEntity>> getAllWeather();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWeather(List<WeatherEntity> weather);

  @Query('DELETE FROM weather')
  Future<void> deleteAllWeather();


  // =========================
  // Current Weather
  // =========================

  @Query('SELECT * FROM current_weather WHERE id = 1')
  Future<CurrentWeatherEntity?> getCurrentWeather();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCurrentWeather(CurrentWeatherEntity weather);

  @Query('DELETE FROM current_weather')
  Future<void> deleteCurrentWeather();
  @Query("SELECT * FROM weather LIMIT 1")
Future<WeatherEntity?> getFirstWeather();
}