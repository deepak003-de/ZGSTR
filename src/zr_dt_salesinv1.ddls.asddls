@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DT_SALESINV1
  as select from zdt_salesinv1
{
  key fkart as Fkart,
  key billtype as Billtype,
  key kschl as Kschl,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchanges as Lastchanges,
  @Semantics.user.localInstanceLastChangedBy: true
  changeuser as Changeuser,
  @Semantics.user.createdBy: true
  createdby as Createdby
    
}
