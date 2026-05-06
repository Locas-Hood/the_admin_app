import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../models/service_models.dart';
import '../providers/app_state.dart';
import '../widgets/requirement_list_editor.dart';

class DigitalServicesEditorScreen extends StatelessWidget {
  const DigitalServicesEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.locale;
    final servicesFile = appState.servicesFile;

    if (servicesFile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppStrings.loading(locale),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            AppStrings.digitalServices(locale),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        for (final category in servicesFile.categories)
          Card(
            child: ExpansionTile(
              title: Text(
                locale.languageCode == 'ar'
                    ? category.categoryAr
                    : category.categoryEn,
              ),
              children: [
                for (final service in category.services)
                  DigitalServiceEditor(
                    service: service,
                    locale: locale,
                    onChanged: () {
                      appState.setStatus('${service.nameEn} updated.');
                    },
                  ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: Text(AppStrings.saveButton(locale)),
            onPressed: () async {
              try {
                await appState.saveServicesFile();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        appState.statusMessage ??
                            AppStrings.saveSuccess(locale),
                      ),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppStrings.saveFailed(locale)}: $error'),
                    ),
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class DigitalServiceEditor extends StatefulWidget {
  final DigitalServiceItem service;
  final Locale locale;
  final VoidCallback onChanged;

  const DigitalServiceEditor({
    super.key,
    required this.service,
    required this.locale,
    required this.onChanged,
  });

  @override
  State<DigitalServiceEditor> createState() => _DigitalServiceEditorState();
}

class _DigitalServiceEditorState extends State<DigitalServiceEditor> {
  late TextEditingController _nameAr;
  late TextEditingController _nameEn;
  late TextEditingController _descriptionAr;
  late TextEditingController _descriptionEn;
  late TextEditingController _officialUrl;

  @override
  void initState() {
    super.initState();
    _nameAr = TextEditingController(text: widget.service.nameAr);
    _nameEn = TextEditingController(text: widget.service.nameEn);
    _descriptionAr = TextEditingController(text: widget.service.descriptionAr);
    _descriptionEn = TextEditingController(text: widget.service.descriptionEn);
    _officialUrl = TextEditingController(text: widget.service.officialUrl);
  }

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    _descriptionAr.dispose();
    _descriptionEn.dispose();
    _officialUrl.dispose();
    super.dispose();
  }

  void _applyChanges() {
    widget.service.nameAr = _nameAr.text.trim();
    widget.service.nameEn = _nameEn.text.trim();
    widget.service.descriptionAr = _descriptionAr.text.trim();
    widget.service.descriptionEn = _descriptionEn.text.trim();
    widget.service.officialUrl = _officialUrl.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.languageCode == 'ar'
                  ? widget.service.nameAr
                  : widget.service.nameEn,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameAr,
              decoration: InputDecoration(labelText: 'Name AR'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameEn,
              decoration: InputDecoration(labelText: 'Name EN'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionAr,
              decoration: InputDecoration(labelText: 'Description AR'),
              maxLines: 2,
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionEn,
              decoration: InputDecoration(labelText: 'Description EN'),
              maxLines: 2,
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _officialUrl,
              decoration: InputDecoration(labelText: 'Official URL'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 14),
            RequirementListEditor(
              label: locale.languageCode == 'ar'
                  ? 'متطلبات عربية'
                  : 'Arabic Requirements',
              values: widget.service.requirementsAr,
              onChanged: (items) {
                setState(() {
                  widget.service.requirementsAr = items;
                });
                widget.onChanged();
              },
            ),
            const SizedBox(height: 14),
            RequirementListEditor(
              label: locale.languageCode == 'ar'
                  ? 'متطلبات إنجليزية'
                  : 'English Requirements',
              values: widget.service.requirementsEn,
              onChanged: (items) {
                setState(() {
                  widget.service.requirementsEn = items;
                });
                widget.onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}
