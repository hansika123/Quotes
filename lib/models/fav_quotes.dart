import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';

@Entity()
class FavoriteQuotes {
  @Id()
  int id = 0;
  String quote;
  bool isLiked;

  FavoriteQuotes({required this.quote, this.isLiked=false});
}
