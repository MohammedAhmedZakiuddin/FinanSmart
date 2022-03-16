import 'package:flutter_test/flutter_test.dart';
import 'package:uchiha_saving/tools/greeting.dart';

main() {
  test("Time helper should return Good Morning", () {
    //Arrange
    var dateTime = DateTime(2021, 1, 1, 5);
    String day_hour = greeting(dateTime);
    //act
    //Assert
    expect(day_hour, "Good Morning");
  });

  test("Time helper should return Good Afternoon", () {
    //Arrange
    var dateTime = DateTime(2021, 1, 1, 13);
    String day_hour = greeting(dateTime);
    //act
    //Assert
    expect(day_hour, "Good Afternoon");
  });

  test("Time helper should return Good Evening", () {
    //Arrange
    DateTime dateTime = DateTime(2021, 1, 1, 18);
    String day_hour = greeting(dateTime);
    //act
    //Assert
    expect(day_hour, "Good Evening");
  });

  test("Time helper should return Good Night", () {
    //Arrange
    var dateTime = DateTime(2021, 1, 1, 22);
    String day_hour = greeting(dateTime);
    //act
    //Assert
    expect(day_hour, "Good Night");
  });
}
