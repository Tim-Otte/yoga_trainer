import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoga_trainer/entities/all.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BodyParts, Poses, Workouts, WorkoutPoses])
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

  /// Returns a stream of all workouts from the database.
  ///
  /// The stream emits a list of [Workout] objects whenever the data changes.
  /// Useful for listening to real-time updates of workouts.
  Stream<List<Workout>> getAllWorkouts() {
    return select(workouts).watch();
  }

  /// Returns a stream of all poses from the database.
  ///
  /// The stream emits a list of [Pose] objects whenever the data changes.
  /// Useful for listening to real-time updates of poses.
  Stream<List<PoseWithBodyPart>> getAllPoses() {
    return (select(poses).join([
      innerJoin(bodyParts, bodyParts.id.equalsExp(poses.affectedBodyPart)),
    ])..orderBy([OrderingTerm.asc(poses.name)])).watch().map(
      (rows) => rows
          .map(
            (row) => PoseWithBodyPart(
              pose: row.readTable(poses),
              bodyPart: row.readTable(bodyParts),
            ),
          )
          .toList(),
    );
  }

  /// Checks if a pose with the given [name] exists in the database.
  ///
  /// Returns `true` if a pose with the specified name is found, otherwise `false`.
  /// This is an asynchronous operation.
  Future<bool> hasPoseWithName(String name) async {
    return (await (select(
          poses,
        )..where((p) => p.name.like(name))).getSingleOrNull()) !=
        null;
  }

  /// Inserts a new pose into the database.
  ///
  /// Returns a [Future] that completes when the pose has been inserted.
  Future insertPose(
    String name,
    String description,
    int duration,
    Difficulty difficulty,
    BodyPart affectedBodyPart,
  ) async {
    await into(poses).insert(
      PosesCompanion.insert(
        name: name,
        description: description,
        duration: duration,
        difficulty: difficulty,
        affectedBodyPart: affectedBodyPart.id,
      ),
    );
  }

  /// Returns a stream of all [BodyPart] objects from the database.
  ///
  /// This stream emits a list of body parts whenever the underlying data changes,
  /// allowing the UI to reactively update as the database is modified.
  Stream<List<BodyPart>> getAllBodyParts() {
    return (select(
      bodyParts,
    )..orderBy([(bp) => OrderingTerm.asc(bp.name)])).watch();
  }

  /// Checks if a body part with the given [name] exists in the database.
  ///
  /// Returns `true` if the body part exists, otherwise returns `false`.
  Future<bool> hasBodyPart(String name) async {
    return (await (select(
          bodyParts,
        )..where((bp) => bp.name.like(name))).getSingleOrNull()) !=
        null;
  }

  /// Inserts a new body part with the given [name] into the database.
  ///
  /// Returns a [Future] that completes when the insertion is finished.
  Future insertBodyPart(String name) async {
    await into(bodyParts).insert(BodyPartsCompanion.insert(name: name));
  }
}
