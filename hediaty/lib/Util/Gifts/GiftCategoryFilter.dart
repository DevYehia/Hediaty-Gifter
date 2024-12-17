import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Enums/giftCategoryEnum.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';

class GiftCategoryFilter implements GiftFilter{

  late GiftCategories selectedCat;

  GiftCategoryFilter(GiftCategories selectedCat){
    this.selectedCat = selectedCat;
  }
  @override
  List<GiftWidget> filter(List<GiftWidget> originalList) {
    List<GiftWidget>  newList = 
    originalList.where((eventWidg) =>
              eventWidg.gift.category == selectedCat.name)
          .toList();
    return newList;
  }
  
}