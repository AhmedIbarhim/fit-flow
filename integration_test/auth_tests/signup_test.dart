import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_flow/core/components/custom_button.dart';
import 'package:fit_flow/core/components/custom_progress_hud.dart';
import 'package:fit_flow/core/components/custom_snackbar.dart';
import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/core/errors/failure.dart';
import 'package:fit_flow/core/route/app_router.dart';
import 'package:fit_flow/features/auth/data/models/user_model.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';
import 'package:fit_flow/features/auth/presentation/controllers/signup_controller/signup_cubit.dart';
import 'package:fit_flow/features/auth/presentation/views/login_view.dart';
import 'package:fit_flow/features/auth/presentation/views/signup_view.dart';
import 'package:fit_flow/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthRepo mockAuthRepo;

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  setUp(() async {
    mockAuthRepo = MockAuthRepo();
    await locator.reset();
    initServiceLocator();
    await locator.unregister<AuthRepo>();
    locator.registerSingleton<AuthRepo>(mockAuthRepo);
  });

  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(authRepo: locator<AuthRepo>()),
            child: const SignupView(),
          ),
        );
      },
    );
  }

  group("signup screen tests", () {
    testWidgets("Navigate to login screen", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final navigationText = find.text("Login");
      expect(navigationText, findsOneWidget);
      await tester.tap(navigationText);
      await tester.pumpAndSettle();

      expect(find.byType(LoginView), findsOneWidget);
    });

    testWidgets("assure text fields validation", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.byType(CustomButton);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("This field is required"), findsNWidgets(3));
    });

    testWidgets("loading indicator appears when loading", (tester) async {
      when(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          userName: any(named: "userName"),
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer((_) async {
        return Future.delayed(
          const Duration(seconds: 2),
          () => Right(
            UserModel(email: "email@mail.com", name: "name", uId: "123"),
          ),
        );
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key("name_field"));
      final emailField = find.byKey(const Key("email_field"));
      final passwordField = find.byKey(const Key("password_field"));
      final signupButton = find.byType(CustomButton);

      await tester.enterText(nameField, "name");
      await tester.enterText(emailField, "email@mail.com");
      await tester.enterText(passwordField, "123456");
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);
    });

    testWidgets(
      "signup success shows success snackbar and navigates to login",
      (tester) async {
        when(
          () => mockAuthRepo.createUserWithEmailAndPassword(
            userName: "name",
            email: "success@mail.com",
            password: "password123",
          ),
        ).thenAnswer((_) async {
          return Right(
            UserModel(email: "success@mail.com", name: "User", uId: "uid123"),
          );
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final nameField = find.byKey(const Key("name_field"));
        final emailField = find.byKey(const Key("email_field"));
        final passwordField = find.byKey(const Key("password_field"));
        final signupButton = find.byType(CustomButton);

        await tester.enterText(nameField, "name");
        await tester.enterText(emailField, "success@mail.com");
        await tester.enterText(passwordField, "password123");
        await tester.tap(signupButton);

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(CustomSnackBar), findsOneWidget);

        expect(find.byType(LoginView), findsOneWidget);
      },
    );

    testWidgets("signup failure shows error snackbar", (tester) async {
      const errorMessage = "Invalid Credintials";
      when(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          userName: "name",
          email: "fail@mail.com",
          password: "wrongPassword",
        ),
      ).thenAnswer((_) async {
        return Left(ServerFailure(errorMessage));
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key("name_field"));
      final emailField = find.byKey(const Key("email_field"));
      final passwordField = find.byKey(const Key("password_field"));
      final signupButton = find.byType(CustomButton);

      await tester.enterText(nameField, "name");
      await tester.enterText(emailField, "fail@mail.com");
      await tester.enterText(passwordField, "wrongPassword");
      await tester.tap(signupButton);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
