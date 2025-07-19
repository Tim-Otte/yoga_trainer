import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/side.dart';

class PoseWithBodyPartAndSide {
  PoseWithBodyPartAndSide({
    required this.pose,
    required this.bodyPart,
    this.side,
    required this.prepTime,
  });

  Pose pose;
  BodyPart bodyPart;
  Side? side;
  int prepTime;
}
