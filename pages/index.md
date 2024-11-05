---
title: Achizitii PNRR
description: Statistici achizitii PNRR
queries:
  - achizitii_directe/total_atribuite.sql
  - achizitii_directe/total_anulate.sql
  - achizitii_directe/total_valoare.sql
  - achizitii_directe/total_furnizori.sql
  - achizitii_directe/total_autoritati.sql

  - achizitii_offline/total.sql
  - achizitii_offline/total_valoare.sql
  - achizitii_offline/total_furnizori.sql
  - achizitii_offline/total_autoritati.sql

  - licitatii_publice/total_atribuite.sql
  - licitatii_publice/total_anulate.sql
  - licitatii_publice/total_valoare.sql
  - licitatii_publice/total_autoritati.sql
  - licitatii_publice/total_furnizori.sql
---

```sql total_atribuite
  select sum(total) as total from (
    select count(*) as total from licitatii_publice where "item.sysProcedureState.text" = 'Atribuita'
    union all
    select count(*) as total from achizitii_directe where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
    union all
    select count(*) as total from achizitii_offline where "details.sysNoticeState.text" = 'Publicat'
  ) t
```

```sql total_anulate
  select sum(total) as total from (
    select count(*) as total from licitatii_publice where "item.sysProcedureState.text" = 'Anulata'
    union all
    select count(*) as total from achizitii_directe where "item.sysDirectAcquisitionState.text" != 'Oferta acceptata'
    union all
    select count(*) as total from achizitii_offline where "details.sysNoticeState.text" != 'Publicat'
  ) t
```

```sql valoare_totala
  select sum(valoare_totala) as total from (
    select sum("item.ronContractValue") as valoare_totala from licitatii_publice where "item.sysProcedureState.text" = 'Atribuita'
    union all
    select sum("item.closingValue") as valoare_totala from achizitii_directe where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
    union all
    select sum("item.awardedValue") as valoare_totala from achizitii_offline
  ) t
```

<BigValue 
  data={total_atribuite} 
  value=total
  title="Total atribuite"
  fmt="num"
/>

<BigValue 
  data={total_anulate} 
  value=total
  title="Total anulate"
  fmt="num"
/>

<BigValue 
  data={valoare_totala} 
  value=total
  title="Valoare totala"
  fmt="num2b"
/>

## [Achizitii directe](/achizitii-directe)

{@partial "achizitii-directe-totals.md"}

```sql total_achizitii_directe_lunar
  select
    count(*) as numar_achizitii,
    sum("item.closingValue") as valoare_totala,
    date_trunc('month', "item.publicationDate") as luna
  from achizitii_directe
  where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'
  group by luna
  order by luna
```

<LineChart 
  data={total_achizitii_directe_lunar}
  x=luna
  y=valoare_totala
  yFmt="num2m"
  y2=numar_achizitii
  yAxisTitle="Valoare"
/>

## [Achizitii offline](/achizitii-offline)

{@partial "achizitii-offline-totals.md"}

```sql total_achizitii_offline_lunar
  select
    count(*) as numar_achizitii,
    sum("item.awardedValue") as valoare_totala,
    date_trunc('month', "item.publicationDate") as luna
  from achizitii_offline
  group by luna
  order by luna
```

<LineChart 
  data={total_achizitii_offline_lunar}
  x=luna
  y=valoare_totala
  y2=numar_achizitii
  yAxisTitle="Valoare"
/>

## [Licitatii publice](/licitatii-publice)

{@partial "licitatii-publice-totals.md"}

```sql total_licitatii_publice_lunar
  select
    count(*) as numar_licitatii,
    sum("item.ronContractValue") as valoare_totala,
    date_trunc('month', "item.noticeStateDate") as luna
  from licitatii_publice
  where "item.sysProcedureState.text" = 'Atribuita'
  group by luna
  order by luna
```

<LineChart 
  data={total_licitatii_publice_lunar}
  x=luna
  y=valoare_totala
  yFmt="num2b"
  y2=numar_licitatii
  yAxisTitle="Valoare"
/>

<LastRefreshed prefix="Data last updated"/>
