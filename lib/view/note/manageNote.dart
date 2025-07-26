import 'package:app/common_widget/button.dart';
import 'package:app/common_widget/keyboard_dismiss.dart';
import 'package:flutter/material.dart';

class ManageNodeScreen extends StatefulWidget {
  const ManageNodeScreen({super.key});

  @override
  State<ManageNodeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ManageNodeScreen> {
  bool _isSaveButtonDisabled = true; // State to manage button disabled status
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fields['title']!.addListener(_updateSaveButtonState);
    _fields['note']!.addListener(_updateSaveButtonState);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _fields['title']!.removeListener(_updateSaveButtonState);
    _fields['note']!.removeListener(_updateSaveButtonState);
    _fields['title']!.dispose();
    _fields['note']!.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(
      () =>
          _isSaveButtonDisabled =
              _fields['title']!.text.isEmpty || _fields['note']!.text.isEmpty,
    );
  }

  onSave() {
    debugPrint('on save ${_fields['title']!.text}');
  }

  final Map<String, TextEditingController> _fields = {
    'title': TextEditingController(),
    'note': TextEditingController(),
  };

  Widget _getBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: KeyboardDismiss(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 24),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                controller: _fields['title'],
                                style: TextStyle(fontSize: 48),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title',
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _fields['note'],
                                maxLines: 10,
                                decoration: InputDecoration(
                                  hintText: 'placeholder',
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: SafeArea(
            child: Button(
              disable: _isSaveButtonDisabled,
              title: 'Save',
              onTap: onSave,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _getBody());
  }
}
