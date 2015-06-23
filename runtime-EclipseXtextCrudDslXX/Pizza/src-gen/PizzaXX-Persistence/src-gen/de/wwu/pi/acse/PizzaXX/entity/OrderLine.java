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
	protected Integer quantity;
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
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
	@NotNull(message="Reference to owning element is a required field")
	@ManyToOne
	protected DeliveryOrder parentElement;
	public DeliveryOrder getParentElement() {
		return parentElement;
	}
	public void setParentElement(DeliveryOrder parentElement) {
		this.parentElement = parentElement;
	}
}
