import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/add_pose.dart';
import 'package:yoga_trainer/pages/page_infos.dart';

class PosesPage extends StatelessWidget implements PageInfos {
  const PosesPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).poses;
  }

  @override
  IconData getIcon() {
    return Icons.sports_gymnastics;
  }

  @override
  Widget? getFAB(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Provider(create: (_) => database, child: AddPosePage());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: database.getAllPoses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: IconWithText(
              icon: Icons.dangerous,
              text: 'Error: ${snapshot.error}',
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: IconWithText(
              icon: Icons.search_off,
              text: AppLocalizations.of(context).noPoses,
            ),
          );
        }

        final poses = snapshot.data!;

        return ListView.builder(
          itemCount: poses.length,
          itemBuilder: (context, index) {
            final pose = poses[index];
            return ListTile(
              title: Text(pose.name),
              subtitle: Text(pose.description),
              trailing: Chip(
                label: Text('${pose.duration}s'),
                avatar: Icon(Icons.timer),
              ),
              onTap: () {
                // Handle workout tap
              },
            );
          },
        );
      },
    );
  }
}
