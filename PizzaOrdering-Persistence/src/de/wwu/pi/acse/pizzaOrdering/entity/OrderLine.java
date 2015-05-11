package de.wwu.pi.acse.pizzaOrdering.entity;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
public class OrderLine {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;
	@NotNull(message="Quantity is a required field")
	private int quantity;
	@NotNull(message="Delivery Order is a required field")
	@ManyToOne
	private DeliveryOrder deliveryOrder;
	@NotNull(message="Dish is a required field")
	@ManyToOne
	private Dish dish;
	
	// Default Constructor
	public OrderLine() {
		super();
	}
	
	public long getId() {
		return this.id;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public DeliveryOrder getDeliveryOrder() {
		return deliveryOrder;
	}

	public void setDeliveryOrder(DeliveryOrder deliveryOrder) {
		this.deliveryOrder = deliveryOrder;
	}

	public Dish getDish() {
		return dish;
	}

	public void setDish(Dish dish) {
		this.dish = dish;
	}

	@Override
	public String toString() {
		return getQuantity()+ "";
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
		OrderLine other = (OrderLine) obj;
		if (this.getId() != other.getId())
			return false;
		return true;
	}
}
