---
title: Achizitii directe PNRR
description: Statistici achizitii directe PNRR
queries:
  - achizitii_directe/total_atribuite.sql
  - achizitii_directe/total_anulate.sql
  - achizitii_directe/total_valoare.sql
  - achizitii_directe/total_furnizori.sql
  - achizitii_directe/total_autoritati.sql
---

{@partial "achizitii-directe-totals.md"}

```sql achizitii_directe_by_cpv
  select
    count(distinct "item.uniqueIdentificationCode") as nr,
    split_part("item.cpvCode", ' - ', 2) as cod_cpv_text,
    split_part("item.cpvCode", ' - ', 1) as cod_cpv,
    concat('cpv-', split_part("item.cpvCode", ' - ', 1)) as url,
    sum("item.closingValue") as valoare,
    count(distinct "authority.entityId") as nr_autoritati,
    count(distinct "supplier.entityId") as nr_furnizori
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by "item.cpvCode"
  order by nr desc
```

## Valoare achizitii directe pe coduri CPV

<DataTable data={achizitii_directe_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="url" title="CPV" contentType=link linkLabel=cod_cpv />
  <Column id="cod_cpv_text" title="Cod CPV" />
  <Column id="nr_autoritati" title="Total autoritati" />
  <Column id="nr_furnizori" title="Total furnizori" />
</DataTable>

<LineBreak/>

## Lista furnizori

```sql achizitii_directe_furnizori_valoare_mare
  select
    concat('furnizor-', cast("supplier.entityId" as integer)) as url,
    "supplier.fiscalNumber" as cod_fiscal,
    "supplier.entityName" as furnizor,
    sum("item.closingValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "authority.entityId") as nr_autoritati
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by all
  order by sum("item.closingValue") desc
```

<DataTable data={achizitii_directe_furnizori_valoare_mare} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="furnizor" title="Furnizor" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Total achizitii" />
  <Column id="nr_autoritati" title="Total autoritati" />
</DataTable>

## Lista autoritati contractante

```sql lista_autoritati
  select
    concat('autoritate-', cast("authority.entityId" as integer)) as url,
    "authority.fiscalNumber" as cod_fiscal,
    "authority.entityName" as autoritate_contractanta,
    sum("item.closingValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "supplier.entityId") as nr_furnizori
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by all
  order by sum("item.closingValue") desc
```

<DataTable data={lista_autoritati} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Total achizitii" />
  <Column id="nr_furnizori" title="Total furnizori" />
</DataTable>

## Achizitii directe pe orase (autoritate)

```sql achizitii_directe_by_city_autoritate
  select
    count(*) as total_achizitii, 
    "authority.city" as oras,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by oras
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_city_autoritate} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>

## Achizitii directe pe orase (furnizor)

```sql achizitii_directe_by_city_furnizor
  select
    count(*) as total_achizitii, 
    "supplier.city" as oras,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by oras
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_city_furnizor} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>