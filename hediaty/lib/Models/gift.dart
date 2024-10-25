class Gift{
  String? name;
  String? description;
  String? category;
  double? price;
  bool isPledged = false;

  Gift({required this.name,
        this.description, 
        required this.category,
        required this.price
        });

  void pledge(){
    isPledged = true;
  }




}