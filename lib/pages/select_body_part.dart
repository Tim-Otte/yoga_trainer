import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/select_body_part/add_body_part_dialog.dart';
import 'package:yoga_trainer/components/stream_list_view.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class SelectBodyPartPage extends StatefulWidget {
  const SelectBodyPartPage({super.key});

  @override
  State<SelectBodyPartPage> createState() => _SelectBodyPartPageState();
}

class _SelectBodyPartPageState extends State<SelectBodyPartPage> {
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
            child: StreamListView(
              stream: database.streamAllBodyParts(_searchText),
              noDataText: AppLocalizations.of(context).noBodyParts,
              itemBuilder: (context, bodyPart, _) => ListTile(
                title: Text(bodyPart.name),
                onTap: () {
                  Navigator.pop(context, bodyPart);
                },
              ),
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
