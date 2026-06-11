@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Einv/Eway GatePass'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_EINVEWAY_GP

  as select distinct from ZV_EINVEWAY_GP2        as a

    inner join            zdt_gatehead           as b on b.gatepassno = a.Gatepassno

    inner join            I_BillingDocumentItem  as c on  c.SalesDocument     = a.salesorder
                                                      and c.SalesDocumentItem = a.Gateitem

    inner join            I_DeliveryDocumentItem as d on  d.DeliveryDocument     = c.ReferenceSDDocument
                                                      and d.DeliveryDocumentItem = c.ReferenceSDDocumentItem

    inner join            I_DeliveryDocument     as e on  e.DeliveryDocument       = c.ReferenceSDDocument
                                                      and e.YY1_GatePassNumber_DLH = a.Gatepassno

{
  key    c.BillingDocument,
  key    c.SalesDocument,
  key    e.DeliveryDocument,
         b.gatepassno,
         b.transportergst,
         b.transportername,
         b.lrrrno,
         b.vehicleno

}
