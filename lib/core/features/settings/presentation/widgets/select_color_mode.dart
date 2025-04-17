
import 'package:flutter/material.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../notifiers/settings_data_provider.dart';


class SelectColorMode extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const SelectColorMode({super.key, required this.settingsDataProvider});

  @override
  State<SelectColorMode> createState() => _SelectColorModeState();
}

class _SelectColorModeState extends State<SelectColorMode> {

  late PrimaryColorMode _currentColorMode;

  Future<void> _saveSetting({
    required PrimaryColorMode primaryColorMode,
  }) async {
    await widget.settingsDataProvider.saveSetting(
      primaryColorMode: primaryColorMode,
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

    _currentColorMode = widget.settingsDataProvider.currentSetting.primaryColorMode;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _currentColorMode != widget.settingsDataProvider.currentSetting.primaryColorMode) {
        _currentColorMode = widget.settingsDataProvider.currentSetting.primaryColorMode;
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _currentColorMode = widget.settingsDataProvider.currentSetting.primaryColorMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _currentColorMode = widget.settingsDataProvider.currentSetting.primaryColorMode;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("COLOUR", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.context(context).textGreyColor),),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: PrimaryColorMode.values.map((e) {
                return _color(
                  appColorMode: e, 
                  onTap: () async{
                   await _saveSetting(primaryColorMode: e);
                });
              },).toList(),
            )
          ],
        );
      },
    );
  }

  Widget _color({required PrimaryColorMode appColorMode, required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        // Handle color mode selection
        onTap();
      },
      child: CircleAvatar(
        backgroundColor: appColorMode.color,
        radius: 20,
        child: (_currentColorMode == appColorMode) ? Center(
          child: Icon(
            Icons.check,
            color: AppColors.context(context).textColor,
          ),
        )
        :
        null
      ),
    );
  }
}

