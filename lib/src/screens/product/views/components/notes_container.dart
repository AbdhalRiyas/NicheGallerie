import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class NotesContainer extends StatelessWidget {
  final List<dynamic> topNotes;
  final List<dynamic> middleNotes;
  final List<dynamic> baseNotes;

  const NotesContainer({
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
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Divider(
                height: 1,
                color: blackColor20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // Matches background to hide divider under text
                child: Text(
                  sections[index + 1]['title']!.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        itemBuilder: (context, index) {
          final section = sections[index];
          final notesList = section['notes'] as List<dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (index ==
                  0) // Only show title without divider for the first section
                Text(
                  section['title']!.toString(),
                  style: const TextStyle(
                    fontSize: 18,
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

                  String noteImage = note.containsKey('image_url')
                      ? note['image_url']!
                      : 'https://via.placeholder.com/50';

                  return SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: noteImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          noteName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
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
