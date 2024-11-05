---
title: Cod CPV achizitii offline
description: Statistici achizitii offline cod CPV
hide_title: true
---

# <Value data={achizitii_offline_cpv} row=0 column="item.cpvCode" />

<BigValue 
  data={achizitie_offline_stats} 
  value=total_achizitii
  title="Achizitii"
/>

<BigValue 
  data={achizitie_offline_stats} 
  value=total_autoritati
  title="Autoritati"
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
    count(*) as total_achizitii,
    count(distinct "details.noticeEntityAddress.fiscalNumber") as total_furnizori,
    count(distinct "authority.entityId") as total_autoritati,
    sum("item.awardedValue") as total_valoare
  from achizitii_offline 
  where '${params.cpvCode}' = split_part("item.cpvCode", ' - ', 1)
```

```sql achizitii_offline_cpv
  select *,
    concat('https://e-licitatie.ro/pub/direct-acquisition/award-notice/view/', cast("item.daAwardNoticeId" as integer)) as link
  from achizitii_offline 
  where '${params.cpvCode}' = split_part("item.cpvCode", ' - ', 1)
```

<DataTable data={achizitii_offline_cpv} rowShading=true search=true rows=50 wrapTitles=true>
  <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.noticeNo" />
  <Column id="item.awardedValue" title="Valoare" fmt="num2k" contentType=colorscale />
  <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
  <Column id="details.finalizationDate" title="Data finalizare" fmt="dd-mm-yyyy" />
  <Column id="item.contractObject" title="Nume achizitie" />
  <Column id="details.noticeEntityAddress.fiscalNumber" title="Cod fiscal furnizor" />
  <Column id="details.noticeEntityAddress.organization" title="Furnizor" />
  <Column id="details.noticeEntityAddress.city" title="Oras furnizor" />
  <Column id="authority.fiscalNumber" title="Cod fiscal autoritate" />
  <Column id="authority.entityName" title="Autoritate" />
  <Column id="authority.city" title="Oras autoritate" />
  <Column id="authority.county" title="Judet autoritate" />  
</DataTable>
