---
title: Cauta
description: Cauta achizitii publice
hide_title: true
---

# Cauta in achizitiile publice

<TextInput
  name=cauta_achizitie
  title="Nume achizitie / licitatie"
  placeholder="cauta..."
/>

<br />

<ButtonGroup title="Tip cautare" name=tip_cautare>
  <ButtonGroupItem valueLabel="Exacta" value="exacta" default />
  <ButtonGroupItem valueLabel="Semantica" value="semantica" />
</ButtonGroup>

{#if inputs.cauta_achizitie != ''}
  ## Achizitii directe

  ```sql cauta_achizitii_directe
    SELECT
      *,
      "item.directAcquisitionName" as nume_achizitie,
      concat('https://e-licitatie.ro/pub/direct-acquisition/view/', cast("item.directAcquisitionId" as integer)) as link
    FROM achizitii_directe
      WHERE CASE 
        WHEN '${inputs.tip_cautare}' = 'exacta' THEN "item.directAcquisitionName" ilike '%${inputs.cauta_achizitie}%'
        ELSE true
      END
      ORDER BY CASE
        WHEN '${inputs.tip_cautare}' = 'semantica' THEN damerau_levenshtein("item.directAcquisitionName", '${inputs.cauta_achizitie}')
        ELSE "item.directAcquisitionName"
      END
      LIMIT 1000
  ```

  <DataTable data={cauta_achizitii_directe} rowShading=true search=true rows=20 wrapTitles=true>
    <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.uniqueIdentificationCode" />
    <Column id="item.closingValue" title="Valoare" fmt="num2k" contentType=colorscale />
    <Column id="item.sysDirectAcquisitionState.text" title="Stare achizitie" />
    <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
    <Column id="item.directAcquisitionName" title="Nume achizitie" />
    <Column id="supplier.fiscalNumber" title="Cod fiscal beneficiar" />
    <Column id="supplier.entityName" title="Beneficiar" />
    <Column id="authority.fiscalNumber" title="Cod fiscal autoritate" />
    <Column id="authority.entityName" title="Autoritate contractanta" />
    <Column id="authority.city" title="Oras autoritate" />
    <Column id="authority.county" title="Judet autoritate" />
    <Column id="item.cpvCode" title="Cod CPV" />
  </DataTable>

  ## Achizitii offline
  ```sql cauta_achizitii_offline
    SELECT *,
        concat('https://e-licitatie.ro/pub/direct-acquisition/award-notice/view/', cast("item.daAwardNoticeId" as integer)) as link
    FROM achizitii_offline 
    WHERE CASE 
        WHEN '${inputs.tip_cautare}' = 'exacta' THEN "item.contractObject" ilike '%${inputs.cauta_achizitie}%'
        ELSE true
      END
      ORDER BY CASE
        WHEN '${inputs.tip_cautare}' = 'semantica' THEN damerau_levenshtein("item.contractObject", '${inputs.cauta_achizitie}')
        ELSE "item.contractObject"
      END
    LIMIT 1000
  ```

  <DataTable data={cauta_achizitii_offline} rowShading=true search=true rows=20 wrapTitles=true>
    <Column id="link" openInNewTab=true title="Cod achizitie" contentType=link linkLabel="item.noticeNo" />
    <Column id="item.awardedValue" title="Valoare" fmt="num2k" contentType=colorscale />
    <Column id="item.publicationDate" title="Data publicare" fmt="dd-mm-yyyy" />
    <Column id="details.finalizationDate" title="Data finalizare" fmt="dd-mm-yyyy" />
    <Column id="item.contractObject" title="Nume achizitie" />
    <Column id="details.noticeEntityAddress.fiscalNumber" title="Cod fiscal beneficiar" />
    <Column id="details.noticeEntityAddress.organization" title="Beneficiar" />
    <Column id="details.noticeEntityAddress.city" title="Oras beneficiar" />
    <Column id="authority.fiscalNumber" title="Cod fiscal autoritate" />
    <Column id="authority.entityName" title="Autoritate contractanta" />
    <Column id="authority.city" title="Oras autoritate" />
    <Column id="authority.county" title="Judet autoritate" />
    <Column id="item.cpvCode" title="Cod CPV" />
  </DataTable>

  ## Licitatii publice
  ```sql cauta_licitatii_publice
    select *,
      case 
        when "item.noticeNo" like 'SCNA%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-rfq/', cast("item.caNoticeId" as integer))
        when "item.noticeNo" like 'CAN%' then concat('https://e-licitatie.ro/pub/notices/ca-notices/view-c/', cast("item.caNoticeId" as integer))
        else concat('#/', cast("item.caNoticeId" as integer))
      end as link,
      "noticeContracts.items.winners.name" as beneficiar,
      "noticeContracts.items.winners.address.city" as oras,
      "noticeContracts.items.winners.address.county.text" as judet,
      coalesce(
        nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.city", '-'),
        nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.city", '-')
      ) as oras_autoritate,
      coalesce(
        nullif("publicNotice.caNoticeEdit_New_U.section1_New_U.section1_1.caAddress.county.text", '-'),
        nullif("publicNotice.caNoticeEdit_New.section1_New.section1_1.caAddress.nutsCodeItem.text", '-'),
        '-'
      ) as judet_autoritate,
    from licitatii_publice,
      unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)
    WHERE CASE 
        WHEN '${inputs.tip_cautare}' = 'exacta' THEN "item.contractTitle" ilike '%${inputs.cauta_achizitie}%'
        ELSE true
      END
      ORDER BY CASE
        WHEN '${inputs.tip_cautare}' = 'semantica' THEN damerau_levenshtein("item.contractTitle", '${inputs.cauta_achizitie}')
        ELSE "item.contractTitle"
      END
    LIMIT 1000
  ```

  <DataTable data={cauta_licitatii_publice} rowShading=true search=true rows=20 wrapTitles=true>
    <Column id="link" openInNewTab=true title="Cod licitatie" contentType=link linkLabel="item.noticeNo" />
    <Column id="item.ronContractValue" title="Valoare" fmt="num2m" contentType=colorscale />
    <Column id="item.sysProcedureState.text" title="Stare licitatie" />
    <Column id="item.noticeStateDate" title="Data publicare" fmt="dd-mm-yyyy" />
    <Column id="item.contractTitle" title="Nume licitatie" />
    <Column id="noticeContracts.items.winners.fiscalNumber" title="Cod fiscal beneficiar" />
    <Column id="noticeContracts.items.winners.name" title="Beneficiar" />
    <Column id="noticeContracts.items.winners.address.city" title="Oras beneficiar" />
    <Column id="noticeContracts.items.winners.address.county.text" title="Judet beneficiar" />
    <Column id="item.contractingAuthorityNameAndFN" title="Autoritate contractanta" />
    <Column id="oras_autoritate" title="Oras autoritate" />
    <Column id="judet_autoritate" title="Judet autoritate" />
    <Column id="item.cpvCodeAndName" title="Cod CPV" />
  </DataTable>
{/if}

