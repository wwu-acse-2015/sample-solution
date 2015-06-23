package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import de.wwu.pi.acse.PizzaXX.ejb.CustomerServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Customer;

import de.wwu.pi.acse.framework.web.Util;

@ManagedBean
public class CustomerDetailsCreate {

	@EJB
	private CustomerServiceBean customerService;

	private Customer customer = new Customer();

	private String errorMessage;

	public Customer getCustomer() {
		return customer;
	}


	public String persist() {
		// Action
		try {
			customer = customerService.create(customer);
		} catch (EJBException e) {
			errorMessage = "Customer not created: "
					+ Util.getCausingMessage(e);
		}

		// Navigation
		if (isError())
			return null;
		else {
			return "/customer/CustomerDetails.xhtml?faces-redirect=true&id="
					+ customer.getId();
		}
	}

	public boolean isError() {
		return errorMessage != null;
	}

	public String getErrorMessage() {
		return errorMessage != null ? errorMessage : "";
	}
}
