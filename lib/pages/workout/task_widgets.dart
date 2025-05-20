import 'package:flavor_harmony_app/pages/workout/edit_screen.dart';
import 'package:flavor_harmony_app/pages/workout/firestor.dart';
import 'package:flavor_harmony_app/pages/workout/note_model.dart';
import 'package:flutter/material.dart';

class TaskWidgets extends StatefulWidget {
  final Note _note;
  TaskWidgets(this._note, {Key? key}) : super(key: key);

  @override
  _TaskWidgetsState createState() => _TaskWidgetsState();
}

class _TaskWidgetsState extends State<TaskWidgets> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget._note.isDon;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Image
              image(),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._note.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Checkbox(
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = value!;
                              FirestoreDatasource()
                                  .toggleIsDone(widget._note.id, isDone);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget._note.subtitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          timeContainer(),
                          SizedBox(width: 10),
                          editButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget image() {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/${widget._note.image}.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget timeContainer() {
    return Container(
      width: 90,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, color: Colors.white),
            SizedBox(width: 10),
            Text(
              widget._note.time,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditScreen(widget._note),
          ),
        );
      },
      child: Container(
        width: 90,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
