import 'package:expense_tracker/manage_screen.dart';
import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ManageScreenController extends GetxController {
  final box = GetStorage();
  var user = User().obs;
  final apiService = ApiService();
  var currentScreen = 0.obs;
  var isLoading = true.obs;
  @override
  void onReady() async {
    super.onReady();
    await isAuthStateChanged();
    isLoading.value = false;
    print('User: ${user.value.email}');
  }

  void changeScreen(int index) {
    currentScreen.value = index;
  }

  Future<void> isAuthStateChanged() async {
    final token = box.read('expenses');
    if (token != null) {
      await getUser();

      // .whenComplete(() => Get.offAll(() => ManageScreen()));
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> getUser() async {
    try {
      final response = await apiService.getCurrentUser();
      if (response.user != null) {
        user.value = response.user ?? User();
      }
      print('manage user: ${user.value.email}');
    } catch (e) {
      print('error: $e');
    }
  }
}
