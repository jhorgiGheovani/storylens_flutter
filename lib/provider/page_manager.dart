import 'dart:async';

import 'package:flutter/material.dart';

class PageManager<double> extends ChangeNotifier {
  late Completer<double> lon;
  late Completer<double> lat;
  Future<double> getLon() async {
    lon = Completer<double>();
    return lon.future;
  }

  Future<double> getLat() async {
    lat = Completer<double>();
    return lat.future;
  }

  void setLon(double value) {
    lon.complete(value);
  }

  void setLat(double value) {
    lat.complete(value);
  }
}
