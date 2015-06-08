package de.wwu.pi.acse.PizzaXX.web;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.framework.logic.AbstractServiceBean;
import de.wwu.pi.acse.framework.web.AbstractConverter;

import de.wwu.pi.acse.PizzaXX.ejb.DishServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Dish;

@ManagedBean(name="dishConverter")
public class DishConverter extends AbstractConverter<Dish> {

	@EJB
	private DishServiceBean service;

	public AbstractServiceBean<Dish> getService() {
		return service;
	}
}
