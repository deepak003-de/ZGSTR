@EndUserText.label: 'Plant Address'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PlantAddress
  as select from ZDT_PLANTADDRESS
  association to parent ZI_PlantAddress_S as _PlantAddressAll on $projection.SingletonID = _PlantAddressAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key BUKRS as Bukrs,
  key WERKS as Werks,
  GSTIN as Gstin,
  LEGALNAME as Legalname,
  ADDRESS1 as Address1,
  ADDRESS2 as Address2,
  CITY as City,
  PINCODE as Pincode,
  STATECODE as Statecode,
  STATECODEDESCRIPTION as Statecodedescription,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_ConfignDeprecationCode', 
      element: 'ConfigurationDeprecationCode'
    }
  } ]
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _PlantAddressAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
