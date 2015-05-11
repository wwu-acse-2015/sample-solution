package de.wwu.pi.acse.pizzaOrdering.entity;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

import java.util.*;

@Entity
public class DeliveryOrder {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;
	@NotNull(message="Received is a required field")
	private Date received;
	@NotNull(message="Customer is a required field")
	@ManyToOne
	private Customer customer;
	@OneToMany(mappedBy = "deliveryOrder")
	private Collection<OrderLine> orderLines = new ArrayList<OrderLine>();

	// Default Constructor
	public DeliveryOrder() {
		super();
	}

	public long getId() {
		return this.id;
	}

	public Date getReceived() {
		return received;
	}

	public void setReceived(Date received) {
		this.received = received;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public Collection<OrderLine> getOrderLines() {
		return orderLines;
	}

	protected void addToOrderLines(OrderLine elem) {
		orderLines.add(elem);
	}

	@Override
	public String toString() {
		return getReceived() + "";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (this.getId() ^ (this.getId() >>> 32));
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		DeliveryOrder other = (DeliveryOrder) obj;
		if (this.getId() != other.getId())
			return false;
		return true;
	}
}
