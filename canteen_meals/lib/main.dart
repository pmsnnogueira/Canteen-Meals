import 'dart:convert';
import 'dart:io';
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



class Meal{
  //final String img;
  final String originalWeekDay;
  final String originalSoup;
  final String originalFish;
  final String originalMeat;
  final String originalVegetarian;
  final String originalDesert;

  String updatedWeekDay = '';
  String updatedSoup = '';
  String updatedFish = '';
  String updatedMeat = '';
  String updatedVegetarian = '';
  String updatedDesert = '';
  bool mealUpdate = false;

  Meal.fromJson(Map<String , dynamic> json):
        originalWeekDay = json['original'] ? ['weekDay'] ?? '',
        originalSoup = json['original'] ? ['soup'] ?? '',
        originalFish = json['original'] ? ['fish'] ?? '',
        originalMeat = json['original'] ? ['meat'] ?? '',
        originalVegetarian = json['original'] ? ['vegetarian'] ?? '',
        originalDesert =  json['original'] ? ['desert'] ?? '',

        mealUpdate = (json['update'] ? ['weekDay'] ?? '').isNotEmpty{
          updatedWeekDay = json['update'] ? ['weekDay'] ?? '';
          updatedSoup = json['update'] ? ['soup'] ?? '';
          updatedFish = json['update'] ? ['fish'] ?? '';
          updatedMeat = json['update'] ? ['meat'] ?? '';
          updatedVegetarian = json['update'] ? ['vegetarian'] ?? '';
          updatedDesert =  json['update'] ? ['desert'] ?? '';
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
  static const Map<String, int> weekdayNumber = {"Monday": 1, "Tuesday": 2, "wednesday": 3, "Thursday" : 4 , "Friday" : 5, "Saturday": 6, "Sunday" : 7};

  DateTime today = DateTime.now();    //Proprio dia que nunca é mudado
  DateTime date = DateTime.now();
  late int day;   //Dia que anda a ser escolhido pelo user
  late DateTime actualMonday;
  late String dateText = ' ';


  List<Meal>? _meals = [];
  bool _fetchingData = false;
  Future<void> _fetchMeals() async {
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(_mealsUrl));
      if (response.statusCode == HttpStatus.ok) { // import do dart.io, não do html
        debugPrint(response.body);
        final mealsData = json.decode(response.body);
        final meals = <Meal>[];
        mealsData.forEach((weekDay, data) {
          final meal = Meal.fromJson(data);
          meals.add(meal);
        });
        setState(() => _meals = meals);

        //setState(() => _meals = [Meal.fromJson(decodedData)]);
        //setState(() => _meals = [Meal.fromJson(decodedData[weekdayName[day]?.toUpperCase()]['original'])]);
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
                    debugPrint('Card -> $_meals');
                    debugPrint('Week -> ${date.toString()}');
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
                     /* if(today.weekday < DateTime.parse('MONDAY').weekday) {   //Verificar se o dia da semana é menor que a o dia da meal
                        return Container();
                      }*/
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.green,
                                icon: Icons.edit,
                                label: 'Edit',
                                onPressed: (context) => _incrementWeek(),)
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 25),
                            //height: 320,
                            width: double.infinity,
                            padding:
                            const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFf363f93),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.elliptical(80, 100),
                                  topRight: Radius.elliptical(80, 100),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFf363f93)
                                          .withOpacity(0.6),
                                      offset: const Offset(-10.0, 0.0),
                                      blurRadius: 10,
                                      spreadRadius: 2),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                left: 32,
                                top: 50.0,
                                bottom: 50,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Fazer o if para verificar se há atualizados
                                  if(!_meals![index].mealUpdate)...{
                                    Text(
                                      _meals![index].originalWeekDay,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text("Soup: ${_meals![index].originalSoup}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Meat: ${_meals![index].originalMeat}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Fish: ${_meals![index].originalFish}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Vegetarian: ${_meals![index]
                                        .originalVegetarian}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Desert: ${_meals![index]
                                        .originalDesert}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                  } else
                                    ...{ //Se houver um Update
                                      Text(
                                        _meals![index].updatedWeekDay,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Soup: ${_meals![index].updatedSoup}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Meat: ${_meals![index].updatedMeat}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Fish: ${_meals![index].updatedFish}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("Vegetarian: ${_meals![index]
                                          .updatedVegetarian}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("Desert: ${_meals![index]
                                          .updatedDesert}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                    },
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                  ),
                ),
          ],
          )
      );
            /*Expanded(
              child: ListView.separated(
                itemCount: _meals!.length,
                separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                itemBuilder: (BuildContext context, int index) => ListTile( // Podias até usar logo um text em vez do list Title
                  title: Text('WeekDay ${_meals![index].weekDay}'),
                  subtitle: Text(_meals![index].soup),
                ),
              ),
            )*/





        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        /*child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                    label: const Text('<'),
                    onPressed: (){}
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text('Data da semana'),
                const SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                    label: const Text('>'),
                    onPressed: (){}
                ),
              ],
            ),


            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

    );

*/

  }
}
