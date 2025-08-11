import 'package:app/bloc/note/note_bloc.dart';
import 'package:app/helpers/response_api.dart';
import 'package:app/shared/path.dart';
import 'package:flutter/material.dart';
import 'package:app/common_widget/common_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageNodeScreen extends StatefulWidget {
  final String method;
  final dynamic data;
  const ManageNodeScreen({required this.method, this.data, super.key});

  @override
  State<ManageNodeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ManageNodeScreen> {
  bool _isSaveButtonDisabled = true; // State to manage button disabled status
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadData();
    _fields['title']['controller']!.addListener(_updateSaveButtonState);
    _fields['detail']['controller']!.addListener(_updateSaveButtonState);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _fields['title']['controller']!.removeListener(_updateSaveButtonState);
    _fields['detail']['controller']!.removeListener(_updateSaveButtonState);
    _fields['title']['controller']!.dispose();
    _fields['detail']['controller']!.dispose();
    super.dispose();
  }

  _loadData() {
    if (widget.method == 'edit') {
      _fields['title']['controller']!.text = widget.data['title'];
      _fields['detail']['controller']!.text = widget.data['detail'];
    }
  }

  void _updateSaveButtonState() {
    setState(
      () =>
          _isSaveButtonDisabled =
              _fields['title']['controller']!.text.isEmpty ||
              _fields['detail']['controller']!.text.isEmpty,
    );
  }

  onSave() {
    setState(() {
      _isLoading = true;
    });
    final title = _fields['title']['controller']!.text;
    final detail = _fields['detail']['controller']!.text;

    if (widget.method == 'edit') {
      final id = widget.data['id'];
      final body = {'id': id, 'title': title, 'detail': detail};
      final req = FetchAPI(
        endpoint: '$localpath/notes/update-note',
        body: body,
      );
      context.read<NoteBloc>().add(UpdateNote(req));
      return;
    }
    final body = {'title': title, 'detail': detail};
    final req = FetchAPI(endpoint: '$localpath/notes/create-note', body: body);
    context.read<NoteBloc>().add(CreateNote(req));
  }

  final Map<dynamic, dynamic> _fields = {
    'title': {'controller': TextEditingController(), 'focusNode': FocusNode()},
    'detail': {'controller': TextEditingController(), 'focusNode': FocusNode()},
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
                                controller: _fields['title']['controller'],
                                style: TextStyle(fontSize: 48),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title',
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _fields['detail']['controller'],
                                maxLines: 10,

                                decoration: InputDecoration(
                                  hintText: 'placeholder',
                                  border: OutlineInputBorder(),
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
              disable: _isSaveButtonDisabled && false,
              title: widget.method == 'edit' ? 'Edit' : 'Save',
              onTap: onSave,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is CreateNoteSuccess) {
          setState(() {
            _isLoading = false;
          });

          context.pop();
        } else if (state is NoteError) {
          setState(() {
            _isLoading = false;
          });

          final payload = state.payload;
          AlertErrorDialog.show(context, payload);
        }
      },
      child: LoadingScreen(
        isLoading: _isLoading,
        child: Scaffold(appBar: AppBar(), body: _getBody()),
      ),
    );
  }
}
