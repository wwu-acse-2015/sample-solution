package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import de.wwu.pi.acse.PizzaXX.ejb.CustomerServiceBean;
import de.wwu.pi.acse.PizzaXX.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Customer;
import de.wwu.pi.acse.PizzaXX.entity.DeliveryOrder;

import de.wwu.pi.acse.framework.web.Util;

@ManagedBean
public class DeliveryOrderCreate {

	@EJB
	private DeliveryOrderServiceBean deliveryOrderService;

	private DeliveryOrder deliveryOrder = new DeliveryOrder();

	private String errorMessage;

	public DeliveryOrder getDeliveryOrder() {
		return deliveryOrder;
	}

	@EJB
	private CustomerServiceBean customerService;
	
	public Collection<Customer> getAllOfTypeCustomer() {
		return customerService.getAll();
	}

	public String persist() {
		// Action
		try {
			deliveryOrder = deliveryOrderService.create(deliveryOrder);
		} catch (EJBException e) {
			errorMessage = "DeliveryOrder not created: "
					+ Util.getCausingMessage(e);
		}

		// Navigation
		if (isError())
			return null;
		else {
			return "/deliveryOrder/details.xhtml?faces-redirect=true&id="
					+ deliveryOrder.getId();
		}
	}

	public boolean isError() {
		return errorMessage != null;
	}

	public String getErrorMessage() {
		return errorMessage != null ? errorMessage : "";
	}
}
