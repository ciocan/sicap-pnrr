---
title: Autoritate contractanta
description: statistici licitatii publice pnrr
---

# <Value data={licitatii_publice_autoritate} row=0 column=autoritate_contractanta />
## <Value data={licitatii_publice_autoritate} row=0 column=oras />, <Value data={licitatii_publice_autoritate} row=0 column=judet />

<BigValue
  data={licitatii_publice_autoritate_stats}
  value=total_licitatii
  title="Licitatii"
/>

<BigValue
  data={licitatii_publice_autoritate_stats}
  value=total_furnizori
  title="Furnizori"
/>

<BigValue
  data={licitatii_publice_autoritate_stats}
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql licitatii_publice_autoritate_stats
  select 
    count(distinct "item.noticeNo") as total_licitatii,
    count(distinct winners) as total_furnizori,
    sum(distinct"item.ronContractValue") as total_valoare
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where 
    "item.nationalId" = '${params.nationalId}'
    and "item.sysProcedureState.text" = 'Atribuita'
```

```sql licitatii_publice_autoritate
  select
    "item.contractingAuthorityNameAndFN" as autoritate_contractanta,
    "item.ronContractValue" as valoare,
    "item.noticeStateDate" as data_publicare,
    "item.contractTitle" as nume_licitatie,
    "item.noticeNo" as cod_licitatie,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.city", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.city", '-'),
      'Nedefinit'
    ) as oras,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.county.text", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.nutsCodeItem.text", '-'),
      '-'
    ) as judet,
    case 
      when "item.noticeNo" like 'SCNA%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-rfq/', cast("item.caNoticeId" as integer))
      when "item.noticeNo" like 'CAN%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-c/', cast("item.caNoticeId" as integer))
      else concat('#/', cast("item.caNoticeId" as integer))
    end as link,
    "item.sysProcedureState.text" as stare_licitatie,
    "noticeContracts.items.winners.name" as furnizor,
    "noticeContracts.items.winners.fiscalNumber" as cod_fiscal,
    "item.cpvCodeAndName" as cod_cpv
  from licitatii_publice
  where "item.nationalId" = '${params.nationalId}'
  order by "item.noticeStateDate" desc
```

<DataTable data={licitatii_publice_autoritate} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod licitatie" contentType=link linkLabel="cod_licitatie" />
  <Column id="valoare" title="Valoare" fmt="num2m" contentType=colorscale />
  <Column id="stare_licitatie" title="Stare licitatie" />
  <Column id="data_publicare" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="nume_licitatie" title="Nume licitatie" />
  <Column id="cod_fiscal" title="Cod fiscal" />
  <Column id="furnizor" title="Furnizor" />
  <Column id="cod_cpv" title="Cod CPV" />
</DataTable>
