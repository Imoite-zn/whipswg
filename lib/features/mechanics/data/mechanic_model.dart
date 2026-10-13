import 'package:flutter/material.dart';

class MechanicModel {
  const MechanicModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.location,
    required this.city,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.services,
    required this.specializations,
    required this.avatarUrl,
    required this.bannerUrl,
    required this.yearsInBusiness,
    required this.isVerified,
    required this.isAseCertified,
    this.isTopRated = false,
    required this.laborRatePerHour,
    required this.reviews,
    required this.responseTimeHours,
  });

  final String id;
  final String shopName;
  final String ownerName;
  final String location; // street address
  final String city;
  final double distanceKm;
  final double rating; // 0.0 – 5.0
  final int reviewCount;
  final List<String> services;
  final List<String> specializations;
  final String avatarUrl;
  final String bannerUrl;
  final int yearsInBusiness;
  final bool isVerified;
  final bool isAseCertified;
  final bool isTopRated;
  final double laborRatePerHour;
  final List<MechanicReview> reviews;
  final int responseTimeHours;

  static final List<MechanicModel> demo = [
    MechanicModel(
      id: 'mech_apex_performance',
      shopName: 'Apex Performance Garage',
      ownerName: 'Carlos Mendez',
      location: '142 Industrial Blvd',
      city: 'Los Angeles, CA',
      distanceKm: 2.4,
      rating: 4.9,
      reviewCount: 218,
      isVerified: true,
      isAseCertified: true,
      isTopRated: true,
      yearsInBusiness: 12,
      laborRatePerHour: 120.0,
      responseTimeHours: 2,
      avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=120',
      bannerUrl: 'https://images.unsplash.com/photo-1632823471565-1ecdf5c6da12?w=600',
      services: ['Body Kit Installation', 'Exhaust Systems', 'Wheel & Tire Fitment', 'ECU Tuning', 'Paint & Wrap'],
      specializations: ['JDM Builds', 'Track Prep', 'Widebody Conversions'],
      reviews: [
        MechanicReview(
          authorName: 'Jake T.',
          rating: 5.0,
          comment: 'Carlos installed my Pandem widebody flawlessly. Gap fitment was perfect. Highly recommend for serious builds.',
          date: '3 days ago',
          carName: 'Nissan GT-R R35',
        ),
        MechanicReview(
          authorName: 'Maria S.',
          rating: 5.0,
          comment: 'Akrapovic cat-back done in 4 hours, car sounds incredible. Super professional shop.',
          date: '1 week ago',
          carName: 'BMW M3 G80',
        ),
        MechanicReview(
          authorName: 'Derek L.',
          rating: 4.0,
          comment: 'Great quality work on my aero package but took a little longer than quoted.',
          date: '2 weeks ago',
          carName: 'Toyota Supra MK4',
        ),
      ],
    ),
    MechanicModel(
      id: 'mech_jdm_legends',
      shopName: 'JDM Legends Workshop',
      ownerName: 'Kenji Tanaka',
      location: '88 Harbor Freight Row',
      city: 'Long Beach, CA',
      distanceKm: 5.1,
      rating: 4.7,
      reviewCount: 154,
      isVerified: true,
      isAseCertified: false,
      isTopRated: false,
      yearsInBusiness: 8,
      laborRatePerHour: 95.0,
      responseTimeHours: 6,
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
      bannerUrl: 'https://images.unsplash.com/photo-1543465077-db45d34b88a5?w=600',
      services: ['Engine Swaps', 'Suspension Tuning', 'Exhaust Fabrication', 'Carbon Fiber Work'],
      specializations: ['Honda / Acura', 'Nissan / Infiniti', 'Drift Builds'],
      reviews: [
        MechanicReview(
          authorName: 'Ricky P.',
          rating: 5.0,
          comment: 'Best 2JZ swap shop in SoCal. Kenji knows these engines inside out.',
          date: '5 days ago',
          carName: 'Toyota Chaser JZX100',
        ),
        MechanicReview(
          authorName: 'Amanda K.',
          rating: 4.5,
          comment: 'Suspension dialed perfectly for track day. Car feels planted now.',
          date: '2 weeks ago',
          carName: 'Honda Civic EK9',
        ),
      ],
    ),
    MechanicModel(
      id: 'mech_euro_craft',
      shopName: 'Euro Craft Motorsports',
      ownerName: 'Stefan Braun',
      location: '321 Willowbrook Lane',
      city: 'Torrance, CA',
      distanceKm: 8.7,
      rating: 4.6,
      reviewCount: 89,
      isVerified: true,
      isAseCertified: true,
      isTopRated: false,
      yearsInBusiness: 15,
      laborRatePerHour: 145.0,
      responseTimeHours: 12,
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=120',
      bannerUrl: 'https://images.unsplash.com/photo-1603553329474-99f95f35394f?w=600',
      services: ['PPF & Vinyl Wrap', 'Stage 1/2 ECU Tune', 'Carbon Fiber Parts', 'Wheel Alignment'],
      specializations: ['BMW M-Series', 'Porsche', 'Audi RS', 'AMG Mercedes'],
      reviews: [
        MechanicReview(
          authorName: 'Philip W.',
          rating: 5.0,
          comment: 'Stefan wrapped my 911 in Satin Emerald Green. Absolutely stunning. Worth every penny.',
          date: '1 week ago',
          carName: 'Porsche 911 GT3',
        ),
        MechanicReview(
          authorName: 'Claire M.',
          rating: 4.0,
          comment: 'Stage 2 tune on my M3 is a beast now. Stefan explained everything clearly.',
          date: '3 weeks ago',
          carName: 'BMW M3 G80',
        ),
      ],
    ),
    MechanicModel(
      id: 'mech_iron_forge',
      shopName: 'Iron Forge Custom Fab',
      ownerName: 'Marcus Johnson',
      location: '77 Commerce Park Dr',
      city: 'Compton, CA',
      distanceKm: 11.3,
      rating: 4.8,
      reviewCount: 312,
      isVerified: false,
      isAseCertified: false,
      isTopRated: true,
      yearsInBusiness: 20,
      laborRatePerHour: 85.0,
      responseTimeHours: 4,
      avatarUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=120',
      bannerUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=600',
      services: ['Custom Fabrication', 'Roll Cage Installs', 'Tube Frame Builds', 'Welding'],
      specializations: ['American Muscle', 'Off-Road Builds', 'Custom Chassis'],
      reviews: [
        MechanicReview(
          authorName: 'Tyrone B.',
          rating: 5.0,
          comment: 'Marcus built a full chromoly cage in my Mustang. Welds look like art.',
          date: '4 days ago',
          carName: 'Ford Mustang GT500',
        ),
      ],
    ),
  ];
}

class MechanicReview {
  const MechanicReview({
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.carName,
  });

  final String authorName;
  final double rating;
  final String comment;
  final String date;
  final String carName;
}

/// Map a service name to a color accent for the tag
extension ServiceColor on String {
  Color get serviceColor {
    if (contains('Body') || contains('Aero')) return const Color(0xFFD62828);
    if (contains('Paint') || contains('Wrap') || contains('PPF')) return const Color(0xFF7E57C2);
    if (contains('Exhaust')) return const Color(0xFFF59E0B);
    if (contains('ECU') || contains('Tune')) return const Color(0xFF22C55E);
    if (contains('Wheel') || contains('Tire') || contains('Align')) return const Color(0xFF38BDF8);
    if (contains('Engine') || contains('Swap')) return const Color(0xFFFF6F00);
    if (contains('Carbon')) return const Color(0xFF64748B);
    if (contains('Suspension')) return const Color(0xFFE91E63);
    if (contains('Weld') || contains('Fab') || contains('Roll')) return const Color(0xFFCFA94E);
    return const Color(0xFF5C5C5C);
  }
}
