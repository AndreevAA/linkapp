import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';
import 'package:linkapp/Settings/iconStyleSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class DisignElements {

  static Container DivisionLineOne(){
    return new Container(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0), height: 1, color: BlockColors.additionalColor,
    margin: const EdgeInsets.only(left: 10.0, right: 10.0),);
  }

  static setDivisionFieldOne(){
    return new Container(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0), height: 20, color: BlockColors.divisionField,
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),);
  }

  static getlCircleAvatarThree(){
    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
      child: CircleAvatar(
        radius: IconSizes.avatarCircleSizeThree,
        backgroundColor: IconColors.additionalColor,
        child: TextSettings.titleTenCenter("AA") ,
        foregroundColor: Colors.white,
      ),
    );
  }

}

class ProfileOperations {
  static Scaffold OpenPersonProfile(String _inputPersonToken){


  }
}