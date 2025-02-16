import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final apiService = ApiService();
  var user = User().obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    currentUser();
  }

  Future<void> currentUser() async {
    try {
      isLoading.value = true;
      final response = await apiService.getCurrentUser();
      user.value = response.user!;

      print('User Profile:${user.value.email}');
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (Get.currentRoute.isEmpty) {
        Get.snackbar('Cannot Get User', e.toString());
      }
    }
  }
}
