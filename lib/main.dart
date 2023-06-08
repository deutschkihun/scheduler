import 'package:provider/provider.dart';
import 'package:scheduler/provider/schedule_provider.dart';
import 'package:scheduler/repository/schedule_repository.dart';
import 'package:scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scheduler/database/drift_database.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase(); // ➊ 데이터베이스 생성

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(ChangeNotifierProvider(
    create: (_) => scheduleProvider,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  ));
}
