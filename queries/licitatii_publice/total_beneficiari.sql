  select count(distinct winners) as total_beneficiari
  from licitatii_publice,
  unnest(string_split("noticeContracts.items.winners.fiscalNumber", ',')) as t(winners)