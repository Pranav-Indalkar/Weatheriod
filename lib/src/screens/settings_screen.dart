import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/main.dart';
import 'package:flutter_weather/src/bloc/weather_bloc.dart';
import 'package:flutter_weather/src/bloc/weather_state.dart';
import 'package:flutter_weather/src/bloc/weather_event.dart';
import 'package:flutter_weather/src/themes.dart';
import 'package:flutter_weather/src/utils/converters.dart';
import 'package:flutter_weather/src/widgets/empty_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _cityName = "Pune";
  bool useCurrentLocation = false;

  _SettingsScreenState();

  

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    Map map = ModalRoute.of(context).settings.arguments;
    WeatherBloc _weatherBloc  = map['weatherBloc'];
    _cityName = map['cityName'];
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primaryColor,
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        color: appTheme.primaryColor,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  _showCityChangeDialog(_weatherBloc);
                },
                child: Text(
                  "City",
                  style: TextStyle(
                    color: appTheme.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Use Current Location",
                    style: TextStyle(color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Switch(
                    value: useCurrentLocation,
                    onChanged: (bool _val){
                      setState(() {
                        useCurrentLocation = !useCurrentLocation;
                        _fetchWeatherWithLocation(_weatherBloc).catchError((error) {
                        _fetchWeatherWithCity(_weatherBloc);
                      });
                      });
                    },
                  )
                ],
              ),
            ),
            cityChooser(_weatherBloc),
            Padding(
              padding: EdgeInsets.only(top: 13,bottom: 5),
              child: Container(
                height: 1,
                color: appTheme.accentColor,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Theme",
            //     style: TextStyle(
            //       color: appTheme.accentColor,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            //     color: AppStateContainer.of(context)
            //         .theme
            //         .accentColor
            //         .withOpacity(0.1),
            //   ),
            //   padding: EdgeInsets.only(left: 10, right: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         "Dark",
            //         style: TextStyle(color: appTheme.accentColor),
            //       ),
            //       Radio(
            //         value: Themes.DARK_THEME_CODE,
            //         groupValue: AppStateContainer.of(context).themeCode,
            //         onChanged: (value) {
            //           AppStateContainer.of(context).updateTheme(value);
            //         },
            //         activeColor: appTheme.accentColor,
            //       )
            //     ],
            //   ),
            // ),
            // Divider(
            //   color: appTheme.primaryColor,
            //   height: 1,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(8),
            //         bottomRight: Radius.circular(8)),
            //     color: AppStateContainer.of(context)
            //         .theme
            //         .accentColor
            //         .withOpacity(0.1),
            //   ),
            //   padding: EdgeInsets.only(left: 10, right: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         "Light",
            //         style: TextStyle(color: appTheme.accentColor),
            //       ),
            //       Radio(
            //         value: Themes.LIGHT_THEME_CODE,
            //         groupValue: AppStateContainer.of(context).themeCode,
            //         onChanged: (value) {
            //           AppStateContainer.of(context).updateTheme(value);
            //         },
            //         activeColor: appTheme.accentColor,
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 13,bottom: 5),
            //   child: Container(
            //     height: 1,
            //     color: appTheme.accentColor,
            //   ),
            // ),
            Padding(
              padding:
                  const EdgeInsets.all(8),
              child: Text(
                "Unit",
                style: TextStyle(
                  color: appTheme.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Celsius",
                    style: TextStyle(color: appTheme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.celsius.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor: appTheme.accentColor,
                  )
                ],
              ),
            ),
            Divider(
              color: appTheme.primaryColor,
              height: 1,
            ),
            Container(
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor
                  .withOpacity(0.1),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Fahrenheit",
                    style: TextStyle(color: appTheme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.fahrenheit.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor: appTheme.accentColor,
                  )
                ],
              ),
            ),
            Divider(
              color: appTheme.primaryColor,
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Kelvin",
                    style: TextStyle(color: appTheme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.kelvin.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor: appTheme.accentColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget cityChooser(_weatherBloc){
    if(useCurrentLocation){
      return EmptyWidget();
    }else{
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: AppStateContainer.of(context)
                .theme
                .accentColor
                .withOpacity(0.1),
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _cityName,
                style: TextStyle(color: AppStateContainer.of(context).theme.accentColor),
              ),
              IconButton(
                icon: Icon(Icons.edit,color: AppStateContainer.of(context).theme.accentColor,),
                onPressed: (){
                  _showCityChangeDialog(_weatherBloc);
                },
              )
            ],
          ),
        );
    }
  }
  void _showCityChangeDialog(WeatherBloc _weatherBloc) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          ThemeData appTheme = AppStateContainer.of(context).theme;
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Change city', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                style: TextButton.styleFrom(
                  primary: appTheme.accentColor,
                  elevation: 1,
                ),
                onPressed: () {
                  _fetchWeatherWithCity(_weatherBloc);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: TextField(
              autofocus: true,
              onChanged: (text) {
                _cityName = text;
              },
              decoration: InputDecoration(
                  hintText: 'Name of your city',
                  hintStyle: TextStyle(color: Colors.black),
                  // suffixIcon: GestureDetector(
                  //   onTap: () {
                  //     _fetchWeatherWithLocation(_weatherBloc).catchError((error) {
                  //       _fetchWeatherWithCity(_weatherBloc);
                  //     });
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Icon(
                  //     Icons.my_location,
                  //     color: Colors.black,
                  //     size: 16,
                  //   ),
                  // )
                  ),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
            ),
          );
        });
  }
  _fetchWeatherWithCity(WeatherBloc _weatherBloc) {
    _weatherBloc.add(FetchWeather(cityName: _cityName));
  }

  _fetchWeatherWithLocation(WeatherBloc _weatherBloc) async {
    var permissionResult = await Permission.locationWhenInUse.status;

    switch (permissionResult) {
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        print('location permission denied');
        _showLocationDeniedDialog();
        break;

      case PermissionStatus.denied:
        await Permission.locationWhenInUse.request();
        _fetchWeatherWithLocation(_weatherBloc);
        break;

      case PermissionStatus.limited:
      case PermissionStatus.granted:
        print('getting location');
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 2));

        print(position.toString());

        _weatherBloc.add(FetchWeather(
          longitude: position.longitude,
          latitude: position.latitude,
        ));
        break;
    }
  }
  void _showLocationDeniedDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          ThemeData appTheme = AppStateContainer.of(context).theme;

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Location is disabled :(',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('Enable!'),
                style: TextButton.styleFrom(
                  primary: appTheme.accentColor,
                  elevation: 1,
                ),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
