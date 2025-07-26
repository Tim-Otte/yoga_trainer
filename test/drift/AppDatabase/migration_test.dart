// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:yoga_trainer/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yoga_trainer/entities/difficulty.dart';
import 'package:yoga_trainer/entities/side.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 does not corrupt data', () async {
    final oldBodyPartsData = <v1.BodyPartsData>[
      v1.BodyPartsData(id: 1, name: 'Head'),
      v1.BodyPartsData(id: 2, name: 'Back'),
    ];
    final expectedNewBodyPartsData = <v2.BodyPartsData>[
      v2.BodyPartsData(id: 1, name: 'Head'),
      v2.BodyPartsData(id: 2, name: 'Back'),
    ];

    final oldPosesData = <v1.PosesData>[
      v1.PosesData(
        id: 1,
        name: 'Test pose 1',
        description: 'Description for Test pose 1',
        duration: 10,
        difficulty: Difficulty.easy.index,
        affectedBodyPart: 1,
        isUnilateral: true,
      ),
      v1.PosesData(
        id: 2,
        name: 'Test pose 2',
        description: 'Description for Test pose 2',
        duration: 20,
        difficulty: Difficulty.hard.index,
        affectedBodyPart: 2,
        isUnilateral: false,
      ),
    ];
    final expectedNewPosesData = <v2.PosesData>[
      v2.PosesData(
        id: 1,
        name: 'Test pose 1',
        description: 'Description for Test pose 1',
        duration: 10,
        difficulty: Difficulty.easy.index,
        affectedBodyPart: 1,
        isUnilateral: true,
      ),
      v2.PosesData(
        id: 2,
        name: 'Test pose 2',
        description: 'Description for Test pose 2',
        duration: 20,
        difficulty: Difficulty.hard.index,
        affectedBodyPart: 2,
        isUnilateral: false,
      ),
    ];

    final oldWorkoutsData = <v1.WorkoutsData>[
      v1.WorkoutsData(
        id: 1,
        name: 'Test workout 1',
        description: 'Description for Test workout 1',
      ),
      v1.WorkoutsData(
        id: 2,
        name: 'Test workout 2',
        description: 'Description for Test workout 2',
      ),
    ];
    final expectedNewWorkoutsData = <v2.WorkoutsData>[
      v2.WorkoutsData(
        id: 1,
        name: 'Test workout 1',
        description: 'Description for Test workout 1',
      ),
      v2.WorkoutsData(
        id: 2,
        name: 'Test workout 2',
        description: 'Description for Test workout 2',
      ),
    ];

    final oldWorkoutPosesData = <v1.WorkoutPosesData>[
      v1.WorkoutPosesData(
        workout: 1,
        pose: 1,
        order: 1,
        prepTime: 3,
        side: Side.left.index,
      ),
      v1.WorkoutPosesData(workout: 2, pose: 2, order: 2, prepTime: 4),
    ];
    final expectedNewWorkoutPosesData = <v2.WorkoutPosesData>[
      v2.WorkoutPosesData(
        workout: 1,
        pose: 1,
        order: 1,
        prepTime: 3,
        side: Side.left.index,
      ),
      v2.WorkoutPosesData(workout: 2, pose: 2, order: 2, prepTime: 4),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.bodyParts, oldBodyPartsData);
        batch.insertAll(oldDb.poses, oldPosesData);
        batch.insertAll(oldDb.workouts, oldWorkoutsData);
        batch.insertAll(oldDb.workoutPoses, oldWorkoutPosesData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewBodyPartsData,
          await newDb.select(newDb.bodyParts).get(),
        );
        expect(expectedNewPosesData, await newDb.select(newDb.poses).get());
        expect(
          expectedNewWorkoutsData,
          await newDb.select(newDb.workouts).get(),
        );
        expect(
          expectedNewWorkoutPosesData,
          await newDb.select(newDb.workoutPoses).get(),
        );
      },
    );
  });

  test('migration from v2 to v3 does not corrupt data', () async {
    final oldBodyPartsData = <v2.BodyPartsData>[
      v2.BodyPartsData(id: 1, name: 'Head'),
      v2.BodyPartsData(id: 2, name: 'Back'),
    ];
    final expectedNewBodyPartsData = <v3.BodyPartsData>[
      v3.BodyPartsData(id: 1, name: 'Head'),
      v3.BodyPartsData(id: 2, name: 'Back'),
    ];

    final oldPosesData = <v2.PosesData>[
      v2.PosesData(
        id: 1,
        name: 'Test pose 1',
        description: 'Description for Test pose 1',
        duration: 10,
        difficulty: Difficulty.easy.index,
        affectedBodyPart: 1,
        isUnilateral: true,
      ),
      v2.PosesData(
        id: 2,
        name: 'Test pose 2',
        description: 'Description for Test pose 2',
        duration: 20,
        difficulty: Difficulty.hard.index,
        affectedBodyPart: 2,
        isUnilateral: false,
      ),
    ];
    final expectedNewPosesData = <v3.PosesData>[
      v3.PosesData(
        id: 1,
        name: 'Test pose 1',
        description: 'Description for Test pose 1',
        duration: 10,
        difficulty: Difficulty.easy.index,
        affectedBodyPart: 1,
        isUnilateral: true,
      ),
      v3.PosesData(
        id: 2,
        name: 'Test pose 2',
        description: 'Description for Test pose 2',
        duration: 20,
        difficulty: Difficulty.hard.index,
        affectedBodyPart: 2,
        isUnilateral: false,
      ),
    ];

    final oldWorkoutsData = <v2.WorkoutsData>[
      v2.WorkoutsData(
        id: 1,
        name: 'Test workout 1',
        description: 'Description for Test workout 1',
      ),
      v2.WorkoutsData(
        id: 2,
        name: 'Test workout 2',
        description: 'Description for Test workout 2',
      ),
    ];
    final expectedNewWorkoutsData = <v3.WorkoutsData>[
      v3.WorkoutsData(
        id: 1,
        name: 'Test workout 1',
        description: 'Description for Test workout 1',
      ),
      v3.WorkoutsData(
        id: 2,
        name: 'Test workout 2',
        description: 'Description for Test workout 2',
      ),
    ];

    final oldWorkoutPosesData = <v2.WorkoutPosesData>[
      v2.WorkoutPosesData(
        workout: 1,
        pose: 1,
        order: 1,
        prepTime: 3,
        side: Side.left.index,
      ),
      v2.WorkoutPosesData(workout: 2, pose: 2, order: 2, prepTime: 4),
    ];
    final expectedNewWorkoutPosesData = <v3.WorkoutPosesData>[
      v3.WorkoutPosesData(
        workout: 1,
        pose: 1,
        order: 1,
        prepTime: 3,
        side: Side.left.index,
      ),
      v3.WorkoutPosesData(workout: 2, pose: 2, order: 2, prepTime: 4),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.bodyParts, oldBodyPartsData);
        batch.insertAll(oldDb.poses, oldPosesData);
        batch.insertAll(oldDb.workouts, oldWorkoutsData);
        batch.insertAll(oldDb.workoutPoses, oldWorkoutPosesData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewBodyPartsData,
          await newDb.select(newDb.bodyParts).get(),
        );
        expect(expectedNewPosesData, await newDb.select(newDb.poses).get());
        expect(
          expectedNewWorkoutsData,
          await newDb.select(newDb.workouts).get(),
        );
        expect(
          expectedNewWorkoutPosesData,
          await newDb.select(newDb.workoutPoses).get(),
        );
      },
    );
  });
}
