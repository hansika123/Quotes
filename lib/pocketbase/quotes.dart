import 'package:pocketbase/pocketbase.dart';
import '../models/quotes_model.dart';
import 'configs.dart.dart';

final pb = PocketBase('https://shy-cherry-5704.fly.dev');

Future<List<Quotes>> fetchQuotes(String token) async {
  // final authData = pb.authStore;
  // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2xsZWN0aW9uSWQiOiJfcGJfdXNlcnNfYXV0aF8iLCJleHAiOjE2ODYzODk1MjcsImlkIjoiMWFvdzRlNGh2eWgxbW11IiwidHlwZSI6ImF1dGhSZWNvcmQifQ.5qQFxJA6OivmNWu804ndYKzOCJOFTLUcwfzsNFRtG8A';
  final headers = {'Authorization': token};

  final records = await pb.collection('quotes').getFullList(
    sort: '-created',
    headers: headers,
  );

  final List<Quotes> quotes = [];
  for (final quotesJson in records) {
    final quote = Quotes.fromJson(quotesJson);
    quotes.add(quote);
  }

  return quotes;
}
