---
title: Beneficiar
description: statistici achizitii directe pnrr beneficiar
---

# <Value data={achizitii_directe_beneficiar} row=0 column="supplier.entityName" />
### cod fiscal: <Value data={achizitii_directe_beneficiar} row=0 column="supplier.fiscalNumber" />
## <Value data={achizitii_directe_beneficiar} row=0 column="supplier.city" />, <Value data={achizitii_directe_beneficiar} row=0 column="supplier.county" />

<BigValue 
  data={beneficiar_stats} 
  value=total_achizitii
  title="Achizitii"
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
    count(distinct "authority.entityId") as total_autoritati,
    count(*) as total_achizitii,
    sum("item.closingValue") as total_valoare
  from pnrr.achizitii_directe
  where "supplier.entityId" = '${params.entityId}' and "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
```

```sql achizitii_directe_beneficiar
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/view/', cast("item.directAcquisitionId" as integer)) as link
  from pnrr.achizitii_directe 
  where "supplier.entityId" = '${params.entityId}'
  order by "item.publicationDate" desc
```

<DataTable data={achizitii_directe_beneficiar} rowShading=true search=true rows=50>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.uniqueIdentificationCode" />
  <Column id="item.closingValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="item.directAcquisitionName" title="Nume achizitie" />
  <Column id="item.sysDirectAcquisitionState.text" title="Stare achizitie" />
  <Column id="authority.fiscalNumber" title="Cod fiscal" />
  <Column id="authority.entityName" title="Autoritate contractanta" />
  <Column id="item.cpvCode" title="Cod CPV" />
</DataTable>
