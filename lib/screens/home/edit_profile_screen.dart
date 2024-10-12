import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ludo/services/auth_service.dart';
import 'package:ludo/widgets/custom_network_image.dart';
import 'package:ludo/widgets/buttons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  late TextEditingController usernameController;

  @override
  void initState(){
    super.initState();
    usernameController = TextEditingController(
      text: Provider.of<AuthService>(context, listen: false).player?.username ?? ''
    );
  }

  @override
  void dispose(){
    usernameController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image ?? selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text('Edit profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(0.02.sw),
        child: SingleChildScrollView(
          child: Column(
            children: [
              0.1.sw.verticalSpace,
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await getImage();
                  },
                  child: selectedImage == null
                  ? CustomNetworkImage(
                    imageUrl: auth.player?.profileImageUrl,
                    radius: 0.1.sw,
                    shape: BoxShape.circle,
                  )
                  : SizedBox.square(
                      dimension: 0.2.sw,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.1.sw)
                        ),
                        child: Image.file(
                          File(selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                  )
                ),
              ),
              0.15.sw.verticalSpace,
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )
                  ),            
                ),
              ),
              0.05.sw.verticalSpace,
          
              CustomFilledButton(
                label: 'upload profile',
                backgroundColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.onPrimary,
                disabled: usernameController.text.length < 3,
                onTap: (){
                  auth.updateProfile(
                    username: usernameController.text,
                    imagePath: selectedImage?.path
                  ).then((profileIsUpdated){
                    if(profileIsUpdated && context.mounted){
                      context.pop();
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}