import 'package:flutter/foundation.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';

class GarageService extends ChangeNotifier {
  static final GarageService instance = GarageService._internal();

  GarageService._internal() {
    _cars.addAll(CarModel.demo);
  }

  final List<CarModel> _cars = [];
  List<CarModel> get cars => List.unmodifiable(_cars);

  void addCar(CarModel car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  void removeCar(String id) {
    _cars.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  CarModel? getCarById(String id) {
    return _cars.where((c) => c.id == id).firstOrNull;
  }
}
