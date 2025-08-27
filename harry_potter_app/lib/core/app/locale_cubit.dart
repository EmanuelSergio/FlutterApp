import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(Locale initial) : super(initial);

  void setLocale(Locale locale) => emit(locale);
}
