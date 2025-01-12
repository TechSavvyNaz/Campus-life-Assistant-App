import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class StudyGroupsScreen extends StatefulWidget {
  @override
  _StudyGroupsScreenState createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedDepartment = 'Computer Science';
  final List<String> _departments = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Business Administration',
    'Software Engineering',
    'Biotechnology',
    'Mathematics',
    'Physics',
    'Chemistry'
  ];

  void _createGroup() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to create a study group')),
      );
      return;
    }

    if (_groupNameController.text.isNotEmpty && _groupDescriptionController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('study_groups').add({
        'groupName': _groupNameController.text,
        'description': _groupDescriptionController.text,
        'department': _selectedDepartment,
        'adminId': user.uid,
        'adminEmail': user.email ?? 'Anonymous',
        'members': [user.uid],
        'timestamp': FieldValue.serverTimestamp(),
      });
      _groupNameController.clear();
      _groupDescriptionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Study group created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
    }
  }

  void _joinGroup(String groupId) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to join a study group')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('study_groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You joined the study group')),
    );
  }

  void _leaveGroup(String groupId) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to leave a study group')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('study_groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([user.uid]),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You left the study group')),
    );
  }

  void _editGroup(String groupId, String currentName, String currentDescription) {
    _groupNameController.text = currentName;
    _groupDescriptionController.text = currentDescription;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Study Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _groupDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('study_groups').doc(groupId).update({
                'groupName': _groupNameController.text,
                'description': _groupDescriptionController.text,
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Study group updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Study Groups'),
        backgroundColor: Color(0xFF1765ED),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _groupDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedDepartment,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value!;
                    });
                  },
                  items: _departments
                      .map((department) => DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  ))
                      .toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1765ED),
                  ),
                  child: Text('Create Group'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('study_groups')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    bool isAdmin = doc['adminId'] == user?.uid;
                    bool isMember = (doc['members'] as List).contains(user?.uid);

                    return ListTile(
                      title: Text(doc['groupName']),
                      subtitle: Text('Department: ${doc['department']}\n${doc['description']}'),
                      trailing: isAdmin
                          ? IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _editGroup(
                            doc.id, doc['groupName'], doc['description']),
                      )
                          : isMember
                          ? TextButton(
                        onPressed: () => _leaveGroup(doc.id),
                        child: Text('Leave'),
                      )
                          : ElevatedButton(
                        onPressed: () => _joinGroup(doc.id),
                        child: Text('Join'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
//study group creation