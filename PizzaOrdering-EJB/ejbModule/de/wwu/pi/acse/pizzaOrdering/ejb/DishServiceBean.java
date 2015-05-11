package de.wwu.pi.acse.pizzaOrdering.ejb;

import java.util.Collection;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import de.wwu.pi.acse.pizzaOrdering.entity.Dish;

@Stateless
public class DishServiceBean {

	@PersistenceContext
	protected EntityManager em;
	
	public Dish create(Dish dish) {
		em.persist(dish);
		return dish;
	}

	public Collection<Dish> getAllDishes() {
		CriteriaBuilder cb = em.getCriteriaBuilder();
		CriteriaQuery<Dish> cq = cb.createQuery(Dish.class);
		Root<Dish> rootEntry = cq.from(Dish.class);
		return em.createQuery(cq.select(rootEntry)).getResultList();
	}

	public Dish getDish(long id) {
		return em.find(Dish.class, id);
	}
	
	public void remove(long id) {
		em.remove(getDish(id));
	}

	public Dish updateMasterData(Dish dish) {
		Dish attachedDish = getDish(dish.getId());
		attachedDish.setName(dish.getName());
		attachedDish.setDescription(dish.getDescription());
		attachedDish.setPrice(dish.getPrice());
		return dish;
	}
}
