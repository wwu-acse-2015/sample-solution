package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.PizzaXX.ejb.CustomerServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Customer;
import de.wwu.pi.acse.framework.web.Util;

@ManagedBean
@ViewScoped
public class CustomerDetails {

	@EJB
	private CustomerServiceBean customerService;

	private long id;
	private Customer customer;
	private String errorMessage;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
		init();
	}

	public void init() {
		customer = null;
	}

	public void ensureInitialized() {
		try {
			if (getCustomer() != null)
				// Success
				return;
		} catch (EJBException e) {
			e.printStackTrace();
		}
		Util.redirectToRoot();
	}

	public Customer getCustomer() {
		if (customer == null) {
			customer = customerService.getWithFetchedReferences(id);
		}
		return customer;
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

	public String persist() {
		customer = customerService.updateMasterData(customer);
		return toPage();
	}

	private String toPage() {
		return "/customer/CustomerDetails.xhtml?faces-redirect=true&id=" + id;
	}

	public String remove() {
		customerService.remove(id);
		return "/customer/CustomerList.xhtml";
	}

}
