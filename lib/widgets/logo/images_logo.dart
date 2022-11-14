import 'package:flutter/material.dart';
import 'package:note_app/resources/constants/asset_path.dart';

class ImageLogo extends StatelessWidget {
  const ImageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetPaths.logo);
  }
}

class ImageError extends StatelessWidget {
  const ImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetPaths.error);
  }
}