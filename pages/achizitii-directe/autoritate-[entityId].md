---
title: Autoritate contractanta
description: statistici achizitii directe pnrr
---

# <Value data={achizitii_directe_autoritate} row=0 column="authority.entityName" />
## <Value data={achizitii_directe_autoritate} row=0 column="authority.city" />, <Value data={achizitii_directe_autoritate} row=0 column="authority.county" />

<BigValue 
  data={achizitie_stats} 
  value=total_achizitii
  title="Achizitii"
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
    count(distinct "supplier.entityId") as total_beneficiari,
    count(*) as total_achizitii,
    sum("item.closingValue") as total_valoare
  from pnrr.achizitii_directe
  where "authority.entityId" = '${params.entityId}' and "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_autoritate
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/view/', cast("item.directAcquisitionId" as integer)) as link
  from pnrr.achizitii_directe 
  where "authority.entityId" = '${params.entityId}'
  order by "item.publicationDate" desc
```

<DataTable data={achizitii_directe_autoritate} rowShading=true search=true rows=50>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.uniqueIdentificationCode" />
  <Column id="item.closingValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="item.directAcquisitionName" title="Nume achizitie" />
  <Column id="item.sysDirectAcquisitionState.text" title="Stare achizitie" />
  <Column id="supplier.fiscalNumber" title="Cod fiscal" />
  <Column id="supplier.entityName" title="Beneficiar" />
  <Column id="item.cpvCode" title="Cod CPV" />
</DataTable>
