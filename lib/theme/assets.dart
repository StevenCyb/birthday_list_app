import 'package:flutter/material.dart';

class AssetsTheme {
  static AssetImage defaultProfile(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const AssetImage('assets/default_profile_dark.png')
        : const AssetImage('assets/default_profile_light.png');
  }
}
