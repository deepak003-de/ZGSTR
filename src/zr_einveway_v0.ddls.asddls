@EndUserText.label: 'Einvoicing ~ EWay Bill Solution'
@AbapCatalog.sqlViewName: 'ZREINVEWAYV0'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZR_EINVEWAY_V0

  as select distinct from I_BillingDocument        as a

    inner join            I_BillingDocumentPartner as b   on  b.BillingDocument = a.BillingDocument
                                                          and b.PartnerFunction = 'RE'
    inner join            I_BillingDocumentItem    as i   on i.BillingDocument = a.BillingDocument

    left outer join       I_DeliveryDocument       as j   on j.DeliveryDocument = i.ReferenceSDDocument

    inner join            I_BillingDocItemPartner  as c   on  c.BillingDocument = a.BillingDocument
                                                          and c.PartnerFunction = 'WE'

    inner join            I_Customer               as d   on d.Customer = b.Customer

    inner join            I_Address_2              as adb on adb.AddressID = b.AddressID



    inner join            I_Customer               as e   on e.Customer = c.Customer

    inner join            I_Address_2              as ads on ads.AddressID = c.AddressID

    inner join            I_RegionText             as g   on  g.Country  = adb.Country
                                                          and g.Region   = adb.Region
                                                          and g.Language = $session.system_language

    inner join            I_RegionText             as h   on  h.Country  = e.Country
                                                          and h.Region   = e.Region
                                                          and h.Language = $session.system_language

    left outer join       zdt_gstrmap              as f   on f.fkart = a.BillingDocumentType

{

  key  a.BillingDocument,

       i.SalesOrganization,
       i.DistributionChannel,
       i.Division,

       a.BillingDocumentType,
       a.BillingDocumentDate,

       f.doctype                                                                             as Doctype,
       f.supplytext                                                                          as Supplytext,
       f.subtype                                                                             as Subtype,
       f.irnind                                                                              as Irnind,
       f.ewayind                                                                             as Ewayind,
       f.cattrxn                                                                             as Cattrxn,
       f.referencefield                                                                      as Referencefield,

       b.Customer                                                                            as BilltoParty,
       d.TaxNumber3                                                                          as BilltoPartyGSTIN,

       //////// changed BillToParty by siba

       // d.CustomerFullName                                                                          as BilltoPartyName,
       cast( adb.AddresseeFullName as abap.char( 220 ) )                                     as BilltoPartyName,
       //       concat(concat(adb.StreetName,concat(',',adb.StreetPrefixName1)),concat(',',adb.StreetPrefixName2) )                as BilltoPartyAddress1,
       // cast(  adb.StreetName  as abap.char( 142 ) )                                                as BilltoPartyAddress1,
       cast( concat(adb.StreetName,concat(',',adb.StreetPrefixName1)) as abap.char( 142 ) )  as BilltoPartyAddress1,
       //      adb.CityName                   as BilltoPartyAddress2,
       // cast( concat(adb.StreetPrefixName1,concat(',',adb.StreetPrefixName2)) as abap.char( 142 ) ) as BilltoPartyAddress2,
       //cast( concat(adb.StreetPrefixName2,concat(',',adb.StreetSuffixName1)) as abap.char( 142 ) ) as BilltoPartyAddress2,
       case
       when adb.StreetPrefixName2 is not null and adb.StreetPrefixName2 <> ''
       and adb.StreetSuffixName1 is not null and adb.StreetSuffixName1 <> ''
       then cast(concat(adb.StreetPrefixName2, concat(',', adb.StreetSuffixName1)) as abap.char(142))
       when adb.StreetPrefixName2 is not null and adb.StreetPrefixName2 <> ''
       then cast(adb.StreetPrefixName2 as abap.char(142))
       when adb.StreetSuffixName1 is not null and adb.StreetSuffixName1 <> ''
       then cast(adb.StreetSuffixName1 as abap.char(142))
       else cast('' as abap.char(142))
       end                                                                                   as BilltoPartyAddress2,


       adb.Region                                                                            as BilltoPartyPOS,
       adb.CityName                                                                          as BilltoPartyLocation,
       adb.PostalCode                                                                        as BilltoPartyPostalCode,
       adb.Region                                                                            as BilltoPartyStateCode,
       g.RegionName                                                                          as BilltoPartyStateCodeDesc,
       adb.Country                                                                           as billtopartycountry,

       c.Customer                                                                            as ShiptoParty,
       e.TaxNumber3                                                                          as ShiptoPartyGSTIN,

       //////// changed ShipToParty by siba

       //   e.CustomerFullName                                                                          as ShiptoPartyName,
       cast( ads.AddresseeFullName as abap.char( 220 ) )                                     as ShiptoPartyName,
       //       concat(concat(ads.StreetName,concat(',',ads.StreetPrefixName1)),concat(',',ads.StreetPrefixName2) )                 as ShiptoPartyAddress1,
       // cast(  ads.StreetName  as abap.char( 142 ) )                                                as ShiptoPartyAddress1,
       cast( concat(ads.StreetName,concat(',',ads.StreetPrefixName1))  as abap.char( 142 ) ) as ShiptoPartyAddress1,
       //       ads.CityName                   as ShiptoPartyAddress2,
       //       cast( concat(ads.StreetPrefixName1,concat(',',ads.StreetPrefixName2)) as abap.char( 142 ) ) as ShiptoPartyAddress2,
       //  cast( concat(ads.StreetPrefixName2,concat(',',ads.StreetSuffixName1)) as abap.char( 142 ) ) as ShiptoPartyAddress2,
       case
       when ads.StreetPrefixName2 is not null and ads.StreetPrefixName2 <> ''
          and ads.StreetSuffixName1 is not null and ads.StreetSuffixName1 <> ''
       then cast( concat( ads.StreetPrefixName2, concat( ',', ads.StreetSuffixName1 ) ) as abap.char(142) )
       when ads.StreetPrefixName2 is not null and ads.StreetPrefixName2 <> ''
       then cast( ads.StreetPrefixName2 as abap.char(142) )
       when ads.StreetSuffixName1 is not null and ads.StreetSuffixName1 <> ''
       then cast( ads.StreetSuffixName1 as abap.char(142) )
       else cast( '' as abap.char(142) )
       end                                                                                   as ShiptoPartyAddress2,


       ads.Region                                                                            as ShiptoPartyPOS,
       ads.CityName                                                                          as ShiptoPartyLocation,
       ads.PostalCode                                                                        as ShiptoPartyPostalCode,
       ads.Region                                                                            as ShiptoPartyStateCode,
       h.RegionName                                                                          as ShiptoPartyStateCodeDesc,
       j.YY1_TransporterCode_DLH                                                             as transportercode,
       j.YY1_TransporterGSTIN_DLH                                                            as trasnportergstin,
       j.YY1_TransporterName_DLH                                                             as transportername,
       j.YY1_VehicleNumber_DLH                                                               as vehiclenumber,
       j.YY1_Distance_DLH                                                                    as distance,
       j.YY1_ModeofTransport_DLH                                                             as modeoftransport,
       j.YY1_TransporterDate1_DLH                                                            as transporterdate,
       j.YY1_TransporterDocumen_DLH                                                          as transporterdocumentnumber,
       j.YY1_ExtendedValidityDa_DLH                                                          as extendedvaliditydate,
       j.YY1_VehicleType_DLH                                                                 as vehicletype

       //     j.YY1_KMDistance_DLH         as KMdistance
       //     cast('' as abap.numc( 5 ))   as KMDistance

}

where
      a.BillingDocumentType <> 'S1'
  and a.BillingDocumentType <> 'S2'
