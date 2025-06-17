import 'package:flutter/material.dart';
import 'package:shop/src/screens/product/views/components/accords_container.dart';
import 'package:shop/src/screens/product/views/components/notes_container.dart';

class CustomTabSwitcher extends StatefulWidget {
  final Map<dynamic, dynamic>? metadata;

  const CustomTabSwitcher({super.key, required this.metadata});

  @override
  State<CustomTabSwitcher> createState() => _CustomTabSwitcherState();
}

class _CustomTabSwitcherState extends State<CustomTabSwitcher> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 0
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    foregroundColor:
                        selectedTab == 0 ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onPressed: () => setState(() => selectedTab = 0),
                  child: const Text(
                    'ACCORDS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 1
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    foregroundColor:
                        selectedTab == 1 ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onPressed: () => setState(() => selectedTab = 1),
                  child: const Text(
                    'NOTES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Dynamic content (auto-sized)
        if (selectedTab == 0)
          AccordsContainer(
            accordsList: widget.metadata?['accords_lists'],
          )
        else
          NotesContainer(
            topNotes: widget.metadata?['top_notes'],
            middleNotes: widget.metadata?['middle_notes'],
            baseNotes: widget.metadata?['base_notes'],
          ),
      ],
    );
  }
}
