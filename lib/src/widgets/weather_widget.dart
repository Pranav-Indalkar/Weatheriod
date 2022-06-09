import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/src/model/weather.dart';
import 'package:flutter_weather/src/utils/WeatherIconMapper.dart';
import 'package:flutter_weather/src/widgets/forecast_horizontal_widget.dart';
import 'package:flutter_weather/src/widgets/value_tile.dart';
import 'package:flutter_weather/src/widgets/weather_swipe_pager.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget({this.weather}) : assert(weather != null);
  
  

  @override
  Widget build(BuildContext context) {
    // int isDay; 
    // if((weather.forecast[0].time > weather.sunrise && weather.forecast[0].time < weather.sunrise)){
    //   isDay = 1;
    // }else{
    //   isDay = 0;
    // }
    // AppStateContainer.of(context).updateTheme(isDay);
    ThemeData appTheme = AppStateContainer.of(context).theme;
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    print(maxHeight);
    print(maxWidth);
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20,),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.4)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    this.weather.cityName.toUpperCase()+", "+this.weather.countryCode,
                    style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 5,
                      color: appTheme.accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: 325,
                height: 295,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.4)
                ),
                child: WeatherSwipePager(weather: weather)
              )
            ),
          ),
        ),
        Padding(
          child: Divider(
            color: appTheme.accentColor,
          ),
          padding: EdgeInsets.all(5),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ValueTile("Wind Speed", '${this.weather.windSpeed} m/s',iconData: WeatherIcons.wind_speed,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: Container(
              width: 1,
              height: 70,
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor
            )),
          ),
          ValueTile(
              "Sunrise",
              DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                  this.weather.sunrise * 1000)),
              iconData: WeatherIcons.sunrise),
          Padding(
            padding: const EdgeInsets.only(left: 10 , right: 10),
            child: Center(
                child: Container(
              width: 1,
              height: 70,
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor,
            )),
          ),
          ValueTile(
              "Sunset",
              DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                  this.weather.sunset * 1000),
              ),
              iconData: WeatherIcons.sunset),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: Container(
              width: 1,
              height: 70,
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor
            )),
          ),
          ValueTile("Humidity", '${this.weather.humidity}%',iconData: WeatherIcons.humidity_percent,),
        ]),
        Padding(
          child: Divider(
            color: appTheme.accentColor,
          ),
          padding: EdgeInsets.all(10),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "5 Day Forecast - ",
              style: TextStyle(
                fontSize: 18,
                color: AppStateContainer.of(context)
                      .theme
                      .accentColor
              ),
              ),
          ),
        ),
        SizedBox(height: 10,),
        ForecastHorizontal(weathers: weather.forecast),
        SizedBox(height: 25,),
      ],
    );
  }
}
