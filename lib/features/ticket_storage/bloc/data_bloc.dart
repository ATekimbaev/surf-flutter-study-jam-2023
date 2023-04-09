import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/repository/get_pdf_repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc({required this.repository}) : super(DataInitial()) {
    on<GetDataEvent>(
      (event, emit) {
        emit(DataInitial());
      },
    );
    on<DownloadPdfEvent>(
      (event, emit) async {
        emit(DataInitial());
        emit(DataLoading());
        try {
          final path = await repository.getPdf(
            event.url,
          );
          emit(DataSuccess(filePath: path));
        } catch (e) {
          emit(DataError(errorText: e.toString()));
        }
      },
    );
  }
  final GetPdfRepository repository;
}
