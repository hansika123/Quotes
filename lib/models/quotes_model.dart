import 'package:pocketbase/pocketbase.dart';

class Quotes {
  String quote;
 
  Quotes({required this.quote});

  factory Quotes.fromJson(RecordModel record) {
    final json = record.toJson();
    return Quotes(quote: json['quote']);
  }

}


