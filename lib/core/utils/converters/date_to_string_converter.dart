class DateToStringConverter {
  String converter(DateTime date) => date.toString().split(' ').first;
}