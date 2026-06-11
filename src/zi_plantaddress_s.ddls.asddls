@EndUserText.label: 'Plant Address Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'PlantAddressAll'
  }
}
define root view entity ZI_PlantAddress_S
  as select from I_Language
    left outer join ZDT_PLANTADDRESS on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_PlantAddress as _PlantAddress
{
  @UI.facet: [ {
    id: 'ZI_PlantAddress', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Plant Address', 
    position: 1 , 
    targetElement: '_PlantAddress'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _PlantAddress,
  @UI.hidden: true
  max( ZDT_PLANTADDRESS.LAST_CHANGED_AT ) as LastChangedAtMax,
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
