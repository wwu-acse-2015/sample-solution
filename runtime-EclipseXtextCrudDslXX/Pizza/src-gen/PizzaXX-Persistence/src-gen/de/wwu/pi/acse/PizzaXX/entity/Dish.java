package de.wwu.pi.acse.PizzaXX.entity;

import de.wwu.pi.acse.framework.data.AbstractEntity;
import javax.persistence.*;
import javax.validation.constraints.*;
import java.util.*;

@SuppressWarnings("serial")
@Entity
public class Dish extends AbstractEntity {

	//Default Constructor
	public Dish() {
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
	
	@NotNull(message="Description is a required field")
	protected String description;
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	protected Integer price;
	public Integer getPrice() {
		return price;
	}
	public void setPrice(Integer price) {
		this.price = price;
	}
	
	@OneToMany(mappedBy="dish")
	protected Collection<OrderLine> orderLines = new ArrayList<OrderLine>();
	public Collection<OrderLine> getOrderLines() {
		return orderLines;
	}
	protected void addToOrderLines(OrderLine elem) {
		orderLines.add(elem);
	}
	
	@Override
	public String toString() {
		return (getName()) + ", " + (getDescription()) + ", " + ((getPrice()==null)?"-":getPrice()) + "";
	}
}
