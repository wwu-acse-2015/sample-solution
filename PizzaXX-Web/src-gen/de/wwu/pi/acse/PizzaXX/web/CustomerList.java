package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import de.wwu.pi.acse.PizzaXX.ejb.CustomerServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Customer;

@ManagedBean
public class CustomerList {

	@EJB
	private CustomerServiceBean customerService;

	public Collection<Customer> getAll() {
		return customerService.getAll();
	}
}
