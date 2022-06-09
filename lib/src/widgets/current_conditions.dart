import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/src/model/weather.dart';
import 'package:flutter_weather/src/widgets/value_tile.dart';

import '../utils/converters.dart';

/// Renders Weather Icon, current, min and max temperatures
class CurrentConditions extends StatelessWidget {
  final Weather weather;
  const CurrentConditions({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;
    TemperatureUnit unit = AppStateContainer.of(context).temperatureUnit;

    int currentTemp = this.weather.temperature.as(unit).round();
    int feelsLike = this.weather.feelsLike.as(unit).round();
    int maxTemp = this.weather.maxTemperature.as(unit).round();
    int minTemp = this.weather.minTemperature.as(unit).round();
    String weatherData = this.weather.description;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        
        Icon(
          weather.getIconData(),
          color: appTheme.accentColor,
          size: 70,
        ),
        SizedBox(height: 25,),
        Text(
          this.weather.description.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 5,
            fontWeight: FontWeight.w400,
            color: appTheme.accentColor,
          ),
        ),
        SizedBox(height: 10,),
        Text(
              'Feels like : $feelsLike°',
              style: TextStyle(
                  fontSize: 16,
                  color: appTheme.accentColor),
            ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currentTemp°',
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w100,
                  color: appTheme.accentColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 2,
                height: 100,
                color: appTheme.accentColor.withAlpha(50),
              ),
            ),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "MAX",
                      style: TextStyle(
                          color: AppStateContainer.of(context)
                              .theme
                              .accentColor
                              .withAlpha(125)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '$maxTemp°',
                      style: TextStyle(fontSize: 18 ,color: appTheme.accentColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Container(
                    height: 2,
                    width: 50,
                    color: appTheme.accentColor.withAlpha(50),
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "MIN",
                      style: TextStyle(
                          color: AppStateContainer.of(context)
                              .theme
                              .accentColor
                              .withAlpha(125)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '$minTemp°',
                      style: TextStyle(fontSize: 18 ,color: appTheme.accentColor),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          
        ]),
      ],
    );
  }


}
