
import 'package:flutter/material.dart';
import 'package:taskspinner/core/commons/widgets/custom_button.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';

class SelectThemeMode extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const SelectThemeMode({super.key, required this.settingsDataProvider});

  @override
  State<SelectThemeMode> createState() => _SelectThemeModeState();
}

class _SelectThemeModeState extends State<SelectThemeMode> {

  ThemeMode _selectedMode = ThemeMode.system;

  Future<void> _saveSetting({
    required ThemeMode themeMode,
  }) async {
    await widget.settingsDataProvider.saveSetting(
        themeMode: themeMode,
        assetBackgroundImagePath: null,
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

    _selectedMode = widget.settingsDataProvider.currentSetting.themeMode;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _selectedMode != widget.settingsDataProvider.currentSetting.themeMode) {
        _selectedMode = widget.settingsDataProvider.currentSetting.themeMode;
        setState(() {
          
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedMode = widget.settingsDataProvider.currentSetting.themeMode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("THEME", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.context(context).textGreyColor)),
            //const SizedBox(height: 10),
            Column(
              children: ThemeMode.values.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomButton(
                    child: _themeMode(
                      mode: e,
                      isSelected: e == _selectedMode,
                      onTap: () {
                        _saveSetting(themeMode: e);
                      },
                    ),
                  ),
                );
              },).toList(),
            )
          ],
        );
      },
    );
  }

  Widget _themeMode({required ThemeMode mode, required bool isSelected, required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        // Handle theme mode selection
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.context(context).primaryColor : Colors.transparent,
              borderRadius: AppSizes.maxCircularRadius,
              border: Border.all(
                color: isSelected ? AppColors.context(context).primaryColor : AppColors.context(context).textColor,
                width: 2,
              ),
            ),
            child: Center(
              child: isSelected ? const Icon(Icons.check, color: Colors.white,) : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(mode.themeName, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
