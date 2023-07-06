import './fav_quotes.dart';
import '../objectbox.g.dart';

late final Store store;

class ObjectBox {
  late Store store;

  // openDBStore() async {
  //   store = await openStore();
  // }

  Future<void> openDBStore() async {
    store = await openStore();
  }

  Future<void> closeDBStore() async {
    store.close();
  }

  void addFavoriteQuotes(FavoriteQuotes fav) {
    store.box<FavoriteQuotes>().put(fav);
    
  }
}
