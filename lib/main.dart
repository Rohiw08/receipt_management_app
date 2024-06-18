import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'package:garage/core/common/error_text.dart';
import 'package:garage/core/common/loading.dart';
import 'package:garage/core/enums/enums.dart';
import 'package:garage/features/auth/controller/auth_controller.dart';
import 'package:garage/firebase_options.dart';
import 'package:garage/l10n/l10n.dart';
import 'package:garage/models/user_model.dart';
import 'package:garage/router.dart';
import 'package:garage/theme/theme.dart';

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

  void getData(String uid, WidgetRef ref) async {
    userModel =
        await ref.watch(authControllerProvider.notifier).getUserData(uid).first;
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
                  getData(data.uid, ref);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
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
