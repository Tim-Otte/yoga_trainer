import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/difficulty.dart';
import 'package:yoga_trainer/entities/side.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout_with_poses.g.dart';

@JsonSerializable()
class WorkoutWithPoses {
  WorkoutWithPoses({
    required this.name,
    required this.description,
    required this.poses,
  });

  final String name;
  final String description;
  final List<PoseInfos> poses;

  factory WorkoutWithPoses.fromJson(Map<String, dynamic> json) =>
      _$WorkoutWithPosesFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutWithPosesToJson(this);
}

@JsonSerializable()
class PoseInfos {
  PoseInfos({
    required this.pose,
    required this.order,
    required this.side,
    required this.prepTime,
  });

  final PoseData pose;
  final int order;
  final Side? side;
  final int? prepTime;

  factory PoseInfos.fromJson(Map<String, dynamic> json) =>
      _$PoseInfosFromJson(json);

  Map<String, dynamic> toJson() => _$PoseInfosToJson(this);
}

@JsonSerializable()
class PoseData {
  PoseData({
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.affectedBodyPart,
    required this.isUnilateral,
    required this.imagePath,
  });

  final String name;
  final String description;
  final int duration;
  final Difficulty difficulty;
  final String affectedBodyPart;
  final bool isUnilateral;
  final String? imagePath;

  factory PoseData.fromJson(Map<String, dynamic> json) =>
      _$PoseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PoseDataToJson(this);

  factory PoseData.fromPose(Pose pose, BodyPart bodyPart) {
    return PoseData(
      name: pose.name,
      description: pose.description,
      duration: pose.duration,
      difficulty: pose.difficulty,
      affectedBodyPart: bodyPart.name,
      isUnilateral: pose.isUnilateral,
      imagePath: pose.imagePath,
    );
  }
}
