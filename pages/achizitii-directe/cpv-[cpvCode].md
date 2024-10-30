---
title: Cod CPV achizitii directe
description: Statistici achizitii directe cod CPV
hide_title: true
---

# <Value data={achizitii_directe_cpv} row=0 column="cod_cpv" />

<BigValue 
  data={achizitie_stats} 
  value=total_achizitii
  title="Achizitii"
/>

<BigValue 
  data={achizitie_stats} 
  value=total_autoritati
  title="Autoritati"
/>

<BigValue 
  data={achizitie_stats} 
  value=total_beneficiari
  title="Beneficiari"
/>

<BigValue 
  data={achizitie_stats} 
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql achizitie_stats
  select 
    count(distinct "item.uniqueIdentificationCode") as total_achizitii,
    count(distinct "supplier.entityId") as total_beneficiari,
    count(distinct "authority.entityId") as total_autoritati,
    sum("item.closingValue") as total_valoare
  from pnrr.achizitii_directe
  where '${params.cpvCode}' = split_part("item.cpvCode", ' - ', 1) and "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_cpv
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/view/', cast("item.directAcquisitionId" as integer)) as link,
    "item.cpvCode" as cod_cpv
  from pnrr.achizitii_directe 
  where '${params.cpvCode}' = split_part("item.cpvCode", ' - ', 1)
  order by "item.publicationDate" desc
```

<DataTable data={achizitii_directe_cpv} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.uniqueIdentificationCode" />
  <Column id="item.closingValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.sysDirectAcquisitionState.text" title="Stare achizitie" />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="item.directAcquisitionName" title="Nume achizitie" />
  <Column id="supplier.fiscalNumber" title="Cod fiscal beneficiar" />
  <Column id="supplier.entityName" title="Beneficiar" />
  <Column id="supplier.city" title="Oras beneficiar" />
  <Column id="supplier.county" title="Judet beneficiar" />
  <Column id="authority.fiscalNumber" title="Cod fiscal autoritate" />
  <Column id="authority.entityName" title="Autoritate contractanta" />
  <Column id="authority.city" title="Oras autoritate" />
  <Column id="authority.county" title="Judet autoritate" />
</DataTable>
