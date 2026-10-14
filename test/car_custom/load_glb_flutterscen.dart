import 'package:flutter/material.dart' as material;
import 'package:flutter_scene/scene.dart' as fscene;
import 'package:vector_math/vector_math_64.dart' as vm;

// 1. Load your car model
late fscene.Node carModel;

Future<void> loadCar() async {
  // Load directly from GLB asset or binary
  carModel = await fscene.Node.fromGlbAsset('assets/car.glb');
}

// 2. Recursively search for the car body node and update its color
void changeCarColor(fscene.Node rootNode, String targetMeshName, material.Color newColor) {
  // Check if this node matches your target mesh name (e.g., "CarBody_Paint")
  if (rootNode.name == targetMeshName) {
    // Access its primitives/mesh and modify the material color
    // Note: Ensure your mesh exposes a PhyscialBasedMaterial
    // rootNode.mesh?.materials[...]
  }

  // Alternatively, traverse children recursively
  for (final child in rootNode.children) {
    changeCarColor(child, targetMeshName, newColor);
  }
}