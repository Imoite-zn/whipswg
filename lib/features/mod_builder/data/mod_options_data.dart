import 'package:flutter/material.dart';

enum PaintFinish {
  gloss,
  matte,
  satin,
  metallic,
  carbonWrap,
}

class PaintColorOption {
  final String name;
  final Color color;
  final PaintFinish finish;
  final String finishLabel;
  final double price;
  final double laborHours;
  final String filmType;

  const PaintColorOption({
    required this.name,
    required this.color,
    required this.finish,
    required this.finishLabel,
    required this.price,
    required this.laborHours,
    required this.filmType,
  });

  static const List<PaintColorOption> curatedColors = [
    // Gloss
    PaintColorOption(
      name: 'Rosso Corsa Red',
      color: Color(0xFFD62828),
      finish: PaintFinish.gloss,
      finishLabel: 'High Gloss Paint',
      price: 2400.0,
      laborHours: 24.0,
      filmType: 'OEM Triple-Coat Enamel',
    ),
    PaintColorOption(
      name: 'Nardo Stealth Grey',
      color: Color(0xFF6C7A89),
      finish: PaintFinish.gloss,
      finishLabel: 'High Gloss Poly',
      price: 2200.0,
      laborHours: 22.0,
      filmType: 'Clear Coat Acrylic',
    ),
    PaintColorOption(
      name: 'Bayside Racing Blue',
      color: Color(0xFF1565C0),
      finish: PaintFinish.gloss,
      finishLabel: 'High Gloss Metallic',
      price: 2600.0,
      laborHours: 25.0,
      filmType: '2-Stage Urethane',
    ),
    // Satin & Matte Wraps
    PaintColorOption(
      name: 'Frozen Matte Black',
      color: Color(0xFF1E1E1E),
      finish: PaintFinish.matte,
      finishLabel: 'Matte Vinyl Wrap',
      price: 3200.0,
      laborHours: 18.0,
      filmType: '3M 2080 Matte Cast Vinyl (90 Micron)',
    ),
    PaintColorOption(
      name: 'Satin Liquid Gold',
      color: Color(0xFFCFA94E),
      finish: PaintFinish.satin,
      finishLabel: 'Satin Metallic Wrap',
      price: 3600.0,
      laborHours: 20.0,
      filmType: 'Avery Dennison Supreme Satin (80 Micron)',
    ),
    PaintColorOption(
      name: 'Satin Emerald Green',
      color: Color(0xFF1B4D3E),
      finish: PaintFinish.satin,
      finishLabel: 'Satin Pearl Wrap',
      price: 3400.0,
      laborHours: 19.0,
      filmType: 'Inozetek SuperGloss Metallic Series',
    ),
    PaintColorOption(
      name: 'Midnight Purple III',
      color: Color(0xFF4A148C),
      finish: PaintFinish.metallic,
      finishLabel: 'Chameleon ChromaFlake',
      price: 4500.0,
      laborHours: 30.0,
      filmType: 'Custom 4-Stage Pearl Flip Tint',
    ),
    PaintColorOption(
      name: 'Forged Carbon Fiber Wrap',
      color: Color(0xFF2C3437),
      finish: PaintFinish.carbonWrap,
      finishLabel: 'Dry Carbon Film',
      price: 4200.0,
      laborHours: 26.0,
      filmType: 'STEK DynoCarbon Gloss TPU PPF',
    ),
    PaintColorOption(
      name: 'Miami Sunset Orange',
      color: Color(0xFFFF6F00),
      finish: PaintFinish.gloss,
      finishLabel: 'Gloss Neon Enamel',
      price: 2500.0,
      laborHours: 22.0,
      filmType: 'BASF Glasurit Polyurethane',
    ),
  ];
}

class BodyKitPackage {
  final String id;
  final String name;
  final String manufacturer;
  final String bodyType; // Widebody, Aero Lip Kit, GT Track, Stock
  final double price;
  final double laborHours;
  final String material;
  final String measurements;
  final String fitmentRequirements;
  final int widthIncreaseMm;
  final int downforceKgAt160Kph;

  const BodyKitPackage({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.bodyType,
    required this.price,
    required this.laborHours,
    required this.material,
    required this.measurements,
    required this.fitmentRequirements,
    required this.widthIncreaseMm,
    required this.downforceKgAt160Kph,
  });

  static const List<BodyKitPackage> packages = [
    BodyKitPackage(
      id: 'stock',
      name: 'OEM Factory Spec',
      manufacturer: 'Original Manufacturer',
      bodyType: 'Stock Body',
      price: 0,
      laborHours: 0,
      material: 'OEM Stamped Steel / Polyurethane',
      measurements: 'Standard Factory Width & Track',
      fitmentRequirements: 'Factory alignment and mounting hardware.',
      widthIncreaseMm: 0,
      downforceKgAt160Kph: 15,
    ),
    BodyKitPackage(
      id: 'pandem_wide',
      name: 'Pandem V3 Widebody Conversion',
      manufacturer: 'TRA Kyoto Pandem',
      bodyType: 'Full Bolt-On Widebody',
      price: 7800.0,
      laborHours: 32.0,
      material: 'Dry Vacuum-Infused FRP & Carbon accents',
      measurements: '+65mm Front / +90mm Rear per fender',
      fitmentRequirements:
          'Requires cutting factory metal quarter panels, seam welding inner wheel tubs, and M6 stainless rivnut fasteners.',
      widthIncreaseMm: 155,
      downforceKgAt160Kph: 120,
    ),
    BodyKitPackage(
      id: 'liberty_walk',
      name: 'LB-Silhouette WORKS GT',
      manufacturer: 'Liberty Walk Official',
      bodyType: 'Super Silhouette Aero Conversion',
      price: 12500.0,
      laborHours: 40.0,
      material: 'Full Dry Carbon Fiber & Hybrid FRP',
      measurements: '+80mm Front / +110mm Rear widening',
      fitmentRequirements:
          'Requires full chassis tub modification, custom undertray brackets, and structural adhesive bonding.',
      widthIncreaseMm: 190,
      downforceKgAt160Kph: 185,
    ),
    BodyKitPackage(
      id: 'gt3_track',
      name: 'Apex Spec GT3 Track Aero',
      manufacturer: 'Apex Motorsport Engineering',
      bodyType: 'Functional Competition Aero',
      price: 5900.0,
      laborHours: 20.0,
      material: 'Autoclaved 3K Twill Carbon Fiber',
      measurements: '+35mm Front track aero blades, flat undertray',
      fitmentRequirements:
          'Mounts to factory chassis crossmember pickup points with titanium stanchion rods.',
      widthIncreaseMm: 70,
      downforceKgAt160Kph: 210,
    ),
    BodyKitPackage(
      id: 'oem_lip',
      name: 'ClubSport Carbon Lip Suite',
      manufacturer: 'Voltex Racing Japan',
      bodyType: 'Clean OEM+ Add-on',
      price: 3400.0,
      laborHours: 8.0,
      material: 'Pre-preg Torayca Carbon Fiber',
      measurements: 'Factory width, +45mm forward reach',
      fitmentRequirements:
          '100% reversible bolt-on to OEM bumper undertray clip locations with 3M VHB bonding.',
      widthIncreaseMm: 0,
      downforceKgAt160Kph: 65,
    ),
  ];
}

class ModularBodyPart {
  final String id;
  final String slot; // 'Front Splitter', 'Side Skirts', 'Rear Diffuser', 'Hood', 'Spoiler'
  final String name;
  final String brand;
  final double price;
  final double laborHours;
  final String material;
  final String specs;
  final String mechanicRequirement;

  const ModularBodyPart({
    required this.id,
    required this.slot,
    required this.name,
    required this.brand,
    required this.price,
    required this.laborHours,
    required this.material,
    required this.specs,
    required this.mechanicRequirement,
  });

  static const List<ModularBodyPart> allParts = [
    // Front Splitters
    ModularBodyPart(
      id: 'splitter_stock',
      slot: 'Front Splitter',
      name: 'OEM Front Bumper Lip',
      brand: 'Factory OEM',
      price: 0,
      laborHours: 0,
      material: 'Flexible ABS Plastic',
      specs: 'Standard factory ground clearance (145mm)',
      mechanicRequirement: 'Factory screw clips.',
    ),
    ModularBodyPart(
      id: 'splitter_carbon_stage2',
      slot: 'Front Splitter',
      name: 'Track Stage-2 Carbon Splitter w/ Tie Rods',
      brand: 'Aeromotions Racing',
      price: 1650.0,
      laborHours: 3.5,
      material: 'Honeycomb Core Pre-Preg Carbon Fiber (3.5mm)',
      specs: 'Extends 95mm forward, chassis mounted, 110mm clearance',
      mechanicRequirement:
          'Requires drilling 2 chassis subframe anchor points for quick-release support rods.',
    ),
    ModularBodyPart(
      id: 'splitter_vrs_street',
      slot: 'Front Splitter',
      name: 'VRS Carbon Bumper Under-Flap',
      brand: 'Varis Japan',
      price: 1100.0,
      laborHours: 2.0,
      material: 'Vacuum Bagged Wet Carbon',
      specs: 'Full width 1740mm, integrated air duct channels',
      mechanicRequirement: 'Mounts directly to bumper lower flange with M6 hardware.',
    ),

    // Side Skirts
    ModularBodyPart(
      id: 'skirts_stock',
      slot: 'Side Skirts',
      name: 'Factory Rocker Panels',
      brand: 'Factory OEM',
      price: 0,
      laborHours: 0,
      material: 'Factory Polypropylene',
      specs: 'Flush OEM rocker panel',
      mechanicRequirement: 'OEM retainers.',
    ),
    ModularBodyPart(
      id: 'skirts_carbon_blades',
      slot: 'Side Skirts',
      name: 'Carbon Aero Step Extensions with Finlets',
      brand: 'APR Performance',
      price: 1250.0,
      laborHours: 2.5,
      material: '100% Gloss 2x2 Carbon Fiber',
      specs: 'Length: 1980mm, Width: 120mm protrusion with 60mm vortex finlets',
      mechanicRequirement: 'Requires underbody sill self-tapping screws and 3M heavy-duty tape.',
    ),

    // Rear Diffusers
    ModularBodyPart(
      id: 'diffuser_stock',
      slot: 'Rear Diffuser',
      name: 'Factory Rear Valance',
      brand: 'Factory OEM',
      price: 0,
      laborHours: 0,
      material: 'Textured Polypropylene',
      specs: 'Single/dual factory exhaust cutout',
      mechanicRequirement: 'Factory push-pins.',
    ),
    ModularBodyPart(
      id: 'diffuser_aggressive_quad',
      slot: 'Rear Diffuser',
      name: 'Aggressive Quad-Strake Carbon Diffuser',
      brand: 'Vorsteiner Aero',
      price: 2100.0,
      laborHours: 4.0,
      material: 'Autoclaved Aerospace Carbon Fiber',
      specs: 'Width: 1420mm, 4 deep vertical strakes (120mm depth), F1 rain light cutout',
      mechanicRequirement:
          'Requires trimming OEM lower heatshield and installing included crash bar bracketry.',
    ),

    // Hoods
    ModularBodyPart(
      id: 'hood_stock',
      slot: 'Hood',
      name: 'Factory Aluminum Hood',
      brand: 'Factory OEM',
      price: 0,
      laborHours: 0,
      material: 'Pressed Aluminum',
      specs: 'Factory weight (18.5 kg), non-vented',
      mechanicRequirement: 'Standard hinge alignment.',
    ),
    ModularBodyPart(
      id: 'hood_vented_carbon',
      slot: 'Hood',
      name: 'Dual Heat Extractor Carbon Hood',
      brand: 'Seibon Carbon',
      price: 2250.0,
      laborHours: 3.0,
      material: 'Grade-A Carbon Fiber with UV-resistant clear coat',
      specs: 'Weight: 8.2 kg (-10.3 kg saving), dual NACA duct thermal extractors',
      mechanicRequirement:
          'Hinges bolt-on. Professional gap calibration and hood latch lock alignment required.',
    ),

    // Spoilers / Wings
    ModularBodyPart(
      id: 'spoiler_none',
      slot: 'Spoiler',
      name: 'Clean Decklid (No Wing)',
      brand: 'Factory Clean',
      price: 0,
      laborHours: 0,
      material: 'N/A',
      specs: 'Low drag, zero added weight',
      mechanicRequirement: 'No installation.',
    ),
    ModularBodyPart(
      id: 'spoiler_ducktail',
      slot: 'Spoiler',
      name: 'Aggressive High-Kick Carbon Ducktail',
      brand: 'Rocket Bunny',
      price: 750.0,
      laborHours: 1.5,
      material: 'Dry Carbon Fiber',
      specs: 'Height: 140mm, angle: 45° rake angle, 35kg downforce at 140km/h',
      mechanicRequirement: '3M Automotive UHB acrylic foam tape + optional trunk lid blind rivets.',
    ),
    ModularBodyPart(
      id: 'spoiler_gt_wing',
      slot: 'Spoiler',
      name: 'Swan-Neck GT3 Carbon Wing (1600mm)',
      brand: 'Voltex Type-5',
      price: 3600.0,
      laborHours: 5.0,
      material: 'Multi-layer dry carbon airfoil with 7075 billet aluminum uprights',
      specs: 'Span: 1600mm, Chord: 285mm, 16-way adjustable angle of attack (-2° to +14°)',
      mechanicRequirement:
          'Requires drilling 4 holes through trunk decklid and installing reinforced chassis under-plates.',
    ),
  ];
}

class WheelSetupOption {
  final String id;
  final String name;
  final String brand;
  final String size;
  final String boltPattern;
  final String offsetFront;
  final String offsetRear;
  final String recommendedTires;
  final String construction;
  final double weightPerWheelKg;
  final double price;
  final double laborHours;
  final String fitmentNote;

  const WheelSetupOption({
    required this.id,
    required this.name,
    required this.brand,
    required this.size,
    required this.boltPattern,
    required this.offsetFront,
    required this.offsetRear,
    required this.recommendedTires,
    required this.construction,
    required this.weightPerWheelKg,
    required this.price,
    required this.laborHours,
    required this.fitmentNote,
  });

  static const List<WheelSetupOption> wheels = [
    WheelSetupOption(
      id: 'wheels_stock',
      name: 'OEM Cast Alloy Wheels',
      brand: 'Factory Original',
      size: '18 x 8.5J',
      boltPattern: '5x114.3',
      offsetFront: 'ET+45',
      offsetRear: 'ET+45',
      recommendedTires: '245/40 R18 All-Season',
      construction: 'Gravity Cast Aluminum',
      weightPerWheelKg: 13.8,
      price: 0,
      laborHours: 0,
      fitmentNote: 'Factory hubcentric alignment.',
    ),
    WheelSetupOption(
      id: 'wheels_te37',
      name: 'Volk Racing TE37 Saga S-Plus',
      brand: 'Rays Engineering Japan',
      size: '19 x 9.5J Front / 19 x 10.5J Rear',
      boltPattern: '5x114.3',
      offsetFront: 'ET+22',
      offsetRear: 'ET+15',
      recommendedTires: '265/35 R19 & 295/30 R19 Michelin Pilot Sport 4S',
      construction: '1-Piece Mold Form Forged Aluminum (6061-T6)',
      weightPerWheelKg: 8.9,
      price: 4400.0,
      laborHours: 2.0,
      fitmentNote:
          'Requires hubcentric rings (73.1mm to 66.1mm) and conical seat lug nuts (torque to 118 Nm).',
    ),
    WheelSetupOption(
      id: 'wheels_bbs_chr',
      name: 'BBS CH-R Nürburgring Edition',
      brand: 'BBS Germany',
      size: '20 x 9.0J Front / 20 x 10.5J Rear',
      boltPattern: '5x112 / 5x114.3',
      offsetFront: 'ET+25',
      offsetRear: 'ET+20',
      recommendedTires: '255/30 R20 & 305/25 R20 Pirelli P Zero Corsa',
      construction: 'Flow-Formed Aluminum with Stainless Rim Protector',
      weightPerWheelKg: 10.4,
      price: 3800.0,
      laborHours: 2.0,
      fitmentNote: 'Direct bolt-on with supplied BBS PFS centering rings.',
    ),
    WheelSetupOption(
      id: 'wheels_rotiform_aerodisc',
      name: 'Rotiform LAS-R with Forged Aerodisc',
      brand: 'Rotiform Wheels USA',
      size: '19 x 8.5J Square Setup',
      boltPattern: '5x114.3',
      offsetFront: 'ET+35',
      offsetRear: 'ET+35',
      recommendedTires: '245/35 R19 Toyo Proxes R888R',
      construction: 'Cast Monoblock with Composite Carbon Aerodisc Cover',
      weightPerWheelKg: 12.1,
      price: 2600.0,
      laborHours: 2.5,
      fitmentNote: 'Hex nut locking mechanism for Aerodisc assembly. Clear big brake calipers up to 380mm.',
    ),
  ];
}

class ExhaustSetupOption {
  final String id;
  final String name;
  final String brand;
  final String pipeDiameter;
  final String material;
  final String soundProfile;
  final int decibelRating;
  final int hpGain;
  final double weightReductionKg;
  final double price;
  final double laborHours;
  final String requirements;

  const ExhaustSetupOption({
    required this.id,
    required this.name,
    required this.brand,
    required this.pipeDiameter,
    required this.material,
    required this.soundProfile,
    required this.decibelRating,
    required this.hpGain,
    required this.weightReductionKg,
    required this.price,
    required this.laborHours,
    required this.requirements,
  });

  static const List<ExhaustSetupOption> exhausts = [
    ExhaustSetupOption(
      id: 'exhaust_stock',
      name: 'OEM Factory Cat-Back',
      brand: 'Factory OEM',
      pipeDiameter: '2.25" (57mm)',
      material: 'Mild Steel / Aluminized',
      soundProfile: 'Quiet OEM Tone',
      decibelRating: 78,
      hpGain: 0,
      weightReductionKg: 0,
      price: 0,
      laborHours: 0,
      requirements: 'Standard catalytic converters and stock ECU.',
    ),
    ExhaustSetupOption(
      id: 'exhaust_akrapovic',
      name: 'Evolution Titanium Cat-Back with Carbon Tips',
      brand: 'Akrapovic Exhaust Systems',
      pipeDiameter: '3.0" to dual 2.75" (76mm to 70mm)',
      material: 'Proprietary Aircraft-Grade Titanium alloy',
      soundProfile: 'Deep Exotic Metallic Growl (Valved)',
      decibelRating: 98,
      hpGain: 28,
      weightReductionKg: 14.6,
      price: 5200.0,
      laborHours: 4.0,
      requirements:
          'Includes electronic valve controller wiring harness. Compatible with factory catalytic converters.',
    ),
    ExhaustSetupOption(
      id: 'exhaust_hks_hipower',
      name: 'HKS Hi-Power Spec-L II Quad',
      brand: 'HKS Performance Japan',
      pipeDiameter: '3.0" straight-through mandrel bent',
      material: 'SU304 Stainless Steel with Titanium Burnt Tips',
      soundProfile: 'Aggressive JDM High-Frequency Roar',
      decibelRating: 104,
      hpGain: 34,
      weightReductionKg: 9.8,
      price: 2800.0,
      laborHours: 3.5,
      requirements:
          'Recommended ECU Stage-2 software remap to optimize backpressure reduction and maximize torque curve.',
    ),
    ExhaustSetupOption(
      id: 'exhaust_borla_stype',
      name: 'Borla S-Type Cat-Back Exhaust System',
      brand: 'Borla Exhaust USA',
      pipeDiameter: '2.75" (70mm) smooth flow',
      material: 'Austenitic T-304 Stainless Steel',
      soundProfile: 'Deep Throaty Muscle V8/Turbo Rumble (Zero Drone)',
      decibelRating: 92,
      hpGain: 18,
      weightReductionKg: 7.2,
      price: 1950.0,
      laborHours: 3.0,
      requirements: 'Direct bolt-on to factory catalytic converter flange. 100% emissions compliant.',
    ),
  ];
}
