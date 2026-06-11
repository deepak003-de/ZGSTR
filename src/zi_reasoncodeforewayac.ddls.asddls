@EndUserText.label: 'Reason Code for EWay Action'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ReasonCodeForEwayAc
  as select from ZDT_EWAYCODE
  association to parent ZI_ReasonCodeForEwayAc_S as _ReasonCodeForEwaAll on $projection.SingletonID = _ReasonCodeForEwaAll.SingletonID
{
  key CODE as Code,
  DESCRIPTION as Description,
  @Consumption.hidden: true
  1 as SingletonID,
  _ReasonCodeForEwaAll
  
}
