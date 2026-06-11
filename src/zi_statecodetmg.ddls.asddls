@EndUserText.label: 'State Code TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_StateCodeTmg
  as select from ZDT_STATE_CODE1
  association to parent ZI_StateCodeTmg_S as _StateCodeTmgAll on $projection.SingletonID = _StateCodeTmgAll.SingletonID
{
  key ID as Id,
  SAPSTATECODE as Sapstatecode,
  GSTSTATECODE as Gststatecode,
  STATENAME as Statename,
  @Consumption.hidden: true
  1 as SingletonID,
  _StateCodeTmgAll
  
}
