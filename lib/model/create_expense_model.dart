class CreateExpense_Model {
  String? message;
  Data? data;

  CreateExpense_Model({this.message, this.data});

  CreateExpense_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  double? amount;
  String? category;
  String? date;
  String? notes;

  Data({this.userId, this.amount, this.category, this.date, this.notes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    amount = (json['amount'] is int)
        ? (json['amount'] as int).toDouble()
        : (json['amount'] as double);
    category = json['category'];
    date = json['date'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['category'] = this.category;
    data['date'] = this.date;
    data['notes'] = this.notes;
    return data;
  }
}
