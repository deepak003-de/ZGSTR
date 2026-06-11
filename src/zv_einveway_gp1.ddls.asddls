@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Einv/Eway GatePass 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_EINVEWAY_GP1
  as select from zdt_gate_item
{
  key id                                 as Id,
  key item                               as Item,
      purchaseorder                      as Purchaseorder,
      cast( gateitem as abap.char( 6 ) ) as Gateitem,
      gatepassno                         as Gatepassno,
      gateitemapi                        as Gateitemapi,
      salesorder
}
