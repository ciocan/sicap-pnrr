---
title: Licitatii publice PNRR
description: Statistici licitatii publice PNRR
---

```sql licitatii_publice_atribuite
  select count(*) as atribuite 
  from licitatii_publice 
  where "item.sysProcedureState.text" = 'Atribuita'
```

```sql licitatii_publice_anulate
  select count(*) as anulate 
  from licitatii_publice
  where "item.sysProcedureState.text" = 'Anulata'
```

```sql licitatii_publice_valoare
  select sum("item.ronContractValue") as valoare
  from licitatii_publice
  where "item.sysProcedureState.text" = 'Atribuita'
```

```sql licitatii_publice_total_autoritati
  select count(distinct "item.contractingAuthorityNameAndFN") as total_autoritati
  from licitatii_publice
```

```sql licitatii_publice_total_beneficiari
  select count(distinct winners) as total_beneficiari
  from licitatii_publice,
  unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
```

<BigValue 
  data={licitatii_publice_atribuite} 
  value=atribuite
  title="Licitatii atribuite"
  fmt="num"
/>

<BigValue 
  data={licitatii_publice_anulate} 
  value=anulate
  title="Licitatii anulate"
  fmt="num"
/>

<BigValue 
  data={licitatii_publice_valoare} 
  value=valoare
  title="Valoare totala"
  fmt="num2b"
/>

<BigValue 
  data={licitatii_publice_total_autoritati} 
  value=total_autoritati
  title="Total autoritati"
  fmt="num"
/>

<BigValue 
  data={licitatii_publice_total_beneficiari} 
  value=total_beneficiari
  title="Total beneficiari"
  fmt="num"
/>

```sql licitatii_publice_by_cpv
  select
    count(distinct "item.noticeNo") as nr,
    "item.cpvCodeAndName" as cod_cpv,
    sum(distinct "item.ronContractValue") as valoare,
    count(distinct "item.contractingAuthorityNameAndFN") as nr_autoritati,
    count(distinct winners) as nr_beneficiari
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where "item.sysProcedureState.text" = 'Atribuita'
  group by cod_cpv
  order by nr desc
```

## Valoare achizitii directe pe coduri CPV

<DataTable data={licitatii_publice_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="valoare" title="Valoare" fmt="num2b" />
  <Column id="cod_cpv" title="Cod CPV" />
  <Column id="nr_autoritati" title="Nr autoritati" />
  <Column id="nr_beneficiari" title="Nr beneficiari" />
</DataTable>
