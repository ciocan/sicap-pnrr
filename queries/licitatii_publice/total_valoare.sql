select sum("item.ronContractValue") as valoare
from licitatii_publice
where "item.sysProcedureState.text" = 'Atribuita'