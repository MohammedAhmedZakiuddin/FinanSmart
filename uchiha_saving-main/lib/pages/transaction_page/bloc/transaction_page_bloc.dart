import 'dart:async';

import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/pages/transaction_page/bloc/transaction_page_model.dart';

class TransactionPageBloc {
  StreamController<TransactionPageModel> _controller =
      StreamController<TransactionPageModel>.broadcast();

  Stream<TransactionPageModel> get stream => _controller.stream;

  get dispose => _controller.close();

  update({
    DateTime? startDate,
    DateTime? endDate,
    Category? category,
  }) async {
    _controller.sink.add(
      TransactionPageModel(
        startDate: startDate,
        endDate: endDate,
        category: category,
      ),
    );
  }
}
