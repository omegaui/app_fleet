class UpdateEvent {}

class UpdateEmptyEvent extends UpdateEvent {}

class UpdateInitializedEvent extends UpdateEvent {
  final bool reinstall;

  UpdateInitializedEvent(this.reinstall);
}

class UpdateState {}

class UpdateEmptyState extends UpdateState {}

class UpdateInitializedState extends UpdateState {
  final bool reinstall;

  UpdateInitializedState(this.reinstall);
}
