import 'dart:convert';
import 'package:canteen_meals/Meal.dart';
import 'package:flutter/material.dart';

import 'AppConstant.dart';


class MealsOriginalWidget extends StatefulWidget{
  final Meal meal;
  var decodedBytes;
  MealsOriginalWidget(this.meal){
    if(meal.originalImg.isNotEmpty) {
      decodedBytes = base64Decode(meal.originalImg);
    }
  }
  @override
  _MealsOriginalWidget createState() => _MealsOriginalWidget();
}

class _MealsOriginalWidget extends State<MealsOriginalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1, top: 20),
      //height: 320,
      width: double.infinity,
      padding:
      const EdgeInsets.only(
          left: 20, right: 20, bottom: 10),
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
            if(widget.meal.originalImg.isNotEmpty)...{
              CircleAvatar(
                radius: 72.0,
                backgroundColor: Colors.transparent,
                backgroundImage:MemoryImage(widget.decodedBytes),
                ),
            },
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.meal.originalWeekDay,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("${AppConstant.SOUP_LABEL}: ${widget.meal.originalSoup}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.MEAT_LABEL}: ${widget.meal.originalMeat}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${AppConstant.FISH_LABEL}: ${widget.meal.originalFish}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.VEGETARIAN_LABEL}: ${widget.meal.originalVegetarian}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.DESERT_LABEL}: ${widget.meal.originalDesert}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MealsUpdatedWidget extends StatefulWidget{
  final Meal meal;
  var decodedBytes;
  MealsUpdatedWidget(this.meal){
    if(meal.originalImg.isNotEmpty) {
      decodedBytes = base64Decode(meal.originalImg);
    }
  }

  @override
  _MealsUpdatedWidget createState() => _MealsUpdatedWidget();
}

class _MealsUpdatedWidget extends State<MealsUpdatedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 25),
      //height: 320,
      width: double.infinity,
      padding:
      const EdgeInsets.only(
          left: 20, right: 20, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7b7126),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(80, 100),
            bottomRight: Radius.elliptical(80, 100),
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
            if(widget.meal.updatedImg.isNotEmpty)...{
              CircleAvatar(
                radius: 72.0,
                backgroundColor: Colors.transparent,
                backgroundImage:MemoryImage(widget.decodedBytes),
              ),
            },
            Text(widget.meal.updatedWeekDay,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            const Text("${AppConstant.UPDATED_LABEL}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("${AppConstant.SOUP_LABEL}: ${widget.meal.updatedSoup}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.MEAT_LABEL}: ${widget.meal.updatedMeat}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${AppConstant.FISH_LABEL}: ${widget.meal.updatedFish}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.VEGETARIAN_LABEL}: ${widget.meal.updatedVegetarian}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("${AppConstant.DESERT_LABEL}: ${widget.meal.updatedDesert}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
