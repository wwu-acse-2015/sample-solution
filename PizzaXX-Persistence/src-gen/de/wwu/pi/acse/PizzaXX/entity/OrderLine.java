package de.wwu.pi.acse.PizzaXX.entity;

import de.wwu.pi.acse.framework.data.AbstractEntity;
import javax.persistence.*;
import javax.validation.constraints.*;
import java.util.*;

@SuppressWarnings("serial")
@Entity
public class OrderLine extends AbstractEntity {

	//Default Constructor
	public OrderLine() {
		super();
	}
	
	@NotNull(message="Quantity is a required field")
	protected int quantity;
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	@NotNull(message="Delivery Order is a required field")
	@ManyToOne
	protected DeliveryOrder deliveryOrder;
	public DeliveryOrder getDeliveryOrder() {
		return deliveryOrder;
	}
	public void setDeliveryOrder(DeliveryOrder deliveryOrder) {
		this.deliveryOrder = deliveryOrder;
	}
	
	@NotNull(message="Dish is a required field")
	@ManyToOne
	protected Dish dish;
	public Dish getDish() {
		return dish;
	}
	public void setDish(Dish dish) {
		this.dish = dish;
	}
	
	@Override
	public String toString() {
		return (getQuantity()) + "";
	}
}
