import 'package:audioplayers/audioplayers.dart';

import 'loggers.dart';
// import 'package:just_audio/just_audio.dart';

class SoundManager {
  // static final AudioPlayer player = AudioPlayer();

  // static Future<void> playSound(String path) async {
  //   await player.setAsset(path);
  //   return player.play();
  // }

  // static Future<void> stopSound() async {
  //   return player.stop();
  // }

  static final AudioCache cache = AudioCache();

  static Future<AudioPlayer?> playSound(String path) async {
    AudioPlayer? res;
    try {
      res = await cache.play(path);
    } catch (e) {
      logger.severe("SoundManager", e);
    }

    return res;
  }
}
