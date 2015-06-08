package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import de.wwu.pi.acse.PizzaXX.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.DeliveryOrder;

@ManagedBean
public class DeliveryOrderList {

	@EJB
	private DeliveryOrderServiceBean deliveryOrderService;

	public Collection<DeliveryOrder> getAll() {
		return deliveryOrderService.getAll();
	}
}
