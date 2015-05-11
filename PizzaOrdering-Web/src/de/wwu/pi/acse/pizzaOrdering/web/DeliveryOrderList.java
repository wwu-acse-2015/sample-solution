package de.wwu.pi.acse.pizzaOrdering.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.pizzaOrdering.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.DeliveryOrder;

@ManagedBean
public class DeliveryOrderList {

	@EJB
	private DeliveryOrderServiceBean deliveryOrderService;

	public Collection<DeliveryOrder> getAllDeliveryOrders() {
		return deliveryOrderService.getAllDeliveryOrders();
	}
}
