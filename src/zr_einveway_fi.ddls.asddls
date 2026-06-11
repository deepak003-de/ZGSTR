@EndUserText.label: 'Einvoicing ~ EWay Bill'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZR_EINVEWAY_FI

  as select from ZR_EINVEWAY_V1

  association to parent ZR_EINVEWAY_F as _Head on $projection.BillingDocument = _Head.BillingDocument

{
  key ZR_EINVEWAY_V1.BillingDocument,
  key ZR_EINVEWAY_V1.SlNo,
      ZR_EINVEWAY_V1.BusinessPlace,
      ZR_EINVEWAY_V1.CompanyCode,
      ZR_EINVEWAY_V1.IN_GSTIdentificationNumber,
      ZR_EINVEWAY_V1.Plant,
      ZR_EINVEWAY_V1.Product,
      ZR_EINVEWAY_V1.ProductName,
      ZR_EINVEWAY_V1.ConsumptionTaxCtrlCode,
      ZR_EINVEWAY_V1.BillingQuantity,
      ZR_EINVEWAY_V1.BillingQuantityUnit,
      ZR_EINVEWAY_V1.TransactionCurrency,
      ZR_EINVEWAY_V1.LocalCurrency,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      ZR_EINVEWAY_V1.NetAmount,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      ZR_EINVEWAY_V1.TaxAmount,
      ZR_EINVEWAY_V1.Sapuom,
      ZR_EINVEWAY_V1.Gstuom,
      ZR_EINVEWAY_V1.Description,
      ZR_EINVEWAY_V1.Werks,
      ZR_EINVEWAY_V1.Portcode,
      ZR_EINVEWAY_V1.Statecode,
      ZR_EINVEWAY_V1.Portname,
      ZR_EINVEWAY_V1.Distance,
      ZR_EINVEWAY_V1.Buyerpincode,
      ZR_EINVEWAY_V1.PlantGSTIN,
      ZR_EINVEWAY_V1.PlantLegalname,
      ZR_EINVEWAY_V1.PlantAddress1,
      ZR_EINVEWAY_V1.PlantAddress2,
      ZR_EINVEWAY_V1.PlantCity,
      ZR_EINVEWAY_V1.PlantPincode,
      ZR_EINVEWAY_V1.PlantStatecode,
      ZR_EINVEWAY_V1.PlantStatecodedescription,
      ZR_EINVEWAY_V1.MaterialValue,
      ZR_EINVEWAY_V1.MaterialBaseValue,
      ZR_EINVEWAY_V1.DiscountValue,
      ZR_EINVEWAY_V1.RoundOffValue,
      ZR_EINVEWAY_V1.CessValue,
      ZR_EINVEWAY_V1.CessBaseValue,
      ZR_EINVEWAY_V1.TCSValue,
      ZR_EINVEWAY_V1.TCSBaseValue,
      ZR_EINVEWAY_V1.SGSTValue,
      ZR_EINVEWAY_V1.SGSTRate,
      ZR_EINVEWAY_V1.CGSTValue,
      ZR_EINVEWAY_V1.CGSTRate,
      ZR_EINVEWAY_V1.IGSTValue,
      ZR_EINVEWAY_V1.IGSTRate,
      ZR_EINVEWAY_V1.TotalGSTRate,
      ZR_EINVEWAY_V1.TotalGSTValue,

      _Head

}
