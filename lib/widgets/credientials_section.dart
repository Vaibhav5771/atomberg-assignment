import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'credential_text_field.dart';
import 'labeled_crediential_field.dart';



class CredentialsSection extends StatelessWidget {
  final TextEditingController apiKeyController;
  final TextEditingController refreshTokenController;
  final bool saveCredentials;
  final ValueChanged<bool?> onSaveCredentialsChanged;
  final VoidCallback onOpenDeveloperPortal;


  const CredentialsSection({
    super.key,
    required this.apiKeyController,
    required this.refreshTokenController,
    required this.saveCredentials,
    required this.onSaveCredentialsChanged,
    required this.onOpenDeveloperPortal,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double logoHeight = constraints.maxWidth * 0.02;

              return SvgPicture.asset(
                'assets/images/logo.svg',
                height: logoHeight.clamp(50, 120),
                fit: BoxFit.contain,
              );
            },
          ),
        ),

        LabeledCredentialField(
          label: 'API Key',
          field: CredentialTextField(
            controller: apiKeyController,
            hintText: 'Paste your API Key here',
            svgIconPath: 'assets/icons/api.svg',
            validator: (value) =>
            value?.trim().isEmpty ?? true ? 'API Key is required' : null,
          ),
        ),

        const SizedBox(height: 16),

        LabeledCredentialField(
          label: 'Refresh Token',
          field: CredentialTextField(
            controller: refreshTokenController,
            hintText: 'Paste your Refresh Token here',
            svgIconPath: 'assets/icons/refresh.svg',
            validator: (value) =>
            value?.trim().isEmpty ?? true
                ? 'Refresh Token is required'
                : null,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                        (states) {
                      return const BorderSide(
                        color: Colors.white,
                        width: 1,
                      );
                    },
                  ),
                  fillColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.transparent, // no fill even when checked
                  ),
                  checkColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              child: Checkbox(
                value: saveCredentials,
                onChanged: onSaveCredentialsChanged,
              ),
            ),


            const Text(
              'Save credentials',
              style: TextStyle(
                fontFamily: 'IBMPlexSans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: onOpenDeveloperPortal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.link,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'You can get your API Key and Refresh Token from Atomberg Developer Portal',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


      ],
    );
  }
}
