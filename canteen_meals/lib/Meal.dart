import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'AppConstant.dart';

class Meal{
  final String originalImg;
  final String originalWeekDay;
  final String originalSoup;
  final String originalFish;
  final String originalMeat;
  final String originalVegetarian;
  final String originalDesert;

  String updatedImg = '';
  String updatedWeekDay = '';
  String updatedSoup = '';
  String updatedFish = '';
  String updatedMeat = '';
  String updatedVegetarian = '';
  String updatedDesert = '';
  bool mealUpdate = false;

  Meal.fromJson(Map<String , dynamic> json):
        originalImg = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.IMG_JSON] ?? '',
        originalWeekDay = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.WEEKDAY_JSON] ?? '',
        originalSoup = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.SOUP_JSON] ?? '',
        originalFish = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.FISH_JSON] ?? '',
        originalMeat = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.MEAT_JSON] ?? '',
        originalVegetarian = json[AppConstant.ORIGINAL_JSON] ? [AppConstant.VEGETARIAN_JSON] ?? '',
        originalDesert =  json[AppConstant.ORIGINAL_JSON] ? [AppConstant.DESERT_JSON] ?? '',

        mealUpdate = (json[AppConstant.UPDATE_JSON] ? [AppConstant.WEEKDAY_JSON] ?? '').isNotEmpty{
        updatedImg = json[AppConstant.UPDATE_JSON] ? [AppConstant.IMG_JSON] ?? '';
        updatedWeekDay = json[AppConstant.UPDATE_JSON] ? [AppConstant.WEEKDAY_JSON] ?? '';
        updatedSoup = json[AppConstant.UPDATE_JSON] ? [AppConstant.SOUP_JSON] ?? '';
        updatedFish = json[AppConstant.UPDATE_JSON] ? [AppConstant.FISH_JSON] ?? '';
        updatedMeat = json[AppConstant.UPDATE_JSON] ? [AppConstant.MEAT_JSON] ?? '';
        updatedVegetarian = json[AppConstant.UPDATE_JSON] ? [AppConstant.VEGETARIAN_JSON] ?? '';
        updatedDesert =  json[AppConstant.UPDATE_JSON] ? [AppConstant.DESERT_JSON] ?? '';
      }

    static Future<void> mealPost(List<String> input) async {

      String url = AppConstant.MEALS_URL;
      Map map = {
        input[0] : {'update' : {
          'weekDay' : input[0],
          'soup' : input[1],
          'fish' : input[3],
          'meat' : input[2],
          'vegetarian' : input[4],
          'desert' : input[5],
        }}
      };
      debugPrint(await apiRequest(url, map));

    }

    static Future<String> apiRequest(String url , Map jsonMap) async{

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.contentType = ContentType("application", "json", charset: "utf-8");
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // Verificar o status code
      debugPrint(response.statusCode.toString());
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return reply;
    }
}