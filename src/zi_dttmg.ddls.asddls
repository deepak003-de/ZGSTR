@EndUserText.label: 'DT TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DtTmg
  as select from ZDT_CCODEADDRESS
  association to parent ZI_DtTmg_S as _DtTmgAll on $projection.SingletonID = _DtTmgAll.SingletonID
{
  key BUKRS as Bukrs,
  GSTIN as Gstin,
  LEGALNAME as Legalname,
  ADDRESS1 as Address1,
  ADDRESS2 as Address2,
  CITY as City,
  PINCODE as Pincode,
  STATECODE as Statecode,
  STATECODEDESCRIPTION as Statecodedescription,
  @Consumption.hidden: true
  1 as SingletonID,
  _DtTmgAll
  
}
