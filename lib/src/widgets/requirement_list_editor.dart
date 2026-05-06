import 'package:flutter/material.dart';

class RequirementListEditor extends StatefulWidget {
  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  const RequirementListEditor({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
  });

  @override
  State<RequirementListEditor> createState() => _RequirementListEditorState();
}

class _RequirementListEditorState extends State<RequirementListEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.values
        .map((value) => TextEditingController(text: value))
        .toList();
  }

  @override
  void didUpdateWidget(covariant RequirementListEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _controllers = widget.values
          .map((value) => TextEditingController(text: value))
          .toList();
    }
  }

  void _notifyChanges() {
    widget.onChanged(
      _controllers
          .map((controller) => controller.text.trim())
          .where((value) => value.isNotEmpty)
          .toList(),
    );
  }

  void _addRequirement() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeRequirement(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
    _notifyChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ..._controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: '${widget.label} ${index + 1}',
                    ),
                    onChanged: (_) => _notifyChanges(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _removeRequirement(index),
                ),
              ],
            ),
          );
        }),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: Text('Add'),
          onPressed: _addRequirement,
        ),
      ],
    );
  }
}
