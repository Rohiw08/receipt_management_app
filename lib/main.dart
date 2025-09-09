import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:receipt_creator/core/common/error_text.dart';
import 'package:receipt_creator/core/common/loading.dart';
import 'package:receipt_creator/core/enums/enums.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/firebase_options.dart';
import 'package:receipt_creator/l10n/l10n.dart';
import 'package:receipt_creator/models/user_model.dart';
import 'package:receipt_creator/router.dart';
import 'package:receipt_creator/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  String? _lastUid;

  void getData(String uid, WidgetRef ref) async {
    userModel =
        await ref.read(authControllerProvider.notifier).getUserData(uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateProvider).when(
        data: (data) => MaterialApp.router(
              supportedLocales: L10n.all,
              locale: Locale(
                  ref.watch(languageNotifierProvider) == AppLanguage.english
                      ? 'en'
                      : 'mr'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              debugShowCheckedModeBanner: false,
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  if (_lastUid != data.uid || userModel == null) {
                    _lastUid = data.uid;
                    getData(data.uid, ref);
                  }
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                } else {
                  userModel = null;
                  _lastUid = null;
                }
                return loggedOutRoute;
              }),
              routeInformationParser: const RoutemasterParser(),
              theme: ref.watch(themeNotifierProvider),
            ),
        error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
        loading: () => const Loader());
  }
}
