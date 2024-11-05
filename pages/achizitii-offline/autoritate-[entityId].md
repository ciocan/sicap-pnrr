---
title: Autoritate contractanta
description: statistici achizitii offline pnrr
---

# <Value data={achizitii_offline_autoritate} row=0 column="authority.entityName" />
## <Value data={achizitii_offline_autoritate} row=0 column="authority.city" />, <Value data={achizitii_offline_autoritate} row=0 column="authority.county" />

<BigValue 
  data={achizitie_offline_stats} 
  value=total_achizitii
  title="Achizitii"
/>

<BigValue 
  data={achizitie_offline_stats} 
  value=total_furnizori
  title="Furnizori"
/>

<BigValue 
  data={achizitie_offline_stats} 
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql achizitie_offline_stats
  select 
    count(distinct "details.noticeEntityAddress.fiscalNumber") as total_furnizori,
    count(*) as total_achizitii,
    sum("item.awardedValue") as total_valoare
  from achizitii_offline 
  where "authority.entityId" = '${params.entityId}'
```

```sql achizitii_offline_autoritate
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/award-notice/view/', cast("item.daAwardNoticeId" as integer)) as link
  from achizitii_offline 
  where "authority.entityId" = '${params.entityId}'
```

<DataTable data={achizitii_offline_autoritate} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.noticeNo" />
  <Column id="item.awardedValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="details.finalizationDate" title="Data finalizare" fmt="dd-mm-yyyy" />
  <Column id="item.contractObject" title="Nume achizitie" />
  <Column id="details.noticeEntityAddress.fiscalNumber" title="Cod fiscal" />
  <Column id="details.noticeEntityAddress.organization" title="Furnizor" />
  <Column id="details.noticeEntityAddress.city" title="Oras" />
  <Column id="item.cpvCode" title="Cod CPV" />
</DataTable>