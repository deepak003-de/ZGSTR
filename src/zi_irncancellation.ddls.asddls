@EndUserText.label: 'IRN Cancellation'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_IrnCancellation
  as select from ZDT_IRNCANCEL
  association to parent ZI_IrnCancellation_S as _IrnCancellationAll on $projection.SingletonID = _IrnCancellationAll.SingletonID
{
  key CODE as Code,
  DESCRIPTION as Description,
  @Consumption.hidden: true
  1 as SingletonID,
  _IrnCancellationAll
  
}
