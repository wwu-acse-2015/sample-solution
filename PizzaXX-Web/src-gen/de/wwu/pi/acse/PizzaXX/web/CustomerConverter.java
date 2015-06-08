package de.wwu.pi.acse.PizzaXX.web;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.framework.logic.AbstractServiceBean;
import de.wwu.pi.acse.framework.web.AbstractConverter;

import de.wwu.pi.acse.PizzaXX.ejb.CustomerServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Customer;

@ManagedBean(name="customerConverter")
public class CustomerConverter extends AbstractConverter<Customer> {

	@EJB
	private CustomerServiceBean service;

	public AbstractServiceBean<Customer> getService() {
		return service;
	}
}
