import 'package:canteen_meals/AppConstant.dart';
import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';

import 'Meal.dart';
import 'AppConstant.dart';
import 'main.dart';

class EditScreen extends StatefulWidget {
  final Meal meal;

  const EditScreen(this.meal , {Key? key}) : super(key : key);

  static const String routName = AppConstant.ROUTENAME_EDIT_SCREEN;

  @override
  State<EditScreen> createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {

  //final updatedImg = TextEditingController();
  final updatedSoup = TextEditingController();
  final updatedMeat = TextEditingController();
  final updatedFish = TextEditingController();
  final updatedVegetarian = TextEditingController();
  final updatedDesert = TextEditingController();
  //bool isValid = true;

  void clearInput(){
    setState(() {
      updatedSoup.text = "";
      updatedMeat.text = "";
      updatedFish.text = "";
      updatedVegetarian.text = "";
      updatedDesert.text = "";
    });
  }

  void updateMeal(bool original){
    setState(() {
      List<String> inputs = [];
      inputs.add(widget.meal.originalWeekDay);

      inputs.add((updatedSoup.text.isNotEmpty) ?
        updatedSoup.text : widget.meal.originalSoup);

      inputs.add((updatedMeat.text.isNotEmpty) ?
        updatedMeat.text : widget.meal.originalMeat);

      inputs.add((updatedFish.text.isNotEmpty) ?
        updatedFish.text : widget.meal.originalFish);

      inputs.add((updatedVegetarian.text.isNotEmpty) ?
        updatedVegetarian.text : widget.meal.originalVegetarian);

      inputs.add((updatedDesert.text.isNotEmpty) ?
        updatedDesert.text : widget.meal.originalDesert);

      Meal.mealPost(inputs , original);

      clearInput();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(AppConstant.EDIT_PAGE_NAME),
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            const Text(
              AppConstant.ORIGINAL_MEAL_LABEL,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            MealsOriginalWidget(widget.meal),
            const Text(
              AppConstant.UPDATED_MEAL_LABEL,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              //onChanged: (inputValue){
                // if(inputValue.isEmpty){
                //   setValidator(true);
                // }else {
                //   setValidator(false);
                // }
              //},
              decoration: const InputDecoration(
                hintText: AppConstant.SOUP_LABEL,
                //errorText: isValid ? null : "This item cant be empty",
              ),
              controller: updatedSoup,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: AppConstant.MEAT_LABEL,
              ),
              controller: updatedMeat,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: AppConstant.FISH_LABEL,
              ),
              controller: updatedFish,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: AppConstant.VEGETARIAN_LABEL,
              ),
              controller: updatedVegetarian,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: AppConstant.DESERT_LABEL,
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
                          side: const BorderSide(color: Colors.red)
                      ),
                    ),
                  ),
                  onPressed: () {
                    updateMeal(true);
                    widget.meal.mealUpdate = false;
                  },//Voltar ao menu original
                  child: Text(
                    AppConstant.RESET_ORIGINAL_LABEL.toUpperCase(),
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
                          side: const BorderSide(color: Colors.green)
                      ),
                    ),
                  ),
                  onPressed: () => updateMeal(false),
                  child: Text(
                    AppConstant.UPDATED_MEAL_LABEL.toUpperCase(),
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