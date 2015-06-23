package de.wwu.pi.acse.PizzaXX.entity;

import de.wwu.pi.acse.framework.data.AbstractEntity;
import javax.persistence.*;
import javax.validation.constraints.*;
import java.util.*;

@SuppressWarnings("serial")
@Entity
public class DeliveryOrder extends AbstractEntity {

	//Default Constructor
	public DeliveryOrder() {
		super();
	}
	
	@NotNull(message="Received is a required field")
	protected Date received;
	public Date getReceived() {
		return received;
	}
	public void setReceived(Date received) {
		this.received = received;
	}
	
	@NotNull(message="Customer is a required field")
	@ManyToOne
	protected Customer customer;
	public Customer getCustomer() {
		return customer;
	}
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	
	@OneToMany(mappedBy="parentElement")
	protected Collection<OrderLine> orderLines = new ArrayList<OrderLine>();
	public Collection<OrderLine> getOrderLines() {
		return orderLines;
	}
	protected void addToOrderLines(OrderLine elem) {
		orderLines.add(elem);
	}
	
	@Override
	public String toString() {
		return (getReceived()) + "";
	}
}
