import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedGender = 'Select Gender';
  String selectedTable = 'Select Table';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int numberOfPeople = 4;

  List<String> tableOptions = ['Select Table'];
  final List<String> femaleTables = ['Select Table', 'Table 1', 'Table 2', 'Table 3', 'Table 4'];
  final List<String> maleTables = ['Select Table', 'Table 5', 'Table 6', 'Table 7', 'Table 8', 'Table 9', 'Table 10'];
  final List<String> otherTables = ['Select Table', 'Table 11', 'Table 12'];
  final List<String> familyTables = ['Select Table', 'Table 13', 'Table 14', 'Table 15', 'Table 16', 'Table 17'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Table'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Select Gender', 'Male', 'Female', 'Other', 'Family']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue!;
                  _updateTableOptions();
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat.yMMMMd().format(selectedDate)),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedTable,
              items: tableOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedTable = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Table',
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Time',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(selectedTime.format(context)),
                    Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'How Many People?',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople > 1) numberOfPeople--;
                    });
                  },
                ),
                Text(
                  '$numberOfPeople',
                  style: TextStyle(fontSize: 20.0),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople < 8) numberOfPeople++;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _bookTable,
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTableOptions() {
    switch (selectedGender) {
      case 'Female':
        tableOptions = femaleTables;
        break;
      case 'Male':
        tableOptions = maleTables;
        break;
      case 'Other':
        tableOptions = otherTables;
        break;
      case 'Family':
        tableOptions = familyTables;
        break;
      default:
        tableOptions = ['Select Table'];
        break;
    }
    selectedTable = tableOptions[0];  // Reset the selected table to the default option
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      if (selectedDateTime.isBefore(now)) {
        // Show an error message or handle the case
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Time"),
              content: Text("You cannot select a time in the past."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  void _bookTable() async {
    if (selectedGender == 'Select Gender' || selectedTable == 'Select Table') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incomplete Information"),
            content: Text("Please select gender and table."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Not Signed In"),
            content: Text("You need to sign in to book a table."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final existingBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('selectedTable', isEqualTo: selectedTable)
        .where('selectedDateTime', isEqualTo: Timestamp.fromDate(selectedDateTime))
        .get();

    if (existingBookings.docs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Table Unavailable"),
            content: Text("The selected table is already booked for the selected date and time."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'selectedGender': selectedGender,
        'selectedTable': selectedTable,
        'selectedDateTime': Timestamp.fromDate(selectedDateTime),
        'numberOfPeople': numberOfPeople,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Booking Confirmed"),
            content: Text("Your table has been successfully booked."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: _buildBookingList(context),
    );
  }

  Widget _buildBookingList(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("Please sign in to view your bookings."));
    }

    final now = Timestamp.fromDate(DateTime.now());
    final query = FirebaseFirestore.instance.collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .where('selectedDateTime', isGreaterThanOrEqualTo: now);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text("Error loading bookings"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No bookings found"));
        }

        final bookings = snapshot.data!.docs;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final date = (booking['selectedDateTime'] as Timestamp).toDate();
            return ListTile(
              title: Text("Table: ${booking['selectedTable']}"),
              subtitle: Text(
                "Date: ${DateFormat.yMMMMd().format(date)}\nTime: ${DateFormat.jm().format(date)}\nPeople: ${booking['numberOfPeople']}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  _cancelBooking(booking.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _cancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Booking"),
          content: Text("Are you sure you want to cancel this booking?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
