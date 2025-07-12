import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';
import 'package:yoga_trainer/components/select_body_part/add_body_part_dialog.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class SelectBodyPart extends StatelessWidget {
  const SelectBodyPart({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.selectBodyPart)),
      body: StreamBuilder(
        stream: database.getAllBodyParts(),
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
                text: AppLocalizations.of(context).noBodyParts,
              ),
            );
          }

          final bodyParts = snapshot.data!;

          return ListView.builder(
            itemCount: bodyParts.length,
            itemBuilder: (context, index) {
              final bodyPart = bodyParts[index];
              return ListTile(
                title: Text(bodyPart.name),
                onTap: () {
                  Navigator.pop(context, bodyPart);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await showDialog<String>(
            context: context,
            builder: (_) {
              return Provider(
                create: (_) => database,
                child: AddBodyPartDialog(),
              );
            },
          );

          if (result != null) {
            database.insertBodyPart(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
