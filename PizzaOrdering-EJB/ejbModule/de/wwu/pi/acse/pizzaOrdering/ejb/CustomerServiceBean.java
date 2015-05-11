package de.wwu.pi.acse.pizzaOrdering.ejb;

import java.util.Collection;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import de.wwu.pi.acse.pizzaOrdering.entity.Customer;

@Stateless
public class CustomerServiceBean {

	@PersistenceContext
	protected EntityManager em;
	
	public Customer create(Customer customer) {
		em.persist(customer);
		return customer;
	}
	
	public Collection<Customer> getAllCustomers() {
		CriteriaBuilder cb = em.getCriteriaBuilder();
		CriteriaQuery<Customer> cq = cb.createQuery(Customer.class);
		Root<Customer> rootEntry = cq.from(Customer.class);
		return em.createQuery(cq.select(rootEntry)).getResultList();
	}

	public Customer getCustomer(long id) {
		return em.find(Customer.class, id);
	}

	public Customer getCustomerWithFetchedReferences(long id) {
		Customer customer = getCustomer(id);
		forceLoadOfDeliveryOrders(customer);
		return customer;
	}

	private void forceLoadOfDeliveryOrders(Customer customer) {
		customer.getDeliveryOrders().size();
	}

	public void remove(long id) {
		em.remove(getCustomer(id));
	}

	public Customer updateMasterData(Customer customer) {
		Customer attachedCustomer = getCustomer(customer.getId());
		attachedCustomer.setName(customer.getName());
		attachedCustomer.setAddress(customer.getAddress());
		attachedCustomer.setPhoneNumber(customer.getPhoneNumber());
		return customer;
	}
}
