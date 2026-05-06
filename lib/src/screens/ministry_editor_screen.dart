import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../models/data_models.dart';
import '../providers/app_state.dart';
import '../widgets/requirement_list_editor.dart';

class MinistryEditorScreen extends StatelessWidget {
  const MinistryEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.locale;
    final dataDocument = appState.dataFile;

    if (dataDocument == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            appState.statusMessage?.isNotEmpty == true
                ? appState.statusMessage!
                : AppStrings.loading(locale),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              AppStrings.ministries(locale),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          for (
            var sectionIndex = 0;
            sectionIndex < dataDocument.sections.length;
            sectionIndex++
          )
            SectionEditor(
              section: dataDocument.sections[sectionIndex],
              sectionIndex: sectionIndex,
              locale: locale,
              onChanged: () {
                appState.setStatus('Section ${sectionIndex + 1} updated.');
              },
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(AppStrings.saveButton(locale)),
              onPressed: () async {
                try {
                  await appState.saveDataFile();
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
                        content: Text(
                          '${AppStrings.saveFailed(locale)}: $error',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SectionEditor extends StatelessWidget {
  final DataSection section;
  final int sectionIndex;
  final Locale locale;
  final VoidCallback onChanged;

  const SectionEditor({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.locale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        initiallyExpanded: sectionIndex == 0,
        title: Text(
          locale.languageCode == 'ar'
              ? 'القسم ${sectionIndex + 1}'
              : 'Section ${sectionIndex + 1}',
        ),
        subtitle: Text(section.lastUpdate),
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final ministry in section.ministries)
                  MinistryEditorCard(
                    ministry: ministry,
                    locale: locale,
                    onChanged: onChanged,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MinistryEditorCard extends StatefulWidget {
  final Ministry ministry;
  final Locale locale;
  final VoidCallback onChanged;

  const MinistryEditorCard({
    super.key,
    required this.ministry,
    required this.locale,
    required this.onChanged,
  });

  @override
  State<MinistryEditorCard> createState() => _MinistryEditorCardState();
}

class _MinistryEditorCardState extends State<MinistryEditorCard> {
  late TextEditingController _nameAr;
  late TextEditingController _nameEn;
  late TextEditingController _provinces;

  @override
  void initState() {
    super.initState();
    _nameAr = TextEditingController(text: widget.ministry.nameAr);
    _nameEn = TextEditingController(text: widget.ministry.nameEn);
    _provinces = TextEditingController(text: widget.ministry.provinces);
  }

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    _provinces.dispose();
    super.dispose();
  }

  void _applyChanges() {
    widget.ministry.nameAr = _nameAr.text.trim();
    widget.ministry.nameEn = _nameEn.text.trim();
    widget.ministry.provinces = _provinces.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.languageCode == 'ar'
                  ? widget.ministry.nameAr
                  : widget.ministry.nameEn,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameAr,
              decoration: InputDecoration(labelText: 'Ministry Name AR'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameEn,
              decoration: InputDecoration(labelText: 'Ministry Name EN'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _provinces,
              decoration: InputDecoration(labelText: 'Provinces'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 16),
            for (final directorate in widget.ministry.directorates)
              DirectorateEditor(
                directorate: directorate,
                locale: locale,
                onChanged: widget.onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

class DirectorateEditor extends StatefulWidget {
  final Directorate directorate;
  final Locale locale;
  final VoidCallback onChanged;

  const DirectorateEditor({
    super.key,
    required this.directorate,
    required this.locale,
    required this.onChanged,
  });

  @override
  State<DirectorateEditor> createState() => _DirectorateEditorState();
}

class _DirectorateEditorState extends State<DirectorateEditor> {
  late TextEditingController _nameAr;
  late TextEditingController _nameEn;

  @override
  void initState() {
    super.initState();
    _nameAr = TextEditingController(text: widget.directorate.nameAr);
    _nameEn = TextEditingController(text: widget.directorate.nameEn);
  }

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    super.dispose();
  }

  void _applyChanges() {
    widget.directorate.nameAr = _nameAr.text.trim();
    widget.directorate.nameEn = _nameEn.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.languageCode == 'ar'
                  ? widget.directorate.nameAr
                  : widget.directorate.nameEn,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameAr,
              decoration: InputDecoration(labelText: 'Directorate Name AR'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameEn,
              decoration: InputDecoration(labelText: 'Directorate Name EN'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 16),
            for (final service in widget.directorate.services)
              MinistryServiceEditor(
                ministryService: service,
                locale: locale,
                onChanged: widget.onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

class MinistryServiceEditor extends StatefulWidget {
  final MinistryService ministryService;
  final Locale locale;
  final VoidCallback onChanged;

  const MinistryServiceEditor({
    super.key,
    required this.ministryService,
    required this.locale,
    required this.onChanged,
  });

  @override
  State<MinistryServiceEditor> createState() => _MinistryServiceEditorState();
}

class _MinistryServiceEditorState extends State<MinistryServiceEditor> {
  late TextEditingController _titleAr;
  late TextEditingController _titleEn;
  late TextEditingController _link;

  @override
  void initState() {
    super.initState();
    _titleAr = TextEditingController(text: widget.ministryService.titleAr);
    _titleEn = TextEditingController(text: widget.ministryService.titleEn);
    _link = TextEditingController(text: widget.ministryService.link);
  }

  @override
  void dispose() {
    _titleAr.dispose();
    _titleEn.dispose();
    _link.dispose();
    super.dispose();
  }

  void _applyChanges() {
    widget.ministryService.titleAr = _titleAr.text.trim();
    widget.ministryService.titleEn = _titleEn.text.trim();
    widget.ministryService.link = _link.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.languageCode == 'ar'
                  ? widget.ministryService.titleAr
                  : widget.ministryService.titleEn,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleAr,
              decoration: InputDecoration(labelText: 'Title AR'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleEn,
              decoration: InputDecoration(labelText: 'Title EN'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _link,
              decoration: InputDecoration(labelText: 'Link'),
              onChanged: (_) => _applyChanges(),
            ),
            const SizedBox(height: 14),
            RequirementListEditor(
              label: locale.languageCode == 'ar'
                  ? 'متطلبات عربية'
                  : 'Arabic Requirements',
              values: widget.ministryService.req,
              onChanged: (items) {
                setState(() {
                  widget.ministryService.req = items;
                });
                widget.onChanged();
              },
            ),
            const SizedBox(height: 14),
            RequirementListEditor(
              label: locale.languageCode == 'ar'
                  ? 'متطلبات إنجليزية'
                  : 'English Requirements',
              values: widget.ministryService.reqEn,
              onChanged: (items) {
                setState(() {
                  widget.ministryService.reqEn = items;
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
