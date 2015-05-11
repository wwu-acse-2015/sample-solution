package de.wwu.pi.acse.pizzaOrdering.entity;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

import java.util.*;

@Entity
public class Customer {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;
	@NotNull(message="Name is a required field")
	private String name;
	@NotNull(message="Address is a required field")
	private String address;
	@NotNull(message="Phone Number is a required field")
	private String phoneNumber;
	@OneToMany(mappedBy = "customer")
	private Collection<DeliveryOrder> deliveryOrders = new ArrayList<DeliveryOrder>();

	// Default Constructor
	public Customer() {
		super();
	}

	public long getId() {
		return this.id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public Collection<DeliveryOrder> getDeliveryOrders() {
		return deliveryOrders;
	}

	public void addToDeliveryOrders(DeliveryOrder elem) {
		deliveryOrders.add(elem);
	}

	@Override
	public String toString() {
		return getName() + ", " + getAddress() + ", " + getPhoneNumber();
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
		Customer other = (Customer) obj;
		if (this.getId() != other.getId())
			return false;
		return true;
	}
}
