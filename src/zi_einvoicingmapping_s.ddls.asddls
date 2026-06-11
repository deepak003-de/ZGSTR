@EndUserText.label: 'E-Invoicing Mapping Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'EInvoicingMappinAll'
  }
}
define root view entity ZI_EInvoicingMapping_S
  as select from I_Language
    left outer join ZDT_GSTRMAP on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_EInvoicingMapping as _EInvoicingMapping
{
  @UI.facet: [ {
    id: 'ZI_EInvoicingMapping', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'E-Invoicing Mapping', 
    position: 1 , 
    targetElement: '_EInvoicingMapping'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _EInvoicingMapping,
  @UI.hidden: true
  max( ZDT_GSTRMAP.LAST_CHANGED_AT ) as LastChangedAtMax,
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
