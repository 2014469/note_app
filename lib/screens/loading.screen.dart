import 'package:flutter/material.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center( 
            //child: SpinKitPumpingHeart	(
              child: SpinKitCubeGrid(	
            // child: SpinKitSpinningLines(
            size: 140,
            color: AppColors.primary,
          ),
        
        
      ),
    );
  }
}