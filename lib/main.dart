import 'package:covid19tracker/bloc/simple_bloc_delegate.dart';
import 'package:covid19tracker/helper/app_config.dart';
import 'package:covid19tracker/widgets/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main({String env}) async {
  WidgetsFlutterBinding.ensureInitialized();

  env = env ?? 'dev';
  final configContent = await rootBundle.loadString(
      'assets/config/$env.json',
    );
  // initialize app config
  AppConfig(configContent);

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp(env: env));
}
