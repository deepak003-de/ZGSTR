@EndUserText.label: 'Reason Code for EWay Action Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ReasonCodeForEwaAll'
  }
}
define root view entity ZI_ReasonCodeForEwayAc_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_REASONCODEFOREWAYAC'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ReasonCodeForEwayAc as _ReasonCodeForEwayAc
{
  @UI.facet: [ {
    id: 'ZI_ReasonCodeForEwayAc', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Reason Code for EWay Action', 
    position: 1 , 
    targetElement: '_ReasonCodeForEwayAc'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _ReasonCodeForEwayAc,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
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
