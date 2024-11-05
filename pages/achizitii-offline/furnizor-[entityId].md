---
title: Furnizor
description: statistici achizitii offline furnizor pnrr
---

# <Value data={achizitii_offline_furnizor} row=0 column="details.noticeEntityAddress.organization" />
### cod fiscal: <Value data={achizitii_offline_furnizor} row=0 column="details.noticeEntityAddress.fiscalNumber" />, <Value data={achizitii_offline_furnizor} row=0 column="details.noticeEntityAddress.city" />

<BigValue 
  data={furnizor_stats} 
  value=total_achizitii
  title="Achizitii"
/>

<BigValue 
  data={furnizor_stats} 
  value=total_autoritati
  title="Autoritati"
/>

<BigValue 
  data={furnizor_stats} 
  value=total_valoare
  title="Valoare"
  fmt="num2m"
  color=green
/>

```sql furnizor_stats
  select
    count(distinct "authority.entityId") as total_autoritati,
    count(*) as total_achizitii,
    sum("item.awardedValue") as total_valoare
  from achizitii_offline 
  where "details.noticeEntityAddress.fiscalNumber" = '${params.entityId}'
```

```sql achizitii_offline_furnizor
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/award-notice/view/', cast("item.daAwardNoticeId" as integer)) as link
  from achizitii_offline 
  where "details.noticeEntityAddress.fiscalNumber" = '${params.entityId}'
  order by "item.publicationDate" desc
```

<DataTable data={achizitii_offline_furnizor} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.noticeNo" />
  <Column id="item.awardedValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="details.finalizationDate" title="Data finalizare" fmt="dd-mm-yyyy" />
  <Column id="item.contractObject" title="Nume achizitie" />
  <Column id="authority.fiscalNumber" title="Cod fiscal" />
  <Column id="authority.entityName" title="Autoritate" />
  <Column id="authority.city" title="Oras" />
  <Column id="authority.county" title="Judet" />
  <Column id="item.cpvCode" title="Cod CPV" />
</DataTable>