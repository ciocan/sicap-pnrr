---
title: Cod CPV
description: Statistici licitatii publice cod CPV
hide_title: true
---

# <Value data={licitatii_publice_cpv} row=0 column="cod_cpv" />

<BigValue
  data={cpv_stats}
  value=total_licitatii
  title="Licitatii"
/>

<BigValue
  data={cpv_stats}
  value=total_autoritati
  title="Autoritati"
/>

<BigValue
  data={cpv_stats}
  value=total_furnizori
  title="Furnizori"
/>

<BigValue
  data={cpv_stats}
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql cpv_stats
  select 
    count(distinct "item.noticeNo") as total_licitatii,
    count(distinct "item.contractingAuthorityNameAndFN") as total_autoritati,
    count(distinct winners) as total_furnizori,
    sum(distinct "item.ronContractValue") as total_valoare
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where '${params.cpvCode}' = split_part("item.cpvCodeAndName", ' - ', 1) and "item.sysProcedureState.text" = 'Atribuita'
```

```sql licitatii_publice_cpv
  select *,
    case 
      when "item.noticeNo" like 'SCNA%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-rfq/', cast("item.caNoticeId" as integer))
      when "item.noticeNo" like 'CAN%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-c/', cast("item.caNoticeId" as integer))
      else concat('#/', cast("item.caNoticeId" as integer))
    end as link,

    "item.cpvCodeAndName" as cod_cpv,
    "item.noticeNo" as cod_licitatie,
    "item.sysProcedureState.text" as stare_licitatie,
    "item.ronContractValue" as valoare,
    "item.noticeStateDate" as data_publicare,
    "item.contractTitle" as nume_licitatie,

    "item.contractingAuthorityNameAndFN" as autoritate_contractanta,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.city", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.city", '-'),
      'Nedefinit'
    ) as oras_autoritate,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.county.text", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.nutsCodeItem.text", '-'),
      '-'
    ) as judet_autoritate,

    "noticeContracts.items.winners.name" as furnizor,
    "noticeContracts.items.winners.address.city" as oras_furnizor,
    "noticeContracts.items.winners.address.county.text" as judet_furnizor,
    "noticeContracts.items.winners.fiscalNumber" as cod_fiscal_furnizor,

  from licitatii_publice
  where '${params.cpvCode}' = split_part("item.cpvCodeAndName", ' - ', 1)
  order by "item.noticeStateDate" desc
```

<DataTable data={licitatii_publice_cpv} rowShading=true search=true rows=100 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod licitatie" contentType=link linkLabel="cod_licitatie" />
  <Column id="valoare" title="Valoare" fmt="num2m" contentType=colorscale />
  <Column id="stare_licitatie" title="Stare licitatie" />
  <Column id="data_publicare" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="nume_licitatie" title="Nume licitatie" contentType=html />
  <Column id="cod_fiscal_furnizor" title="Cod fiscal furnizor" />
  <Column id="furnizor" title="Furnizor" />
  <Column id="oras_furnizor" title="Oras furnizor" />
  <Column id="judet_furnizor" title="Judet furnizor" />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="oras_autoritate" title="Oras autoritate" />
  <Column id="judet_autoritate" title="Judet autoritate" />
</DataTable>
