import 'package:flutter/material.dart';

class NoteImages extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const NoteImages({Key? key, required this.selectedIndex, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onSelect(index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: selectedIndex == index ? Colors.purple : Colors.grey,
                ),
              ),
              width: 140,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [Image.asset('assets/images/${index}.png')],
              ),
            ),
          );
        },
      ),
    );
  }
}
