@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_DT_HEADER_TOKEN
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_DT_HEADER_TOKEN
{
  key Company,
  key Gstin,
  key Clientid,
  Lastchanges,
  Changeuser,
  Createdby
  
}
