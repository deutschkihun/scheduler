import 'package:flutter/material.dart';
import 'package:scheduler/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  const MainCalendar(
      {required this.onDaySelected, required this.selectedDate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      focusedDay: DateTime.now(),
      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0)),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: LIGHT_GREY_COLOR),
          weekendDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: LIGHT_GREY_COLOR),
          selectedDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: PRIMARY_COLOR)),
          defaultTextStyle:
              TextStyle(fontWeight: FontWeight.w700, color: DARK_GREY_COLOR),
          weekendTextStyle:
              TextStyle(fontWeight: FontWeight.w700, color: DARK_GREY_COLOR),
          selectedTextStyle:
              TextStyle(fontWeight: FontWeight.w600, color: PRIMARY_COLOR)),
    );
  }
}
