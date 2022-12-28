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