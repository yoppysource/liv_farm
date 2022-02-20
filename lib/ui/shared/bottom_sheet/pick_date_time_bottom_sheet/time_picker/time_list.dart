import 'package:flutter/material.dart';

import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/time_picker/time_button.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:liv_farm/util/time_of_day_extension.dart';

typedef TimeSelectedCallback = void Function(TimeOfDay hour);

class TimeList extends StatefulWidget {
  final TimeOfDay firstTime;
  final TimeOfDay lastTime;
  final TimeOfDay initialTime;
  final int timeStep;
  final int index;
  final double padding;
  final TimeSelectedCallback onHourSelected;

  const TimeList({
    Key? key,
    this.padding = 0,
    required this.timeStep,
    required this.firstTime,
    required this.lastTime,
    required this.onHourSelected,
    required this.initialTime,
    this.index = 0,
  }) : super(key: key);

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  late ScrollController _scrollController;
  final double itemExtent = 90;
  late TimeOfDay _selectedHour;
  List<TimeOfDay> hours = [];

  @override
  void initState() {
    super.initState();
    _initialData();
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _animateScroll(hours.indexOf(widget.initialTime));
    });
  }

  @override
  void didUpdateWidget(TimeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstTime != widget.firstTime ||
        oldWidget.timeStep != widget.timeStep ||
        oldWidget.initialTime != widget.initialTime) {
      _initialData();
      _animateScroll(hours.indexOf(widget.initialTime));
    }
  }

  _initialData() {
    _selectedHour = widget.initialTime;
    _loadHours();
  }

  void _loadHours() {
    hours.clear();
    var hour =
        TimeOfDay(hour: widget.firstTime.hour, minute: widget.firstTime.minute);
    while (hour.before(widget.lastTime)) {
      hours.add(hour);
      hour = hour.add(minutes: widget.timeStep);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: widget.padding),
        itemCount: hours.length,
        itemExtent: itemExtent,
        itemBuilder: (BuildContext context, int index) {
          final hour = hours[index];

          return Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: TimeButton(
              borderColor: kMainGrey,
              activeBorderColor: kMainGreen,
              backgroundColor: Colors.white,
              activeBackgroundColor: kMainGreen.withOpacity(0.9),
              textStyle: Theme.of(context).textTheme.bodyText2!,
              activeTextStyle: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: kMainBlack),
              time: hour.format(context),
              value: _selectedHour == hour,
              onSelect: (_) => _selectHour(index, hour),
            ),
          );
        },
      ),
    );
  }

  void _selectHour(int index, TimeOfDay hour) {
    _selectedHour = hour;
    _animateScroll(index);
    widget.onHourSelected(hour);
    setState(() {});
  }

  void _animateScroll(int index) {
    double offset = index < 0 ? 0 : index * itemExtent;
    if (offset > _scrollController.position.maxScrollExtent) {
      offset = _scrollController.position.maxScrollExtent;
    }
    _scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
