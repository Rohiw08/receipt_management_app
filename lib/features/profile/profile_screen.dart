import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/core/common/appbar_title.dart';
import 'package:garage/core/common/black_button.dart';
import 'package:garage/core/enums/enums.dart';
import 'package:garage/features/auth/controller/auth_controller.dart';
import 'package:garage/theme/theme.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void signOut() {
    ref.watch(authControllerProvider.notifier).signOut();
    Routemaster.of(context).pop();
  }

  void navigateToHomeScreen() {
    Routemaster.of(context).pop();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  void toggleLanguage(WidgetRef ref) {
    ref.read(languageNotifierProvider.notifier).toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final isDarktheme =
        ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark;
    final isLoading = ref.watch(authControllerProvider);
    final userModel = ref.watch(userProvider);
    final userName = userModel?.name ?? "User";
    final userEmail = userModel?.email ?? "Email";
    final userAddress = userModel?.address ?? "Adress";
    final userContactNumber = userModel?.contactNumber ?? "Contact number";
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          appbarTitleText: AppLocalizations.of(context)!.profile,
        ),
        leading: IconButton(
            onPressed: () {
              navigateToHomeScreen();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: themeColor(context),
                child: Text(
                  userName[0].toUpperCase(),
                  style: const TextStyle(fontSize: 45),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                AppLocalizations.of(context)!.storeInfo,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline_outlined),
                title: Text(
                  AppLocalizations.of(context)!.storeName,
                ),
                subtitle: Text(userName),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(AppLocalizations.of(context)!.email),
                subtitle: Text(userEmail),
              ),
              ListTile(
                leading: const Icon(Icons.phone_enabled_outlined),
                title: Text(
                  AppLocalizations.of(context)!.contactNumber,
                ),
                subtitle: Text(userContactNumber),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(
                  AppLocalizations.of(context)!.storeAddress,
                ),
                subtitle: Text(userAddress),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                title: Text(
                  isDarktheme
                      ? AppLocalizations.of(context)!.darkMode
                      : AppLocalizations.of(context)!.lightMode,
                ),
                value: isDarktheme,
                onChanged: (val) => toggleTheme(ref),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                title: Text(
                    ref.watch(languageNotifierProvider.notifier).language ==
                            AppLanguage.english
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.marathi),
                value: ref.watch(languageNotifierProvider.notifier).language ==
                    AppLanguage.english,
                onChanged: (value) => ref
                    .read(languageNotifierProvider.notifier)
                    .toggleLanguage(),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: () {
                  signOut();
                },
                buttonText: AppLocalizations.of(context)!.signOut,
                isLoading: isLoading,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
