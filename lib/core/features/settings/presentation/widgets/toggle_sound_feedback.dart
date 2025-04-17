
import 'package:flutter/material.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';

class ToggleSoundFeedback extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const ToggleSoundFeedback({super.key, required this.settingsDataProvider});

  @override
  State<ToggleSoundFeedback> createState() => _ToggleSoundFeedbackState();
}

class _ToggleSoundFeedbackState extends State<ToggleSoundFeedback> {

  late bool _tickSound;

  Future<void> _saveSetting({
    required bool tickSound,
  }) async {
    await widget.settingsDataProvider.saveSetting(
        tickSound: tickSound,
        onError: (err){

        },
        onDone: () {
          // Handle success
        },
      );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    _tickSound = widget.settingsDataProvider.currentSetting.tickSound;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _tickSound != widget.settingsDataProvider.currentSetting.tickSound) {
        _tickSound = widget.settingsDataProvider.currentSetting.tickSound;
        setState(() {
          
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _tickSound = widget.settingsDataProvider.currentSetting.tickSound;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.volume_up, size: AppSizes.mediumIconSize,),
                  SizedBox(width: 8,),
                  Text("Tick sound", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  
                ],
              ),
          
              Switch(
                value: _tickSound,
                onChanged: (value) {
                  _saveSetting(tickSound: value);
                },
              )
            ],
          ),
        );
      },
    );
  }

}
