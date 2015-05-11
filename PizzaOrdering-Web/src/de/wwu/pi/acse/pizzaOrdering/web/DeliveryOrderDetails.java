package de.wwu.pi.acse.pizzaOrdering.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.pizzaOrdering.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.pizzaOrdering.ejb.DishServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.DeliveryOrder;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;
import de.wwu.pi.acse.pizzaOrdering.entity.OrderLine;
import de.wwu.pi.acse.pizzaOrdering.web.util.Util;

@ManagedBean
@ViewScoped
public class DeliveryOrderDetails {

	@EJB
	private DeliveryOrderServiceBean deliveryOrderService;

	@EJB
	private DishServiceBean dishService;
	
	public Collection<Dish> getAllDishes() {
		return dishService.getAllDishes();
	}

	private long id;
	private DeliveryOrder deliveryOrder;
	private String errorMessage;

	private int quantityForNewOrderLine;
	private Dish dishForNewOrderLine;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
		init();
	}

	public void init() {
		deliveryOrder = null;
	}

	public void ensureInitialized() {
		try {
			if (getDeliveryOrder() != null)
				// Success
				return;
		} catch (EJBException e) {
			e.printStackTrace();
		}
		Util.redirectToRoot();
	}

	public DeliveryOrder getDeliveryOrder() {
		if (deliveryOrder == null) {
			deliveryOrder = deliveryOrderService.getDeliveryOrderWithFetchedReferences(id);
		}
		return deliveryOrder;
	}

	public boolean isError() {
		return errorMessage != null;
	}

	public String getErrorMessage() {
		return errorMessage != null ? errorMessage : "";
	}

	private void resetError() {
		errorMessage = null;
	}

	public String submitMasterDataChanges() {
		deliveryOrder = deliveryOrderService.updateMasterData(deliveryOrder);
		return toPage();
	}

	private String toPage() {
		return "/deliveryOrder/details.xhtml?faces-redirect=true&id=" + id;
	}

	public String remove() {
		deliveryOrderService.remove(id);
		return "/deliveryOrder/list.xhtml";
	}

	public String addToOrderLines() {
		resetError();
		try  {
			deliveryOrderService.addToOrderLines(id, quantityForNewOrderLine, dishForNewOrderLine);
		} catch (EJBException e) {
			errorMessage = "Order Lines could not be added: " +
				Util.getCausingMessage(e);
		}

		if (isError()) return null;
		else return toPage();
	}

	public String removeFromOrderLines(OrderLine orderLine) {
		deliveryOrderService.removeFromOrderLines(orderLine);
		return toPage();
	}

	public int getQuantityForNewOrderLine() {
		return quantityForNewOrderLine;
	}
	
	public void setQuantityForNewOrderLine(int quantity) {
		this.quantityForNewOrderLine = quantity;
	}
	
	public Dish getDishForNewOrderLine() {
		return dishForNewOrderLine;
	}
	
	public void setDishForNewOrderLine(Dish dish) {
		this.dishForNewOrderLine = dish;
	}
}
