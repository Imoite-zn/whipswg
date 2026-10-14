import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart' as fscene;

class CarCustomizerScreen extends StatefulWidget {
  const CarCustomizerScreen({super.key});

  @override
  State<CarCustomizerScreen> createState() => _CarCustomizerScreenState();
}

class _CarCustomizerScreenState extends State<CarCustomizerScreen> {
  late fscene.Scene _scene;
  bool _isLoaded = false;
  late fscene.Node _car;

  @override
  void initState() {
    super.initState();
    _initScene();
  }

  Future<void> _initSession() async {} // boilerplate

  Future<void> _initScene() async {
    _scene = fscene.Scene();
    
    // Load car model
    _car = await fscene.Node.fromGlbAsset('assets/car.glb');
    _scene.add(_car);

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return fscene.SceneView(
      _scene,
      cameraBuilder: (elapsed) => fscene.PerspectiveCamera(
        position: vm.Vector3(3.0, 1.5, 3.0),
        target: vm.Vector3(0.0, 0.5, 0.0),
      ),
    );
  }
}