import 'package:flavor_harmony_app/pages/workout/edit_screen.dart';
import 'package:flavor_harmony_app/services/note_services.dart';
import 'package:flavor_harmony_app/model/note_model.dart';
import 'package:flavor_harmony_app/widget/workout/edit_button.dart';
import 'package:flavor_harmony_app/widget/workout/image_container.dart';
import 'package:flavor_harmony_app/widget/workout/time_container.dart';
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
              ImageContainer(imageName: widget._note.image.toString()),
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
                              NoteServices()
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
                          TimeContainer(time: widget._note.time),
                          SizedBox(width: 10),
                          EditButton(
                            note: widget._note,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(widget._note),
                                ),
                              );
                            },
                          ),
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
}
