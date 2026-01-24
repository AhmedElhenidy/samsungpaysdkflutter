import '../samsung_pay_sdk_flutter.dart';

/// This class provides AmountBoxControl on custom payment sheet. 
/// AmountBoxControl is used for displaying amount information on custom payment sheet. 
///

class AmountBoxControl extends SheetControl{
  List<SheetItem>? items =[];
  String? currencyCode;

  /// Constructor to create AmountBoxControl. 
  ///
  ///  [Parameters:] 
  /// [controlId] Unique ID to represent the AmountBoxControl. 
  ///             This ID is used to compare and identify the other SheetControls. 
  ///
  /// [currencyCode] Currency code to be used by Payment Gateway for payment. 
  ///                ISO 4217 currency code (example: USD, KRW, EUR, and so on / All uppercase). 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if controlId is empty. 
  ///

  AmountBoxControl(String controlId, String currencyCode) : super(controltype: Controltype.AMOUNTBOX){
    setControlId(controlId);
    setCurrencyCode(currencyCode);
  }

  ///@nodoc
  List<SheetItem>? getItems() {
    return items;
  }

  ///@nodoc
  factory AmountBoxControl.fromJson(Map<String, dynamic> json){
    AmountBoxControl amountBoxControl = AmountBoxControl(json["controlId"], json["currencyCode"]);
    for(var item in json["items"]){
      SheetItem sheetItem =SheetItem.fromJson(item);
      amountBoxControl.items!.add(sheetItem);
    }
    return amountBoxControl;
  }

  ///@nodoc
  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = super.toJson();
    data.addAll({
      "items": items!.map((e)=>e.toJson()).toList(),
      "currencyCode": currencyCode,
    });
    return data;
  }

  ///@nodoc
  int getAmountTotalIndex() {
    int foundIndex = 0;
    for (; foundIndex <  items!.length; foundIndex++) {
      if (items?[foundIndex].getSheetItemType() == SheetItemType.AMOUNT_TOTAL.name) {
        return foundIndex;
      }
    }
    return -1;
  }

  ///@nodoc
  bool _hasAmountTotal(){
    return getAmountTotalIndex() > -1;
  }

  ///@nodoc
  int _getItemIndex(String id) {
    for (int foundIndex = 0; foundIndex < items!.length; foundIndex++) {
      if (items?[foundIndex].getId() == id) {
        return foundIndex;
      }
    }
    return -1;
  }

  ///
  /// API to add item or add item (add item in a specific location, this is optional).
  ///
  ///  [Parameters:] 
  /// [id] - Unique ID to be set. 
  /// [title] - Title to be displayed. 
  /// [price] - Price to be set. 
  /// [extraPrice] - If extraPrice is set, extraPrice is displayed instead of price on custom payment sheet. 
  /// [location] - Location to be displayed in AmountBoxControl on custom payment sheet. For this case you need to call the method by using key: value format (location: 2). 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if ID or title is empty. 
  /// Throws an [ArgumentError] if the same ID is used in other SheetControl. 
  /// Throws an [ArgumentError] if location is invalid or the same ID is used in other SheetControls. 
  ///

  void addItem(String id, String title, double price, String extraPrice,{int? location}) {
    if(location == null)
    {
      if (_hasAmountTotal()) {
        location = items!.length-1;
      } else {
        location = items!.length;
      }
    }
    if (id.isEmpty) {
      throw ArgumentError("addItem : You must set itemId.");
    } else if (title.isEmpty) {
      throw ArgumentError("addItem : You must set title.");
    } else if (location < 0 || (_hasAmountTotal() && location >= items!.length) || (!_hasAmountTotal() && location > items!.length)) {
      throw ArgumentError("addItem : there is abnormal location");
    } else if (_getItemIndex(id) > -1) {
      throw ArgumentError("addItem : same id is used.");
    }
    SheetItem sheetItem = SheetItem(id: id,title: title, dValue: price, sValue: extraPrice,sheetItemType: SheetItemType.AMOUNT_ITEM.name.toString());
    items?.insert(location, sheetItem);
  }

  ///
  /// API to check the item is existing or not.
  ///
  ///  [Parameters:] 
  /// [id] Unique ID to be checked. 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if ID is empty. 
  ///
  /// Return 'true' or 'false' 
  ///

  bool existItem(String id)
  {
    if (id.isEmpty) {
      throw ArgumentError("You must set id.");
    }
    else if(items!.isEmpty) {
      throw ArgumentError("You don't have any item.");
    }
    else {
      final index = items!.indexWhere((items) => items.id == id);
      if (index==-1) {
        return false;
      }
      return true;
    }
  }

  ///
  /// API to return the currency code. 
  /// ISO 4217 currency code (example: USD, KRW, EUR, and so on). 
  ///
  /// Return Currency code. 
  ///
  ///
  String? getCurrencyCode(){
    return currencyCode;
  }

  ///
  /// API to set the currency code.
  ///
  ///  [Parameters:] 
  /// [currencyCode] Currency code to be used by Payment Gateway for payment. 
  ///                ISO 4217 currency code (example: USD, KRW, EUR, and so on / All uppercase). 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if the currency code is empty. 
  ///
  void setCurrencyCode(String currencyCode){
    if (currencyCode.isEmpty) {
      throw ArgumentError("currencyCode is empty");
    }
    this.currencyCode = currencyCode;
  }

  ///
  /// API to get value for ID.
  ///
  ///  [Parameters:] 
  /// id Unique ID to get value. 
  /// Return double value 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if the ID is empty. 
  /// Throws an [ArgumentError] if the ID is invalid. 
  ///
  double? getValue(String id)
  {
    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }

    final index = items!.indexWhere((items) => items.id == id);
    if (index > -1) {
      return items!.elementAt(index).dValue;
    }
    throw ArgumentError("id is invalid.");
  }

  ///
  /// API to remove item.
  ///
  ///  [Parameters:] 
  /// [id] - ID of item to remove. 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if the ID is empty. 
  /// Throws an [ArgumentError] if the ID is invalid. 
  ///

  void removeItem(String id){
    int index;
    if (id.isEmpty) {
      throw ArgumentError("removeItem : You must set itemId.");
    }
    else if ((index = _getItemIndex(id)) < 0) {
      throw ArgumentError("removeItem : there is no id.");
    }
    items?.removeAt(index);
  }

  ///
  /// API to set the amount total.
  ///
  ///  [Parameters:] 
  /// [price] - Price to be set. 
  ///           This amount is for online payment transaction. 
  ///
  /// [displayOption] - Amount total display option. Merchant must set one of the predefined formats to display total. 
  ///        The possible values are: 
  ///            [SpaySdk.FORMAT_TOTAL_PRICE_ONLY] 
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_AMOUNT] 
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_CHARGE] 
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_FARE] 
  ///            [SpaySdk.FORMAT_TOTAL_FREE_TEXT_ONLY] 
  ///            [SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING] 
  ///            [SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY] 
  ///            [SpaySdk.FORMAT_TOTAL_PENDING] 
  ///            [SpaySdk.FORMAT_TOTAL_PENDING_TEXT_ONLY] 
  ///            [SpaySdk.FORMAT_TOTAL_UP_TO_AMOUNT] 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if displayOption is empty. 

  void setAmountTotal(double price, String displayOption){
    if(displayOption.isEmpty){
      throw ArgumentError("setAmountTotal : You must set displayOption.");
    }
    int foundIndex = getAmountTotalIndex();
    SheetItem item= SheetItem(id: "",title: "",dValue: price, sValue: displayOption, sheetItemType: SheetItemType.AMOUNT_TOTAL.name.toString());
    if (foundIndex > -1) {
      items?[foundIndex] = item;
    } else {
      items?.add(item);
    }
  }

  ///
  /// API to update item title.
  ///
  ///  [Parameters:] 
  /// [id] - Unique ID of item to update. 
  /// [title] - Title to be set. 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if the ID is empty. 
  /// Throws an [ArgumentError] if there are no items associated with the ID. 
  ///

  void updateTitle(String id, String title){
    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }
    int foundIndex = items!.indexWhere((items) => items.id == id);

    if (foundIndex > -1) {
      SheetItem item = SheetItem(id: id, title: title, dValue: items!.elementAt(foundIndex).dValue, sValue: items!.elementAt(foundIndex).sValue, sheetItemType:items![foundIndex].getSheetItemType());
      items?.insert(foundIndex,item);
      return;
    }
    throw ArgumentError("updateTitle : there are no items associated with the id.");
  }

  ///
  /// API to update price. 
  ///
  /// currencyCode + price will appear on custom payment sheet. 
  /// If price is set, then extraPrice is initialized empty value, 
  /// because extraPrice appear if extraPrice is not empty. 
  ///
  ///  [Parameters:] 
  /// [id] - Unique ID of item to update. 
  /// [price] - Price to be set. 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if the ID is empty. 
  /// Throws an [ArgumentError] if there are no items associated with the ID. 
  ///

  void updateValue(String id, double price,{String? extraPrice}){

    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }
    int foundIndex = _getItemIndex(id);
    if (foundIndex > -1) {
      if(extraPrice==null)
      {
        SheetItem item = SheetItem(id: id, title: items![foundIndex].title, dValue: price,  sValue: "", sheetItemType: items![foundIndex].getSheetItemType());
        items?[foundIndex] = item;
      }
      else
      {
        SheetItem item = SheetItem(id: id, title: items![foundIndex].title, dValue: price, sValue: extraPrice,  sheetItemType: items![foundIndex].getSheetItemType());
        items?[foundIndex] = item;
      }
      return;
    }
    throw ArgumentError("updateValue : there are no items associated with the id.");//popup
  }
}
