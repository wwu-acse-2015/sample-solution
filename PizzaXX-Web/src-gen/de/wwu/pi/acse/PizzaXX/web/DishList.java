package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import de.wwu.pi.acse.PizzaXX.ejb.DishServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Dish;

@ManagedBean
public class DishList {

	@EJB
	private DishServiceBean dishService;

	public Collection<Dish> getAll() {
		return dishService.getAll();
	}
}
