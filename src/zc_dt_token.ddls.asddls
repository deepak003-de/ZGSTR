@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_DT_TOKEN
  provider contract transactional_query
  as projection on ZR_DT_TOKEN
{
  key Tparameter,
  Value,
  LocalLastChanged,
  LastChanged,
  Createdby,
  Lastchangedby
  
}
