import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});


  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date); 
      return DateFormat('d MMM yyyy').format(parsedDate);
    } catch (e) {
      return date; 
    }
  }

  
  String convertTo12HourFormat(String time24) {
    try {
      final timeParts = time24.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12 == 0 ? 12 : hour % 12;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24; 
    }
  }

  
  String getEventStatus(String eventDate, String eventTime) {
    try {
      final parsedDate = DateTime.parse(eventDate); 
      final timeParts = eventTime.split(':'); 
      final eventDateTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
          int.parse(timeParts[0]), int.parse(timeParts[1]));

      final now = DateTime.now();
      if (eventDateTime.isBefore(now)) {
        return "Past Event";
      } else if (eventDateTime.year == now.year &&
          eventDateTime.month == now.month &&
          eventDateTime.day == now.day) {
        return "Today";
      } else {
        return "Upcoming";
      }
    } catch (e) {
      return "Unknown"; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Events',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading events',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No events found.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventDate = event['event_date'] ?? 'No date';
              final eventTime = event['event_time'] ?? 'No time';
              final eventDescription = event['event_description'] ?? 'No description';

              // Format date, time, and determine status
              final formattedDate = formatDate(eventDate);
              final formattedTime = convertTo12HourFormat(eventTime);
              final eventStatus = getEventStatus(eventDate, eventTime);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          eventDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          eventStatus,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: eventStatus == "Past Event"
                                ? Colors.red
                                : eventStatus == "Today"
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventListPage extends StatelessWidget {
//   const EventListPage({super.key});

//   // Helper function to convert 24-hour format to 12-hour format with AM/PM
//   String convertTo12HourFormat(String time24) {
//     try {
//       final timeParts = time24.split(':');
//       int hour = int.parse(timeParts[0]);
//       int minute = int.parse(timeParts[1]);

//       String period = hour >= 12 ? 'PM' : 'AM';
//       hour = hour % 12 == 0 ? 12 : hour % 12;

//       return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//     } catch (e) {
//       return time24; // Return original time if parsing fails
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Saved Events',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('events')
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text(
//                 'Error loading events',
//                 style: TextStyle(fontSize: 18, color: Colors.redAccent),
//               ),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No events found.',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             );
//           }

//           final events = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               final event = events[index];
//               final eventDate = event['event_date'] ?? 'No date';
//               final eventTime = event['event_time'] ?? 'No time';
//               final eventDescription = event['event_description'] ?? 'No description';

//               // Convert time to 12-hour format
//               final formattedTime = convertTo12HourFormat(eventTime);

//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               eventDate,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepPurple,
//                               ),
//                             ),
//                             Text(
//                               formattedTime,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepPurple,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           eventDescription,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
