import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';

import 'Meal.dart';

class EditScreen extends StatefulWidget {
  final String title = "Edit Meal";
  final Meal meal;

  const EditScreen(this.meal , {Key? key}) : super(key : key);

  static const String routName = '/EditScreen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {

  //final updatedImg = TextEditingController();
  final updatedWeekDay = TextEditingController();
  final updatedSoup = TextEditingController();
  final updatedMeat = TextEditingController();
  final updatedFish = TextEditingController();
  final updatedVegetarian = TextEditingController();
  final updatedDesert = TextEditingController();
  //bool isValid = true;

  void clearInput(){
    setState(() {
      updatedWeekDay.text = "";
      updatedSoup.text = "";
      updatedMeat.text = "";
      updatedFish.text = "";
      updatedVegetarian.text = "";
      updatedDesert.text = "";
    });
  }

  void updateMeal(){
    setState(() {
      List<String> inputs = [];
      inputs.add( (updatedWeekDay.text.isNotEmpty) ?
        updatedWeekDay.text : widget.meal.originalWeekDay);

      inputs.add((updatedMeat.text.isNotEmpty) ?
        updatedMeat.text : widget.meal.originalMeat);

      inputs.add((updatedFish.text.isNotEmpty) ?
        updatedFish.text : widget.meal.originalFish);

      inputs.add((updatedVegetarian.text.isNotEmpty) ?
        updatedVegetarian.text : widget.meal.originalVegetarian);

      inputs.add((updatedDesert.text.isNotEmpty) ?
        updatedDesert.text : widget.meal.originalDesert);
      Meal.mealPost(inputs);

      clearInput();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.title),
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Original Meal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            MealsOriginalWidget(widget.meal),
            const Text(
              "Updated Meal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              maxLines: 1,
              controller: updatedWeekDay,
              onChanged: (inputValue){
                // if(inputValue.isEmpty){
                //   setValidator(true);
                // }else{
                //   setValidator(false);
                // }
              },
              decoration: InputDecoration(
                hintText: "Weekday",
                //errorText: isValid ? null : "This item cant be empty",
              ),
            ),
            TextField(
              onChanged: (inputValue){
                // if(inputValue.isEmpty){
                //   setValidator(true);
                // }else {
                //   setValidator(false);
                // }
              },
              decoration: InputDecoration(
                hintText: "Soup",
                //errorText: isValid ? null : "This item cant be empty",
              ),
              controller: updatedSoup,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Meat",
              ),
              controller: updatedMeat,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Fish",
              ),
              controller: updatedFish,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Vegetarian",
              ),
              controller: updatedVegetarian,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Desert",
              ),
              controller: updatedDesert,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      ),
                    ),
                  ),
                  onPressed: () => null,
                  child: Text(
                    "Reset to Original".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)
                      ),
                    ),
                  ),
                  onPressed: () => updateMeal(),
                  child: Text(
                    "Update Meal".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}