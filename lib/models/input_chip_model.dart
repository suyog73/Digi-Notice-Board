import 'package:notice_board/models/user_model.dart';

class InputChipData {
  final String label;

  InputChipData({required this.label});
}

class InputChips {
  static final all = <InputChipData>[
    // InputChipData(label: UserModel.name.toString()),
    // InputChipData(label: UserModel.adminCategory.toString()),
  ];
}
