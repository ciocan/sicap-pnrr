---
title: Beneficiar
description: Statistici licitatii publice beneficiar PNRR
---

# <Value data={licitatii_publice_beneficiar} row=0 column="beneficiar" />
### cod fiscal: <Value data={licitatii_publice_beneficiar} row=0 column="noticeContracts.items.winners.fiscalNumber" />
## <Value data={licitatii_publice_beneficiar} row=0 column="oras" />, <Value data={licitatii_publice_beneficiar} row=0 column="judet" />

<BigValue 
  data={beneficiar_stats} 
  value=total_licitatii
  title="Licitatii"
/>

<BigValue 
  data={beneficiar_stats} 
  value=total_autoritati
  title="Autoritati"
/>

<BigValue 
  data={beneficiar_stats} 
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql beneficiar_stats
  select 
    count(distinct "item.noticeNo") as total_licitatii,
    count(distinct "item.contractingAuthorityNameAndFN") as total_autoritati,
    sum(distinct "item.ronContractValue") as total_valoare
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where winners = '${params.fiscalNumber}' and "item.sysProcedureState.text" = 'Atribuita'
```

```sql licitatii_publice_beneficiar
  select *,
    case 
      when "item.noticeNo" like 'SCNA%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-rfq/', cast("item.caNoticeId" as integer))
      when "item.noticeNo" like 'CAN%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-c/', cast("item.caNoticeId" as integer))
      else concat('#/', cast("item.caNoticeId" as integer))
    end as link,
    "noticeContracts.items.winners.name" as beneficiar,
    "noticeContracts.items.winners.address.city" as oras,
    "noticeContracts.items.winners.address.county.text" as judet,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.city", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.city", '-')
    ) as oras_autoritate,
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where winners = '${params.fiscalNumber}' and "item.sysProcedureState.text" = 'Atribuita'
  order by "item.noticeStateDate" desc
```

<DataTable data={licitatii_publice_beneficiar} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod licitatie" contentType=link linkLabel="item.noticeNo" />
  <Column id="item.ronContractValue" title="Valoare" fmt="num2m" contentType=colorscale />
  <Column id="item.sysProcedureState.text" title="Stare licitatie" />
  <Column id="item.noticeStateDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="item.contractTitle" title="Nume licitatie" />
  <Column id="item.contractingAuthorityNameAndFN" title="Autoritate contractanta" />
  <Column id="oras_autoritate" title="Oras autoritate" />
  <Column id="item.cpvCodeAndName" title="Cod CPV" />
</DataTable>