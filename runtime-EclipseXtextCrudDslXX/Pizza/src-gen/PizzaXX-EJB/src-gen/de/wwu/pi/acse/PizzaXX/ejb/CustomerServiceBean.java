package de.wwu.pi.acse.PizzaXX.ejb;

import javax.ejb.Stateless;

import de.wwu.pi.acse.PizzaXX.entity.Customer;
import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

@Stateless
public class CustomerServiceBean extends AbstractServiceBean<Customer> {

	public Customer create(Customer customer) {
		em.persist(customer);
		return customer;
	}

	@Override
	public Customer getWithFetchedReferences(long id) {
		Customer customer = get(id);
		forceLoadOfDeliveryOrders(customer);
		return customer;
	}

	public void remove(long id) {
		em.remove(get(id));
	}

	public Customer updateMasterData(Customer customer) {
		Customer attachedCustomer = get(customer.getId());
		attachedCustomer.setName(customer.getName());
		attachedCustomer.setAddress(customer.getAddress());
		attachedCustomer.setPhoneNumber(customer.getPhoneNumber());
		return customer;
	}

	private void forceLoadOfDeliveryOrders(Customer customer) {
		customer.getDeliveryOrders().size();
	}
}
