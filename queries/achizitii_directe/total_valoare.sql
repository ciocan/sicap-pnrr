select sum("item.closingValue") as total 
from pnrr.achizitii_directe 
where "item.sysDirectAcquisitionState.text" = 'Oferta acceptata'