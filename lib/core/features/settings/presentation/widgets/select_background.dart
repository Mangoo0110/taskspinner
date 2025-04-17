
import 'package:flutter/material.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../notifiers/settings_data_provider.dart';
import '../../../../../utils/constants/app_sizes.dart';

class SelectBackgroundImage extends StatefulWidget {
  final SettingsDataProvider settingsDataProvider;
  const SelectBackgroundImage({super.key, required this.settingsDataProvider});

  @override
  State<SelectBackgroundImage> createState() => _SelectBackgroundImageState();
}

class _SelectBackgroundImageState extends State<SelectBackgroundImage> {

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
    await widget.settingsDataProvider.saveSetting(
        assetBackgroundImagePath: assetBackgroundImagePath,
      );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    _selectedImagePath = widget.settingsDataProvider.currentSetting.assetBackgroundImagePath;
    widget.settingsDataProvider.addListener(() {
      if(mounted && context.mounted && _selectedImagePath != widget.settingsDataProvider.currentSetting.assetBackgroundImagePath) {
        _selectedImagePath = widget.settingsDataProvider.currentSetting.assetBackgroundImagePath;
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
            Text("Background", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.context(context).textGreyColor)),
            const SizedBox(height: 8),
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
        height: 70,
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
