import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

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
        originalImg = json['original'] ? ['img'] ?? '',
        originalWeekDay = json['original'] ? ['weekDay'] ?? '',
        originalSoup = json['original'] ? ['soup'] ?? '',
        originalFish = json['original'] ? ['fish'] ?? '',
        originalMeat = json['original'] ? ['meat'] ?? '',
        originalVegetarian = json['original'] ? ['vegetarian'] ?? '',
        originalDesert =  json['original'] ? ['desert'] ?? '',

        mealUpdate = (json['update'] ? ['weekDay'] ?? '').isNotEmpty{
        updatedImg = json['update'] ? ['img'] ?? '';
        updatedWeekDay = json['update'] ? ['weekDay'] ?? '';
        updatedSoup = json['update'] ? ['soup'] ?? '';
        updatedFish = json['update'] ? ['fish'] ?? '';
        updatedMeat = json['update'] ? ['meat'] ?? '';
        updatedVegetarian = json['update'] ? ['vegetarian'] ?? '';
        updatedDesert =  json['update'] ? ['desert'] ?? '';
      }

    static Future<void> mealPost(List<String> input) async {

      String url = "...";
      Map map = {
        input[0] : {'updated' : {
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
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // Verificar o status code
      debugPrint(response.toString());
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return reply;
    }
}