@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_DT_SALESINV1
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_DT_SALESINV1
{
  key Fkart,
  key Billtype,
  key Kschl,
  Lastchanges,
  Changeuser,
  Createdby
  
}
