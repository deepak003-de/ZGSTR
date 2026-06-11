@EndUserText.label: 'Sales Invoicing GST Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'SalesInvoicingGsAll'
  }
}
define root view entity ZI_SalesInvoicingGst_S
  as select from I_Language
    left outer join ZDT_SALESINV on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_SalesInvoicingGst as _SalesInvoicingGst
{
  @UI.facet: [ {
    id: 'ZI_SalesInvoicingGst', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Sales Invoicing GST', 
    position: 1 , 
    targetElement: '_SalesInvoicingGst'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _SalesInvoicingGst,
  @UI.hidden: true
  max( ZDT_SALESINV.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
