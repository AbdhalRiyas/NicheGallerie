import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

import '../../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (email) {
              // Save email logic
            },
            validator: emaildValidator.call,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon:
                  FormFieldSvgIcon(iconPath: "assets/icons/Message.svg"),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: "Phone",
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: SvgPicture.asset(
                      "assets/icons/Phone.svg",
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withValues(alpha: 0.3),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  CountryCodePicker(
                    padding: EdgeInsets.zero,
                    showFlag: false,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                      color: whiteColor,
                    ),
                    dialogSize: const Size.fromHeight(400),
                    showDropDownButton: true,
                    onChanged: print,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    initialSelection: '+971',
                    searchDecoration: InputDecoration(
                      fillColor: lightGreyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                      hintText: 'Search country',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _textEditingController,
            onSaved: (date) {
              // Save birth date logic
            },
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: "Birthday",
              prefixIcon:
                  FormFieldSvgIcon(iconPath: "assets/icons/Calender.svg"),
            ),
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () {
              _selectDate(context);
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (pass) {
              // Save password logic
            },
            validator: passwordValidator.call,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: FormFieldSvgIcon(iconPath: "assets/icons/Lock.svg"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _textEditingController.text = DateFormat.yMd().format(_selectedDate);
      });
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
