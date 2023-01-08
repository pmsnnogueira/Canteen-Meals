import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:canteen_meals/Meal.dart';
import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditScreen.dart';
import 'AppConstant.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstant.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.container,
      ),
      initialRoute: MyHomePage.routeName,
      routes:{
        MyHomePage.routeName : (context) => const MyHomePage(title: AppConstant.APP_NAME),
        //EditScreen.routName : (context) => EditScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  static const String routeName = AppConstant.ROUTENAME_HOMEPAGE;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  DateTime today = DateTime.now();    //Proprio dia que nunca é mudado
  DateTime date = DateTime.now();     //date alteravel
  late DateTime actualMonday;
  late String dateText = ' ';
  String? _currentAddress;
  Position? _currentPosition;


  /// This functions connects with the website and converts the json to an list of meals.
  List<Meal>? _meals = [];
  bool _fetchingData = false;
  Future<void> _fetchMeals() async {
    try {
      setState(() => _fetchingData = true);

      http.Response response = await http.get(Uri.parse(AppConstant.MEALS_URL));

      if (response.statusCode == HttpStatus.ok) { // import do dart.io, não do html
        final mealsData = json.decode(utf8.decode(response.body.codeUnits));
        saveMeals(response.bodyBytes);

        final meals = <Meal>[];
        mealsData.forEach((weekDay, data) {
          final meal = Meal.fromJson(data);
          meals.add(meal);

        });
        setState(() => _meals = meals);
      }
    } catch (e) {
      debugPrint('Something went wrong: $e');
    } finally {
      setState(() => _fetchingData = false);
    }
  }


  Future<void> _fetchLoadMeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() => _fetchingData = true);

      if(prefs.containsKey('listMeals') == true){
        final Uint8List response = await loadMeals();

        final mealsData = json.decode(utf8.decode(response));
        final meals = <Meal>[];

        mealsData.forEach((weekDay, data) {
          final meal = Meal.fromJson(data);
          meals.add(meal);
        });
        setState(() => _meals = meals);
      }else{
        setState(() {
          _fetchingData = false;
        });
      }

    } catch (e) {
      debugPrint('Something went wrong: $e');
    } finally {
      setState(() => _fetchingData = false);
    }
  }


  static Future<bool> saveMeals(Uint8List meals) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(meals);
    return prefs.setString("listMeals", base64Image);
  }

  static Future<Uint8List> loadMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uint8List bytes = base64Decode(prefs.getString("listMeals") ?? '');
    return bytes;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }  if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }  return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();  if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }


  @override
  void initState() {
    super.initState();
    // Get the first day of the week (Monday)
    actualMonday = today.weekday == 7 ? today.add(const Duration(days: 1)) : today.subtract(Duration(days: today.weekday - 1));
    dateText = DateFormat(AppConstant.DATE_FORMAT).format(today);


    if(today.weekday == 7){
      date = date.add(const Duration(days:1));
      today = today.add(const Duration(days: 1));
    }
    if(today.weekday == 6){
      date = date.add(const Duration(days:2));
      today = today.add(const Duration(days: 2));
    }
    dateText = DateFormat(AppConstant.DATE_FORMAT).format(date);



    /*Future<bool> geoLocal = _handleLocationPermission();
    _getCurrentPosition();
    debugPrint(_currentAddress);
    debugPrint(_currentPosition.toString());*/
    //_meals = getSavedMeals();
   
    //_fetchMeals();
    //saveMeals();

    //loadMeals();
    //meals();
    _fetchLoadMeals();

  }

  Future<void> meals() async {
    await _fetchLoadMeals();
    if(_meals!.isEmpty){
      await _fetchMeals();
      //await saveMeals();
    }
  }

  ///_decrementWeek functions is used to decrement the week
  void _decrementWeek() {
    setState(() {
      if (date.isAfter(today)) { //Passa para a proxima segunda Feira
        //Decrementar uma semana ao dateTime que posso alterar
        if (date == today) {
          date = actualMonday.subtract(const Duration(days: 7));
          actualMonday = actualMonday.subtract(const Duration(days: 7));
        } else if (date != today) {
          date = actualMonday.subtract(const Duration(days: 7));
          actualMonday = actualMonday.subtract(const Duration(days: 7));
        }
      }
      if(date.isBefore(today)){
        date = today;
      }

      dateText = DateFormat(AppConstant.DATE_FORMAT).format(date);
    });
  }

  ///_incrementWeek functions is used to increment the week
  void _incrementWeek() {
    setState(() {
      if (date.isAfter(today) || date == today) { //Passa para a proxima segunda Feira
        //Incrementar uma semana ao dateTime que posso alterar
        if (date == today) {
          date = actualMonday.add(const Duration(days: 7));
          actualMonday = actualMonday.add(const Duration(days: 7));
        } else if (date != today) {
          date = actualMonday.add(const Duration(days: 7));
          actualMonday = actualMonday.add(const Duration(days: 7));
        }
      }
      dateText = DateFormat(AppConstant.DATE_FORMAT).format(date);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstant.APP_NAME),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                heroTag: null,
                label: const Text(
                  AppConstant.PREVIOUS_WEEK,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () async {
                  _decrementWeek();
                  //_fetchMeals();
                  //debugPrint('Card -> $_meals');
                  //debugPrint('Week -> ${date.toString()}');
                  //Map<String, dynamic> mondayMeal = await getMealForDay(_mealsUrl, 'MONDAY');
                },
              ),
              const SizedBox(
                width: 20,
              ),
              Text(dateText),
              const SizedBox(
                width: 20,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                label: const Text(
                    AppConstant.NEXT_WEEK,
                  style: TextStyle(
                    fontSize: 25,
                  ),),
                onPressed: () {
                  _incrementWeek();
                  //_fetchMeals();
                },
              ),
            ],
          ),
          if (_fetchingData) const CircularProgressIndicator(),
          if (!_fetchingData && _meals != null && _meals!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _meals!.length,
                itemBuilder: (context,index){
                  var aux = DateTime.now();
                  if(aux.day == date.day && aux.month == date.month && aux.year == date.year &&
                    (AppConstant.WEEKDAYNUMBER[_meals![index].originalWeekDay.toLowerCase()] ?? 0) < today.weekday){
                    return const Offstage();
                  }
                  if(!_meals![index].mealUpdate){
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: AppConstant.EDIT_LABEL,
                            onPressed: (context) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(_meals![index]),
                                ),
                            ),
                          )
                        ],
                      ),
                      child: MealsOriginalWidget(_meals![index]),
                    );
                  }else{
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: AppConstant.EDIT_LABEL,
                            onPressed: (context) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreen(_meals![index]),
                              ),
                            ),
                          )
                        ],
                      ),
                      child: MealsUpdatedWidget(_meals![index]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _fetchMeals,
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),)
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
