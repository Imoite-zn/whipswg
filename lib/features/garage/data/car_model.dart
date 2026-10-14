class CarModel {
  const CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.year,
    required this.category,
    required this.modelUrl,
    required this.thumbnailUrl,
    required this.colorHex,
    this.horsepower,
    this.torque,
    this.weight,
    this.drivetrain,
    this.multiAnglePhotos = const [],
    this.isCustomUpload = false,
  });

  final String id;
  final String name;
  final String brand;
  final int year;
  final String category;
  final String modelUrl; // .glb / .gltf URL
  final String thumbnailUrl;
  final String colorHex;
  final int? horsepower;
  final int? torque;
  final int? weight;
  final String? drivetrain;
  final List<String> multiAnglePhotos;
  final bool isCustomUpload;

  String get fullName => '$year $brand $name';

  Map<String, dynamic> toSupabaseMap({String? userId, String? userEmail}) {
    final validUuid = userId != null &&
        RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
            .hasMatch(userId);

    return {
      'id': id,
      if (validUuid) 'user_id': userId,
      if (userEmail != null && userEmail.isNotEmpty) 'user_email': userEmail,
      'name': name,
      'brand': brand,
      'year': year,
      'category': category,
      'model_url': modelUrl,
      'thumbnail_url': thumbnailUrl,
      'color_hex': colorHex,
      'horsepower': horsepower,
      'torque': torque,
      'weight': weight,
      'drivetrain': drivetrain,
      'multi_angle_photos': multiAnglePhotos,
      'is_custom_upload': isCustomUpload,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] as String? ?? 'car_${DateTime.now().millisecondsSinceEpoch}',
      name: map['name'] as String? ?? 'Vehicle',
      brand: map['brand'] as String? ?? 'Custom',
      year: (map['year'] as num?)?.toInt() ?? 2024,
      category: map['category'] as String? ?? 'Custom',
      modelUrl: map['model_url'] as String? ?? map['modelUrl'] as String? ?? '',
      thumbnailUrl: map['thumbnail_url'] as String? ?? map['thumbnailUrl'] as String? ?? '',
      colorHex: map['color_hex'] as String? ?? map['colorHex'] as String? ?? '#CFB84E',
      horsepower: (map['horsepower'] as num?)?.toInt(),
      torque: (map['torque'] as num?)?.toInt(),
      weight: (map['weight'] as num?)?.toInt(),
      drivetrain: map['drivetrain'] as String?,
      multiAnglePhotos: (map['multi_angle_photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (map['multiAnglePhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isCustomUpload: map['is_custom_upload'] as bool? ?? map['isCustomUpload'] as bool? ?? true,
    );
  }

  CarModel copyWith({
    String? id,
    String? name,
    String? brand,
    int? year,
    String? category,
    String? modelUrl,
    String? thumbnailUrl,
    String? colorHex,
    int? horsepower,
    int? torque,
    int? weight,
    String? drivetrain,
    List<String>? multiAnglePhotos,
    bool? isCustomUpload,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      year: year ?? this.year,
      category: category ?? this.category,
      modelUrl: modelUrl ?? this.modelUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      colorHex: colorHex ?? this.colorHex,
      horsepower: horsepower ?? this.horsepower,
      torque: torque ?? this.torque,
      weight: weight ?? this.weight,
      drivetrain: drivetrain ?? this.drivetrain,
      multiAnglePhotos: multiAnglePhotos ?? this.multiAnglePhotos,
      isCustomUpload: isCustomUpload ?? this.isCustomUpload,
    );
  }

  /// Demo cars (using free GLB models from GitHub / public CDN)
  static final List<CarModel> demo = [
    const CarModel(
      id: 'toyota_supra_mk4',
      name: 'Supra MK4',
      brand: 'Toyota',
      year: 1998,
      category: 'Sports',
      modelUrl:
          'https://modelviewer.dev/shared-assets/models/Astronaut.glb', // placeholder
      thumbnailUrl:
          'https://images.unsplash.com/photo-1623869675781-80aa31012a5a?w=400',
      colorHex: '#C62828',
      horsepower: 320,
      torque: 427,
      weight: 1570,
      drivetrain: 'RWD',
    ),
    const CarModel(
      id: 'nissan_gtr_r35',
      name: 'GT-R R35',
      brand: 'Nissan',
      year: 2023,
      category: 'Super Car',
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1580274455191-1c62238fa333?w=400',
      colorHex: '#1565C0',
      horsepower: 565,
      torque: 637,
      weight: 1752,
      drivetrain: 'AWD',
    ),
    const CarModel(
      id: 'ford_mustang_gt',
      name: 'Mustang GT',
      brand: 'Ford',
      year: 2022,
      category: 'Muscle',
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=400',
      colorHex: '#E65100',
      horsepower: 460,
      torque: 529,
      weight: 1696,
      drivetrain: 'RWD',
    ),
    const CarModel(
      id: 'bmw_m3_g80',
      name: 'M3 Competition',
      brand: 'BMW',
      year: 2023,
      category: 'Sedan',
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=400',
      colorHex: '#37474F',
      horsepower: 503,
      torque: 650,
      weight: 1730,
      drivetrain: 'RWD',
    ),
    const CarModel(
      id: 'subaru_wrx_sti',
      name: 'WRX STI',
      brand: 'Subaru',
      year: 2021,
      category: 'Rally',
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=400',
      colorHex: '#1565C0',
      horsepower: 310,
      torque: 407,
      weight: 1497,
      drivetrain: 'AWD',
    ),
    const CarModel(
      id: 'porsche_911_turbo',
      name: '911 Turbo S',
      brand: 'Porsche',
      year: 2024,
      category: 'Super Car',
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?w=400',
      colorHex: '#CFB84E',
      horsepower: 650,
      torque: 800,
      weight: 1640,
      drivetrain: 'AWD',
    ),
  ];
}
