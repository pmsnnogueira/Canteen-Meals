import 'dart:convert';
import 'dart:io';
import 'package:canteen_meals/Meal.dart';
import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen Meals',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.container,
      ),
      home: const MyHomePage(title: 'Canteen Meals'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}






class _MyHomePageState extends State<MyHomePage> {

  static const String _mealsUrl = "http://amov.servehttp.com:8080/menu";

  static const Map<int, String> weekdayName = {1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"};
  static const Map<String, int> weekdayNumber = {"monday": 1, "tuesday": 2, "wednesday": 3, "thursday" : 4 , "friday" : 5, "saturday": 6, "sunday" : 7};

  DateTime today = DateTime.now();    //Proprio dia que nunca é mudado
  DateTime date = DateTime.now();     //date alteravel
  late int day;   //Dia que anda a ser escolhido pelo user
  late DateTime actualMonday;
  late String dateText = ' ';


  /// This functions connects with the website and converts the json to an list of meals.
  List<Meal>? _meals = [];
  bool _fetchingData = false;
  Future<void> _fetchMeals() async {
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(_mealsUrl));
      if (response.statusCode == HttpStatus.ok) { // import do dart.io, não do html
        final mealsData = json.decode(response.body);
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
    day = today.weekday;    //Dia atual da semana em String ex -> monday
    //actualWeek = DateFormat('dd/MM/yyyy').format(today);      //Semana Atual ex -> 27/12/2022

    // Get the first day of the week (Monday)
    actualMonday = today.weekday == 7 ? today.add(Duration(days: 1)) : today.subtract(Duration(days: today.weekday - 1));
    debugPrint(today.toString());

    dateText = DateFormat('dd/MM/yyyy').format(today);

    _fetchMeals();
  }

  void _decrementWeek() {
    setState(() {
      if (date.isAfter(today)) { //Passa para a proxima segunda Feira
        //Decrementar uma semana ao dateTime que posso alterar
        if (date == today) {
          date = actualMonday.subtract(Duration(days: 7));
          actualMonday = actualMonday.subtract(Duration(days: 7));
        } else if (date != today) {
          date = actualMonday.subtract(Duration(days: 7));
          actualMonday = actualMonday.subtract(Duration(days: 7));
        }
      }
      if(date.isBefore(today)){
        date = today;
      }

      dateText = DateFormat('dd/MM/yyyy').format(date);
    });
  }

  void _incrementWeek() {
    setState(() {
      if (date.isAfter(today) || date == today) { //Passa para a proxima segunda Feira
        //Incrementar uma semana ao dateTime que posso alterar
        if (date == today) {
          date = actualMonday.add(Duration(days: 7));
          actualMonday = actualMonday.add(Duration(days: 7));
        } else if (date != today) {
          date = actualMonday.add(Duration(days: 7));
          actualMonday = actualMonday.add(Duration(days: 7));
        }
      }
      dateText = DateFormat('dd/MM/yyyy').format(date);
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
                  label: const Text('<'),
                  onPressed: () async {
                    _decrementWeek();
                    _fetchMeals();
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
                  label: const Text('>'),
                  onPressed: () {
                    _incrementWeek();
                    _fetchMeals();
                  }
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
                    (weekdayNumber[_meals![index].originalWeekDay.toLowerCase()] ?? 0) < today.weekday){
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
                            label: 'Edit',
                            onPressed: (context) => _incrementWeek(),
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
                            label: 'Edit',
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
