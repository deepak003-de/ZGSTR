@EndUserText.label: 'Error Log'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ERRORLOG
  as select from zdt_error_log
  association to parent ZR_EINVEWAY_F as _Head on $projection.Billdoc = _Head.BillingDocument
{
  key billdoc   as Billdoc,
  key item      as Item,
      action,
      docdate,
      doctype,
      logtime,
      logdate,
      errorcode as Errorcode,
      message   as Message,
      _Head
}
