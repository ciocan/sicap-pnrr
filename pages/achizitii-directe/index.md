---
title: Achizitii directe PNRR
description: Statistici achizitii directe PNRR
---

```sql achizitii_directe_total
  select count(*) as total 
  from achizitii_directe 
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_total_valoare
  select sum("item.closingValue") as total 
  from pnrr.achizitii_directe 
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_total_beneficiari
  select count(distinct "supplier.entityId") as total 
  from pnrr.achizitii_directe 
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_total_autoritati
  select count(distinct "authority.entityId") as total 
  from pnrr.achizitii_directe 
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

<BigValue 
  data={achizitii_directe_total} 
  value=total
  title="Total achizitii directe"
  fmt="num"
/>

<BigValue 
  data={achizitii_directe_total_valoare} 
  value=total
  title="Valoare totala"
  fmt="num2b"
/>

<BigValue 
  data={achizitii_directe_total_beneficiari} 
  value=total
  title="Total beneficiari"
  fmt="num"
/>

<BigValue 
  data={achizitii_directe_total_autoritati} 
  value=total
  title="Total autoritati"
  fmt="num"
/>

```sql achizitii_directe_by_cpv
  select
    count(*) as nr, 
    "item.cpvCode" as CPV,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by "item.cpvCode"
  order by nr desc
```

## Valoare achizitii directe pe coduri CPV

<DataTable data={achizitii_directe_by_cpv} rowShading=true search=true>
  <Column id="nr" title="Nr" />
  <Column id="CPV" title="CPV" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
</DataTable>

<LineBreak/>

## Lista beneficiari

```sql achizitii_directe_beneficiari_valoare_mare
  select
    concat('beneficiar-', cast("supplier.entityId" as integer)) as url,
    "supplier.fiscalNumber" as cod_fiscal,
    "supplier.entityName" as beneficiar,
    sum("item.closingValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "authority.entityId") as nr_autoritati
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by all
  order by sum("item.closingValue") desc
```

<DataTable data={achizitii_directe_beneficiari_valoare_mare} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="beneficiar" title="Beneficiar" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Nr achizitii" />
  <Column id="nr_autoritati" title="Nr autoritati" />
</DataTable>

## Lista autoritati contractante

```sql lista_autoritati
  select
    concat('autoritate-', cast("authority.entityId" as integer)) as url,
    "authority.fiscalNumber" as cod_fiscal,
    "authority.entityName" as autoritate_contractanta,
    sum("item.closingValue") as valoare,
    count(*) as nr_achizitii,
    count(distinct "supplier.entityId") as nr_beneficiari
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by all
  order by sum("item.closingValue") desc
```

<DataTable data={lista_autoritati} rowShading=true search=true rows=20>
  <Column id="url" title="Cod fiscal" contentType=link linkLabel=cod_fiscal />
  <Column id="autoritate_contractanta" title="Autoritate contractanta" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="nr_achizitii" title="Nr achizitii" />
  <Column id="nr_beneficiari" title="Nr beneficiari" />
</DataTable>

## Achizitii directe pe judete (autoritate)

```sql achizitii_directe_by_judete
  select
    count(*) as total_achizitii, 
    "authority.county" as judet,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by "authority.county"
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_judete} rowShading=true search=true>
  <Column id="judet" title="Judet" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>

## Achizitii directe pe judete (beneficiar)

```sql achizitii_directe_by_beneficiar
  select
    count(*) as total_achizitii, 
    "supplier.county" as judet,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by "supplier.county"
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_beneficiar} rowShading=true search=true>
  <Column id="judet" title="Judet" />
  <Column id="valoare" title="Valoare" fmt="num2m" />
  <Column id="total_achizitii" title="Total achizitii" />
</DataTable>