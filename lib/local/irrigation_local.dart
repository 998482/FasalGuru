// local/irrigation_entity.dart + irrigation_dao.dart
// Ek hi file me rakha hai, alag kar lena agar tumhara convention alag hai.

import 'package:floor/floor.dart';

@entity
class IrrigationEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String cropName;        // 'wheat' internal key, not 'gehun'
  final String soilTexture;     // 'loam' etc
  final DateTime sowingDate;
  final double previousDeficitMm; // kal ka Dr - yahi persistent state hai
  final DateTime lastUpdated;

  IrrigationEntity({
    this.id,
    required this.cropName,
    required this.soilTexture,
    required this.sowingDate,
    required this.previousDeficitMm,
    required this.lastUpdated,
  });
}

@dao
abstract class IrrigationDao {
  @Query('SELECT * FROM IrrigationEntity ORDER BY lastUpdated DESC LIMIT 1')
  Future<IrrigationEntity?> getLatest();

  @Query('SELECT * FROM IrrigationEntity WHERE cropName = :cropName '
      'AND sowingDate = :sowingDate LIMIT 1')
  Future<IrrigationEntity?> getForCrop(String cropName, DateTime sowingDate);

  @insert
  Future<void> insertEntry(IrrigationEntity entry);

  @update
  Future<void> updateEntry(IrrigationEntity entry);

  @Query('DELETE FROM IrrigationEntity')
  Future<void> clearAll();
}

// weather_database.dart me is DAO/entity ko add karna hoga:
//
// @Database(version: X, entities: [WeatherEntity, CurrentWeatherEntity, IrrigationEntity])
// abstract class AppDatabase extends FloorDatabase {
//   IrrigationDao get irrigationDao;
//   ...
// }
//
// Phir build_runner dubara chalana: flutter pub run build_runner build