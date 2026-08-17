// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WeatherDao? _weatherDaoInstance;

  IrrigationDao? _irrigationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `weather` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `tempMax` REAL NOT NULL, `tempMin` REAL NOT NULL, `rain` REAL NOT NULL, `precipitation` REAL NOT NULL, `precipitationProbability` INTEGER NOT NULL, `windSpeed` REAL NOT NULL, `et0` REAL NOT NULL, `weatherCode` INTEGER NOT NULL, `syncedAt` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `current_weather` (`id` INTEGER NOT NULL, `temperature` REAL NOT NULL, `humidity` INTEGER NOT NULL, `rain` REAL NOT NULL, `weatherCode` INTEGER NOT NULL, `windSpeed` REAL NOT NULL, `updatedAt` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `IrrigationEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `cropName` TEXT NOT NULL, `soilTexture` TEXT NOT NULL, `sowingDate` INTEGER NOT NULL, `previousDeficitMm` REAL NOT NULL, `lastUpdated` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WeatherDao get weatherDao {
    return _weatherDaoInstance ??= _$WeatherDao(database, changeListener);
  }

  @override
  IrrigationDao get irrigationDao {
    return _irrigationDaoInstance ??= _$IrrigationDao(database, changeListener);
  }
}

class _$WeatherDao extends WeatherDao {
  _$WeatherDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _weatherEntityInsertionAdapter = InsertionAdapter(
            database,
            'weather',
            (WeatherEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'tempMax': item.tempMax,
                  'tempMin': item.tempMin,
                  'rain': item.rain,
                  'precipitation': item.precipitation,
                  'precipitationProbability': item.precipitationProbability,
                  'windSpeed': item.windSpeed,
                  'et0': item.et0,
                  'weatherCode': item.weatherCode,
                  'syncedAt': item.syncedAt
                }),
        _currentWeatherEntityInsertionAdapter = InsertionAdapter(
            database,
            'current_weather',
            (CurrentWeatherEntity item) => <String, Object?>{
                  'id': item.id,
                  'temperature': item.temperature,
                  'humidity': item.humidity,
                  'rain': item.rain,
                  'weatherCode': item.weatherCode,
                  'windSpeed': item.windSpeed,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WeatherEntity> _weatherEntityInsertionAdapter;

  final InsertionAdapter<CurrentWeatherEntity>
      _currentWeatherEntityInsertionAdapter;

  @override
  Future<List<WeatherEntity>> getAllWeather() async {
    return _queryAdapter.queryList('SELECT * FROM weather ORDER BY date ASC',
        mapper: (Map<String, Object?> row) => WeatherEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            tempMax: row['tempMax'] as double,
            tempMin: row['tempMin'] as double,
            rain: row['rain'] as double,
            precipitation: row['precipitation'] as double,
            precipitationProbability: row['precipitationProbability'] as int,
            windSpeed: row['windSpeed'] as double,
            et0: row['et0'] as double,
            weatherCode: row['weatherCode'] as int,
            syncedAt: row['syncedAt'] as String));
  }

  @override
  Future<void> deleteAllWeather() async {
    await _queryAdapter.queryNoReturn('DELETE FROM weather');
  }

  @override
  Future<CurrentWeatherEntity?> getCurrentWeather() async {
    return _queryAdapter.query('SELECT * FROM current_weather WHERE id = 1',
        mapper: (Map<String, Object?> row) => CurrentWeatherEntity(
            id: row['id'] as int,
            temperature: row['temperature'] as double,
            humidity: row['humidity'] as int,
            rain: row['rain'] as double,
            weatherCode: row['weatherCode'] as int,
            windSpeed: row['windSpeed'] as double,
            updatedAt: row['updatedAt'] as String));
  }

  @override
  Future<void> deleteCurrentWeather() async {
    await _queryAdapter.queryNoReturn('DELETE FROM current_weather');
  }

  @override
  Future<WeatherEntity?> getFirstWeather() async {
    return _queryAdapter.query('SELECT * FROM weather LIMIT 1',
        mapper: (Map<String, Object?> row) => WeatherEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            tempMax: row['tempMax'] as double,
            tempMin: row['tempMin'] as double,
            rain: row['rain'] as double,
            precipitation: row['precipitation'] as double,
            precipitationProbability: row['precipitationProbability'] as int,
            windSpeed: row['windSpeed'] as double,
            et0: row['et0'] as double,
            weatherCode: row['weatherCode'] as int,
            syncedAt: row['syncedAt'] as String));
  }

  @override
  Future<void> insertWeather(List<WeatherEntity> weather) async {
    await _weatherEntityInsertionAdapter.insertList(
        weather, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertCurrentWeather(CurrentWeatherEntity weather) async {
    await _currentWeatherEntityInsertionAdapter.insert(
        weather, OnConflictStrategy.replace);
  }
}

class _$IrrigationDao extends IrrigationDao {
  _$IrrigationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _irrigationEntityInsertionAdapter = InsertionAdapter(
            database,
            'IrrigationEntity',
            (IrrigationEntity item) => <String, Object?>{
                  'id': item.id,
                  'cropName': item.cropName,
                  'soilTexture': item.soilTexture,
                  'sowingDate': _dateTimeConverter.encode(item.sowingDate),
                  'previousDeficitMm': item.previousDeficitMm,
                  'lastUpdated': _dateTimeConverter.encode(item.lastUpdated)
                }),
        _irrigationEntityUpdateAdapter = UpdateAdapter(
            database,
            'IrrigationEntity',
            ['id'],
            (IrrigationEntity item) => <String, Object?>{
                  'id': item.id,
                  'cropName': item.cropName,
                  'soilTexture': item.soilTexture,
                  'sowingDate': _dateTimeConverter.encode(item.sowingDate),
                  'previousDeficitMm': item.previousDeficitMm,
                  'lastUpdated': _dateTimeConverter.encode(item.lastUpdated)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<IrrigationEntity> _irrigationEntityInsertionAdapter;

  final UpdateAdapter<IrrigationEntity> _irrigationEntityUpdateAdapter;

  @override
  Future<IrrigationEntity?> getLatest() async {
    return _queryAdapter.query(
        'SELECT * FROM IrrigationEntity ORDER BY lastUpdated DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => IrrigationEntity(
            id: row['id'] as int?,
            cropName: row['cropName'] as String,
            soilTexture: row['soilTexture'] as String,
            sowingDate: _dateTimeConverter.decode(row['sowingDate'] as int),
            previousDeficitMm: row['previousDeficitMm'] as double,
            lastUpdated: _dateTimeConverter.decode(row['lastUpdated'] as int)));
  }

  @override
  Future<IrrigationEntity?> getForCrop(
    String cropName,
    DateTime sowingDate,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM IrrigationEntity WHERE cropName = ?1 AND sowingDate = ?2 LIMIT 1',
        mapper: (Map<String, Object?> row) => IrrigationEntity(id: row['id'] as int?, cropName: row['cropName'] as String, soilTexture: row['soilTexture'] as String, sowingDate: _dateTimeConverter.decode(row['sowingDate'] as int), previousDeficitMm: row['previousDeficitMm'] as double, lastUpdated: _dateTimeConverter.decode(row['lastUpdated'] as int)),
        arguments: [cropName, _dateTimeConverter.encode(sowingDate)]);
  }

  @override
  Future<void> clearAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM IrrigationEntity');
  }

  @override
  Future<void> insertEntry(IrrigationEntity entry) async {
    await _irrigationEntityInsertionAdapter.insert(
        entry, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEntry(IrrigationEntity entry) async {
    await _irrigationEntityUpdateAdapter.update(
        entry, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
