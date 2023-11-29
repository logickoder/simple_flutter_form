import 'package:flutter/material.dart';
import '../app/data/model/form.dart' as model;
import '../app/domain/service/form_service.dart';
import '../app/route.dart';
import '../app/theme.dart';

class FormListScreen extends StatefulWidget {
  const FormListScreen({super.key});

  @override
  State<FormListScreen> createState() => _FormListScreenState();
}

class _FormListScreenState extends State<FormListScreen> {
  List<model.Form> _items = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, _refreshList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Forms'),
      ),
      body: _items.isEmpty ? _emptyScreen() : _screen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.of(context).primary,
        foregroundColor: AppColor.of(context).background,
        child: const Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }

  Widget _emptyScreen() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No forms found, click the + button to add a new form',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _screen() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (_, index) {
        final item = _items[index];
        final texts = <String>[
          item.name,
          item.email,
          item.phoneNumber,
          item.address,
        ].where((text) => text.isNotEmpty).toList();

        return ListTile(
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            texts.map((text) => _take(text)).join('; '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => _navigateToForm(item),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  /// retrieves all forms from the database
  Future<void> _refreshList() async {
    final items = await FormService.getAll();
    setState(() => _items = items);
  }

  void _navigateToForm([model.Form? form]) async {
    final itemChanged = await Navigator.pushNamed(
      context,
      AppRoute.form,
      arguments: form,
    );
    if (itemChanged == true) {
      await _refreshList();
    }
  }

  String _take(String string, [int limit = 6]) {
    if (string.length <= limit) {
      return string;
    }

    return string.substring(0, limit);
  }
}
