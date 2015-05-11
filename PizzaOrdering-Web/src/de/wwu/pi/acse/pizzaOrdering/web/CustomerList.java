package de.wwu.pi.acse.pizzaOrdering.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.pizzaOrdering.ejb.CustomerServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Customer;

@ManagedBean
public class CustomerList {

	@EJB
	private CustomerServiceBean customerService;

	public Collection<Customer> getAllCustomers() {
		return customerService.getAllCustomers();
	}
}
