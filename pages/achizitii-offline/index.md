---
title: Achizitii offline PNRR
description: Statistici achizitii offline PNRR
queries:
  - achizitii_offline/total.sql
  - achizitii_offline/total_valoare.sql 
  - achizitii_offline/total_furnizori.sql
  - achizitii_offline/total_autoritati.sql
---

{@partial "achizitii-offline-totals.md"}

```sql achizitii_offline_by_cpv
  select
    count(*) as nr, 
    "item.cpvCode" as CPV,
    concat('cpv-', split_part("item.cpvCode", ' - ', 1)) as url,
    split_part("item.cpvCode", ' - ', 1) as cod_cpv,
    split_part("item.cpvCode", ' - ', 2) as cod_cpv_text,
    sum("item.awardedValue") as valoare,
    count(distinct "authority.entityId") as nr_autoritati,
    count(distinct "details.noticeEntityAddress.fiscalNumber") as nr_furnizori
  from achizitii_offline 
  group by "item.cpvCode"
  order by nr desc
```

<DataTable data={achizitii_offline_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="url" title="CPV" contentType=link linkLabel=cod_cpv />
  <Column id="cod_cpv_text" title="Cod CPV" />
  <Column id="nr_autoritati" title="Total autoritati" />
  <Column id="nr_furnizori" title="Total furnizori" />
</DataTable>

<LineBreak/>

## Lista furnizori

```sql achizitii_offline_furnizori_valoare_mare
  select
    concat('furnizor-', cast("details.noticeEntityAddress.fiscalNumber" as string)) as url,
    "details.noticeEntityAddress.fiscalNumber" as cod_fiscal,
    "details.noticeEntityAddress.organization" as furnizor,
    sum("item.awardedValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "authority.entityId") as nr_autoritati,
    "details.noticeEntityAddress.city" as localitate,
  from achizitii_offline 
  group by all
  order by valoare desc
```

<DataTable data={achizitii_offline_furnizori_valoare_mare} rowShading=true search=true rows=20 wrapTitles=true>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="furnizor" title="Furnizor" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Total achizitii" />
  <Column id="nr_autoritati" title="Total autoritati" />
  <Column id="localitate" title="Localitate" />
</DataTable>

## Lista autoritati contractante

```sql achizitii_offline_autoritati_valoare_mare
  select
    concat('autoritate-', cast("authority.entityId" as integer)) as url,
    "authority.fiscalNumber" as cod_fiscal,
    "authority.entityName" as autoritate_contractanta,
    sum("item.awardedValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "details.noticeEntityAddress.fiscalNumber") as nr_furnizori
  from achizitii_offline 
  group by all
  order by valoare desc
```

<DataTable data={achizitii_offline_autoritati_valoare_mare} rowShading=true search=true rows=20 wrapTitles=true>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Total achizitii" />
  <Column id="nr_furnizori" title="Total furnizori" />
</DataTable>

## Achizitii directe pe orase (autoritate)

```sql achizitii_offline_by_city_autoritate
  select
    count(*) as total_achizitii, 
    "authority.city" as oras,
    sum("item.awardedValue") as valoare
  from achizitii_offline 
  group by oras
  order by total_achizitii desc
```

<DataTable data={achizitii_offline_by_city_autoritate} rowShading=true search=true wrapTitles=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>

## Achizitii directe pe orase (furnizor)

```sql achizitii_offline_by_city_furnizor
  select
    count(*) as total_achizitii, 
    "details.noticeEntityAddress.city" as oras,
    sum("item.awardedValue") as valoare
  from achizitii_offline 
  group by oras
  order by total_achizitii desc
```

<DataTable data={achizitii_offline_by_city_furnizor} rowShading=true search=true wrapTitles=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>