import 'package:flutter/material.dart';

class AttendanceUI extends StatefulWidget {
  const AttendanceUI({Key? key}) : super(key: key);

  @override
  State<AttendanceUI> createState() => _AttendanceUIState();
}

class _AttendanceUIState extends State<AttendanceUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เช็คการทำงาน'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ท่านสามารถเช็คการทำงานของพนักงานได้ที่นี่',
              style: TextStyle(fontSize: 18.0),
            ),
            // ส่วนการเช็คการทำงานของพนักงานสามารถเพิ่มเติมต่อได้ตามต้องการ
          ],
        ),
      ),
    );
  }
}
