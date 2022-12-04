import 'package:flutter/cupertino.dart';


class OrderNumberProvider with ChangeNotifier
{
String? _orderNumber;
String? get orderNumber =>  _orderNumber;
void setOrderNumber(order) =>_orderNumber=order;
}