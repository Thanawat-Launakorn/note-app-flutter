part of 'note_bloc.dart';

@immutable
abstract class NoteEvent {}

class LoadNote extends NoteEvent {
  final FetchAPI req;
  LoadNote(this.req);
}

class CreateNote extends NoteEvent {
  final FetchAPI req;
  CreateNote(this.req);
}

class UpdateNote extends NoteEvent {
  final FetchAPI req;
  UpdateNote(this.req);
}

class DeleteNote extends NoteEvent {
  final FetchAPI req;
  DeleteNote(this.req);
}

class SelectNotesEvent extends NoteEvent {
  final int index;
  final bool isSelected;

  SelectNotesEvent({ required this.index, required this.isSelected });
}
