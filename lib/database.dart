import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoga_trainer/entities/all.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Workouts, Poses, WorkoutPoses])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  Stream<List<Workout>> getAllWorkouts() {
    return select(workouts).watch();
  }

  Stream<List<Pose>> getAllPoses() {
    return select(poses).watch();
  }

  Future<bool> hasPoseWithName(String name) async {
    return (await (select(
          poses,
        )..where((p) => p.name.like(name))).getSingleOrNull()) !=
        null;
  }
}
