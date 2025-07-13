import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';
import 'package:yoga_trainer/components/select_body_part/add_body_part_dialog.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class SelectBodyPart extends StatefulWidget {
  const SelectBodyPart({super.key});

  @override
  State<SelectBodyPart> createState() => _SelectBodyPartState();
}

class _SelectBodyPartState extends State<SelectBodyPart> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectBodyPart),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: localizations.search,
                prefixIcon: Icon(Symbols.search),
              ),
              autofocus: true,
              initialValue: _searchText,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: database.getAllBodyParts(_searchText),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: IconWithText(
                      icon: Symbols.dangerous,
                      text: 'Error: ${snapshot.error}',
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: IconWithText(
                      icon: Symbols.search_off,
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
          ),
        ],
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
        child: Icon(Symbols.add),
      ),
    );
  }
}
