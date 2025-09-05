import 'database.steps.dart';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/entities/workout_with_poses.dart' as export_models;
import 'package:yoga_trainer/extensions/iterable.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [BodyParts, Poses, Workouts, WorkoutPoses, WorkoutWeekdays],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.alterTable(TableMigration(schema.workoutPoses));
        },
        from2To3: (m, schema) async {
          await m.alterTable(TableMigration(schema.workoutPoses));
        },
        from3To4: (m, schema) async {
          await m.createTable(schema.workoutWeekdays);
        },
      ),
    );
  }

  /// Calculates the total duration of a workout session as an [Expression<int>].
  /// This method is typically used to generate a SQL expression for querying
  /// workout durations from the database.
  Expression<int> _getWorkoutDurationCalculation(
    int workoutPrepTime,
    int defaultPosePrepTime,
  ) {
    return
    // Workout prep time
    Variable(workoutPrepTime) +
        (
            // Pose prep time
            coalesce([workoutPoses.prepTime, Variable(defaultPosePrepTime)]) +
                // Prep time if both sides are trained
                workoutPoses.side
                    .caseMatch<int>(
                      when: {
                        Constant(Side.both.index): Variable(
                          defaultPosePrepTime,
                        ),
                      },
                      orElse: Constant(0),
                    )
                    // Only if side is unilateral
                    .iif(poses.isUnilateral, Constant(0)) +
                // Duration of the poses, multiplied by 2 if both sides are trained
                (poses.duration *
                    workoutPoses.side
                        .caseMatch<int>(
                          when: {Constant(Side.both.index): Constant(2)},
                          orElse: Constant(1),
                        )
                        // Only if side is unilateral
                        .iif(poses.isUnilateral, Constant(1))))
            .sum();
  }

  /// Returns a stream of all workouts, optionally filtered by a search query.
  ///
  /// If [search] is provided, only workouts matching the search criteria will be included
  /// in the resulting list. The stream emits updates whenever the underlying data changes.
  ///
  /// The [workoutPrepTime] and the [defaultPrepTime] are included in the duration calculation.
  ///
  /// Returns a [Stream] that emits lists of [WorkoutWithInfos] objects.
  Stream<List<WorkoutWithInfos>> streamAllWorkouts({
    required int workoutPrepTime,
    required int defaultPosePrepTime,
    String? search,
    Weekday? weekday,
  }) {
    final duration = _getWorkoutDurationCalculation(
      workoutPrepTime,
      defaultPosePrepTime,
    );
    final difficulty = poses.difficulty.max();

    final query =
        select(workouts).join([
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
            if (weekday != null)
              leftOuterJoin(
                workoutWeekdays,
                workoutWeekdays.workout.equalsExp(workouts.id),
                useColumns: false,
              ),
          ])
          ..addColumns([duration, difficulty])
          ..groupBy(
            [workouts.id, workouts.name, workouts.description],
            having: (search ?? '').isEmpty
                ? null
                : (workouts.name.contains(search!) |
                      workouts.description.contains(search)),
          );

    if (weekday != null) {
      query.where(workoutWeekdays.weekday.equals(weekday.index));
    }

    return (query..orderBy([OrderingTerm.asc(workouts.name)])).watch().map(
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
  Future<WorkoutWithInfos> getWorkout(
    int id, {
    required int workoutPrepTime,
    required int defaultPosePrepTime,
  }) async {
    final duration = _getWorkoutDurationCalculation(
      workoutPrepTime,
      defaultPosePrepTime,
    );
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
          ..groupBy([
            workouts.id,
            workouts.name,
            workouts.description,
          ], having: workouts.id.equals(id))
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

  /// Retrieves workout data for export based on the provided list of workout IDs.
  ///
  /// Returns a `Future` that completes with the exported workout data.
  ///
  /// [workoutIds] is a list of integer IDs representing the workouts to be exported.
  Future<List<export_models.WorkoutWithPoses>> getWorkoutsForExport(
    List<int> workoutIds,
  ) async {
    List<export_models.WorkoutWithPoses> result = [];
    var w = await select(workouts).get();
    for (var workout in w) {
      var rows = await ((select(workoutPoses).join([
        innerJoin(poses, poses.id.equalsExp(workoutPoses.pose)),
        innerJoin(bodyParts, bodyParts.id.equalsExp(poses.affectedBodyPart)),
      ]))..where(workoutPoses.workout.equals(workout.id))).get();

      result.add(
        export_models.WorkoutWithPoses(
          name: workout.name,
          description: workout.description,
          poses: rows.map((row) {
            var wp = row.readTable(workoutPoses);
            var p = row.readTable(poses);
            var bp = row.readTable(bodyParts);

            return export_models.PoseInfos(
              pose: export_models.PoseData.fromPose(p, bp),
              order: wp.order,
              prepTime: wp.prepTime,
              side: wp.side,
            );
          }).toList(),
        ),
      );
    }

    return result;
  }

  /// Imports workout data into the database.
  ///
  /// Returns a [Future] that completes when the import operation is finished.
  Future importWorkouts(
    List<export_models.WorkoutWithPoses> workoutsToImport,
  ) async {
    final bodyPartsToInsert = workoutsToImport
        .map((x) => x.poses.map((y) => y.pose.affectedBodyPart))
        .fold(<String>[], (prev, el) => [...prev, ...el])
        .toSet();
    final Map<String, int> bodyPartMap = {};

    for (var bodyPart in bodyPartsToInsert) {
      final exists = await (select(
        bodyParts,
      )..where((bp) => bp.name.equals(bodyPart))).getSingleOrNull();

      if (exists != null) {
        bodyPartMap[bodyPart] = exists.id;
      } else {
        final newId = await into(
          bodyParts,
        ).insert(BodyPartsCompanion.insert(name: bodyPart));
        bodyPartMap[bodyPart] = newId;
      }
    }

    for (var workout in workoutsToImport) {
      final workoutId = await into(workouts).insert(
        WorkoutsCompanion.insert(
          name: workout.name,
          description: workout.description,
        ),
      );

      for (var pose in workout.poses) {
        final exists =
            await (select(poses)..where(
                  (p) =>
                      p.name.equals(pose.pose.name) &
                      p.affectedBodyPart.equals(
                        bodyPartMap[pose.pose.affectedBodyPart]!,
                      ),
                ))
                .getSingleOrNull();

        int poseId;

        if (exists != null) {
          poseId = exists.id;
        } else {
          poseId = await into(poses).insert(
            PosesCompanion.insert(
              name: pose.pose.name,
              description: pose.pose.description,
              duration: pose.pose.duration,
              difficulty: pose.pose.difficulty,
              affectedBodyPart: bodyPartMap[pose.pose.affectedBodyPart]!,
              isUnilateral: pose.pose.isUnilateral,
            ),
          );
        }

        await into(workoutPoses).insert(
          WorkoutPosesCompanion.insert(
            workout: workoutId,
            pose: poseId,
            order: pose.order,
            side: Value(pose.side),
            prepTime: Value(pose.prepTime),
          ),
        );
      }
    }
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
    List<Weekday> weekdays,
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
        prepTime: Value.absentIfNull(p.prepTime),
      ),
    );

    final weekdaysToInsert = weekdays.map(
      (w) => WorkoutWeekdaysCompanion.insert(workout: workoutId, weekday: w),
    );

    await batch((batch) {
      batch.insertAll(workoutPoses, posesToInsert);
      batch.insertAll(workoutWeekdays, weekdaysToInsert);
    });
  }

  /// Updates an existing workout in the database.
  ///
  /// This method performs an update operation on a workout record.
  ///
  /// Returns a [Future] that completes when the update is finished.
  Future updateWorkout(
    WorkoutsCompanion workout,
    List<PoseWithBodyPartAndSide> poses,
    List<Weekday> weekdays,
  ) async {
    await batch((batch) {
      // Workout
      batch.update(
        workouts,
        workout,
        where: (w) => w.id.equals(workout.id.value),
      );
      // Poses
      batch.deleteWhere(
        workoutPoses,
        (wp) => wp.workout.equals(workout.id.value),
      );
      batch.insertAll(
        workoutPoses,
        poses.mapWithIndex(
          (item, index) => WorkoutPosesCompanion.insert(
            workout: workout.id.value,
            pose: item.pose.id,
            order: index,
            side: Value(item.side),
            prepTime: Value.absentIfNull(item.prepTime),
          ),
        ),
      );
      // Weekdays
      batch.deleteWhere(
        workoutWeekdays,
        (ww) => ww.workout.equals(workout.id.value),
      );
      batch.insertAll(
        workoutWeekdays,
        weekdays.map(
          (item) => WorkoutWeekdaysCompanion.insert(
            workout: workout.id.value,
            weekday: item,
          ),
        ),
      );
    });
  }

  /// Deletes a workout from the database by its [id].
  ///
  /// Returns a [Future] that completes when the workout has been deleted.
  Future deleteWorkout(int id) async {
    await batch((batch) {
      batch.deleteWhere(workoutPoses, (wp) => wp.workout.equals(id));
      batch.deleteWhere(workoutWeekdays, (ww) => ww.workout.equals(id));
      batch.deleteWhere(workouts, (w) => w.id.equals(id));
    });
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

    if (pose.isUnilateral.value) {
      await (update(workoutPoses)
            ..where((wp) => wp.pose.equals(pose.id.value) & wp.side.isNull()))
          .write(WorkoutPosesCompanion(side: Value(Side.both)));
    } else {
      await (update(workoutPoses)..where(
            (wp) => wp.pose.equals(pose.id.value) & wp.side.isNull().not(),
          ))
          .write(WorkoutPosesCompanion(side: Value(null)));
    }
  }

  /// Deletes a pose from the database by its [id].
  ///
  /// Returns a [Future] that completes when the pose has been deleted.
  Future deletePose(int id) async {
    await batch((batch) {
      batch.deleteWhere(workoutPoses, (wp) => wp.pose.equals(id));
      batch.deleteWhere(poses, (p) => p.id.equals(id));
    });
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

  /// Retrieves a list of [Weekday] objects associated with the specified [workoutId].
  ///
  /// Returns a [Future] that completes with a list of [Weekday]s for the given workout.
  Future<List<Weekday>> getAllWeekdaysForWorkout(int workoutId) async {
    return (select(workoutWeekdays)
          ..where((ww) => ww.workout.equals(workoutId)))
        .map((ww) => ww.weekday)
        .get();
  }
}
