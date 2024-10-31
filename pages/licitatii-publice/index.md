---
title: Licitatii publice PNRR
description: Statistici licitatii publice PNRR
queries:
  - licitatii_publice/total_atribuite.sql
  - licitatii_publice/total_anulate.sql
  - licitatii_publice/total_valoare.sql
  - licitatii_publice/total_autoritati.sql
  - licitatii_publice/total_beneficiari.sql
---

{@partial "licitatii-publice-totals.md"}


```sql licitatii_publice_by_cpv
  select
    count(distinct "item.noticeNo") as nr,
    concat('cpv-', split_part("item.cpvCodeAndName", ' - ', 1)) as url,
    split_part("item.cpvCodeAndName", ' - ', 1) as cod_cpv,
    split_part("item.cpvCodeAndName", ' - ', 2) as cod_cpv_text,
    sum(distinct "item.ronContractValue") as valoare,
    count(distinct "item.contractingAuthorityNameAndFN") as nr_autoritati,
    count(distinct winners) as nr_beneficiari
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where "item.sysProcedureState.text" = 'Atribuita'
  group by "item.cpvCodeAndName"
  order by nr desc
```

## Valoare achizitii directe pe coduri CPV

<DataTable data={licitatii_publice_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="valoare" title="Valoare" fmt="num2b" />
  <Column id="url" title="Cod CPV" contentType=link linkLabel=cod_cpv />
  <Column id="cod_cpv_text" title="Cod CPV" />
  <Column id="nr_autoritati" title="Total autoritati" />
  <Column id="nr_beneficiari" title="Total beneficiari" />
</DataTable>

<LineBreak/>

## Lista beneficiari

```sql licitatii_publice_beneficiari_valoare_mare
  select
    concat('beneficiar-', trim(winners)) as url,
    winners as cod_fiscal,
    count(distinct "item.noticeNo") as nr_licitatii,
    sum(distinct "item.ronContractValue") as valoare,
    count(distinct "item.contractingAuthorityNameAndFN") as nr_autoritati,
    "noticeContracts.items.winners.name" as beneficiar
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where "item.sysProcedureState.text" = 'Atribuita'
  group by all
  order by valoare desc
```

<DataTable data={licitatii_publice_beneficiari_valoare_mare} rowShading=true search=true>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="beneficiar" title="Beneficiar" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_licitatii" title="Total licitatii" />
  <Column id="nr_autoritati" title="Total autoritati" />
</DataTable>

## Lista autoritati contractante

```sql licitatii_publice_autoritati_valoare_mare
  select
    concat('autoritate-', "item.nationalId") as url,
    "item.nationalId" as cod_fiscal,
    substring("item.contractingAuthorityNameAndFN", position('-' in "item.contractingAuthorityNameAndFN") + 1) as autoritate_contractanta,
    sum(distinct "item.ronContractValue") as valoare,
    count(distinct "item.noticeNo") as nr_licitatii,
    count(distinct winners) as nr_beneficiari
  from licitatii_publice,
    unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
  where "item.sysProcedureState.text" = 'Atribuita'
  group by all
  order by valoare desc
```

<DataTable data={licitatii_publice_autoritati_valoare_mare} rowShading=true search=true>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_licitatii" title="Total licitatii" />
  <Column id="nr_beneficiari" title="Total beneficiari" />
</DataTable>

## Licitatii pe orase (autoritate contractanta)

```sql licitatii_publice_by_city_autoritate
  select
    count(*) as total_licitatii,
    coalesce(
      nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.city", '-'),
      nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.city", '-')
    ) as oras,
    sum("item.ronContractValue") as valoare
  from licitatii_publice
  where "item.sysProcedureState.text" = 'Atribuita'
  group by oras
  order by total_licitatii desc
```

<DataTable data={licitatii_publice_by_city_autoritate} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_licitatii" title="Total licitatii" />
</DataTable>

## Licitatii pe orase (beneficiar)

```sql licitatii_publice_by_city_beneficiar
  select
    count(distinct "item.noticeNo") as total_licitatii,
    trim(t.oras) as oras,
    sum(distinct "item.ronContractValue") as valoare
  from licitatii_publice,
    unnest(
      string_split(
        coalesce(
          nullif("noticeContracts.items.winner.address.city", '-'),
          nullif("noticeContracts.items.winners.address.city", '-')
        ),
        ','
      )
    ) as t(oras)
  where "item.sysProcedureState.text" = 'Atribuita'
  group by trim(t.oras)
  order by total_licitatii desc
```

<DataTable data={licitatii_publice_by_city_beneficiar} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_licitatii" title="Total licitatii" />
</DataTable>