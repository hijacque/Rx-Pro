int getAge(DateTime birthdate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthdate.year;
  birthdate = birthdate.copyWith(year: currentDate.year);

  if (birthdate.isAfter(currentDate)) {
    // haven't had their birthday this year yet
    age -= 1;
  }

  return age;
}