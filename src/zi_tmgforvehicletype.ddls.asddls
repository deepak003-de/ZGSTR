@EndUserText.label: 'TMG for Vehicle Type'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForVehicleType
  as select from ZDT_VEHTYPE
  association to parent ZI_TmgForVehicleType_S as _TmgForVehicleTypAll on $projection.SingletonID = _TmgForVehicleTypAll.SingletonID
{
  key ID as Id,
  VEHICLETYPE as Vehicletype,
  VEHICLETYPEDESC as Vehicletypedesc,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForVehicleTypAll
  
}
