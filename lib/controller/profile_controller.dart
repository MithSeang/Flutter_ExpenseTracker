import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final apiService = ApiService();
  var user = GetUser_Model().user.obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    currentUser();
  }

  void currentUser() async {
    try {
      isLoading.value = true;
      final response = await apiService.getCurrentUser();
      user.value = response.user;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Cannot Get User', e.toString());
    }
  }
}
