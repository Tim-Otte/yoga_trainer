import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/settings/tile_type.dart';
import 'package:yoga_trainer/extensions/color.dart';

class MaterialSettingsTile<T> extends StatelessWidget {
  const MaterialSettingsTile({
    super.key,
    required this.tileType,
    this.prefix,
    required this.title,
    this.description,
    this.onTap,
    this.onToggle,
    this.value,
    this.initialValue,
    required this.enabled,
    this.suffix,
  });

  final SettingsTileType tileType;
  final Widget? prefix;
  final Widget? title;
  final Widget? description;
  final Function(BuildContext context)? onTap;
  final Function(bool value)? onToggle;
  final Widget? value;
  final T? initialValue;
  final bool enabled;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;
    final secondaryBodyColor = theme.textTheme.bodyMedium!.color!.useOpacity(
      0.75,
    );

    return IgnorePointer(
      ignoring: !enabled,
      child: Material(
        child: InkWell(
          onTap:
              enabled &&
                  (onTap != null || onToggle != null) &&
                  tileType != SettingsTileType.numberTile
              ? () {
                  if (onToggle != null && T is bool) {
                    onToggle!.call(!(initialValue as bool? ?? false));
                  } else {
                    onTap?.call(context);
                  }
                }
              : null,
          highlightColor: theme.highlightColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Row(
            children: [
              // Icon
              if (prefix != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 12),
                  child: IconTheme(
                    data: theme.iconTheme.copyWith(
                      color: theme.colorScheme.primary.useOpacity(
                        enabled ? 1.0 : 0.6,
                      ),
                    ),
                    child: prefix!,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 24,
                    end: 24,
                    bottom: textScaler.scale(19),
                    top: textScaler.scale(19),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          color: theme.textTheme.titleMedium!.color?.useOpacity(
                            enabled ? 1.0 : 0.6,
                          ),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        child: title ?? Container(),
                      ),
                      if (value != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: secondaryBodyColor.useOpacity(
                                enabled ? 1.0 : 0.6,
                              ),
                            ),
                            child: value!,
                          ),
                        )
                      else if (description != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: secondaryBodyColor.useOpacity(
                                enabled ? 1.0 : 0.6,
                              ),
                            ),
                            child: description!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
      ),
    );
  }
}
