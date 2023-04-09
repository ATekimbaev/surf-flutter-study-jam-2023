part of 'data_bloc.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataError extends DataState {
  final String errorText;
  DataError({required this.errorText});
}

class DataSuccess extends DataState {
  final String filePath;
  DataSuccess({required this.filePath});
}
