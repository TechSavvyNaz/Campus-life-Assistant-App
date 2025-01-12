import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:campuslife_assistant/storage/notification_database.dart';
import 'package:campuslife_assistant/services/shared_preferences_service.dart';

import '../services/firestore_service.dart';

class ClassScheduleScreen extends StatefulWidget {
  @override
  _ClassScheduleScreenState createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professorController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  String? _selectedTime = "Select Time";
  String? _selectedDate = "Select Date";
  List<String> _selectedDays = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professorController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showDialog([DocumentSnapshot? schedule]) {
    setState(() {
      _errorMessage = null;
    });

    if (schedule != null) {
      _nameController.text = schedule['name'];
      _professorController.text = schedule['professor'];
      _roomController.text = schedule['room'];
      _selectedTime = schedule['time'];
      _selectedDate = schedule['date'];
      _selectedDays = (schedule['days'] as String).split(',');
    } else {
      _nameController.clear();
      _professorController.clear();
      _roomController.clear();
      _selectedTime = "Select Time";
      _selectedDate = "Select Date";
      _selectedDays.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(schedule == null ? 'Add Class' : 'Edit Class'),
              backgroundColor: Colors.amber[100],
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    _buildTextField(_nameController, 'Class Name', Icons.class_),
                    SizedBox(height: 8.0),
                    _buildTextField(
                        _professorController, 'Professor Name', Icons.person),
                    SizedBox(height: 8.0),
                    _buildTextField(
                        _roomController, 'Room Number', Icons.meeting_room),
                    SizedBox(height: 8.0),
                    _buildDaysSelector(),
                    SizedBox(height: 8.0),
                    _buildDatePicker(context, setState),
                    SizedBox(height: 8.0),
                    _buildTimePicker(context, setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _professorController.text.isEmpty ||
                        _roomController.text.isEmpty ||
                        _selectedDays.isEmpty ||
                        _selectedTime == "Select Time" ||
                        _selectedDate == "Select Date") {
                      setState(() {
                        _errorMessage = 'Please fill all fields';
                      });
                      return;
                    }

                    final user = _auth.currentUser;
                    final classData = {
                      'name': _nameController.text,
                      'professor': _professorController.text,
                      'room': _roomController.text,
                      'time': _selectedTime,
                      'date': _selectedDate,
                      'days': _selectedDays.join(','),
                      'userId': user?.uid,
                    };

                    try {
                      if (schedule == null) {
                        await _firestore.collection('classSchedules').add(classData);

                        // Send add notification
                        await _sendNotification(
                          'Class Added',
                          'The class "${_nameController.text}" has been added.',
                        );
                      } else {
                        await schedule.reference.update(classData);

                        // Send update notification
                        await _sendNotification(
                          'Class Updated',
                          'The class "${_nameController.text}" has been updated.',
                        );
                      }

                      // Save notification in the local database
                      await NotificationDatabase().insertNotification({
                        'title': schedule == null ? 'Class Added' : 'Class Updated',
                        'body':
                        'The class "${_nameController.text}" has been ${schedule == null ? 'added' : 'updated'}.',
                        'timestamp': DateTime.now().toString(),
                      });

                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDaysSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Days:'),
        Wrap(
          spacing: 8.0,
          children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
              .map((day) => ChoiceChip(
            label: Text(day),
            selected: _selectedDays.contains(day),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedDays.add(day);
                } else {
                  _selectedDays.remove(day);
                }
              });
            },
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, StateSetter setState) {
    return ListTile(
      title: Text(_selectedDate!),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate.toString().split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildTimePicker(BuildContext context, StateSetter setState) {
    return ListTile(
      title: Text(_selectedTime!),
      trailing: Icon(Icons.access_time),
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            _selectedTime = pickedTime.format(context);
          });
        }
      },
    );
  }

  Future<void> _sendNotification(String title, String body) async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          'Schedule Notifications',
          channelDescription: 'Class schedule notifications',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class Schedule')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('classSchedules')
            .where('userId', isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No classes scheduled'));
          }

          final schedules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text(schedule['name']),
                subtitle: Text(
                  '${schedule['time']} - ${schedule['days']} - ${schedule['professor']}',
                ),
                onTap: () => _showDialog(schedule),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final className = schedule['name'];
                    await schedule.reference.delete();

                    // Send delete notification
                    await _sendNotification(
                      'Class Deleted',
                      'The class "$className" has been deleted.',
                    );

                    // Save the notification in the local database
                    await NotificationDatabase().insertNotification({
                      'title': 'Class Deleted',
                      'body': 'The class "$className" has been deleted.',
                      'timestamp': DateTime.now().toString(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Class "$className" deleted')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
