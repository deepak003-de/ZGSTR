@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'State Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_STATECODE
 as select from zdt_state_code1
{

  key     sapstatecode as Sapstatecode,
  key     gststatecode as Gststatecode,
          statename    as Statename
}
