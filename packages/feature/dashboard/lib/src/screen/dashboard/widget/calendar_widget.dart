import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../dashboard_bloc.dart';
import 'calendar_cell.dart';

class CalendarWidget extends StatelessWidget {
  final Function(DateTime, DateTime)? onDateSelected;
  final Function(DateTime)? onPageChanged;

  const CalendarWidget({
    super.key,
    this.onDateSelected,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) {
        return prev.selectedDate != curr.selectedDate || prev.focusedDate != curr.focusedDate;
      },
      builder: (context, state) {
        return TableCalendar(
          firstDay: state.firstDay,
          lastDay: state.lastDay,
          focusedDay: state.focusedDate,
          selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
          calendarFormat: CalendarFormat.month,
          rowHeight: 40.0,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          onDaySelected: onDateSelected,
          onPageChanged: onPageChanged,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return CalendarCell(day: day.day.toString());
            },
            selectedBuilder: (context, day, focusedDay) {
              return CalendarCell(
                day: day.day.toString(),
                color: Colors.blue,
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return CalendarCell(
                day: day.day.toString(),
                color: Colors.orange,
              );
            },
          ),
        );
      },
    );
  }
}
