package de.wwu.pi.acse.pizzaOrdering.web;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.pizzaOrdering.ejb.CustomerServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Customer;
import de.wwu.pi.acse.pizzaOrdering.web.util.Util;

@ManagedBean
@ViewScoped
public class CustomerDetails {

	@EJB
	private CustomerServiceBean customerService;

	private long id;
	private Customer customer;


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
			customer = customerService.getCustomerWithFetchedReferences(id);
		}
		return customer;
	}

	public String submitMasterDataChanges() {
		customer = customerService.updateMasterData(customer);
		return toPage();
	}

	private String toPage() {
		return "/customer/details.xhtml?faces-redirect=true&id=" + id;
	}

	public String remove() {
		customerService.remove(id);
		return "/customer/list.xhtml";
	}

}
