@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DT_HEADER_TOKEN
  as select from ZDT_HEADER_TOKEN
{
  key company as Company,
  key gstin as Gstin,
  key clientid as Clientid,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchanges as Lastchanges,
  @Semantics.user.localInstanceLastChangedBy: true
  changeuser as Changeuser,
  @Semantics.user.createdBy: true
  createdby as Createdby
  
}
