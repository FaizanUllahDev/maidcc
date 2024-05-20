import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/core/widgets/gap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType textInputType;
  final String? Function(String?)? validation;
  final bool alignCenter;
  final bool readOnly;
  final double? borderRadius;
  final bool obscureText;
  final int maxLength;
  final TextCapitalization textCapitalization;
  final String? label;
  final TextInputAction? inputAction;
  final bool rejectSpecialChar;
  final bool allowDecimals;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool showStericPassword;

  const CommonTextFieldWidget({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.textInputType = TextInputType.text,
    this.validation,
    this.borderRadius,
    this.alignCenter = false,
    this.readOnly = false,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength = 25,
    this.label,
    this.inputAction,
    this.rejectSpecialChar = false,
    this.onEditingComplete,
    this.allowDecimals = true,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.showStericPassword = false,
  });

  @override
  State<CommonTextFieldWidget> createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
      borderSide: const BorderSide(color: AppColors.outlinedInputBorder),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            // style: context.textTheme.titleMedium,
          ),
          const Gap(),
        ],
        TextFormField(
          obscureText: widget.obscureText,
          validator: widget.validation,
          keyboardType: widget.textInputType,
          controller: widget.controller,
          textCapitalization: widget.textCapitalization,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),

            // show * in password

            // specialChar
            if (widget.rejectSpecialChar)
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            if (widget.textInputType == TextInputType.number)
              widget.allowDecimals
                  ? FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  : FilteringTextInputFormatter.digitsOnly,
          ],
          readOnly: widget.readOnly,
          textAlign: widget.alignCenter ? TextAlign.center : TextAlign.start,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            // Placeholder text
            // contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 32),

            helperStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
            border: outlineInputBorder,
            suffixIcon: widget.suffixIcon,

            focusedBorder: outlineInputBorder,

            disabledBorder: outlineInputBorder,

            enabled: true,
            enabledBorder: outlineInputBorder,

            // color
            fillColor: Colors.white,
            filled: true,
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
            hintTextDirection: TextDirection.ltr,
          ),
          textInputAction: widget.inputAction ?? TextInputAction.next,
          onEditingComplete: widget.onEditingComplete,

          onChanged: (text) {
            // Handle text changes
            if (kDebugMode) {
              print('Text changed: $text');
            }
            widget.onChanged?.call(text);
          },
          minLines: widget.minLines,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
        ),
      ],
    );
  }
}
