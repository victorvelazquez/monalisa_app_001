import 'package:monalisa_app_001/features/auth/domain/entities/role.dart';

class RolesApp {
  // SHIPMENT
  static bool appShipment = false;
  static bool appShipmentQty = false;
  static bool appShipmentManual = false;
  static bool appShipmentLowqty = false;
  static bool appShipmentPrepare = false;
  static bool appShipmentComplete = false;

  // RECEIPT
  static bool appReceipt = false;
  static bool appReceiptQty = false;
  static bool appReceiptManual = false;
  static bool appReceiptPrepare = false;
  static bool appReceiptComplete = false;

  // SHIPMENT CONFIRM
  static bool appShipmentconfirm = false;
  static bool appShipmentconfirmQty = false;
  static bool appShipmentconfirmManual = false;
  static bool appShipmentconfirmComplete = false;

  // RECEIPT CONFIRM
  static bool appReceiptconfirm = false;
  static bool appReceiptconfirmQty = false;
  static bool appReceiptconfirmManual = false;
  static bool appReceiptconfirmComplete = false;

  // PICK CONFIRM
  static bool appPickconfirm = false;
  static bool appPickconfirmQty = false;
  static bool appPickconfirmManual = false;
  static bool appPickconfirmComplete = false;

  // QA CONFIRM
  static bool appQaconfirm = false;
  static bool appQaconfirmQty = false;
  static bool appQaconfirmManual = false;
  static bool appQaconfirmComplete = false;

  static set(List<Role> roles) {
    for (var role in roles) {
      //SHIPMENT
      if (role.name.toUpperCase() == 'APP_SHIPMENT') {
        appShipment = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_QTY') {
        appShipmentQty = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_MANUAL') {
        appShipmentManual = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_LOWQTY') {
        appShipmentLowqty = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_PREPARE') {
        appShipmentPrepare = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENT_COMPLETE') {
        appShipmentComplete = true;
      }

      //RECEIPT
      if (role.name.toUpperCase() == 'APP_RECEIPT') {
        appReceipt = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_QTY') {
        appReceiptQty = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_MANUAL') {
        appReceiptManual = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_PREPARE') {
        appReceiptPrepare = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPT_COMPLETE') {
        appReceiptComplete = true;
      }

      //SHIPMENT CONFIRM
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM') {
        appShipmentconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM_QTY') {
        appShipmentconfirmQty = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM_MANUAL') {
        appShipmentconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_SHIPMENTCONFIRM_COMPLETE') {
        appShipmentconfirmComplete = true;
      }

      //RECEIPT CONFIRM
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM') {
        appReceiptconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM_QTY') {
        appReceiptconfirmQty = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM_MANUAL') {
        appReceiptconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_RECEIPTCONFIRM_COMPLETE') {
        appReceiptconfirmComplete = true;
      }

      //PICK CONFIRM
      if (role.name.toUpperCase() == 'APP_PICKCONFIRM') {
        appPickconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_PICKCONFIRM_QTY') {
        appPickconfirmQty = true;
      }
      if (role.name.toUpperCase() == 'APP_PICKCONFIRM_MANUAL') {
        appPickconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_PICKCONFIRM_COMPLETE') {
        appPickconfirmComplete = true;
      }

      //QA CONFIRM
      if (role.name.toUpperCase() == 'APP_QACONFIRM') {
        appQaconfirm = true;
      }
      if (role.name.toUpperCase() == 'APP_QACONFIRM_QTY') {
        appQaconfirmQty = true;
      }
      if (role.name.toUpperCase() == 'APP_QACONFIRM_MANUAL') {
        appQaconfirmManual = true;
      }
      if (role.name.toUpperCase() == 'APP_QACONFIRM_COMPLETE') {
        appQaconfirmComplete = true;
      }
    }
  }

  static String getString() {
    return 'RolesApp{appShipment: $appShipment, appShipmentQty: $appShipmentQty, appShipmentManual: $appShipmentManual, appShipmentLowqty: $appShipmentLowqty, appShipmentComplete: $appShipmentPrepare, appShipmentComplete: $appShipmentComplete, appReceipt: $appReceipt, appReceiptQty: $appReceiptQty, appReceiptManual: $appReceiptManual, appReceiptComplete: $appReceiptPrepare, appReceiptComplete: $appReceiptComplete, appShipmentconfirm: $appShipmentconfirm, appShipmentconfirmQty: $appShipmentconfirmQty, appShipmentconfirmManual: $appShipmentconfirmManual, appShipmentconfirmComplete: $appShipmentconfirmComplete, appReceiptconfirm: $appReceiptconfirm, appReceiptconfirmQty: $appReceiptconfirmQty, appReceiptconfirmManual: $appReceiptconfirmManual, appReceiptconfirmComplete: $appReceiptconfirmComplete, appPickconfirm: $appPickconfirm, appPickconfirmQty: $appPickconfirmQty, appPickconfirmManual: $appPickconfirmManual, appPickconfirmComplete: $appPickconfirmComplete, appQaconfirm: $appQaconfirm, appQaconfirmQty: $appQaconfirmQty, appQaconfirmManual: $appQaconfirmManual, appQaconfirmComplete: $appQaconfirmComplete}';
  }
}
