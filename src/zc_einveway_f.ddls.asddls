@Metadata.allowExtensions: true
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Invoicing && E-Way Bill'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_EINVEWAY_F
  provider contract transactional_query
  as projection on ZR_EINVEWAY_F
{
      @EndUserText.label: 'Billing Document'
      @Search.defaultSearchElement: true
  key BillingDocument,
      @EndUserText.label: 'Billing Document Type'
      BillingDocumentType,
      @UI.hidden: true
      Total,
      @EndUserText.label: 'Progress Bar'
      Progress,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Billing Document Date'
      BillingDocumentDate,
      @EndUserText.label: 'Document Type'
      @Search.defaultSearchElement: true
      Doctype,
      @EndUserText.label: 'Supply Text'
      Supplytext,
      @EndUserText.label: 'Sub Type'
      Subtype,
      @EndUserText.label: 'IRN Indicator'
      Irnind,
      @EndUserText.label: 'EWAY Indicator'
      Ewayind,
      @EndUserText.label: 'Transaction Category'
      Cattrxn,
      @EndUserText.label: 'Reference Field'
      Referencefield,
      @EndUserText.label: 'Bill to Party'
      BilltoParty,
      @EndUserText.label: 'Bill to Party GSTN'
      BilltoPartyGSTIN,
      @EndUserText.label: 'Bill to Party Name'
      BilltoPartyName,
      @EndUserText.label: 'Bill to Party Address1'
      BilltoPartyAddress1,
      @EndUserText.label: 'Bill to Party Address2'
      BilltoPartyAddress2,
      @EndUserText.label: 'Bill to Party POS'
      BilltoPartyPOS,
      @EndUserText.label: 'Bill to Party Location'
      BilltoPartyLocation,
      @EndUserText.label: 'Bill to Party Pin Code'
      BilltoPartyPostalCode,
      @EndUserText.label: 'Bill to Party State Code'
      BilltoPartyStateCode,
      @EndUserText.label: 'Bill to Party State Code Desc.'
      BilltoPartyStateCodeDesc,

      @EndUserText.label: 'Ship to Party'
      ShiptoParty,
      @EndUserText.label: 'Ship to Party GSTN'
      ShiptoPartyGSTIN,
      @EndUserText.label: 'Ship to Party Name'
      ShiptoPartyName,
      @EndUserText.label: 'Ship to Party Address1'
      ShiptoPartyAddress1,
      @EndUserText.label: 'Ship to Party Address2'
      ShiptoPartyAddress2,
      @EndUserText.label: 'Ship to Party POS'
      ShiptoPartyPOS,
      @EndUserText.label: 'Ship to Party Location'
      ShiptoPartyLocation,
      @EndUserText.label: 'Ship to Party Pin Code'
      ShiptoPartyPostalCode,
      @EndUserText.label: 'Ship to Party State Code'
      ShiptoPartyStateCode,
      @EndUserText.label: 'Ship to Party State Code Desc.'
      ShiptoPartyStateCodeDesc,
      @EndUserText.label: 'Acknowledgement Number'
      ackno,
      @EndUserText.label: 'Acknowledgement Date'
      ackdate,
      @EndUserText.label: 'IRN'
      irn,
      @UI.hidden: true
      irstatus,
      @EndUserText.label: 'IRN Cancel Date'
      irncanceldate,
      @EndUserText.label: 'Signed Invoice'
      signedinv,
      @EndUserText.label: 'Signed QR Code'
      signedqrcode,
      @EndUserText.label: 'eWay Bill Number'
      eway,
      @EndUserText.label: 'eWay Bill Cancel Date'
      ewaycanceldate,
      @EndUserText.label: 'Link for IRN Print'
      urlirn,
      @EndUserText.label: 'IRN Flag'
      irnflag,
      @EndUserText.label: 'eWay Flag'
      ewayflag,
      @EndUserText.label: 'IRN Cancel Flag'
      irncancflag,
      @EndUserText.label: 'eWay Cancel Flag'
      ewaycancflag,
      @EndUserText.label: 'IRN Message'
      irnmessage,
      @EndUserText.label: 'eWay Message'
      ewaymessage,
      @EndUserText.label: 'IRN Cancel Message'
      cirnmessage,
      @EndUserText.label: 'eWay Cancel Flag'
      cewaymessage,
      @EndUserText.label: 'eWay Validity Date'
      ewayvaliditydate,
      @EndUserText.label: 'eWay Date'
      ewaydate,
      @EndUserText.label: 'IRN Print'
      printflag,
      @EndUserText.label: 'Only EwayBill Flag'
      OnlyEwayFlag,
      @EndUserText.label: 'Eway Bill URL'
      urleway,
      @EndUserText.label: 'eWay Bill Print'
      printewayflag,
      @EndUserText.label: 'Transporter Code'
      transportercode,
      @EndUserText.label: 'Transporter Name'
      transportername,
      @EndUserText.label: 'Transporter GSTIN'
      trasnportergstin,
      @EndUserText.label: 'Vehicle Number'
      vehiclenumber,
      @EndUserText.label: 'Distance'
      distance,
      @EndUserText.label: 'Eway Validity Upto(Modification)'
      extendedvaliditydate,
      @EndUserText.label: 'Mode Of Transport'
      modeoftransport,
      @EndUserText.label: 'Transporter Document Date'
      transporterdocumentdate,
      @EndUserText.label: 'Transporter Document Number'
      transporterdocumentnumber,
      @EndUserText.label: 'Vehicle Type'
      vehicletype,

      @EndUserText.label: 'Movement Status'
      movementstatus,
      @EndUserText.label: 'Movement Place'
      movementplace,
      @EndUserText.label: 'Movement Remarks'
      movementremarks,
      @EndUserText.label: 'Movement Date'
      movementdate,
      @EndUserText.label: 'Movement Time'
      movementtime,
      @EndUserText.label: 'From Place'
      fromplace,
      @EndUserText.label: 'From State'
      fromstate,
      @EndUserText.label: 'Remaining Distance'
      remainingdistance,
      @EndUserText.label: 'Extension Reason Code'
      extnrsncode,
      @EndUserText.label: 'Extension Remarks'
      extnremarks,
      @EndUserText.label: 'From Pin Code'
      frompincode,
      @EndUserText.label: 'Consignment Status'
      consignmentstatus,
      @EndUserText.label: 'Transit Type'
      transittype,
      @EndUserText.label: 'New Vehicle Number'
      newvehicleno,
      @EndUserText.label: 'New Transporter'
      newtranno,
      @EndUserText.label: 'From Place ~ Multi Vehicle Update'
      fromplacemultiveh,
      @EndUserText.label: 'From State ~ Multi Vehicle Update'
      fromstatemultiveh,
      @EndUserText.label: 'Reason Code ~ Vehicle Update'
      reasoncodemultiveh,
      @EndUserText.label: 'Reason Remarks ~ Vehicle Update'
      reasonremmultiveh,
      @EndUserText.label: 'Reason Code ~ eWay Cancellation'
      cancelrsncodeewb,
      @EndUserText.label: 'Reason Remarks ~ eWay Cancellation'
      cancelremarksewb,
      @EndUserText.label: 'Reason Code ~ EInv Cancellation'
      cnlrsneinv,
      @EndUserText.label: 'Reason Remarks ~ Einv Cancellation'
      cnlremarkseinv,
      toplace,
      tostate,
      totalquantity,
      unitcode,
//      KMdistance,


      /* Associations */
      /* Associations */
      _item  : redirected to composition child ZC_EINVEWAY_FI,
      _error : redirected to composition child ZC_ERRORLOG
}
