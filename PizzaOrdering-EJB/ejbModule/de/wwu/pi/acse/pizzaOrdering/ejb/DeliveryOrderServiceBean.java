package de.wwu.pi.acse.pizzaOrdering.ejb;

import java.util.Collection;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import de.wwu.pi.acse.pizzaOrdering.entity.DeliveryOrder;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;
import de.wwu.pi.acse.pizzaOrdering.entity.OrderLine;

@Stateless
public class DeliveryOrderServiceBean {

	@PersistenceContext
	protected EntityManager em;
	
	public DeliveryOrder create(DeliveryOrder deliveryOrder) {
		em.persist(deliveryOrder);
		return deliveryOrder;
	}
	
	public Collection<DeliveryOrder> getAllDeliveryOrders() {
		CriteriaBuilder cb = em.getCriteriaBuilder();
		CriteriaQuery<DeliveryOrder> cq = cb.createQuery(DeliveryOrder.class);
		Root<DeliveryOrder> rootEntry = cq.from(DeliveryOrder.class);
		return em.createQuery(cq.select(rootEntry)).getResultList();
	}

	public DeliveryOrder getDeliveryOrder(long id) {
		return em.find(DeliveryOrder.class, id);
	}

	public DeliveryOrder getDeliveryOrderWithFetchedReferences(long id) {
		DeliveryOrder deliveryOrder = getDeliveryOrder(id);
		forceLoadOfOrderLines(deliveryOrder);
		return deliveryOrder;
	}

	private void forceLoadOfOrderLines(DeliveryOrder deliveryOrder) {
		deliveryOrder.getOrderLines().size();
	}
	public void addToOrderLines(long id, Integer quantity, Dish dish) {
		DeliveryOrder deliveryOrder = getDeliveryOrder(id);
		OrderLine orderLine = new OrderLine();
		orderLine.setDeliveryOrder(deliveryOrder);
		orderLine.setQuantity(quantity);
		orderLine.setDish(dish);
		em.persist(orderLine);
	}

	public void removeFromOrderLines(OrderLine detachedOrderLine) {
		OrderLine orderLines = em.merge(detachedOrderLine);
		DeliveryOrder deliveryOrder = orderLines.getDeliveryOrder();
		deliveryOrder.getOrderLines().remove(orderLines);
		em.remove(orderLines);
	}

	public void remove(long id) {
		em.remove(getDeliveryOrder(id));
	}

	public DeliveryOrder updateMasterData(DeliveryOrder deliveryOrder) {
		DeliveryOrder attachedDeliveryOrder = getDeliveryOrder(deliveryOrder.getId());
		attachedDeliveryOrder.setCustomer(deliveryOrder.getCustomer());
		attachedDeliveryOrder.setReceived(deliveryOrder.getReceived());
		return deliveryOrder;
	}
}
