
import 'package:flutter/material.dart';
import 'package:taskspinner/core/services/app_services.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';

class ToggleHapticFeedback extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const ToggleHapticFeedback({super.key, required this.settingsDataProvider});

  @override
  State<ToggleHapticFeedback> createState() => _ToggleHapticFeedbackState();
}

class _ToggleHapticFeedbackState extends State<ToggleHapticFeedback> {

  late bool _hapticImpact;

  Future<void> _saveSetting({
    required bool hapticImpact,
  }) async {
    await widget.settingsDataProvider.saveSetting(
      hapticImpact: hapticImpact,
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

    _hapticImpact = widget.settingsDataProvider.currentSetting.hapticImpact;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _hapticImpact != widget.settingsDataProvider.currentSetting.hapticImpact) {
        _hapticImpact = widget.settingsDataProvider.currentSetting.hapticImpact;
        setState(() {
          
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _hapticImpact = widget.settingsDataProvider.currentSetting.hapticImpact;
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
                  Icon(Icons.vibration, size: AppSizes.mediumIconSize,),
                  SizedBox(width: 8,),
                  Text("Haptic impact", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                ],
              ),
          
              Switch(
                value: _hapticImpact,
                onChanged: (value) async{
                  await _saveSetting(hapticImpact: value).then((_) async{
                    await AppServices.physicalFeedback.availableFeedbacks();
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }

}
