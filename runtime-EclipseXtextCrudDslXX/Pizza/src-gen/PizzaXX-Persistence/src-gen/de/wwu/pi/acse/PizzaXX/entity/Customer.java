package de.wwu.pi.acse.PizzaXX.entity;

import de.wwu.pi.acse.framework.data.AbstractEntity;
import javax.persistence.*;
import javax.validation.constraints.*;
import java.util.*;

@SuppressWarnings("serial")
@Entity
public class Customer extends AbstractEntity {

	//Default Constructor
	public Customer() {
		super();
	}
	
	@NotNull(message="Name is a required field")
	protected String name;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@NotNull(message="Address is a required field")
	protected String address;
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	@NotNull(message="Phone Number is a required field")
	protected String phoneNumber;
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	
	@OneToMany(mappedBy="customer")
	protected Collection<DeliveryOrder> deliveryOrders = new ArrayList<DeliveryOrder>();
	public Collection<DeliveryOrder> getDeliveryOrders() {
		return deliveryOrders;
	}
	protected void addToDeliveryOrders(DeliveryOrder elem) {
		deliveryOrders.add(elem);
	}
	
	@Override
	public String toString() {
		return (getName()) + ", " + (getAddress()) + ", " + (getPhoneNumber()) + "";
	}
}
