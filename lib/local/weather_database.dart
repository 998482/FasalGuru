import 'dart:async';

import 'package:fasalguru/local/irrigation_local.dart';
import 'package:fasalguru/ui/home/widgets/datePicker/date_time_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'current_weather_entity.dart';
import 'weather_dao.dart';
import 'weather_entity.dart';

part 'weather_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(
  version: 2,
  entities: [
    WeatherEntity,
    CurrentWeatherEntity,
    IrrigationEntity,
  ],
)

abstract class AppDatabase extends FloorDatabase {
  WeatherDao get weatherDao;
    IrrigationDao get irrigationDao;
}