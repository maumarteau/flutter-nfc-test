import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class EventCardData extends StatelessWidget {
  final dynamic eventData;

  const EventCardData({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  String formatDate(DateTime dateTime, String format) {
    Intl.defaultLocale = 'es';
    initializeDateFormatting();
    final formatter = DateFormat(format, Intl.defaultLocale);
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: eventData.isEmpty
          ? const CircularProgressIndicator()
          : Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      eventData['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatDate(
                          DateTime.parse(eventData['startAt']),
                          'dd MMMM, yyyy',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatDate(
                          DateTime.parse(eventData['startAt']),
                          'EEEE, HH:mm',
                        ),
                        style: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
