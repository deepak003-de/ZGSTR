@EndUserText.label: 'Partner Function for Port Code'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PartnerFunctionForP
  as select from ZDT_PORTPARTNER
  association to parent ZI_PartnerFunctionForP_S as _PartnerFunctionFAll on $projection.SingletonID = _PartnerFunctionFAll.SingletonID
{
  key ID as Id,
  PARNTERFUNCTION as Parnterfunction,
  @Consumption.hidden: true
  1 as SingletonID,
  _PartnerFunctionFAll
  
}
