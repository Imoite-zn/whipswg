import 'package:flutter_scene/scene.dart' as fscene;

late fscene.Node spoilerModel;
late fscene.Node activeSpoilerNode;

Future<void> attachSpoiler(fscene.Node carRoot) async {
  // 1. Load the spoiler GLB asset
  spoilerModel = await fscene.Node.fromGlbAsset('assets/mods/spoiler_gt.glb');

  // 2. Optionally position it relative to the car's trunk socket
  // Find a designated empty/dummy node inside the car model if you baked socket transforms
  fscene.Node? trunkSocket = carRoot.findByName('socket_trunk');

  if (trunkSocket != null) {
    trunkSocket.add(spoilerModel);
    activeSpoilerNode = spoilerModel;
  } else {
    // Fallback: Add directly to root and manually adjust transform translation
    spoilerModel.transform.setTranslation(vm.Vector3(0.0, 0.8, -1.5));
    carRoot.add(spoilerModel);
    activeSpoilerNode = spoilerModel;
  }
}

// 3. Swapping or Removing Mods
void removeCurrentMod() {
  // Detach or remove the node from its parent
  activeSpoilerNode.parent?.removeChild(activeSpoilerNode);
}