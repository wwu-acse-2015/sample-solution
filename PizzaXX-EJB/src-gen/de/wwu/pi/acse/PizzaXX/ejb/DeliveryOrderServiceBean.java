package de.wwu.pi.acse.PizzaXX.ejb;

import javax.ejb.Stateless;

import de.wwu.pi.acse.PizzaXX.entity.DeliveryOrder;
import de.wwu.pi.acse.PizzaXX.entity.Dish;
import de.wwu.pi.acse.PizzaXX.entity.OrderLine;
import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

@Stateless
public class DeliveryOrderServiceBean extends AbstractServiceBean<DeliveryOrder> {

	public DeliveryOrder create(DeliveryOrder deliveryOrder) {
		em.persist(deliveryOrder);
		return deliveryOrder;
	}

	@Override
	public DeliveryOrder getWithFetchedReferences(long id) {
		DeliveryOrder deliveryOrder = get(id);
		forceLoadOfOrderLines(deliveryOrder);
		return deliveryOrder;
	}

	public void remove(long id) {
		em.remove(get(id));
	}

	public DeliveryOrder updateMasterData(DeliveryOrder deliveryOrder) {
		DeliveryOrder attachedDeliveryOrder = get(deliveryOrder.getId());
		attachedDeliveryOrder.setCustomer(deliveryOrder.getCustomer());
		attachedDeliveryOrder.setReceived(deliveryOrder.getReceived());
		return deliveryOrder;
	}

	private void forceLoadOfOrderLines(DeliveryOrder deliveryOrder) {
		deliveryOrder.getOrderLines().size();
	}
	public void addToOrderLines(long id, Integer quantity, Dish dish) {
		DeliveryOrder deliveryOrder = get(id);
		OrderLine orderLines = new OrderLine();
		orderLines.setDeliveryOrder(deliveryOrder);
		orderLines.setQuantity(quantity);
		orderLines.setDish(dish);
		em.persist(orderLines);
	}

	public void removeFromOrderLines(OrderLine detachedOrderLine) {
		OrderLine orderLines = em.merge(detachedOrderLine);
		DeliveryOrder deliveryOrder = orderLines.getDeliveryOrder();
		deliveryOrder.getOrderLines().remove(orderLines);
		em.remove(orderLines);
	}
}
