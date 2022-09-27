import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  String text = "";
  Widget Function(BuildContext)? pageBuilder;

  CustomDialog(this.text, this.pageBuilder);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Title(
                color: Colors.black,
                child: Text(text, style: TextStyle(fontSize: 20)),
              ),
              Container(
                width: 60.0,
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: ElevatedButton (
                  onPressed: () {
                    if (pageBuilder == null) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: pageBuilder!));
                    }
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}