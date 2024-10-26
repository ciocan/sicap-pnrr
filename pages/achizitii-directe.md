---
title: Achizitii directe
description: statistici achizitii directe 
---

```sql achizitii_directe_total
  select count(*) as total from achizitii_directe
```

<BigValue 
  data={achizitii_directe_total} 
  value=total
  title="Total achizitii directe"
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

