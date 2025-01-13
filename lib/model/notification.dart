// class Notifications {
//   int? _id;
//   int? _idUser;
//   String? _action;
//
//   Notifications(this._id, this._idUser, this._action);
//
//
//   int? get id => _id;
//
//   set id(int? value) {
//     _id = value;
//   }
//
//   Map<String, dynamic> toJSON() {
//     return {
//       'id': _id,
//       'idUser': _idUser,
//       'action': _action,
//     };
//   }
//
//   static Notifications fromJSON(Map<String, dynamic> json) {
//     return Notifications(json['id'], json['idUser'], json['action']);
//   }
//
//   int? get idUser => _idUser;
//
//   set idUser(int? value) {
//     _idUser = value;
//   }
//
//   String? get action => _action;
//
//   set action(String? value) {
//     _action = value;
//   }
// }
