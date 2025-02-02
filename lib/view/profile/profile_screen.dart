import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/logout_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController _profileController = Get.put(ProfileController());
  final LogoutController _logoutController = Get.put(LogoutController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = _profileController.user.value;
      if (_profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (profile == null) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("User not found"),
            SizedBox(
              width: 150,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _logoutController.logout();
                  },
                  label: const Text('Logout'),
                  icon: const Icon(Icons.logout)),
            ),
          ],
        ));
      }
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('My Profile'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/640px-User_icon_2.svg.png'),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTextInput('${profile.username}'),
              const SizedBox(
                height: 20,
              ),
              _buildTextInput("${profile.email}"),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        _logoutController.logout();
                      },
                      label: const Text('Logout'),
                      icon: const Icon(Icons.logout)),
                ),
              )
            ],
          ));
    });
  }

  Widget _buildTextInput(
    String name,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 187, 185, 185).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            hintText: name,
            hintStyle:
                TextStyle(color: const Color.fromARGB(255, 141, 139, 139)),
            border: InputBorder.none),
      ),
    );
  }
}
