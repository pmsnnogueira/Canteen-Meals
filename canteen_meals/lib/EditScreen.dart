import 'dart:convert';

import 'package:canteen_meals/AppConstant.dart';
import 'package:canteen_meals/MyWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Meal.dart';

class EditScreen extends StatefulWidget {
  final Meal meal;

  const EditScreen(this.meal , {Key? key}) : super(key : key);

  static const String routName = AppConstant.ROUTENAME_EDIT_SCREEN;

  @override
  State<EditScreen> createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {

  double latitude = 0.0, longitude = 0.0;
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  late LocationData _locationData;
  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {});
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        latitude = currentLocation.latitude ?? 0;
        longitude = currentLocation.longitude ?? 0;
        var latDiff = latitude - isecLatitude;
        var longDiff = longitude - isecLongitude;
        debugPrint("lat: $latitude\nlong: $longitude");
        if((latDiff > - 0.01 || latDiff < 0.01) &&  (longDiff > - 0.01 || longDiff < 0.01)) {
          updateAvailable = true;
        } else {
          updateAvailable = false;
        }
      });
    });
  }

  bool updateAvailable = false;

  double isecLatitude = 40.192860490691935;
  double isecLongitude = -8.412703369001143;


  Future<void> _getCoordinates() async {
    if (!_serviceEnabled || _permissionGranted != PermissionStatus.granted) {
      return;
    }
    _locationData = await location.getLocation();
    setState(() {
      latitude = _locationData.latitude ?? 0.0;
      longitude = _locationData.longitude ?? 0.0;
    });
  }



  String _image = '';
  final imagePicker = ImagePicker();

  //final updatedImg = TextEditingController();
  final updatedSoup = TextEditingController();
  final updatedMeat = TextEditingController();
  final updatedFish = TextEditingController();
  final updatedVegetarian = TextEditingController();
  final updatedDesert = TextEditingController();
  //bool isValid = true;

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      File temp = File(image!.path);
      _image = base64Encode(temp.readAsBytesSync());
      widget.meal.updatedImg = _image;
    });
  }

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
    if(!updateAvailable) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('To far away from the canteen')
        ),
      );
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        const SnackBar(
            content: Text('Updated successfully')
        ),
      );
    }

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

      inputs.add((updatedDesert.text.isNotEmpty) ?
      updatedDesert.text : widget.meal.originalDesert);

      inputs.add((_image.isNotEmpty) ? _image : '');

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
            if(_image.isNotEmpty)...{
              CircleAvatar(
                radius: 72.0,
                backgroundColor: Colors.transparent,
                backgroundImage:MemoryImage(base64Decode(_image)),
              ),
            },
            ElevatedButton(onPressed: getImage, child:const Text("Add Image")),
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