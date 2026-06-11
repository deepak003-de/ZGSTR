@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_UOM
  as select from zdt_uom
{
  key    sapuom      as Sapuom,
  key    gstuom      as Gstuom,
         description as Description
}
where
  configdeprecationcode is initial
