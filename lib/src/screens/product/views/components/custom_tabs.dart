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

  final List<String> _tabs = ['ACCORDS', 'NOTES'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = selectedTab == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () => setState(() => selectedTab = index),
                    child: Text(
                      _tabs[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
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
