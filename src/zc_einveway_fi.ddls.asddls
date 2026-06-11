@Metadata.allowExtensions: true
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Invoicing && E-Way Bill'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_EINVEWAY_FI

  as projection on ZR_EINVEWAY_FI
{

      @EndUserText.label: 'Billing Document'
      @Search.defaultSearchElement: true
  key BillingDocument,
      @EndUserText.label: 'Item No.'
  key SlNo,
      @EndUserText.label: 'Business Place'
      @Search.defaultSearchElement: true
      BusinessPlace,
      @EndUserText.label: 'Company Code'
      @Search.defaultSearchElement: true
      CompanyCode,
      @EndUserText.label: 'Business Place GSTN'
      IN_GSTIdentificationNumber,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Product Name'
      ProductName,
      @EndUserText.label: 'HSN Code'
      ConsumptionTaxCtrlCode,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      @EndUserText.label: 'Sales UoM'
      BillingQuantityUnit,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      @EndUserText.label: 'LocalCurrency'
      LocalCurrency,
      @EndUserText.label: 'Net Amount'
      @Semantics.amount.currencyCode: 'LocalCurrency'
      NetAmount,
      @EndUserText.label: 'Tax Amount'
      @Semantics.amount.currencyCode: 'LocalCurrency'
      TaxAmount,
      @EndUserText.label: 'SAP UoM'
      Sapuom,
      @EndUserText.label: 'GST UoM'
      Gstuom,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Plant'
      Werks,
      @EndUserText.label: 'Port Code'
      Portcode,
      @EndUserText.label: 'State Code'
      Statecode,
      @EndUserText.label: 'Port Name'
      Portname,
      @EndUserText.label: 'Distance'
      Distance,
      @EndUserText.label: 'Buyer Pin Code'
      Buyerpincode,
      @EndUserText.label: 'Plant GSTN'
      PlantGSTIN,
      @EndUserText.label: 'Plant Legal Name'
      PlantLegalname,
      @EndUserText.label: 'Plant Address 1'
      PlantAddress1,
      @EndUserText.label: 'Plant Address 2'
      PlantAddress2,
      @EndUserText.label: 'Plant City'
      PlantCity,
      @EndUserText.label: 'Plant Pin Code'
      PlantPincode,
      @EndUserText.label: 'Plant State Code'
      PlantStatecode,
      @EndUserText.label: 'Plant State Code Desc.'
      PlantStatecodedescription,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Material Value'
      MaterialValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Material Base Value'
      MaterialBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Discount Value'
      DiscountValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'RoundOff Value'      
      RoundOffValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Cess Value'
      CessValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Cess Base Value'
      CessBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'TCS Value'
      TCSValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'TCS Base Value'
      TCSBaseValue,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'SGST Value'
      SGSTValue,
      @EndUserText.label: 'SGST Rate'
      SGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'CGST Value'
      CGSTValue,
      @EndUserText.label: 'CGST Rate'
      CGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'IGST Value'
      IGSTValue,
      @EndUserText.label: 'IGST Rate'
      IGSTRate,
      @EndUserText.label: 'Total GST Rate'
      TotalGSTRate,
      @Semantics.amount.currencyCode: 'LocalCurrency'
      @EndUserText.label: 'Total GST Value'
      TotalGSTValue,

      /* Associations */
      _Head : redirected to parent ZC_EINVEWAY_F

}
