@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vehicle Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_VEHTYPE
  as select from zdt_vehtype
{

  key      vehicletype     as Vehicletype,
           vehicletypedesc as Vehicletypedesc
}
