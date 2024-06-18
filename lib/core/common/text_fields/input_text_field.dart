import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldCard extends StatelessWidget {
  final TextEditingController nameController;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldCard({
    super.key,
    required this.nameController,
    required this.hintText,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: hintText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          contentPadding: const EdgeInsets.only(top: 10, left: 12, bottom: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${AppLocalizations.of(context)!.pleaseEnter} $hintText';
          }
          return null;
        },
        keyboardType: textInputType,
      ),
    );
  }
}

// ${AppLocalizations.of(context)!.pleaseEnter}