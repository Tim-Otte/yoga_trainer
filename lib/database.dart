import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/iterable.dart';

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

  /// Returns a stream of all workouts, optionally filtered by a search query.
  ///
  /// If [search] is provided, only workouts matching the search criteria will be included
  /// in the resulting list. The stream emits updates whenever the underlying data changes.
  ///
  /// The [workoutPrepTime] and the [defaultPrepTime] are included in the duration calculation.
  ///
  /// Returns a [Stream] that emits lists of [WorkoutWithInfos] objects.
  Stream<List<WorkoutWithInfos>> streamAllWorkouts(
    int workoutPrepTime,
    int defaultPosePrepTime, {
    String? search,
  }) {
    final duration =
        Variable(workoutPrepTime) +
        (workoutPoses.prepTime +
                Variable(defaultPosePrepTime) +
                (poses.duration *
                    workoutPoses.side.caseMatch<int>(
                      when: {Constant(Side.both.index): Constant(2)},
                      orElse: Constant(1),
                    )))
            .sum();

    final difficulty = poses.difficulty.max();

    return (select(workouts).join([
            innerJoin(
              workoutPoses,
              workoutPoses.workout.equalsExp(workouts.id),
              useColumns: false,
            ),
            innerJoin(
              poses,
              poses.id.equalsExp(workoutPoses.pose),
              useColumns: false,
            ),
          ])
          ..addColumns([duration, difficulty])
          ..groupBy(
            [workouts.id, workouts.name, workouts.description],
            having: (search ?? '').isNotEmpty
                ? (workouts.name.contains(search!) |
                      workouts.description.contains(search))
                : null,
          )
          ..orderBy([OrderingTerm.asc(workouts.name)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => WorkoutWithInfos(
                  workout: row.readTable(workouts),
                  duration: row.read(duration)!,
                  difficulty: Difficulty.values[(row.read(difficulty)!)],
                ),
              )
              .toList(),
        );
  }

  /// Retrieves a [WorkoutWithInfos] object for the workout with the given [id].
  ///
  /// Returns a [Future] that completes with the workout and its associated information.
  Future<WorkoutWithInfos> getWorkout(int id) async {
    final duration =
        (poses.duration *
                workoutPoses.side.caseMatch(
                  when: {Constant(Side.both.index): Constant(2)},
                  orElse: Constant(1),
                ))
            .sum();

    final difficulty = poses.difficulty.max();

    return (select(workouts).join([
            innerJoin(
              workoutPoses,
              workoutPoses.workout.equalsExp(workouts.id),
              useColumns: false,
            ),
            innerJoin(
              poses,
              poses.id.equalsExp(workoutPoses.pose),
              useColumns: false,
            ),
          ])
          ..addColumns([duration, difficulty])
          ..groupBy([workouts.id, workouts.name, workouts.description])
          ..where(workouts.id.equals(id))
          ..orderBy([OrderingTerm.asc(workouts.name)]))
        .map(
          (row) => WorkoutWithInfos(
            workout: row.readTable(workouts),
            duration: row.read(duration) ?? 0,
            difficulty: Difficulty.values[(row.read(difficulty) ?? 0)],
          ),
        )
        .getSingle();
  }

  /// Checks if a workout with the specified [name] exists in the database.
  ///
  /// If an [id] is given, only rows without this id are checked.
  ///
  /// Returns `true` if a workout with the given name is found, otherwise `false`.
  Future<bool> hasWorkoutWithName(String name, {int? id}) async {
    final query = select(workouts)..where((p) => p.name.like(name));

    if (id != null) {
      query.where((w) => w.id.equals(id).not());
    }

    return (await query.getSingleOrNull()) != null;
  }

  /// Inserts a new workout entry into the database.
  ///
  /// Returns a [Future] that completes when the workout has been successfully inserted.
  Future insertWorkout(
    String name,
    String description,
    List<PoseWithBodyPartAndSide> poses,
  ) async {
    final workoutId = await into(
      workouts,
    ).insert(WorkoutsCompanion.insert(name: name, description: description));

    final posesToInsert = poses.mapWithIndex(
      (p, index) => WorkoutPosesCompanion.insert(
        workout: workoutId,
        pose: p.pose.id,
        order: index,
        side: Value(p.side),
      ),
    );

    await batch((batch) => batch.insertAll(workoutPoses, posesToInsert));
  }

  /// Updates an existing workout in the database.
  ///
  /// This method performs an update operation on a workout record.
  ///
  /// Returns a [Future] that completes when the update is finished.
  Future updateWorkout(
    WorkoutsCompanion workout,
    List<PoseWithBodyPartAndSide> poses,
  ) async {
    await (update(
      workouts,
    )..where((w) => w.id.equals(workout.id.value))).write(workout);

    await (delete(
      workoutPoses,
    )..where((wp) => wp.workout.equals(workout.id.value))).go();

    await batch(
      (batch) => batch.insertAll(
        workoutPoses,
        poses.mapWithIndex(
          (item, index) => WorkoutPosesCompanion.insert(
            workout: workout.id.value,
            pose: item.pose.id,
            order: index,
            side: Value(item.side),
            prepTime: Value(item.prepTime),
          ),
        ),
      ),
    );
  }

  /// Deletes a workout from the database by its [id].
  ///
  /// Returns a [Future] that completes when the workout has been deleted.
  Future deleteWorkout(int id) async {
    await (delete(workoutPoses)..where((wp) => wp.workout.equals(id))).go();

    await (delete(workouts)..where((w) => w.id.equals(id))).go();
  }

  /// Returns a stream of all poses from the database.
  ///
  /// The stream emits a list of [Pose] objects whenever the data changes.
  /// Useful for listening to real-time updates of poses.
  Stream<List<PoseWithBodyPart>> streamAllPoses() {
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

  /// Retrieves a list of all poses along with their associated body parts from the database.
  ///
  /// Returns a [Future] that completes with a list of [PoseWithBodyPart] objects.
  Future<List<PoseWithBodyPart>> getAllPoses() {
    return (select(poses).join([
          innerJoin(bodyParts, bodyParts.id.equalsExp(poses.affectedBodyPart)),
        ])..orderBy([OrderingTerm.asc(poses.name)]))
        .map(
          (row) => PoseWithBodyPart(
            pose: row.readTable(poses),
            bodyPart: row.readTable(bodyParts),
          ),
        )
        .get();
  }

  /// Retrieves all poses associated with a specific workout.
  ///
  /// Returns a [Future] that completes with a list of [PoseWithBodyPart] objects
  /// for the workout identified by [workoutId].
  Future<List<PoseWithBodyPartAndSide>> getAllPosesForWorkout(int workoutId) {
    return (select(poses).join([
            innerJoin(
              bodyParts,
              bodyParts.id.equalsExp(poses.affectedBodyPart),
            ),
            innerJoin(workoutPoses, workoutPoses.pose.equalsExp(poses.id)),
          ])
          ..where(workoutPoses.workout.equals(workoutId))
          ..orderBy([OrderingTerm.asc(workoutPoses.order)]))
        .map(
          (row) => PoseWithBodyPartAndSide(
            pose: row.readTable(poses),
            bodyPart: row.readTable(bodyParts),
            side: row.readTable(workoutPoses).side,
            prepTime: row.readTable(workoutPoses).prepTime,
          ),
        )
        .get();
  }

  /// Retrieves a [PoseWithBodyPart] object by its unique [id].
  ///
  /// Returns a [Future] that completes with the pose and its associated body part.
  Future<PoseWithBodyPart> getPose(int id) async {
    return (select(poses).join([
          innerJoin(bodyParts, bodyParts.id.equalsExp(poses.affectedBodyPart)),
        ])..where(poses.id.equals(id)))
        .map(
          (row) => PoseWithBodyPart(
            pose: row.readTable(poses),
            bodyPart: row.readTable(bodyParts),
          ),
        )
        .getSingle();
  }

  /// Checks if a pose with the given [name] and [bodyPart] exists in the database.
  ///
  /// If an [id] is given, only rows without this id are checked.
  ///
  /// Returns `true` if a pose with the specified name is found, otherwise `false`.
  /// This is an asynchronous operation.
  Future<bool> hasPoseWithName(
    String name,
    BodyPart? bodyPart, {
    int? id,
  }) async {
    final query = select(poses);

    if (id != null) {
      query.where((p) => p.name.like(name) & p.id.equals(id).not());
    } else {
      query.where((p) => p.name.like(name));
    }

    if (bodyPart != null) {
      query.where((p) => p.affectedBodyPart.equals(bodyPart.id));
    }

    return (await query.getSingleOrNull()) != null;
  }

  /// Inserts a new pose into the database.
  ///
  /// Returns a [Future] that completes when the pose has been inserted.
  Future insertPose(
    String name,
    String description,
    int duration,
    Difficulty difficulty,
    bool isUnilateral,
    BodyPart affectedBodyPart,
  ) async {
    await into(poses).insert(
      PosesCompanion.insert(
        name: name,
        description: description,
        duration: duration,
        difficulty: difficulty,
        isUnilateral: isUnilateral,
        affectedBodyPart: affectedBodyPart.id,
      ),
    );
  }

  /// Updates an existing pose in the database with the provided [pose] data.
  ///
  /// Returns a [Future] that completes when the update operation is finished.
  Future updatePose(PosesCompanion pose) async {
    await (update(poses)..where((p) => p.id.equals(pose.id.value))).write(pose);
  }

  /// Deletes a pose from the database by its [id].
  ///
  /// Returns a [Future] that completes when the pose has been deleted.
  Future deletePose(int id) async {
    await (delete(workoutPoses)..where((wp) => wp.pose.equals(id))).go();

    await (delete(poses)..where((p) => p.id.equals(id))).go();
  }

  /// Returns a stream of all [BodyPart]s that match the given [search] query.
  ///
  /// The stream emits updated lists whenever the underlying data changes.
  Stream<List<BodyPart>> streamAllBodyParts(String search) {
    var query = select(bodyParts);

    if (search.isNotEmpty) {
      query.where((bp) => bp.name.contains(search));
    }

    query.orderBy([(bp) => OrderingTerm.asc(bp.name)]);

    return query.watch();
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
