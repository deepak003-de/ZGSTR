@EndUserText.label: '###Generated Code Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZR_DT_TOKEN
  as select from zdt_token
{
  key tparameter as Tparameter,
  value as Value,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  @Semantics.user.localInstanceLastChangedBy: true
  lastchangedby as Lastchangedby
  
}
