import 'package:covid19tracker/bloc/simple_bloc_delegate.dart';
import 'package:covid19tracker/widgets/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}
