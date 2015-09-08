select restaurante.nif, restaurante.tipo_comida,
       AVG(info_reserva.calidad),
       AVG(info_reserva.servicio),
       AVG(info_reserva.precio),
       (AVG(info_reserva.calidad)+AVG(info_reserva.servicio)+AVG(info_reserva.precio))/3
from restaurante, info_reserva
where restaurante.nif = info_reserva.nif
group by restaurante.nif, restaurante.tipo_comida
order by restaurante.tipo_comida, 
         (AVG(info_reserva.calidad)+AVG(info_reserva.servicio)+AVG(info_reserva.precio))/3 desc         