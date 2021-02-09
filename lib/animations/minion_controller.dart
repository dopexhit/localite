import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare.dart';

class MinionController extends FlareControls {
  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    play("Wave");
  }
  //Stand
  //Wave
  //Jump
  //Dance

  @override
  void onCompleted(String name) {
    super.onCompleted(name);
    play("Stand");
  }

  void jump() {
    play("Jump");
  }

  void dance() {
    play("Dance");
  }

  void wave() {
    play("Wave");
  }
}