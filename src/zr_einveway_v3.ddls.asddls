@EndUserText.label: 'Einvoiving ~ Eway Bill Solution'
@AbapCatalog.sqlViewName: 'ZREINVEWAYV3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZR_EINVEWAY_V3

  as select from ZR_EINVEWAY_V2

{

  key BillingDocument,
  key BillingDocumentItem,
      TransactionCurrency,
      LocalCurrency,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( MaterialValue )     as MaterialValue,
      max( MaterialBaseValue ) as MaterialBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      min( DiscountValue )     as DiscountValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      sum( NetValue )          as NetValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      sum( RoundOffValue )     as RoundOffValue,
      // RoundOffValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( CessValue )         as CessValue,
      max( CessBaseValue )     as CessBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( TCSValue )          as TCSValue,
      max( TCSBaseValue )      as TCSBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( SGSTValue )         as SGSTValue,
      max( SGSTRate )          as SGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( CGSTValue )         as CGSTValue,
      max( CGSTRate )          as CGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      max( IGSTValue )         as IGSTValue,
      max( IGSTRate )          as IGSTRate

}
group by
  BillingDocument,
  BillingDocumentItem,
  TransactionCurrency,
  LocalCurrency
// RoundOffValue
