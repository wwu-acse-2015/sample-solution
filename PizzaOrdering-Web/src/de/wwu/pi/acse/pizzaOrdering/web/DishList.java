package de.wwu.pi.acse.pizzaOrdering.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.pizzaOrdering.ejb.DishServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;

@ManagedBean
public class DishList {

	@EJB
	private DishServiceBean dishService;

	public Collection<Dish> getAllDishes() {
		return dishService.getAllDishes();
	}
}
