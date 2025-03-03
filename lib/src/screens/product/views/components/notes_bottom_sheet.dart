import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class NotesBottomSheet extends StatelessWidget {
  final List<dynamic> topNotes;
  final List<dynamic> middleNotes;
  final List<dynamic> baseNotes;

  const NotesBottomSheet({
    super.key,
    required this.topNotes,
    required this.middleNotes,
    required this.baseNotes,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'title': 'TOP NOTES', 'notes': topNotes},
      {'title': 'MIDDLE NOTES', 'notes': middleNotes},
      {'title': 'BASE NOTES', 'notes': baseNotes},
    ];

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const Divider(
          height: 32,
          color: blackColor20,
        ),
        itemBuilder: (context, index) {
          final section = sections[index];
          final notesList = section['notes'] as List<dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                section['title']!.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: defaultPadding,
                runSpacing: defaultPadding,
                children: notesList.map((note) {
                  String noteName = note.containsKey('top_note_name')
                      ? note['top_note_name']!
                      : note.containsKey('middle_note_name')
                          ? note['middle_note_name']!
                          : note['base_note_name']!;

                  // String noteImage = note.containsKey('top-note-image')
                  //     ? note['top-note-image']!
                  //     : note.containsKey('middle-note-image')
                  //         ? note['middle-note-image']!
                  //         : note['base-note-image']!;

                  return SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        // Container(
                        //   width: 50,
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     image: DecorationImage(
                        //       image: NetworkImage(
                        //         'https://nichegallerie.com/wp-content/uploads/2023/04/cinnamon.jpg',
                        //       ),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        Text(
                          noteName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
