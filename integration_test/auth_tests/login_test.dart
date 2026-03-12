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
import 'package:fit_flow/features/auth/presentation/controllers/login_controller/login_cubit.dart';
import 'package:fit_flow/features/auth/presentation/views/login_view.dart';
import 'package:fit_flow/features/auth/presentation/views/signup_view.dart';
import 'package:fit_flow/features/home/presentation/views/home_view.dart';
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
          home: BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(authRepo: locator<AuthRepo>()),
            child: const LoginView(),
          ),
        );
      },
    );
  }

  group("login screen tests", () {
    testWidgets("Navigate to signup screen", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final navigationText = find.textContaining('Sign Up');
      expect(navigationText, findsOneWidget);
      await tester.tapAt(
        tester.getBottomRight(navigationText).translate(-30, -15),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SignupView), findsOneWidget);
    });

    testWidgets("assure text fields validation", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.byType(CustomButton);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("This field is required"), findsNWidgets(2));
    });

    testWidgets("loading indicator appears when loading", (tester) async {
      when(
        () => mockAuthRepo.signInWithEmailAndPassword(
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

      final emailField = find.byKey(const Key("email_field"));
      final passwordField = find.byKey(const Key("password_field"));
      final loginButton = find.byType(CustomButton);

      await tester.enterText(emailField, "email@mail.com");
      await tester.enterText(passwordField, "123456");
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);
    });

    testWidgets("login success shows success snackbar and navigates to home", (
      tester,
    ) async {
      when(
        () => mockAuthRepo.signInWithEmailAndPassword(
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

      await tester.enterText(
        find.byKey(const Key("email_field")),
        "success@mail.com",
      );
      await tester.enterText(
        find.byKey(const Key("password_field")),
        "password123",
      );
      await tester.tap(find.byType(CustomButton));

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(CustomSnackBar), findsOneWidget);

      expect(find.byType(HomeView), findsOneWidget);

      // expect(find.text("Home"), findsOneWidget);
    });

    testWidgets("login failure shows error snackbar", (tester) async {
      const errorMessage = "Invalid Name or Password";
      when(
        () => mockAuthRepo.signInWithEmailAndPassword(
          email: "fail@mail.com",
          password: "wrongpassword",
        ),
      ).thenAnswer((_) async {
        return Left(ServerFailure(errorMessage));
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key("email_field"));
      final passwordField = find.byKey(const Key("password_field"));
      final loginButton = find.byType(CustomButton);

      await tester.enterText(emailField, "fail@mail.com");
      await tester.enterText(passwordField, "wrongpassword");
      await tester.tap(loginButton);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
