select count(distinct "supplier.entityId") as total 
from pnrr.achizitii_directe 
where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'