import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Validate this field on blur or explicit form submission, never on first tap.
class AppTextField extends FormField<String> {
  AppTextField({
    super.key,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
    super.enabled = true,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    int? maxLines = 1,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
         initialValue: controller.text,
         validator: validator == null
             ? null
             : (_) => validator(controller.text),
         autovalidateMode: AutovalidateMode.onUnfocus,
         builder: (field) {
           final border = OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: const BorderSide(color: AppColors.error, width: 1.5),
           );
           return Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               if (field.hasError)
                 Padding(
                   padding: const EdgeInsets.only(bottom: 8),
                   child: FieldErrorNotice(field.errorText!),
                 ),
               TextField(
                 controller: controller,
                 enabled: enabled,
                 obscureText: obscureText,
                 autocorrect: autocorrect,
                 enableSuggestions: enableSuggestions,
                 keyboardType: keyboardType,
                 autofillHints: autofillHints,
                 inputFormatters: inputFormatters,
                 maxLength: maxLength,
                 maxLines: maxLines,
                 onChanged: field.didChange,
                 onTapOutside: (_) =>
                     FocusManager.instance.primaryFocus?.unfocus(),
                 decoration: field.hasError
                     ? decoration.copyWith(
                         enabledBorder: border,
                         focusedBorder: border,
                       )
                     : decoration,
               ),
             ],
           );
         },
       );
}

class FieldErrorNotice extends StatelessWidget {
  final String message;
  const FieldErrorNotice(this.message, {super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EF),
        border: Border.all(color: const Color(0xFFF3BCBC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class AppSelectField<T> extends FormField<T> {
  AppSelectField({
    super.key,
    super.initialValue,
    super.validator,
    required List<DropdownMenuItem<T>>? items,
    required ValueChanged<T?>? onChanged,
    Widget? hint,
    bool isExpanded = true,
    BorderRadius? borderRadius,
    Color? dropdownColor,
    Widget? icon,
    Color? iconEnabledColor,
    TextStyle? style,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
         autovalidateMode: AutovalidateMode.disabled,
         builder: (field) => Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             if (field.hasError)
               Padding(
                 padding: const EdgeInsets.only(bottom: 8),
                 child: FieldErrorNotice(field.errorText!),
               ),
             InputDecorator(
               decoration: decoration.copyWith(
                 enabled: onChanged != null,
                 enabledBorder: field.hasError
                     ? OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                         borderSide: const BorderSide(color: AppColors.error),
                       )
                     : null,
               ),
               isEmpty: field.value == null && hint == null,
               child: DropdownButtonHideUnderline(
                 child: DropdownButton<T>(
                   value: field.value,
                   items: items,
                   hint: hint,
                   isExpanded: isExpanded,
                   isDense: true,
                   borderRadius: borderRadius ?? BorderRadius.circular(12),
                   dropdownColor: dropdownColor ?? Colors.white,
                   icon: icon ?? const Icon(Icons.expand_more),
                   iconEnabledColor: iconEnabledColor ?? AppColors.textMuted,
                   style:
                       style ??
                       const TextStyle(
                         fontFamily: 'Roboto',
                         color: AppColors.textDark,
                         fontSize: 14,
                       ),
                   onChanged: onChanged == null
                       ? null
                       : (value) {
                           field.didChange(value);
                           field.validate();
                           onChanged(value);
                         },
                 ),
               ),
             ),
           ],
         ),
       );
}
