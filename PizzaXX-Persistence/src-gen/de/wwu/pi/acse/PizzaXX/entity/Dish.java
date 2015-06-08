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
	
	@NotNull(message="Price is a required field")
	protected int price;
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	
	@Override
	public String toString() {
		return (getName()) + ", " + (getDescription()) + ", " + (getPrice()) + "";
	}
}
