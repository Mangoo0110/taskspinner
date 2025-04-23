import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/commons/widgets/custom_button.dart';
import 'package:taskspinner/core/features/settings/presentation/widgets/toggle_sound_feedback.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../../../../services/app_services.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../widgets/select_background.dart';
import '../widgets/select_theme_mode.dart';
import '../widgets/select_color_mode.dart';
import '../widgets/toggle_haptic_feedback.dart';



class SettingsPopup extends StatelessWidget {
  final SettingsDataProvider settingsDataProvider;
  const SettingsPopup({super.key, required this.settingsDataProvider});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () async{
            await AppServices.physicalFeedback.availableFeedbacks();
            if(context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: Dialog(
              backgroundColor: Colors.transparent, // Transparent background for blur effect
              child: Stack(
                children: [
                  // The blurred background
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                      child: Container(
                        color: Colors.black.withAlpha(0), // Transparent background
                      ),
                    ),
                  ),
                  Hero(
                    tag: "Spinner_Settings",
                    child: GestureDetector(
                      onTap: () {
                        
                      },
                      child: ClipRect(
                        child: AnimatedContainer(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth - 20,
                            maxHeight: min(constraints.maxHeight - 40, 650)
                          ),
                          duration: Duration(milliseconds: 350),
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20,),
                          decoration: BoxDecoration(
                            color: AppColors.context(context).popupBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _header(),
                              Flexible(
                                child: ListView(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    
                                    const SizedBox(height: 0),
                                    SelectThemeMode(settingsDataProvider: settingsDataProvider,),
                                    const SizedBox(height: 30),
                                    SelectColorMode(settingsDataProvider: settingsDataProvider),
                                    const SizedBox(height: 30),
                                    SelectBackgroundImage(settingsDataProvider: settingsDataProvider,),
                                    const SizedBox(height: 30),
                                    ToggleSoundFeedback(settingsDataProvider: settingsDataProvider,),
                                    const SizedBox(height: 5),
                                    ToggleHapticFeedback(settingsDataProvider: settingsDataProvider,),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: AppSizes.largeIconSize, color: AppColors.context(context).primaryColor),
                  const SizedBox(width: 5),
                  Text("Settings", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.normal, color: AppColors.context(context).primaryColor,
                  )),
                ],
              ),
          ),
        );
      },
    );
  }
}








