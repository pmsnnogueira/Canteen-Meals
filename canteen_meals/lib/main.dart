import 'dart:convert';
import 'dart:io';
import 'package:canteen_meals/Meal.dart';
import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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


  /// This functions connects with the website and converts the json to an list of meals.
  List<Meal>? _meals = [];
  bool _fetchingData = false;
  Future<void> _fetchMeals() async {
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(AppConstant.MEALS_URL));
      //debugPrint(${response.statusCode.toString()}");
      if (response.statusCode == HttpStatus.ok) { // import do dart.io, não do html
        final mealsData = json.decode(utf8.decode(response.body.codeUnits));
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

  @override
  void initState() {
    super.initState();
    // Get the first day of the week (Monday)
    actualMonday = today.weekday == 7 ? today.add(const Duration(days: 1)) : today.subtract(Duration(days: today.weekday - 1));
    dateText = DateFormat(AppConstant.DATE_FORMAT).format(today);

    _fetchMeals();
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
                            onPressed: (context) => _incrementWeek(),
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
        )
      );
  }
}
