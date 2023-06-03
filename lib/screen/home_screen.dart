import 'package:flutter/material.dart';
import 'package:scheduler/component/main_calender.dart';
import 'package:scheduler/component/schedule_bottom_sheet.dart';
import 'package:scheduler/component/schedule_card.dart';
import 'package:scheduler/component/today_banner.dart';
import 'package:scheduler/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler/database/drift_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => ScheduleBottomSheet(
                    selectedDate: selectedDate,
                  ),
              isDismissible: true,
              isScrollControlled: true);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalender(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  return TodayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.length ?? 0,
                  );
                }),
            SizedBox(height: 8.0),
            Expanded(
                child: StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final schedule = snapshot.data![index]; // 현재 index에 해당되는 일정
                    return Dismissible(
                      key: ObjectKey(schedule.id), // 유니크한 키값
                      direction:
                          DismissDirection.startToEnd, // 밀기 방향 (오른쪽에서 왼쪽으로)
                      onDismissed: (DismissDirection direction) {
                        // 밀기 했을 때 실행할 함수
                        GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ),
                      ),
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
