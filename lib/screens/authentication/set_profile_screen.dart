import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ludo/configs/route_paths.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/widgets/tonal_elevation.dart';
import 'package:ludo/widgets/custom_network_image.dart';
import 'package:ludo/widgets/buttons.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  State<SetProfileScreen> createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {

  String username = '';
  bool usernameIsAvailable = false;
  bool checkingAvailability = false;
  bool showsSuffixIcon = false;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;

  Future getImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image ?? selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) { // TODO: design SetProfileScreen
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await getImage();
            },
            child: selectedImage == null
            ? CustomNetworkImage(
              imageUrl: auth.player?.profileImageUrl,
              radius: 35,
              shape: BoxShape.circle,
            )
            : SizedBox.square(
                dimension: 70,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35)
                  ),
                  child: Image.file(
                    File(selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: showsSuffixIcon
                  ? checkingAvailability
                    ? Icon(CupertinoIcons.ellipsis, color: Theme.of(context).colorScheme.surface.tonalElevation(Elevation.level5, context),)
                    : usernameIsAvailable 
                      ? Icon(CupertinoIcons.check_mark_circled, color: Theme.of(context).colorScheme.primary,)
                      : Icon(CupertinoIcons.xmark_circle, color: Theme.of(context).colorScheme.error)
                  : null,
                labelText: 'Username',
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                 )
              ),
              onChanged: (value) async {
                username = value;
                setState(() {
                  usernameIsAvailable = false;
                  showsSuffixIcon = false;
                });
              },
              onSubmitted: (value) async{
                setState(() {
                  showsSuffixIcon = true;
                });
                if(!checkingAvailability){
                  setState(() {
                    checkingAvailability = true;
                  });
                  usernameIsAvailable = await auth.usernameIsAvailable(username);
                  setState(() {
                    checkingAvailability = false;
                  });
                }
              },
          
            ),
          ),
          CustomFilledButton(
            label: 'upload profile',
            backgroundColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onPrimary,
            disabled: !usernameIsAvailable,
            onTap: (){
              auth.updateProfile(
                username: username,
                imagePath: selectedImage?.path
              ).then((profileIsUpdated){
                if(profileIsUpdated && context.mounted){
                  GoRouter.of(context).pushReplacement(RoutePaths.home);
                }
              });
            },
          )
        ],
      ),
    );
  }
}