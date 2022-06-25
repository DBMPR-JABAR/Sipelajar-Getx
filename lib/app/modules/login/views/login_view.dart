import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../helper/loading.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_login.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Image.asset(
                    "assets/images/logo-sp2.png",
                    fit: BoxFit.contain,
                    height: Get.height * 0.2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => TextField(
                        controller: controller.usernameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          hintText: "Masukan NIP / NIK / Email",
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          errorText: controller.usernameError.value != ''
                              ? controller.usernameError.value
                              : null,
                        ),
                        onChanged: controller.usernameOnChanged,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: !controller.isShowPassword.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isShowPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: controller.isShowPassword.value
                                  ? Colors.white
                                  : Colors.white,
                            ),
                            onPressed: () {
                              controller.isShowPassword.toggle();
                            },
                          ),
                          errorText: controller.passwordError.value != ''
                              ? controller.passwordError.value
                              : null,
                        ),
                        onChanged: controller.passwordOnChanged,
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Container(
                        width: Get.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: controller.buttonEnabled.value
                                    ? Colors.amberAccent
                                    : Colors.grey,
                                splashFactory: controller.buttonEnable.value
                                    ? null
                                    : NoSplash.splashFactory),
                            onPressed: () {
                              controller.buttonEnabled.value
                                  ? controller.login()
                                  : null;
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )),
                  ],
                )),
                SizedBox(
                    child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/jabar.png',
                        width: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GetBuilder<LoginController>(
                      builder: (controller) => Text(
                        'Version ${controller.packageInfo.version}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Obx(() => controller.isLoading.value ? Loading() : Container())
          ]),
        ),
      ),
    );
  }
}
