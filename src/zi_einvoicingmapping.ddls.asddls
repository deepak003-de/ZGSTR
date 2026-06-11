@EndUserText.label: 'E-Invoicing Mapping'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_EInvoicingMapping
  as select from ZDT_GSTRMAP
  association to parent ZI_EInvoicingMapping_S as _EInvoicingMappinAll on $projection.SingletonID = _EInvoicingMappinAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key BLART as Blart,
  key FKART as Fkart,
  DOCTYPE as Doctype,
  SUPPLYTEXT as Supplytext,
  SUBTYPE as Subtype,
  IRNIND as Irnind,
  EWAYIND as Ewayind,
  CATTRXN as Cattrxn,
  REFERENCEFIELD as Referencefield,
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
  _EInvoicingMappinAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
