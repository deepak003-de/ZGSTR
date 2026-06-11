@EndUserText.label: 'ewaycancel'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_Ewaycancel
  as select from ZDT_EWAYCANCEL
  association to parent ZI_Ewaycancel_S as _EwaycancelAll on $projection.SingletonID = _EwaycancelAll.SingletonID
{
  key CODE as Code,
  DESCRIPTION as Description,
  @Consumption.hidden: true
  1 as SingletonID,
  _EwaycancelAll
  
}
