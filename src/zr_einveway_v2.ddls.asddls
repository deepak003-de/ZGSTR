@EndUserText.label: 'Einvoiving ~ Eway Bill Solution'
@AbapCatalog.sqlViewName: 'ZREINVEWAYV2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZR_EINVEWAY_V2
  as select from    I_BillingDocument              as a

    inner join      I_BillingDocumentItem          as b on b.BillingDocument = a.BillingDocument

    inner join      I_BillingDocumentItemPrcgElmnt as c on  c.BillingDocument     = b.BillingDocument
                                                        and c.BillingDocumentItem = b.BillingDocumentItem

    left outer join zdt_salesinv1                  as d on  d.fkart = a.BillingDocumentType
                                                        and d.kschl = c.ConditionType

{

  key a.BillingDocument,
  key b.BillingDocumentItem,

      a.TransactionCurrency,
      cast( 'INR' as abap.cuky( 5 ) )                                                                             as LocalCurrency,

      case when d.billtype = '1' then case when a.AccountingExchangeRate < 0
            then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else  cast( c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end else 0 end  as MaterialValue,
      case when d.billtype = '1' then c.ConditionRateValue else 0 end                                             as MaterialBaseValue,

      case when d.billtype = '5' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as DiscountValue,

      case when d.billtype = '9' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as NetValue,

      case when d.billtype = '6' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as CessValue,
      case when d.billtype = '6' then c.ConditionRateValue   else 0 end                                           as CessBaseValue,

      case when d.billtype = '7' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as TCSValue,
      case when d.billtype = '7' then c.ConditionRateValue   else 0 end                                           as TCSBaseValue,

      case when d.billtype = '8' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as RoundOffValue,

      case when d.billtype = '2' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast(c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end  as SGSTValue,
      case when d.billtype = '2' then c.ConditionRateValue  else 0 end                                            as SGSTRate,

      case when d.billtype = '3' then case when a.AccountingExchangeRate < 0
                then  cast(c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast( c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end as CGSTValue,
      case when d.billtype = '3' then c.ConditionRateValue    else 0 end                                          as CGSTRate,

      case when d.billtype = '4' then case when a.AccountingExchangeRate < 0
                then cast( c.ConditionAmount * a.AccountingExchangeRate * -1 as abap.curr( 13 , 2 ) )
                else cast( c.ConditionAmount * a.AccountingExchangeRate as abap.curr( 13 , 2 ) ) end   else 0 end as IGSTValue,
      case when d.billtype = '4' then c.ConditionRateValue  else 0 end                                            as IGSTRate

}
