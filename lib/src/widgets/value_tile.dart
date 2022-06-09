import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/src/widgets/empty_widget.dart';

/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData]
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ValueTile(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this.label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppStateContainer.of(context)
                              .theme
                              .accentColor
                            ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    this.iconData != null
                        ? Icon(
                            iconData,
                            color: appTheme.accentColor,
                            size: 24,
                          )
                        : EmptyWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      this.value,
                      style: TextStyle(fontSize: 15,color: appTheme.accentColor),
                    ),
                  ],
                )
              )
            )
          );
  }
}
