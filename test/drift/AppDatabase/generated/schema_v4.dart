// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class BodyParts extends Table with TableInfo<BodyParts, BodyPartsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BodyParts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_parts';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyPartsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyPartsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  BodyParts createAlias(String alias) {
    return BodyParts(attachedDatabase, alias);
  }
}

class BodyPartsData extends DataClass implements Insertable<BodyPartsData> {
  final int id;
  final String name;
  const BodyPartsData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  BodyPartsCompanion toCompanion(bool nullToAbsent) {
    return BodyPartsCompanion(id: Value(id), name: Value(name));
  }

  factory BodyPartsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyPartsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  BodyPartsData copyWith({int? id, String? name}) =>
      BodyPartsData(id: id ?? this.id, name: name ?? this.name);
  BodyPartsData copyWithCompanion(BodyPartsCompanion data) {
    return BodyPartsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyPartsData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyPartsData &&
          other.id == this.id &&
          other.name == this.name);
}

class BodyPartsCompanion extends UpdateCompanion<BodyPartsData> {
  final Value<int> id;
  final Value<String> name;
  const BodyPartsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  BodyPartsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<BodyPartsData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  BodyPartsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return BodyPartsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyPartsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class Poses extends Table with TableInfo<Poses, PosesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Poses(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 250),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> affectedBodyPart = GeneratedColumn<int>(
    'affected_body_part',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES body_parts (id)',
    ),
  );
  late final GeneratedColumn<bool> isUnilateral = GeneratedColumn<bool>(
    'is_unilateral',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unilateral" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    duration,
    difficulty,
    affectedBodyPart,
    isUnilateral,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'poses';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      affectedBodyPart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}affected_body_part'],
      )!,
      isUnilateral: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unilateral'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  Poses createAlias(String alias) {
    return Poses(attachedDatabase, alias);
  }
}

class PosesData extends DataClass implements Insertable<PosesData> {
  final int id;
  final String name;
  final String description;
  final int duration;
  final int difficulty;
  final int affectedBodyPart;
  final bool isUnilateral;
  final String? imagePath;
  const PosesData({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.affectedBodyPart,
    required this.isUnilateral,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['duration'] = Variable<int>(duration);
    map['difficulty'] = Variable<int>(difficulty);
    map['affected_body_part'] = Variable<int>(affectedBodyPart);
    map['is_unilateral'] = Variable<bool>(isUnilateral);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  PosesCompanion toCompanion(bool nullToAbsent) {
    return PosesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      duration: Value(duration),
      difficulty: Value(difficulty),
      affectedBodyPart: Value(affectedBodyPart),
      isUnilateral: Value(isUnilateral),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory PosesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      duration: serializer.fromJson<int>(json['duration']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      affectedBodyPart: serializer.fromJson<int>(json['affectedBodyPart']),
      isUnilateral: serializer.fromJson<bool>(json['isUnilateral']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'duration': serializer.toJson<int>(duration),
      'difficulty': serializer.toJson<int>(difficulty),
      'affectedBodyPart': serializer.toJson<int>(affectedBodyPart),
      'isUnilateral': serializer.toJson<bool>(isUnilateral),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  PosesData copyWith({
    int? id,
    String? name,
    String? description,
    int? duration,
    int? difficulty,
    int? affectedBodyPart,
    bool? isUnilateral,
    Value<String?> imagePath = const Value.absent(),
  }) => PosesData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    duration: duration ?? this.duration,
    difficulty: difficulty ?? this.difficulty,
    affectedBodyPart: affectedBodyPart ?? this.affectedBodyPart,
    isUnilateral: isUnilateral ?? this.isUnilateral,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  PosesData copyWithCompanion(PosesCompanion data) {
    return PosesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      duration: data.duration.present ? data.duration.value : this.duration,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      affectedBodyPart: data.affectedBodyPart.present
          ? data.affectedBodyPart.value
          : this.affectedBodyPart,
      isUnilateral: data.isUnilateral.present
          ? data.isUnilateral.value
          : this.isUnilateral,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PosesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('difficulty: $difficulty, ')
          ..write('affectedBodyPart: $affectedBodyPart, ')
          ..write('isUnilateral: $isUnilateral, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    duration,
    difficulty,
    affectedBodyPart,
    isUnilateral,
    imagePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.duration == this.duration &&
          other.difficulty == this.difficulty &&
          other.affectedBodyPart == this.affectedBodyPart &&
          other.isUnilateral == this.isUnilateral &&
          other.imagePath == this.imagePath);
}

class PosesCompanion extends UpdateCompanion<PosesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> duration;
  final Value<int> difficulty;
  final Value<int> affectedBodyPart;
  final Value<bool> isUnilateral;
  final Value<String?> imagePath;
  const PosesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.duration = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.affectedBodyPart = const Value.absent(),
    this.isUnilateral = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  PosesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required int duration,
    required int difficulty,
    required int affectedBodyPart,
    required bool isUnilateral,
    this.imagePath = const Value.absent(),
  }) : name = Value(name),
       description = Value(description),
       duration = Value(duration),
       difficulty = Value(difficulty),
       affectedBodyPart = Value(affectedBodyPart),
       isUnilateral = Value(isUnilateral);
  static Insertable<PosesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? duration,
    Expression<int>? difficulty,
    Expression<int>? affectedBodyPart,
    Expression<bool>? isUnilateral,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (duration != null) 'duration': duration,
      if (difficulty != null) 'difficulty': difficulty,
      if (affectedBodyPart != null) 'affected_body_part': affectedBodyPart,
      if (isUnilateral != null) 'is_unilateral': isUnilateral,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  PosesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<int>? duration,
    Value<int>? difficulty,
    Value<int>? affectedBodyPart,
    Value<bool>? isUnilateral,
    Value<String?>? imagePath,
  }) {
    return PosesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      affectedBodyPart: affectedBodyPart ?? this.affectedBodyPart,
      isUnilateral: isUnilateral ?? this.isUnilateral,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (affectedBodyPart.present) {
      map['affected_body_part'] = Variable<int>(affectedBodyPart.value);
    }
    if (isUnilateral.present) {
      map['is_unilateral'] = Variable<bool>(isUnilateral.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('difficulty: $difficulty, ')
          ..write('affectedBodyPart: $affectedBodyPart, ')
          ..write('isUnilateral: $isUnilateral, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class Workouts extends Table with TableInfo<Workouts, WorkoutsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Workouts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 250),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  Workouts createAlias(String alias) {
    return Workouts(attachedDatabase, alias);
  }
}

class WorkoutsData extends DataClass implements Insertable<WorkoutsData> {
  final int id;
  final String name;
  final String description;
  const WorkoutsData({
    required this.id,
    required this.name,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
  }

  factory WorkoutsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  WorkoutsData copyWith({int? id, String? name, String? description}) =>
      WorkoutsData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  WorkoutsData copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
  }) : name = Value(name),
       description = Value(description);
  static Insertable<WorkoutsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class WorkoutPoses extends Table
    with TableInfo<WorkoutPoses, WorkoutPosesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutPoses(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> workout = GeneratedColumn<int>(
    'workout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  late final GeneratedColumn<int> pose = GeneratedColumn<int>(
    'pose',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES poses (id)',
    ),
  );
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> side = GeneratedColumn<int>(
    'side',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<int> prepTime = GeneratedColumn<int>(
    'prep_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [workout, pose, order, side, prepTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_poses';
  @override
  Set<GeneratedColumn> get $primaryKey => {workout, pose, order};
  @override
  WorkoutPosesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPosesData(
      workout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout'],
      )!,
      pose: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pose'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}side'],
      ),
      prepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_time'],
      ),
    );
  }

  @override
  WorkoutPoses createAlias(String alias) {
    return WorkoutPoses(attachedDatabase, alias);
  }
}

class WorkoutPosesData extends DataClass
    implements Insertable<WorkoutPosesData> {
  final int workout;
  final int pose;
  final int order;
  final int? side;
  final int? prepTime;
  const WorkoutPosesData({
    required this.workout,
    required this.pose,
    required this.order,
    this.side,
    this.prepTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout'] = Variable<int>(workout);
    map['pose'] = Variable<int>(pose);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<int>(side);
    }
    if (!nullToAbsent || prepTime != null) {
      map['prep_time'] = Variable<int>(prepTime);
    }
    return map;
  }

  WorkoutPosesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPosesCompanion(
      workout: Value(workout),
      pose: Value(pose),
      order: Value(order),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
      prepTime: prepTime == null && nullToAbsent
          ? const Value.absent()
          : Value(prepTime),
    );
  }

  factory WorkoutPosesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPosesData(
      workout: serializer.fromJson<int>(json['workout']),
      pose: serializer.fromJson<int>(json['pose']),
      order: serializer.fromJson<int>(json['order']),
      side: serializer.fromJson<int?>(json['side']),
      prepTime: serializer.fromJson<int?>(json['prepTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workout': serializer.toJson<int>(workout),
      'pose': serializer.toJson<int>(pose),
      'order': serializer.toJson<int>(order),
      'side': serializer.toJson<int?>(side),
      'prepTime': serializer.toJson<int?>(prepTime),
    };
  }

  WorkoutPosesData copyWith({
    int? workout,
    int? pose,
    int? order,
    Value<int?> side = const Value.absent(),
    Value<int?> prepTime = const Value.absent(),
  }) => WorkoutPosesData(
    workout: workout ?? this.workout,
    pose: pose ?? this.pose,
    order: order ?? this.order,
    side: side.present ? side.value : this.side,
    prepTime: prepTime.present ? prepTime.value : this.prepTime,
  );
  WorkoutPosesData copyWithCompanion(WorkoutPosesCompanion data) {
    return WorkoutPosesData(
      workout: data.workout.present ? data.workout.value : this.workout,
      pose: data.pose.present ? data.pose.value : this.pose,
      order: data.order.present ? data.order.value : this.order,
      side: data.side.present ? data.side.value : this.side,
      prepTime: data.prepTime.present ? data.prepTime.value : this.prepTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPosesData(')
          ..write('workout: $workout, ')
          ..write('pose: $pose, ')
          ..write('order: $order, ')
          ..write('side: $side, ')
          ..write('prepTime: $prepTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workout, pose, order, side, prepTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPosesData &&
          other.workout == this.workout &&
          other.pose == this.pose &&
          other.order == this.order &&
          other.side == this.side &&
          other.prepTime == this.prepTime);
}

class WorkoutPosesCompanion extends UpdateCompanion<WorkoutPosesData> {
  final Value<int> workout;
  final Value<int> pose;
  final Value<int> order;
  final Value<int?> side;
  final Value<int?> prepTime;
  final Value<int> rowid;
  const WorkoutPosesCompanion({
    this.workout = const Value.absent(),
    this.pose = const Value.absent(),
    this.order = const Value.absent(),
    this.side = const Value.absent(),
    this.prepTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPosesCompanion.insert({
    required int workout,
    required int pose,
    required int order,
    this.side = const Value.absent(),
    this.prepTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workout = Value(workout),
       pose = Value(pose),
       order = Value(order);
  static Insertable<WorkoutPosesData> custom({
    Expression<int>? workout,
    Expression<int>? pose,
    Expression<int>? order,
    Expression<int>? side,
    Expression<int>? prepTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workout != null) 'workout': workout,
      if (pose != null) 'pose': pose,
      if (order != null) 'order': order,
      if (side != null) 'side': side,
      if (prepTime != null) 'prep_time': prepTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPosesCompanion copyWith({
    Value<int>? workout,
    Value<int>? pose,
    Value<int>? order,
    Value<int?>? side,
    Value<int?>? prepTime,
    Value<int>? rowid,
  }) {
    return WorkoutPosesCompanion(
      workout: workout ?? this.workout,
      pose: pose ?? this.pose,
      order: order ?? this.order,
      side: side ?? this.side,
      prepTime: prepTime ?? this.prepTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workout.present) {
      map['workout'] = Variable<int>(workout.value);
    }
    if (pose.present) {
      map['pose'] = Variable<int>(pose.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (side.present) {
      map['side'] = Variable<int>(side.value);
    }
    if (prepTime.present) {
      map['prep_time'] = Variable<int>(prepTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPosesCompanion(')
          ..write('workout: $workout, ')
          ..write('pose: $pose, ')
          ..write('order: $order, ')
          ..write('side: $side, ')
          ..write('prepTime: $prepTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class WorkoutWeekdays extends Table
    with TableInfo<WorkoutWeekdays, WorkoutWeekdaysData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutWeekdays(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> workout = GeneratedColumn<int>(
    'workout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [workout, weekday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_weekdays';
  @override
  Set<GeneratedColumn> get $primaryKey => {workout, weekday};
  @override
  WorkoutWeekdaysData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutWeekdaysData(
      workout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
    );
  }

  @override
  WorkoutWeekdays createAlias(String alias) {
    return WorkoutWeekdays(attachedDatabase, alias);
  }
}

class WorkoutWeekdaysData extends DataClass
    implements Insertable<WorkoutWeekdaysData> {
  final int workout;
  final int weekday;
  const WorkoutWeekdaysData({required this.workout, required this.weekday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout'] = Variable<int>(workout);
    map['weekday'] = Variable<int>(weekday);
    return map;
  }

  WorkoutWeekdaysCompanion toCompanion(bool nullToAbsent) {
    return WorkoutWeekdaysCompanion(
      workout: Value(workout),
      weekday: Value(weekday),
    );
  }

  factory WorkoutWeekdaysData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutWeekdaysData(
      workout: serializer.fromJson<int>(json['workout']),
      weekday: serializer.fromJson<int>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workout': serializer.toJson<int>(workout),
      'weekday': serializer.toJson<int>(weekday),
    };
  }

  WorkoutWeekdaysData copyWith({int? workout, int? weekday}) =>
      WorkoutWeekdaysData(
        workout: workout ?? this.workout,
        weekday: weekday ?? this.weekday,
      );
  WorkoutWeekdaysData copyWithCompanion(WorkoutWeekdaysCompanion data) {
    return WorkoutWeekdaysData(
      workout: data.workout.present ? data.workout.value : this.workout,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutWeekdaysData(')
          ..write('workout: $workout, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workout, weekday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutWeekdaysData &&
          other.workout == this.workout &&
          other.weekday == this.weekday);
}

class WorkoutWeekdaysCompanion extends UpdateCompanion<WorkoutWeekdaysData> {
  final Value<int> workout;
  final Value<int> weekday;
  final Value<int> rowid;
  const WorkoutWeekdaysCompanion({
    this.workout = const Value.absent(),
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutWeekdaysCompanion.insert({
    required int workout,
    required int weekday,
    this.rowid = const Value.absent(),
  }) : workout = Value(workout),
       weekday = Value(weekday);
  static Insertable<WorkoutWeekdaysData> custom({
    Expression<int>? workout,
    Expression<int>? weekday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workout != null) 'workout': workout,
      if (weekday != null) 'weekday': weekday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutWeekdaysCompanion copyWith({
    Value<int>? workout,
    Value<int>? weekday,
    Value<int>? rowid,
  }) {
    return WorkoutWeekdaysCompanion(
      workout: workout ?? this.workout,
      weekday: weekday ?? this.weekday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workout.present) {
      map['workout'] = Variable<int>(workout.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutWeekdaysCompanion(')
          ..write('workout: $workout, ')
          ..write('weekday: $weekday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV4 extends GeneratedDatabase {
  DatabaseAtV4(QueryExecutor e) : super(e);
  late final BodyParts bodyParts = BodyParts(this);
  late final Poses poses = Poses(this);
  late final Workouts workouts = Workouts(this);
  late final WorkoutPoses workoutPoses = WorkoutPoses(this);
  late final WorkoutWeekdays workoutWeekdays = WorkoutWeekdays(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bodyParts,
    poses,
    workouts,
    workoutPoses,
    workoutWeekdays,
  ];
  @override
  int get schemaVersion => 4;
}
