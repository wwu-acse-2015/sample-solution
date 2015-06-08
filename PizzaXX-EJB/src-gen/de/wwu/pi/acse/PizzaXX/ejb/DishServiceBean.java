package de.wwu.pi.acse.PizzaXX.ejb;

import javax.ejb.Stateless;

import de.wwu.pi.acse.PizzaXX.entity.Dish;
import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

@Stateless
public class DishServiceBean extends AbstractServiceBean<Dish> {

	public Dish create(Dish dish) {
		em.persist(dish);
		return dish;
	}

	@Override
	public Dish getWithFetchedReferences(long id) {
		Dish dish = get(id);
		return dish;
	}

	public void remove(long id) {
		em.remove(get(id));
	}

	public Dish updateMasterData(Dish dish) {
		Dish attachedDish = get(dish.getId());
		attachedDish.setName(dish.getName());
		attachedDish.setDescription(dish.getDescription());
		attachedDish.setPrice(dish.getPrice());
		return dish;
	}
}
