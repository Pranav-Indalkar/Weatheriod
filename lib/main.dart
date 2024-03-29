import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/bloc/weather_bloc_observer.dart';
import 'package:flutter_weather/src/screens/routes.dart';
import 'package:flutter_weather/src/screens/weather_screen.dart';
import 'package:flutter_weather/src/themes.dart';
import 'package:flutter_weather/src/utils/constants.dart';
import 'package:flutter_weather/src/utils/converters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'src/api/weather_api_client.dart';
import 'src/bloc/weather_bloc.dart';
import 'src/repository/weather_repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
      apiKey: "003ab8ae38b892e0136be889f63729c6",
    ),
  );

  runApp(AppStateContainer(
    child: WeatherApp(weatherRepository: weatherRepository),
  ));
}

class WeatherApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  WeatherApp({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: AppStateContainer.of(context).theme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: weatherRepository),
        child: WeatherScreen(),
      ),
      routes: Routes.mainRoute,
    );
  }
}

/// top level widget to hold application state
/// state is passed down with an inherited widget
/// inherited widget state is mainly used to hold app theme and temerature unit
class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({@required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    var widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    return widget.data;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {
  ThemeData _theme = Themes.getTheme(Themes.DARK_THEME_CODE);
  int themeCode = Themes.DARK_THEME_CODE;
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;
  bool useCurrentLocation = true;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPref) {
      setState(() {
        DateTime now = DateTime.now();
        if(now.hour >= 7 && now.hour < 19){
          themeCode = Themes.LIGHT_THEME_CODE;
        }else{
          themeCode = Themes.DARK_THEME_CODE;
        }
        temperatureUnit = TemperatureUnit.values[
            sharedPref.getInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT) ??
                TemperatureUnit.celsius.index];
        useCurrentLocation = sharedPref.getBool(CONSTANTS.SHARED_PREF_USE_LOCATION) ?? true;
        this._theme = Themes.getTheme(themeCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(theme.accentColor);
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  ThemeData get theme => _theme;

  updateTheme(int themeCode) {
    _theme = Themes.getTheme(themeCode);
    this.themeCode = themeCode;
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_THEME, themeCode);
    });
  }

  updateUseLocation(bool useLocation){
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setBool(CONSTANTS.SHARED_PREF_USE_LOCATION,useLocation);
      print("Use Location " + sharedPref.getBool(CONSTANTS.SHARED_PREF_USE_LOCATION).toString());
    });
    this.useCurrentLocation = useLocation;
  }

  updateTemperatureUnit(TemperatureUnit unit) {
    setState(() {
      this.temperatureUnit = unit;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT, unit.index);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  const _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) => true;
}
