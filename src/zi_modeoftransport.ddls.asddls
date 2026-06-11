@EndUserText.label: 'Mode of Transport'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ModeOfTransport
  as select from ZDT_MOT
  association to parent ZI_ModeOfTransport_S as _ModeOfTransportAll on $projection.SingletonID = _ModeOfTransportAll.SingletonID
{
  key ID as Id,
  MOT as Mot,
  MOTDESC as Motdesc,
  @Consumption.hidden: true
  1 as SingletonID,
  _ModeOfTransportAll
  
}
