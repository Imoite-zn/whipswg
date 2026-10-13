import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';

/// In-memory garage state: starts with demo cars, allows adding custom uploads.
class GarageNotifier extends Notifier<List<CarModel>> {
  @override
  List<CarModel> build() => List<CarModel>.from(CarModel.demo);

  void addCar(CarModel car) => state = [...state, car];

  void removeCar(String id) => state = state.where((c) => c.id != id).toList();
}

final garageProvider =
    NotifierProvider<GarageNotifier, List<CarModel>>(GarageNotifier.new);
