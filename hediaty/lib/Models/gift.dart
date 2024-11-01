import 'package:hediaty/Models/DBManager.dart';

class Gift{
  int ID;
  String name;
  String? description;
  String category;
  double price;
  bool isPledged;
  int eventID;
  int? pledgerID;
  Gift({required this.ID,
        required this.name,
        this.description, 
        required this.category,
        required this.price,
        required this.isPledged,
        required this.eventID,
        this.pledgerID
        });


  static Future<List<Gift>> getAllGifts(int eventID) async{
    List<Gift> gifts = [];
    final db = await DBManager.getDataBase();
    List<Map> rawGifts = await db.rawQuery("SELECT * FROM GIFTS WHERE eventID = $eventID");
    print(rawGifts);
    for(final rawGift in rawGifts){
      gifts.add(Gift(ID: rawGift["ID"],
      name: rawGift["name"],
      price: rawGift["price"],
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"]));
    }
    print("Gifts!!!");
    return gifts;    
  }




}