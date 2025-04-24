import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:taskspinner/core/features/settings/presentation/notifiers/settings_data_provider.dart';

import '../features/settings/domain/entity/setting.dart';
import 'dekhao.dart';

class PhysicalFeedback {
  late AudioPlayer _audioPlayer;
  late Setting _setting;
  SettingsDataProvider settingsDataProvider;


  PhysicalFeedback(this.settingsDataProvider, {AudioPlayer? player}) {
    _audioPlayer = player ?? AudioPlayer();
    _setting = settingsDataProvider.currentSetting;
    _listen();
  }

  Future<void> dispose() async{
    await _audioPlayer.dispose();
  }

  void _listen() {
    settingsDataProvider.addListener(() {
      _setting = settingsDataProvider.currentSetting;
    });
  }


  Future<void> init({String? audioAssetPath}) async{
    // Preload the tick sound
    await _audioPlayer.setAsset(audioAssetPath ?? 'assets/sounds/spin_tick.mp3');
  }

  Future<void> availableFeedbacks() async{
    await tick();
    await vibrate();
    
  }

  Future<void> tick({bool? force}) async{
    try {
      if(_setting.tickSound || force == true) {
        dekhao("ticking..");
        await _audioPlayer.seek(Duration.zero); // rewind
        await _audioPlayer.play();              // fire-and-forget
      }
    } catch (e) {
      dekhao("Failed to tick. $e");
    }
  }

  Future<void> vibrate({HapticImpact? impact, bool? force}) async{
    try {
      if(_setting.hapticImpact || force == true) {
        impact ??= HapticImpact.heavy;
        switch (impact) {
          case HapticImpact.light:
            HapticFeedback.lightImpact();
          case HapticImpact.medium:
            HapticFeedback.mediumImpact();
          case HapticImpact.heavy:
            HapticFeedback.heavyImpact();
          case HapticImpact.none:
            ();
        }
      }
    } catch (e) {
      dekhao("Failed to give haptic impact. $e");
    }
  }

}