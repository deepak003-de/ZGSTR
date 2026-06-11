@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Error Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_ERRORLOG

  as projection on ZR_ERRORLOG
{

      @EndUserText.label: 'Billing Document'
  key Billdoc,
      @EndUserText.label: 'Error Count'
  key Item,
      @EndUserText.label: 'Error Code'
      Errorcode,
      @EndUserText.label: 'Message'
      Message,

      _Head : redirected to parent ZC_EINVEWAY_F

}
