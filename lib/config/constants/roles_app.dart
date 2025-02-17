import 'package:monalisa_app_001/features/auth/domain/entities/role.dart';

class RolesApp {
  static bool appShipment = false;
  static bool appShipmentManual = false;
  static bool appShipmentComplete = false;
  static bool appReceipt = false;
  static bool appReceiptManual = false;
  static bool appReceiptComplete = false;
  static bool appShipmentconfirm = false;
  static bool appShipmentconfirmManual = false;
  static bool appShipmentconfirmComplete = false;
  static bool appReceiptconfirm = false;
  static bool appReceiptconfirmManual = false;
  static bool appReceiptconfirmComplete = false;


  static set(List<Role> roles) {
    for (var role in roles) {
      if (role.name.toUpperCase() == 'APP_SHIPMENT') {
        appShipment = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_MANUAL') {
        appShipmentManual = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_COMPLETE') {
        appShipmentComplete = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT') {
        appReceipt = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_MANUAL') {
        appReceiptManual = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_COMPLETE') {
        appReceiptComplete = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM') {
        appShipmentconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM_MANUAL') {
        appShipmentconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM_COMPLETE') {
        appShipmentconfirmComplete = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM') {
        appReceiptconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM_MANUAL') {
        appReceiptconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM_COMPLETE') {
        appReceiptconfirmComplete = true;
      }     
    }
  }
}