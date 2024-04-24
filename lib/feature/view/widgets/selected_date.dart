// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateWidget extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? selectedDay;
  final bool Function(DateTime) onPressed;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(int) onPressedYear;
  final Function(String) onPressedMounth;

  const SelectDateWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.selectedDay,
    required this.onPressed,
    required this.onDaySelected,
    required this.onPressedYear,
    required this.onPressedMounth,
  });

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime? _selectedDay;
  @override
  void initState() {
    _selectedDay = widget.selectedDay;
    super.initState();
  }

  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 0.7 * MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Assets.icons.esc,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Select a date',
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  widget.selectedDay != null
                      ? AppButton(
                          height: 40,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 0.2 * MediaQuery.of(context).size.width,
                          onPressed: () async {
                            widget.onDaySelected
                                .call(widget.focusedDay, widget.focusedDay);
                            Navigator.pop(context);
                          },
                          label: 'Add',
                        )
                      : const SizedBox(width: 70),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPopupMenuButtonMonths(),
                        _buildPopupMenuButtonYears(),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: TableCalendar(
                        focusedDay: _selectedDay!,
                        firstDay: widget.firstDay,
                        lastDay: widget.lastDay,
                        sixWeekMonthsEnforced: false,
                        daysOfWeekHeight: 20.0,
                        weekNumbersVisible: false,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        shouldFillViewport: false,
                        calendarFormat: CalendarFormat.month,
                        rowHeight: 40,
                        headerVisible: false,
                        daysOfWeekVisible: false,
                        headerStyle: HeaderStyle(
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineMedium!,
                          leftChevronPadding: EdgeInsets.zero,
                          formatButtonPadding: EdgeInsets.zero,
                          rightChevronPadding: EdgeInsets.zero,
                          headerMargin: const EdgeInsets.only(
                              left: 40, right: 40, bottom: 10),
                          leftChevronMargin: EdgeInsets.zero,
                          rightChevronMargin: EdgeInsets.zero,
                          titleCentered: true,
                          formatButtonVisible: false,
                          headerPadding: EdgeInsets.zero,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.4)),
                          selectedDecoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            )),
                          ),
                          rowDecoration: const BoxDecoration(),
                          tablePadding: const EdgeInsets.only(top: 10),
                          weekendTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          todayTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          defaultTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          holidayTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          outsideTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          selectedTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          disabledTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          rangeEndTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          weekNumberTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          rangeStartTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                          withinRangeTextStyle:
                              Theme.of(context).textTheme.displayLarge!,
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDay),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = focusedDay;
                            _selectedDay = selectedDay;
                          });

                          widget.onDaySelected.call(selectedDay, selectedDay);
                        },
                        calendarBuilders: CalendarBuilders(
                          headerTitleBuilder: (context, day) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat('MMMM').format(day),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]));
  }

  Widget _buildPopupMenuButtonMonths() {
    return PopupMenuButton<String>(
      constraints: const BoxConstraints.expand(width: 250, height: 320),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      color: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      iconColor: Theme.of(context).colorScheme.background,
      shadowColor: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.zero,
      offset: const Offset(-550, 0),
      elevation: 0,
      onSelected: (String value) {
        setState(() {
          widget.onPressedMounth.call(
              value); // Убедимся, что onPressedMonth не равен null перед вызовом
          _selectedMonth = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return _buildMonthPopupMenuItems(context);
      },
      child: Row(
        children: [
          Assets.icons.arrowDown.svg(),
          const SizedBox(width: 5),
          Text(_selectedMonth, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMonthPopupMenuItems(BuildContext context) {
    // Список названий месяцев
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Создание PopupMenuItem для каждого месяца
    return months.map((String month) {
      final isFirst = months.first == month;
      final isLast = months.last == month;
      return PopupMenuItem<String>(
        padding: EdgeInsets.zero,
        value: month,
        height: 40,
        child: ListTile(
          focusColor: Theme.of(context).colorScheme.onBackground,
          splashColor: Theme.of(context).colorScheme.onBackground,
          hoverColor: Theme.of(context).colorScheme.onBackground,
          selectedColor: Theme.of(context).colorScheme.onBackground,
          selectedTileColor: Theme.of(context).colorScheme.onBackground,
          tileColor: _selectedMonth == month
              ? Theme.of(context).colorScheme.onBackground
              : Colors.transparent,
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          minLeadingWidth: 250,
          title: Container(
            height: 57,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: isFirst ? const Radius.circular(30) : Radius.zero,
                  bottom: isLast ? const Radius.circular(30) : Radius.zero,
                ),
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Text(month,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: _selectedMonth == month
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context)
                                .colorScheme
                                .onBackground) // Установка красного цвета для выбранного элемента
                    // Используйте стандартный цвет для остальных элементов
                    ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPopupMenuButtonYears() {
    return PopupMenuButton<int>(
      constraints: const BoxConstraints.expand(width: 250, height: 520),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      color: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      iconColor: Theme.of(context).colorScheme.background,
      shadowColor: Theme.of(context).colorScheme.background,
      // elevation: 0,
      iconSize: 0,
      padding: EdgeInsets.zero,
      onSelected: (int value) {
        setState(() {
          widget.onPressedYear.call(
              value); // Убедимся, что onPressedMonth не равен null перед вызовом
          _selectedYear = value;
        });
      },

      itemBuilder: (BuildContext context) {
        return _buildYearPopupMenuItems(context);
      },
      child: Row(
        children: [
          Assets.icons.arrowDown.svg(),
          const SizedBox(width: 5),
          Text(_selectedYear.toString(),
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  List<PopupMenuEntry<int>> _buildYearPopupMenuItems(BuildContext context) {
    // Список последних 10 лет
    final List<int> years =
        List.generate(10, (index) => (DateTime.now().year - index) + 6);

    // Создание PopupMenuItem для каждого года
    return years.map((int year) {
      // Определяем, является ли текущий элемент первым или последним
      final isFirst = years.first == year;
      final isLast = years.last == year;

      return PopupMenuItem<int>(
        value: year,
        height: 42,
        padding: EdgeInsets.zero,
        child: ListTile(
          minVerticalPadding: 0,
          focusColor: Theme.of(context).colorScheme.onBackground,
          splashColor: Theme.of(context).colorScheme.onBackground,
          hoverColor: Theme.of(context).colorScheme.onBackground,
          selectedColor: Theme.of(context).colorScheme.onBackground,
          selectedTileColor: Theme.of(context).colorScheme.onBackground,
          tileColor: _selectedYear == year
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.background,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(30) : Radius.zero,
              bottom: isLast ? const Radius.circular(30) : Radius.zero,
            ),
          ),
          title: Container(
            height: 57,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: isFirst ? const Radius.circular(30) : Radius.zero,
                bottom: isLast ? const Radius.circular(30) : Radius.zero,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '$year',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: _selectedYear == year
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

// class CalendarTimePicker extends StatefulWidget {
//   final DateTime focusedDay;
//   final DateTime firstDay;
//   final DateTime lastDay;
//   final DateTime selectedDay;
//   final bool Function(DateTime)? onPressed;
//   final Function(DateTime, DateTime)? onDaySelected;
//   final Function(int) onPressedYear;
//   final Function(String) onPressedMounth;

//   const CalendarTimePicker({
//     super.key,
//     required this.onPressed,
//     required this.focusedDay,
//     required this.firstDay,
//     required this.lastDay,
//     required this.selectedDay,
//     required this.onDaySelected,
//     required this.onPressedYear,
//     required this.onPressedMounth,
//   });

//   @override
//   State<CalendarTimePicker> createState() => _CalendarTimePickerState();
// }

// class _CalendarTimePickerState extends State<CalendarTimePicker> {
//   DateTime? _focusedDay;
//   DateTime? _selectedDay;
//   @override
//   void initState() {
//     _focusedDay = widget.focusedDay;
//     _selectedDay = _selectedDay;
//     super.initState();
//   }

//   String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
//   int _selectedYear = DateTime.now().year;
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }

// }

int getMonthIndex(String month) {
  switch (month) {
    case 'January':
      return 1;
    case 'February':
      return 2;
    case 'March':
      return 3;
    case 'April':
      return 4;
    case 'May':
      return 5;
    case 'June':
      return 6;
    case 'July':
      return 7;
    case 'August':
      return 8;
    case 'September':
      return 9;
    case 'October':
      return 10;
    case 'November':
      return 11;
    case 'December':
      return 12;
    default:
      return 0; // Если введен некорректный месяц, возвращаем 0 или можно выбрать любое другое значение
  }
}
