@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZV_EINVEWAY_GP1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_EINVEWAY_GP2
  as select from ZV_EINVEWAY_GP1
{
  key Id,
  key Item,
      Purchaseorder,
      lpad( Gateitem, 6, '0' ) as Gateitem,
      Gatepassno,
      Gateitemapi,
      salesorder
}
