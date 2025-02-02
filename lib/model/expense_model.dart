class Expense_Model {
  String? message;
  List<Data>? data;

  Expense_Model({this.message, this.data});

  Expense_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? username;
  String? email;
  int? expenseID;
  double? amount;
  String? category;
  String? date;
  String? notes;

  Data(
      {this.userId,
      this.username,
      this.email,
      this.expenseID,
      this.amount,
      this.category,
      this.date,
      this.notes});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    username = json['Username'] ?? "Unknown";
    email = json['Email'] ?? "No Email";
    expenseID = json['ExpenseID'];
    amount =
        (json['Amount'] is int) ? json['Amount'].toDouble() : json['Amount'];
    category = json['Category'] ?? "Uncategorized";
    date = json['Date'] ?? 'No Date';
    notes = json['Notes'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['Username'] = this.username;
    data['Email'] = this.email;
    data['ExpenseID'] = this.expenseID;
    data['Amount'] = this.amount;
    data['Category'] = this.category;
    data['Date'] = this.date;
    data['Notes'] = this.notes;
    return data;
  }
}
