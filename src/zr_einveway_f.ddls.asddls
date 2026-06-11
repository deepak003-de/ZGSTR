@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Invoicing && E-Way Bill'
define root view entity ZR_EINVEWAY_F

  as select from    ZR_EINVEWAY_V0

    inner join      I_BillingDocument as b on ZR_EINVEWAY_V0.BillingDocument = b.BillingDocument

    left outer join zdt_einveway           on ZR_EINVEWAY_V0.BillingDocument = zdt_einveway.vbeln

    left outer join ZV_EINVEWAY_GP         on ZR_EINVEWAY_V0.BillingDocument = ZV_EINVEWAY_GP.BillingDocument

  composition [0..*] of ZR_EINVEWAY_FI as _item
  composition [0..*] of ZR_ERRORLOG    as _error

{
  key ZR_EINVEWAY_V0.BillingDocument,
      ZR_EINVEWAY_V0.BillingDocumentType,
      ZR_EINVEWAY_V0.BillingDocumentDate,

      ZR_EINVEWAY_V0.SalesOrganization,
      ZR_EINVEWAY_V0.DistributionChannel,
      ZR_EINVEWAY_V0.Division,

      ZR_EINVEWAY_V0.Doctype,
      ZR_EINVEWAY_V0.Supplytext,
      ZR_EINVEWAY_V0.Subtype,
      ZR_EINVEWAY_V0.Irnind,
      ZR_EINVEWAY_V0.Ewayind,
      ZR_EINVEWAY_V0.Cattrxn,
      ZR_EINVEWAY_V0.Referencefield,

      ZR_EINVEWAY_V0.BilltoParty,
      ZR_EINVEWAY_V0.BilltoPartyGSTIN,
      ZR_EINVEWAY_V0.BilltoPartyName,
      ZR_EINVEWAY_V0.BilltoPartyAddress1,
      ZR_EINVEWAY_V0.BilltoPartyAddress2,
      ZR_EINVEWAY_V0.BilltoPartyPOS,
      ZR_EINVEWAY_V0.BilltoPartyLocation,
      ZR_EINVEWAY_V0.BilltoPartyPostalCode,
      ZR_EINVEWAY_V0.BilltoPartyStateCode,
      ZR_EINVEWAY_V0.BilltoPartyStateCodeDesc,

      ZR_EINVEWAY_V0.ShiptoParty,
      ZR_EINVEWAY_V0.ShiptoPartyGSTIN,
      ZR_EINVEWAY_V0.ShiptoPartyName,
      ZR_EINVEWAY_V0.ShiptoPartyAddress1,
      ZR_EINVEWAY_V0.ShiptoPartyAddress2,
      ZR_EINVEWAY_V0.ShiptoPartyPOS,
      ZR_EINVEWAY_V0.ShiptoPartyLocation,
      ZR_EINVEWAY_V0.ShiptoPartyPostalCode,
      ZR_EINVEWAY_V0.ShiptoPartyStateCode,
      ZR_EINVEWAY_V0.ShiptoPartyStateCodeDesc,



      case when zdt_einveway.status = 'Transporter Updated'
      then 'Transporter Updated'
      when zdt_einveway.status = 'eWay Bill Extended'
      then 'eWay Bill Extended'
       when zdt_einveway.status = 'Vehicle Updated'
      then 'Vehicle Updated'
       when zdt_einveway.status = 'Multi Vehicle Updated'
      then 'Multi Vehicle Updated'
       when zdt_einveway.status = 'Multi Vehicle Added'
      then 'Multi Vehicle Added'
      when zdt_einveway.status = 'Movement Added'
      then 'Movement Added'
      when zdt_einveway.status = 'eWay Bill Consolidated'
      then 'eWay Bill Consolidated'


      when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is initial
      then 'IRN Cancelled'
      when zdt_einveway.irncancflag is  initial and zdt_einveway.ewaycancflag is not initial
      then 'eWay Cancelled'
      when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is not initial
      then 'IRN/eWay Bill Cancelled'
       when zdt_einveway.irnflag is initial and zdt_einveway.ewayflag is initial
      then 'Invoice Created'
       when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is initial
      then 'IRN Generated'
      when zdt_einveway.irnflag is  initial and zdt_einveway.ewayflag is not initial
      then 'eWay Bill Generated'
      when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is not initial
      then 'IRN/eWay Bill Generated'
      else 'Invoice Created'           end           as Status,

      case  when zdt_einveway.status = 'Transporter Updated' then 3
      when zdt_einveway.status = 'eWay Bill Extended' then 3
      when zdt_einveway.status = 'Vehicle Updated' then 3
      when zdt_einveway.status = 'Multi Vehicle Updated' then 3
      when zdt_einveway.status = 'Multi Vehicle Added' then 3
      when zdt_einveway.status = 'Movement Added' then 3
      when zdt_einveway.status = 'eWay Bill Consolidated' then 3

            when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is initial then 1
            when zdt_einveway.irncancflag is  initial and zdt_einveway.ewaycancflag is not initial then 1
             when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is not initial then 1
            when zdt_einveway.irnflag is initial and zdt_einveway.ewayflag is initial then 1
            when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is initial  then 2
            when zdt_einveway.irnflag is  initial and zdt_einveway.ewayflag is not initial  then 3
            when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is not initial then 3

            else 3 end                               as Criticality,
      cast( case when zdt_einveway.status = 'Transporter Updated' then 100
      when zdt_einveway.status = 'eWay Bill Extended' then 100
      when zdt_einveway.status = 'Vehicle Updated' then 100
      when zdt_einveway.status = 'Multi Vehicle Updated' then 100
      when zdt_einveway.status = 'Multi Vehicle Added' then 100
      when zdt_einveway.status = 'Movement Added' then 100
      when zdt_einveway.status = 'eWay Bill Consolidated' then 100

                        when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is initial then 100
            when zdt_einveway.irncancflag is  initial and zdt_einveway.ewaycancflag is not initial then 50
             when zdt_einveway.irncancflag is not initial and zdt_einveway.ewaycancflag is not initial then 100
                        when zdt_einveway.irnflag is initial and zdt_einveway.ewayflag is initial then 25
                          when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is initial then 50
                          when zdt_einveway.irnflag is  initial and zdt_einveway.ewayflag is not initial then 100
                          when zdt_einveway.irnflag is not initial and zdt_einveway.ewayflag is not initial then 100

                          else 25 end as abap.int4 ) as Progress,
      cast( 100 as abap.int4 )                       as Total,
      zdt_einveway.ackno,
      zdt_einveway.ackdate,
      zdt_einveway.irn,
      zdt_einveway.irstatus,
      zdt_einveway.irncanceldate,
      case when zdt_einveway.irnflag is not initial
      then 'Signed Invoice Generated'
      else '' end                                    as signedinv,
      case when zdt_einveway.irnflag is not initial
       then 'Signed QR Code Generated'
       else '' end                                   as signedqrcode,
      zdt_einveway.eway,
      zdt_einveway.ewaycanceldate,
      zdt_einveway.urlirn,
      zdt_einveway.irnflag,
      zdt_einveway.ewayflag,
      zdt_einveway.irncancflag,
      zdt_einveway.ewaycancflag,

      zdt_einveway.irnmessage,
      zdt_einveway.ewaymessage,
      zdt_einveway.cirnmessage,
      zdt_einveway.cewaymessage,

      zdt_einveway.ewayvaliditydate,
      zdt_einveway.ewaydate,

      case when zdt_einveway.irnflag is not initial or zdt_einveway.irncancflag is not initial
      then 'Print'
      else '' end                                    as printflag,
      case when b.BillingDocumentType = 'F2'
           then cast( '' as abap_boolean )
      else cast( 'X' as abap_boolean ) end           as OnlyEwayFlag,
      case when zdt_einveway.ewayflag is not initial or zdt_einveway.ewaycancflag is not initial
            then 'Print'
            else '' end                              as printewayflag,
      zdt_einveway.urleway,

      //      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      //      then zdt_einveway.transportercode
      //      else
      //      ZR_EINVEWAY_V0.transportercode end             as transportercode,
      zdt_einveway.transportercode                   as transportercode,

      case when zdt_einveway.transportername is not initial then zdt_einveway.transportername
      else ZV_EINVEWAY_GP.transportername end        as transportername,

      case when zdt_einveway.transportergstin is not initial then zdt_einveway.transportergstin
      else ZV_EINVEWAY_GP.transportergst end         as trasnportergstin,

      case when zdt_einveway.vehiclenumber is not initial then zdt_einveway.vehiclenumber
       else ZV_EINVEWAY_GP.vehicleno end             as vehiclenumber,

      //      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      //            then zdt_einveway.distance
      //            else
      //            ZR_EINVEWAY_V0.distance end              as distance,
      cast(
       case
         when zdt_einveway.eway is not initial
           or zdt_einveway.ewaycancflag is not initial
         then zdt_einveway.distance
         else ZR_EINVEWAY_V0.distance
       end
       as abap.dec( 10 , 0 )
      )                                              as distance,

      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      then zdt_einveway.extendedvaliditydate
      else
      ZR_EINVEWAY_V0.extendedvaliditydate end        as extendedvaliditydate,

      //      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      //      then zdt_einveway.modeoftransport
      //      else
      //      ZR_EINVEWAY_V0.modeoftransport end             as modeoftransport,
      zdt_einveway.modeoftransport                   as modeoftransport,

      //      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      //      then zdt_einveway.transporterdocumentdate
      //      else
      //      ZR_EINVEWAY_V0.transporterdate end             as transporterdocumentdate,
      zdt_einveway.transporterdocumentdate           as transporterdocumentdate,

      case when zdt_einveway.transporterdocumentdate is not initial then zdt_einveway.transporterdocumentnumber
       else ZV_EINVEWAY_GP.lrrrno end                as transporterdocumentnumber,
      //zdt_einveway.transporterdocumentnumber         as transporterdocumentnumber,

      //      case when zdt_einveway.eway is not initial or zdt_einveway.ewaycancflag is not initial
      //       then zdt_einveway.vehicletype
      //       else
      //       ZR_EINVEWAY_V0.vehicletype end                as vehicletype,
      zdt_einveway.vehicletype                       as vehicletype,

      zdt_einveway.movementstatus,
      zdt_einveway.movementplace,
      zdt_einveway.movementremarks,
      zdt_einveway.movementdate,
      zdt_einveway.movementtime,
      zdt_einveway.fromplace,
      zdt_einveway.fromstate,
      zdt_einveway.remainingdistance,
      zdt_einveway.extnrsncode,
      zdt_einveway.extnremarks,
      zdt_einveway.frompincode,
      zdt_einveway.consignmentstatus,
      zdt_einveway.transittype,
      zdt_einveway.newvehicleno,
      zdt_einveway.newtranno,
      zdt_einveway.fromplacemultiveh,
      zdt_einveway.fromstatemultiveh,
      zdt_einveway.reasoncodemultiveh,
      zdt_einveway.reasonremmultiveh,
      zdt_einveway.cancelrsncodeewb,
      zdt_einveway.cancelremarksewb,
      zdt_einveway.cnlrsneinv,
      zdt_einveway.cnlremarkseinv,
      zdt_einveway.toplace,
      zdt_einveway.tostate,
      zdt_einveway.totalquantity,
      zdt_einveway.unitcode,

      //    ZR_EINVEWAY_V0.KMdistance,

      _item, // Make association public
      _error
}
