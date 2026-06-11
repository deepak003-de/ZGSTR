@EndUserText.label: 'Einvoicing ~ EWay Bill Solution'
@AbapCatalog.sqlViewName: 'ZREINVEWAYV1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZR_EINVEWAY_V1

  as select distinct from I_BillingDocumentItem         as a

    inner join            I_ProductText                 as b  on  b.Product  = a.Product
                                                              and b.Language = $session.system_language

    inner join            I_IN_PlantBusinessPlaceDetail as d  on d.Plant = a.Plant
    inner join            I_BillingDocument             as dd on dd.BillingDocument = a.BillingDocument

    inner join            I_IN_BusinessPlaceTaxDetail   as e  on  e.BusinessPlace = d.BusinessPlace
                                                              and e.CompanyCode   = d.CompanyCode

    inner join            ZR_EINVEWAY_V4                as i  on  i.BillingDocument     = a.BillingDocument
                                                              and i.BillingDocumentItem = a.BillingDocumentItem

    left outer join       I_ProductPlantIntlTrd         as c  on  c.Product = a.Product
                                                              and c.Plant   = a.Plant

    left outer join       zdt_uom                       as f  on f.sapuom = a.BillingQuantityUnit
    left outer join       zdt_portpartner               as hj on hj.parnterfunction != ' '
    left outer join       I_BillingDocumentPartnerBasic as hi on  hi.BillingDocument = a.BillingDocument
                                                              and hj.parnterfunction = hi.PartnerFunction
    left outer join       I_Customer                    as ff on ff.Customer = hi.Customer


    left outer join       zdt_plantaddress              as h  on  h.bukrs = d.CompanyCode
                                                              and h.werks = a.Plant

{

  key a.BillingDocument,
  key a.BillingDocumentItem                                                                     as SlNo,

      d.BusinessPlace,
      d.CompanyCode,
      e.IN_GSTIdentificationNumber,
      a.Plant,
      a.Product,
      a.SalesOrganization,
      a.DistributionChannel,
      a.Division,
      b.ProductName,
      c.ConsumptionTaxCtrlCode,
      a.BillingQuantity,
      a.BillingQuantityUnit,
      a.TransactionCurrency,
      cast( 'INR' as abap.cuky( 5 ) )                                                           as LocalCurrency,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      i.NetValue                                                                                as NetAmount,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      case when dd.AccountingExchangeRate < 0
      then cast(  a.TaxAmount * dd.AccountingExchangeRate * -1 as abap.curr( 13, 2 ) )
      else cast(  a.TaxAmount * dd.AccountingExchangeRate  as abap.curr( 13, 2 ) ) end          as TaxAmount,

      //UoM
      f.sapuom                                                                                  as Sapuom,
      f.gstuom                                                                                  as Gstuom,
      f.description                                                                             as Description,

      //PortCode
      a.Plant                                                                                   as Werks,
      ff.Customer                                                                               as Portcode,
      ff.Region                                                                                 as Statecode,
      ff.CustomerName                                                                           as Portname,
      ''                                                                                        as Distance,
      ff.PostalCode                                                                             as Buyerpincode,
      concat_with_space( ff.StreetName, concat_with_space( ff.CityName, ff.PostalCode, 1 ), 1 ) as addressport,
      ff.CityName                                                                               as portcity,
      ff.TaxNumber3                                                                             as portgst,

      //Plant
      h.gstin                                                                                   as PlantGSTIN,
      h.legalname                                                                               as PlantLegalname,
      h.address1                                                                                as PlantAddress1,
      h.address2                                                                                as PlantAddress2,
      h.city                                                                                    as PlantCity,
      h.pincode                                                                                 as PlantPincode,
      h.statecode                                                                               as PlantStatecode,
      h.statecodedescription                                                                    as PlantStatecodedescription,

      //Tax
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.MaterialValue as abap.curr( 23, 2 ) )                                             as MaterialValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.MaterialBaseValue as abap.curr( 23, 2 ) )                                         as MaterialBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.DiscountValue as abap.curr( 23, 2 ) )                                             as DiscountValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.RoundOffValue as abap.curr( 23, 2 ) )                                             as RoundOffValue,
      //    cast( 0 as abap.dec(23,2) )                                                           as RoundOffValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.CessValue as abap.curr( 23, 2 ) )                                                 as CessValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.CessBaseValue as abap.curr( 23, 2 ) )                                             as CessBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.TCSValue as abap.curr( 23, 2 ) )                                                  as TCSValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.TCSBaseValue as abap.curr( 23, 2 ) )                                              as TCSBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.SGSTValue as abap.curr( 23, 2 ) )                                                 as SGSTValue,
      cast( i.SGSTRate as abap.dec( 23, 2 ) )                                                   as SGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.CGSTValue as abap.curr( 23, 2 ) )                                                 as CGSTValue,
      cast( i.CGSTRate as abap.dec( 23, 2 ) )                                                   as CGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.IGSTValue as abap.curr( 23, 2 ) )                                                 as IGSTValue,
      cast( i.IGSTRate as abap.dec( 23, 2 ) )                                                   as IGSTRate,
      cast( i.TotalGSTRate as abap.dec( 23, 2 ) )                                               as TotalGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      cast( i.TotalGSTValue as abap.curr( 23, 2 ) )                                             as TotalGSTValue,

      a.Batch,
      a.BillToPartyCountry,
      a.BusinessArea
}

where
     SalesDocumentItemCategory = 'TAN'
  or SalesDocumentItemCategory = 'TAD'
  or SalesDocumentItemCategory = 'CBEN'
  or SalesDocumentItemCategory = 'G2N'
  or SalesDocumentItemCategory = 'L2N'
  or SalesDocumentItemCategory = 'G2W'
  or SalesDocumentItemCategory = 'TAX'
  or SalesDocumentItemCategory = 'TAXP'
