import 'package:expense_tracker/manage_screen.dart';
import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:expense_tracker/view/home/home_screen.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ManageScreenController extends GetxController {
  final box = GetStorage();
  var user = GetUser_Model().user.obs;
  final apiService = ApiService();
  var currentScreen = 0.obs;

  @override
  void onReady() async {
    super.onReady();
    await isAuthStateChanged();
    print('User: ${user.value?.email}');
  }

  void changeScreen(int index) {
    currentScreen.value = index;
  }

  Future<void> isAuthStateChanged() async {
    final token = box.read('expenses');
    if (token != null) {
      await getUser().whenComplete(() => Get.offAll(() => ManageScreen()));
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> getUser() async {
    try {
      final response = await apiService.getCurrentUser();
      user.value = response.user;
    } catch (e) {
      print('error: $e');
    }
  }
}
