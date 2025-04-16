import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/commons/widgets/custom_button.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';



class SettingsPopup extends StatelessWidget {
  final SettingsDataProvider settingsDataProvider;
  const SettingsPopup({super.key, required this.settingsDataProvider});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.context(context).popupBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.color_lens, size: AppSizes.largeIconSize, color: AppColors.context(context).primaryColor),
                                  const SizedBox(width: 5),
                                  Text("Settings", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontStyle: FontStyle.normal, color: AppColors.context(context).primaryColor,
                                  )),
                                ],
                              ),
                              const SizedBox(height: 40),
                              SelectThemeMode(settingsDataProvider: settingsDataProvider,),
                              const SizedBox(height: 20),
                              SelectColorMode(settingsDataProvider: settingsDataProvider),
                              const SizedBox(height: 20),
                              UploadBackgroundImage(settingsDataProvider: settingsDataProvider,),
                              const SizedBox(height: 20),
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
}




class SelectThemeMode extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const SelectThemeMode({super.key, required this.settingsDataProvider});

  @override
  State<SelectThemeMode> createState() => _SelectThemeModeState();
}

class _SelectThemeModeState extends State<SelectThemeMode> {

  ThemeMode _selectedMode = ThemeMode.system;

  Future<void> _saveAppearence({
    required ThemeMode themeMode,
  }) async {
    await widget.settingsDataProvider.saveAppearence(
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

    _selectedMode = widget.settingsDataProvider.currentAppearence.themeMode;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _selectedMode != widget.settingsDataProvider.currentAppearence.themeMode) {
        _selectedMode = widget.settingsDataProvider.currentAppearence.themeMode;
        setState(() {
          
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedMode = widget.settingsDataProvider.currentAppearence.themeMode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Theme Mode", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Column(
              children: ThemeMode.values.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    child: _themeMode(
                      mode: e,
                      isSelected: e == _selectedMode,
                      onTap: () {
                        _saveAppearence(themeMode: e);
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


class SelectColorMode extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const SelectColorMode({super.key, required this.settingsDataProvider});

  @override
  State<SelectColorMode> createState() => _SelectColorModeState();
}

class _SelectColorModeState extends State<SelectColorMode> {

  late PrimaryColorMode _currentColorMode;

  Future<void> _saveAppearence({
    required PrimaryColorMode primaryColorMode,
  }) async {
    await widget.settingsDataProvider.saveAppearence(
        themeMode: null,
        primaryColorMode: primaryColorMode,
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

    _currentColorMode = widget.settingsDataProvider.currentAppearence.primaryColorMode;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _currentColorMode != widget.settingsDataProvider.currentAppearence.primaryColorMode) {
        _currentColorMode = widget.settingsDataProvider.currentAppearence.primaryColorMode;
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _currentColorMode = widget.settingsDataProvider.currentAppearence.primaryColorMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _currentColorMode = widget.settingsDataProvider.currentAppearence.primaryColorMode;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Color Mode", style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: PrimaryColorMode.values.map((e) {
                return _color(
                  appColorMode: e, 
                  onTap: () async{
                   await _saveAppearence(primaryColorMode: e);
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


class UploadBackgroundImage extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const UploadBackgroundImage({super.key, required this.settingsDataProvider});

  @override
  State<UploadBackgroundImage> createState() => _UploadBackgroundImageState();
}

class _UploadBackgroundImageState extends State<UploadBackgroundImage> {

  late String? _selectedImagePath;

  final List<String> _imagePaths = [
    "assets/images/background1.jpeg",
    "assets/images/background2.jpeg",
    "assets/images/background3.jpeg",
    "assets/images/background4.jpeg",
  ];

  Future<void> _saveAppearence({
    required String assetBackgroundImagePath,
  }) async {
    await widget.settingsDataProvider.saveAppearence(
        assetBackgroundImagePath: assetBackgroundImagePath,
      );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    _selectedImagePath = widget.settingsDataProvider.currentAppearence.assetBackgroundImagePath;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _selectedImagePath != widget.settingsDataProvider.currentAppearence.assetBackgroundImagePath) {
        _selectedImagePath = widget.settingsDataProvider.currentAppearence.assetBackgroundImagePath;
        setState(() {
          
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedImagePath = _imagePaths.first;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Background Image", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _imagePaths
                .map((e) => _imageCardSelector(
                  imagePath: e, 
                  isSelected: _selectedImagePath == e, 
                  onTap: (){
                    _saveAppearence(assetBackgroundImagePath: e);
                },
              ),).toList(),
            )
          ],
        );
      },
    );
  }

  Widget _imageCardSelector({required String imagePath, required bool isSelected, required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        // Handle image selection
        onTap();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: AppSizes.smallBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.context(context).primaryColor : AppColors.context(context).textColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}