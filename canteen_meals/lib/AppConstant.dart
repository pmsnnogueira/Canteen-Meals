class AppConstant{
  static const String APP_NAME = "Canteen Meals";

  static const String EDIT_PAGE_NAME = "Edit Meal";

  static const String ROUTENAME_HOMEPAGE = '/';
  static const String ROUTENAME_EDIT_SCREEN = '/EditScreen';

  ///This is used to connect the android emulator with the pc localhost
  static const String MEALS_URL = "http://192.168.1.211:8080/menu";
  static const String IMAGE_URL = "http://192.168.1.211:8080/images/";
  ///Link for the professor public server with the json file
  ///Professor Github link: https://github.com/ansisec
  //static const String MEALS_URL = "http://amov.servehttp.com:8080/menu";

  static const Map<int, String> WEEKDAYNAME = {1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"};
  static const Map<String, int> WEEKDAYNUMBER = {"monday": 1, "tuesday": 2, "wednesday": 3, "thursday" : 4 , "friday" : 5, "saturday": 6, "sunday" : 7};

  static const String DATE_FORMAT = "dd/MM/yyyy";

  static const String NEXT_WEEK = ">";
  static const String PREVIOUS_WEEK = "<";

  static const String EDIT_LABEL = "Edit";

  static const String WEEKDAY_LABEL = "WeekDay";
  static const String SOUP_LABEL = "Soup";
  static const String MEAT_LABEL = "Meat";
  static const String FISH_LABEL = "Fish";
  static const String VEGETARIAN_LABEL = "Vegetarian";
  static const String DESERT_LABEL = "Desert";

  static const String ORIGINAL_MEAL_LABEL = "Original Meal";
  static const String UPDATED_MEAL_LABEL = "Updated Meal";
  static const String UPDATED_LABEL = "Updated";
  static const String ORIGINAL_LABEL = "Original";

  ///Labels for Edit Page buttons
  static const String RESET_ORIGINAL_LABEL = "Reset to Original";
  static const String UPDATE_MEAL_LABEL = "Update Meal";

  ///Strings for json
  static const String ORIGINAL_JSON = "original";
  static const String UPDATE_JSON = "update";
  static const String IMG_JSON = "img";
  static const String WEEKDAY_JSON = "weekDay";
  static const String SOUP_JSON = "soup";
  static const String FISH_JSON = "fish";
  static const String MEAT_JSON = "meat";
  static const String VEGETARIAN_JSON = "vegetarian";
  static const String DESERT_JSON = "desert";



}