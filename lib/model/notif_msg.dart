enum NotifMessageType { InternetConnection, Auth, Null }

class NotifMessageModel {
  bool? _success;
  // NotifMessageType? _messageType;
  String? _message;
  // String? _descripsion;
  dynamic _data;

  NotifMessageModel({
    bool success = false,
    String? message,
    dynamic data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  bool get getSuccess => _success ?? false;
  String get getMessage => _message ?? '';
  dynamic get getData => _data;

  set setSuccess(bool success) {
    _success = success;
  }

  // bool get getIsErr => _isErr ?? false;

  // set setMessageType(NotifMessageType messageType) {
  //   _messageType = messageType;
  // }

  // NotifMessageType get getMessageType => _messageType ?? NotifMessageType.Null;

  set setMessage(String message) {
    _message = message;
  }

  // String get getMessage => _message ?? '';

  // set setDescripsion(String descripsion) {
  //   _descripsion = descripsion;
  // }

  // String get getDescripsion => _descripsion ?? '';

}
