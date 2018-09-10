select orders.*, os.status_name
from orders
inner join orders_status os on os.id = orders.status_id
order by orders.id;
