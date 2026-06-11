@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Tax Classification'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_GSTTAXCLASSIFICATION
as select distinct from    I_BillingDocument     as a
    inner join      I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
    left outer join zdt_salesinv          as d on  d.fkart                 =  a.BillingDocumentType
                                               and d.billtype              =  '4'
                                               and d.configdeprecationcode != 'W'
    left outer join zdt_salesinv          as e on  e.fkart                 =  a.BillingDocumentType
                                               and e.billtype              =  '2'
                                               and e.configdeprecationcode != 'W'
    left outer join zdt_salesinv          as f on  f.fkart                 =  a.BillingDocumentType
                                               and f.billtype              =  '2'
                                               and f.configdeprecationcode != 'W'
    left outer join zdt_salesinv          as g on  g.fkart                 =  a.BillingDocumentType
                                               and g.billtype              =  '2'
                                               and g.configdeprecationcode != 'W'
    left outer join I_CustSalesAreaTax    as h on  h.Customer            = b.BillToParty
                                               and h.CustomerTaxCategory = d.kschl
                                               and h.DistributionChannel = a.DistributionChannel
                                               and h.Division            = a.Division

    left outer join I_CustSalesAreaTax    as i on  h.Customer            = b.BillToParty
                                               and h.CustomerTaxCategory = e.kschl
                                               and h.DistributionChannel = a.DistributionChannel
                                               and h.Division            = a.Division

    left outer join I_CustSalesAreaTax    as j on  h.Customer            = b.BillToParty
                                               and h.CustomerTaxCategory = f.kschl
                                               and h.DistributionChannel = a.DistributionChannel
                                               and h.Division            = a.Division

    left outer join I_CustSalesAreaTax    as k on  h.Customer            = b.BillToParty
                                               and h.CustomerTaxCategory = g.kschl
                                               and h.DistributionChannel = a.DistributionChannel
                                               and h.Division            = a.Division

{
  a.BillingDocument,
  case when h.CustomerTaxClassification is not initial or h.CustomerTaxClassification is not null
  then h.CustomerTaxClassification
  when i.CustomerTaxClassification is not initial or i.CustomerTaxClassification is not null
  then i.CustomerTaxClassification
  when j.CustomerTaxClassification is not initial or j.CustomerTaxClassification is not null
  then j.CustomerTaxClassification
  when k.CustomerTaxClassification is not initial or k.CustomerTaxClassification is not null
  then k.CustomerTaxClassification end as CustomerTaxClassification

}
