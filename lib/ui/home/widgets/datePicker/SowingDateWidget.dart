import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SowingDateWidget extends StatefulWidget {

  final Function(DateTime) onDateSelected;

  const SowingDateWidget({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<SowingDateWidget> createState() => _SowingDateWidgetState();
}


class _SowingDateWidgetState extends State<SowingDateWidget> {

  DateTime? selectedDate;


  Future<void> _pickDate() async {

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );


    if (date != null) {

      setState(() {
        selectedDate = date;
      });


      // HomeScreen ko date bhej do
      widget.onDateSelected(date);

    }
  }


  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          "Sowing Date",
          style: theme.textTheme.titleLarge,
        ),


        const SizedBox(height: 12),


        InkWell(

          borderRadius: BorderRadius.circular(16),

          onTap: _pickDate,


          child: Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),


            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(.2),
              ),

            ),


            child: Row(

              children: [

                Icon(
                  Icons.calendar_month_rounded,
                  color: theme.colorScheme.primary,
                ),


                const SizedBox(width: 15),


                Expanded(

                  child: Text(

                    selectedDate == null
                        ? "Select Sowing Date"
                        : DateFormat("dd MMM yyyy")
                            .format(selectedDate!),


                    style: theme.textTheme.bodyLarge,

                  ),

                ),


                Icon(
                  Icons.keyboard_arrow_right,
                  color: theme.colorScheme.primary,
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }
}