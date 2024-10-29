---
title: Achizitii PNRR
description: Statistici achizitii PNRR
queries:
  - achizitii_directe/total_atribuite.sql
  - achizitii_directe/total_anulate.sql
  - achizitii_directe/total_valoare.sql
  - achizitii_directe/total_beneficiari.sql
  - achizitii_directe/total_autoritati.sql

  - achizitii_offline/total.sql
  - achizitii_offline/total_valoare.sql
  - achizitii_offline/total_beneficiari.sql
  - achizitii_offline/total_autoritati.sql

  - licitatii_publice/total_atribuite.sql
  - licitatii_publice/total_anulate.sql
  - licitatii_publice/total_valoare.sql
  - licitatii_publice/total_autoritati.sql
  - licitatii_publice/total_beneficiari.sql
---


## [Achizitii directe](/achizitii-directe)

{@partial "achizitii-directe-totals.md"}

```sql total_achizitii_directe_lunar
  select
    count(*) as total_achizitii,
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
  y2=total_achizitii
  yAxisTitle="Valoare"
/>

## [Achizitii offline](/achizitii-offline)

{@partial "achizitii-offline-totals.md"}

```sql total_achizitii_offline_lunar
  select
    count(*) as total_achizitii,
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
  y2=total_achizitii
  yAxisTitle="Valoare"
/>

## [Licitatii publice](/licitatii-publice)

{@partial "licitatii-publice-totals.md"}

```sql total_licitatii_publice_lunar
  select
    count(*) as total_licitatii,
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
  y2=total_licitatii
  yAxisTitle="Valoare"
/>

# Despre

Acest site este un instrument de analiza a achizitiilor PNRR din Romania, pe baza datelor din [Sistemul Electronic de Achizitii Publice](https://www.e-licitatie.ro/). Codul sursa si datele despre contractele de achizitii (in format CSV) din acest site sunt disponibile pe [GitHub](https://github.com/ciocan/sicap-pnrr/).

Pentru orice intrebari legate de datele si instrumentul de analiza, nu ezitati sa ma contactati pe [email](mailto:radu@sicap.ai?subject=SICAP%20PNRR) sau folositi [GitHub issues](https://github.com/ciocan/sicap-pnrr/issues) pentru a raporta erori sau propune noi functionalitati.

Codul sursa este disponibil sub licenta MIT.

<LastRefreshed prefix="Data last updated"/>
