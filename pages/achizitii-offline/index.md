---
title: Achizitii offline PNRR
description: statistici achizitii offline pnrr
---

```sql achizitii_offline_total
  select count(*) as total 
  from achizitii_offline 
```

```sql achizitii_offline_total_valoare
  select sum("item.awardedValue") as total 
  from achizitii_offline 
```

```sql achizitii_offline_total_beneficiari
  select count(distinct "details.noticeEntityAddress.fiscalNumber") as total 
  from achizitii_offline 
```

```sql achizitii_offline_total_autoritati
  select count(distinct "authority.entityId") as total 
  from achizitii_offline 
```

<BigValue data={achizitii_offline_total} value=total title="Total achizitii offline" />

<BigValue data={achizitii_offline_total_valoare} value=total title="Valoare totala" fmt="num2m" />

<BigValue data={achizitii_offline_total_beneficiari} value=total title="Total beneficiari" />

<BigValue data={achizitii_offline_total_autoritati} value=total title="Total autoritati" />

```sql achizitii_offline_by_cpv
  select
    count(*) as nr, 
    "item.cpvCode" as CPV,
    sum("item.awardedValue") as valoare
  from achizitii_offline 
  group by "item.cpvCode"
  order by nr desc
```

<DataTable data={achizitii_offline_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="CPV" title="CPV" />
</DataTable>

<LineBreak/>

## Lista beneficiari

```sql achizitii_offline_beneficiari_valoare_mare
  select
    concat('beneficiar-', cast("details.noticeEntityAddress.fiscalNumber" as string)) as url,
    "details.noticeEntityAddress.fiscalNumber" as cod_fiscal,
    "details.noticeEntityAddress.organization" as beneficiar,
    sum("item.awardedValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "authority.entityId") as nr_autoritati,
    "details.noticeEntityAddress.city" as localitate,
  from achizitii_offline 
  group by all
  order by valoare desc
```

<DataTable data={achizitii_offline_beneficiari_valoare_mare} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="beneficiar" title="Beneficiar" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Ach." />
  <Column id="nr_autoritati" title="Aut." />
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
    count(distinct "details.noticeEntityAddress.fiscalNumber") as nr_beneficiari
  from achizitii_offline 
  group by all
  order by valoare desc
```

<DataTable data={achizitii_offline_autoritati_valoare_mare} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Ach." />
  <Column id="nr_beneficiari" title="Benef." />
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

<DataTable data={achizitii_offline_by_city_autoritate} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>

## Achizitii directe pe orase (beneficiar)

```sql achizitii_offline_by_city_beneficiar
  select
    count(*) as total_achizitii, 
    "details.noticeEntityAddress.city" as oras,
    sum("item.awardedValue") as valoare
  from achizitii_offline 
  group by oras
  order by total_achizitii desc
```

<DataTable data={achizitii_offline_by_city_beneficiar} rowShading=true search=true>
  <Column id="oras" title="Oras" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>