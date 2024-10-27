---
title: Achizitii directe
description: statistici achizitii directe 
---

```sql achizitii_directe_total
  select count(*) as total from achizitii_directe
```

```sql achizitii_directe_total_valoare
  select sum("item.closingValue") as total from pnrr.achizitii_directe
```

```sql achizitii_directe_total_beneficiari
  select count(distinct "supplier.entityId") as total from pnrr.achizitii_directe
```

```sql achizitii_directe_total_autoritati
  select count(distinct "authority.entityId") as total from pnrr.achizitii_directe
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
  group by "item.cpvCode"
  order by nr desc
```

## Valoare achizitii directe pe coduri CPV

<DataTable data={achizitii_directe_by_cpv} rowShading=true search=true>
  <Column id="nr" header="Nr" />
  <Column id="CPV" header="CPV" />
  <Column id="valoare" header="Valoare" fmt="num2m" />
</DataTable>

## Achizitii directe pe judete (autoritate)

```sql achizitii_directe_by_judete
  select
    count(*) as total_achizitii, 
    "authority.county" as judet,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  group by "authority.county"
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_judete} rowShading=true search=true>
  <Column id="judet" header="Judet" />
  <Column id="valoare" header="Valoare" fmt="num2m" />
  <Column id="total_achizitii" header="Total achizitii" />
</DataTable>

## Achizitii directe pe judete (beneficiar)

```sql achizitii_directe_by_beneficiar
  select
    count(*) as total_achizitii, 
    "supplier.county" as judet,
    sum("item.closingValue") as valoare
  from pnrr.achizitii_directe
  group by "supplier.county"
  order by total_achizitii desc
```

<DataTable data={achizitii_directe_by_beneficiar} rowShading=true search=true>
  <Column id="judet" header="Judet" />
  <Column id="valoare" header="Valoare" fmt="num2m" />
  <Column id="total_achizitii" header="Total achizitii" />
</DataTable>

## Lista beneficiari cu valoare totala mai mare de 100.000 de lei

```sql achizitii_directe_beneficiari_valoare_mare
  select
    "supplier.fiscalNumber",
    "supplier.entityId",
    "supplier.entityName",
    sum("item.closingValue") as valoare,
    count(*) as total_achizitii,
    count(distinct "authority.entityId") as total_autoritati
  from pnrr.achizitii_directe
  where "item.closingValue" > 100000
  group by "supplier.entityId", "supplier.entityName", "supplier.fiscalNumber"
  order by sum("item.closingValue") desc
```

<DataTable data={achizitii_directe_beneficiari_valoare_mare} rowShading=true search=true>
  <Column id="supplier.fiscalNumber" header="Cod fiscal" />
  <Column id="supplier.entityName" header="Beneficiar" />
  <Column id="total_achizitii" header="Nr achizitii" />
  <Column id="total_autoritati" header="Nr autoritati" />
  <Column id="valoare" header="Valoare" fmt="num2m" />
</DataTable>
