import 'package:fit_flow/core/utils/app_text_styles.dart';
import 'package:fit_flow/features/auth/presentation/controllers/signup_controller/signup_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/utils/app_colors.dart';
import '../../../../core/components/custom_app_bar.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_progress_hud.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/custom_text_form_field.dart';
import '../../../../core/route/routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool isObscure = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          showErrorSnackBar(context, state.errMessage);
        }
        if (state is SignUpSuccess) {
          showSuccessSnackBar(context, "Account created successfully");
          Navigator.pushNamed(context, Routes.login);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          inAsyncCall: state is SignupLoading,
          child: Scaffold(
            appBar: buildCustomAppBar(context, title: "Sign Up"),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),

                        CustomTextFormField(
                          label: "Name",
                          controller: nameController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          label: "Email",
                          controller: emailController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          label: "Password",
                          controller: passwordController,
                          obscureText: isObscure,
                          suffixIcon: IconButton(
                            icon: isObscure
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: AppColors.primaryColor,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 50.h),
                        CustomButton(
                          text: "Sign Up",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<SignupCubit>().signup(
                                userName: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: AppTextStyles.bold16.copyWith(
                                  color: const Color(0xFF949D9E),
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.login,
                                    );
                                  },
                                text: 'Login',
                                style: AppTextStyles.bold16.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
