package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.PizzaXX.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.PizzaXX.ejb.DishServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.DeliveryOrder;
import de.wwu.pi.acse.PizzaXX.entity.Dish;
import de.wwu.pi.acse.PizzaXX.entity.OrderLine;
import de.wwu.pi.acse.framework.web.Util;

@ManagedBean
@ViewScoped
public class DeliveryOrderDetails {

	@EJB
	private DeliveryOrderServiceBean service;
	//Service for referenced classes of composite elements
	@EJB
	private DishServiceBean dishService;
	
	public Collection<Dish> getAllOfTypeDish() {
		return dishService.getAll();
	}

	private long id;
	private DeliveryOrder deliveryOrder;
	private String errorMessage;

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
			deliveryOrder = service.getWithFetchedReferences(id);
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
		deliveryOrder = service.updateMasterData(deliveryOrder);
		return toPage();
	}

	private String toPage() {
		return "/deliveryOrder/details.xhtml?faces-redirect=true&id=" + id;
	}

	public String remove() {
		service.remove(id);
		return "/deliveryOrder/list.xhtml";
	}

	public String addToOrderLines() {
		resetError();
		try  {
			service.addToOrderLines(id, quantityForNewOrderLines, dishForNewOrderLines);
		} catch (EJBException e) {
			errorMessage = "Order Lines could not be added: " +
				Util.getCausingMessage(e);
		}

		if (isError()) return null;
		else return toPage();
	}

	public String removeFromOrderLines(OrderLine orderLine) {
		service.removeFromOrderLines(orderLine);
		return toPage();
	}

	protected int quantityForNewOrderLines;
	public int getQuantityForNewOrderLines() {
		return quantityForNewOrderLines;
	}
	public void setQuantityForNewOrderLines(int quantity) {
		this.quantityForNewOrderLines = quantity;
	}
	public Dish dishForNewOrderLines;
	public Dish getDishForNewOrderLines() {
		return dishForNewOrderLines;
	}
	public void setDishForNewOrderLines(Dish dish) {
		this.dishForNewOrderLines = dish;
	}
}
