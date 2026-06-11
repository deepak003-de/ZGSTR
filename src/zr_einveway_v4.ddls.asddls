@EndUserText.label: 'Einvoicing ~ EWay Bill Solution'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_EINVEWAY_V4
  as select from ZR_EINVEWAY_V3
{
  key BillingDocument,
  key BillingDocumentItem,
      TransactionCurrency,
      LocalCurrency,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      MaterialValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      MaterialBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      NetValue,
      //      cast( NetValue + RoundOffValue as abap.curr(13,2) ) as NetValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      DiscountValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      RoundOffValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      CessValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      CessBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      TCSValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      TCSBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      SGSTValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      SGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      CGSTValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      CGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      IGSTValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      IGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      ( IGSTRate + SGSTRate + CGSTRate )    as TotalGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      ( IGSTValue + SGSTValue + CGSTValue ) as TotalGSTValue
}
