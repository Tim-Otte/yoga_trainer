import 'package:flutter/material.dart';

class DetailsListItem {
  const DetailsListItem(this.icon, this.text, {this.iconNeedsExtraSpace});

  final IconData icon;
  final Widget text;
  final bool? iconNeedsExtraSpace;
}

class DetailsList extends StatelessWidget {
  const DetailsList({super.key, required this.children});

  final List<DetailsListItem> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      children: children
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 14, color: theme.colorScheme.primary),
                SizedBox(width: item.iconNeedsExtraSpace ?? false ? 5 : 4),
                item.text,
              ],
            ),
          )
          .toList(),
    );
  }
}
