import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_swg/core/auth/auth_service.dart';
import 'package:ride_swg/core/supabase/supabase_config.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';

/// Garage state notifier: fetches custom cars from Supabase per user profile,
/// combines them with default fleet, and persists uploads to Supabase.
class GarageNotifier extends Notifier<List<CarModel>> {
  VoidCallback? _authListener;

  @override
  List<CarModel> build() {
    _authListener ??= () {
      fetchCars();
    };
    AuthService.instance.removeListener(_authListener!);
    AuthService.instance.addListener(_authListener!);

    ref.onDispose(() {
      if (_authListener != null) {
        AuthService.instance.removeListener(_authListener!);
      }
    });

    Future.microtask(() => fetchCars());
    return List<CarModel>.from(CarModel.demo);
  }

  Future<void> fetchCars() async {
    if (!SupabaseConfig.isConfigured) return;

    try {
      final userId = AuthService.instance.currentUserId;
      final userEmail = AuthService.instance.currentUserEmail;

      dynamic query = SupabaseConfig.client.from('cars').select();

      final validUuid = userId != null &&
          RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
              .hasMatch(userId);

      if (validUuid && userEmail.isNotEmpty) {
        query = query.or('user_id.eq.$userId,user_email.eq.$userEmail');
      } else if (validUuid) {
        query = query.eq('user_id', userId);
      } else if (userEmail.isNotEmpty) {
        query = query.eq('user_email', userEmail);
      }

      final response = await query.order('created_at', ascending: false);

      final customCars = (response as List<dynamic>)
          .map((e) => CarModel.fromMap(e as Map<String, dynamic>))
          .toList();

      final customIds = customCars.map((c) => c.id).toSet();
      final remainingDemo =
          CarModel.demo.where((c) => !customIds.contains(c.id)).toList();
      state = [...customCars, ...remainingDemo];
    } catch (e) {
      debugPrint('Error fetching cars from Supabase: $e');
    }
  }

  Future<void> addCar(CarModel car) async {
    // 1. Immediate UI update
    state = [car, ...state.where((c) => c.id != car.id)];

    // 2. Persist to Supabase
    if (!SupabaseConfig.isConfigured) return;

    try {
      final userId = AuthService.instance.currentUserId;
      final userEmail = AuthService.instance.currentUserEmail;

      await SupabaseConfig.client.from('cars').upsert(
        car.toSupabaseMap(
          userId: userId,
          userEmail: userEmail,
        ),
      );
    } catch (e) {
      debugPrint('Error saving car to Supabase: $e');
    }
  }

  Future<void> removeCar(String id) async {
    state = state.where((c) => c.id != id).toList();

    if (!SupabaseConfig.isConfigured) return;

    try {
      await SupabaseConfig.client.from('cars').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error removing car from Supabase: $e');
    }
  }
}

final garageProvider =
    NotifierProvider<GarageNotifier, List<CarModel>>(GarageNotifier.new);
