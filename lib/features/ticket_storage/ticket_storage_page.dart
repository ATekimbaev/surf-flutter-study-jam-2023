import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_flutter_study_jam_2023/core/common_widgets/bottom_sheet.dart';
import 'package:surf_flutter_study_jam_2023/core/consts/app_consts.dart';
import 'package:surf_flutter_study_jam_2023/core/theme/app_colors.dart';
import 'package:surf_flutter_study_jam_2023/core/theme/app_fonts.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/data_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/pdf_details_page.dart';

import '../../core/common_widgets/list_view_item.dart';
import 'models/pdf_list_model.dart';

class TicketStoragePage extends StatefulWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  State<TicketStoragePage> createState() => _TicketStoragePageState();
}

class _TicketStoragePageState extends State<TicketStoragePage> {
  TextEditingController controller = TextEditingController();
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    initPrefs();
    BlocProvider.of<DataBloc>(context).add(GetDataEvent());
  }

  List<String> pdfs = [];
  List<bool> isDownloadList = [];
  List<String> names = [];
  PdfListModel? model;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    pdfs = prefs?.getStringList(AppConts.pdfsList) ?? [];
    isDownloadList = List.generate(pdfs.length, (index) => false);
    model = PdfListModel(
      name: pdfs,
      isDownload: isDownloadList,
      url: pdfs,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              pdfs.clear();
              isDownloadList.clear();
              prefs?.setStringList(AppConts.pdfsList, pdfs.toSet().toList());
              setState(() {});
            },
            icon: const Icon(
              Icons.delete,
              color: AppColors.black,
            ),
          )
        ],
        centerTitle: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Хранение билетов',
          style: AppFonts.h1.copyWith(color: AppColors.black),
        ),
      ),
      body: BlocConsumer<DataBloc, DataState>(
        listener: (context, state) {
          if (state is DataSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfDetailsPage(filePath: state.filePath),
              ),
            );
          }
          if (state is DataError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
                content: Text(state.errorText),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: pdfs.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Здесь пока ничего нет',
                          style: AppFonts.h2.copyWith(color: AppColors.black),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: model?.isDownload?.length ?? 0,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Item(
                          isDownload: model?.isDownload?[index] ?? false,
                          onPressed: () async {
                            if (model?.isDownload?[index] == false) {
                              BlocProvider.of<DataBloc>(context).add(
                                DownloadPdfEvent(
                                  url: pdfs[index],
                                ),
                              );
                              model?.isDownload?[index] = true;
                              isDownloadList[index] = true;
                              prefs?.setStringList(
                                  AppConts.pdfsList, pdfs.toSet().toList());
                            } else {
                              model?.isDownload?[index] = false;
                              isDownloadList[index] = false;
                              prefs?.setStringList(
                                  AppConts.pdfsList, pdfs.toSet().toList());
                              final dir = await getTemporaryDirectory();
                              final fileName = '${dir.path}/url';
                              final file = File(fileName);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PdfDetailsPage(filePath: file.path),
                                ),
                              );
                            }
                            setState(() {});
                          },
                          title: model?.name?[index] ?? '',
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
      floatingActionButton: Builder(builder: (context) {
        return ElevatedButton(
          child: const Text('Добавить'),
          onPressed: () {
            Scaffold.of(context).showBottomSheet(
              (context) => CustomBottomSheet(
                controller: controller,
                onPressed: () {
                  names.add(controller.text);
                  pdfs.add(controller.text);
                  isDownloadList.add(false);
                  prefs?.setStringList(
                      AppConts.pdfsList, pdfs.toSet().toList());
                  model = PdfListModel(
                    name: pdfs,
                    isDownload: isDownloadList,
                    url: pdfs,
                  );
                  setState(() {});
                },
              ),
            );
          },
        );
      }),
    );
  }
}
