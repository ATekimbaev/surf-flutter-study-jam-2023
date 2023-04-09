part of 'data_bloc.dart';

abstract class DataEvent {}

class GetDataEvent extends DataEvent {}

class DownloadPdfEvent extends DataEvent {
  final String url;
  DownloadPdfEvent({
    required this.url,
  });
}

class ToggleSelectionEvent extends DataEvent {
  final int index;
  ToggleSelectionEvent(this.index);
}
