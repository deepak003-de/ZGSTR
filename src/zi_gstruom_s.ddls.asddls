@EndUserText.label: 'GSTR UoM\'\'\'\' Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GstrUomAll'
  }
}
define root view entity ZI_GstrUom_S
  as select from I_Language
    left outer join ZDT_UOM on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GstrUom as _GstrUom
{
  @UI.facet: [ {
    id: 'ZI_GstrUom', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GSTR UoM\'\'\'\'', 
    position: 1 , 
    targetElement: '_GstrUom'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GstrUom,
  @UI.hidden: true
  max( ZDT_UOM.LAST_CHANGED_AT ) as LastChangedAtMax,
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
