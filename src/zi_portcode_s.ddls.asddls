@EndUserText.label: 'Port Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'PortCodeAll'
  }
}
define root view entity ZI_PortCode_S
  as select from I_Language
    left outer join ZDT_PORTCODE on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_PortCode as _PortCode
{
  @UI.facet: [ {
    id: 'ZI_PortCode', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Port Code', 
    position: 1 , 
    targetElement: '_PortCode'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _PortCode,
  @UI.hidden: true
  max( ZDT_PORTCODE.LAST_CHANGED_AT ) as LastChangedAtMax,
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
