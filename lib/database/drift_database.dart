import 'package:scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'drift_database.g.dart';

@DriftDatabase(// 사용할 테이블 등록
    tables: [Schedules])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 데이터를 조회하고 변화를 감지
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // 드리프트 db 클래스는 필수로 schemaVersion 값을 지정해주어야 함
  int get schemaVersion => 1;
}

// 드리프트 db 객체는 부모생성자에 LazyDatabase 를 필수로 넣어주어야 한다
// 이안에 저장 풀더도 지정해주어야 한다.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder =
        await getApplicationDocumentsDirectory(); // 데이터베이스 파일 저장할 폴더
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
