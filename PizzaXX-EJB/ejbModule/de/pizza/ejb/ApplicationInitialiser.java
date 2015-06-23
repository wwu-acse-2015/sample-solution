package de.pizza.ejb;

import java.util.Calendar;
import java.util.Random;

import javax.annotation.PostConstruct;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import de.wwu.pi.acse.PizzaXX.entity.*;

@Startup @Singleton
public class ApplicationInitialiser {

  @PersistenceContext
  EntityManager em;
  
  @PostConstruct
  public void initialise() {
    Customer johnDoe = createCustomer("John Doe", "+49 251 833800", "Leonardo-Campus 18");
    em.persist(johnDoe);
    
    Customer poeDameron = createCustomer("Poe Dameron", "+49 251 547578", "Peter-Wust-Straße 13");
    em.persist(poeDameron);

    Dish hawaii = createDish("Pizza Hawaii", "Ham and pineapple");
    em.persist(hawaii);
    Dish salami = createDish("Pizza Salami", "Salami");
    em.persist(salami);
    Dish funghi = createDish("Pizza Funghi", "Funghi");
    em.persist(funghi);
    
    DeliveryOrder order = createOrderFor(johnDoe);
    em.persist(order); 
    addDishesToOrder(new Dish[] { hawaii, salami }, order);
    
    order = createOrderFor(poeDameron);
    em.persist(order); 
    addDishesToOrder(new Dish[] { salami, funghi }, order);
  }
  
  private void addDishesToOrder(Dish[] dishes, DeliveryOrder order) {
    for (Dish dish : dishes) {
      OrderLine o = new OrderLine();
      o.setQuantity(new Random().nextInt(3) + 1);
      o.setDish(dish);
      o.setParentElement(order);
      em.persist(o);
      order.getOrderLines().add(o);
    }
  }

  private Dish createDish(String name, String description) {
    Dish dish = new Dish();
    dish.setName(name);
    dish.setDescription(description);
    return dish;
  }

  private Customer createCustomer(String name, String phoneNumber,
      String address) {
    Customer customer = new Customer();
    customer.setName(name);
    customer.setPhoneNumber(phoneNumber);
    customer.setAddress(address);
    return customer;
  }
  
  private DeliveryOrder createOrderFor(Customer customer) {
    DeliveryOrder order = new DeliveryOrder();
    order.setReceived(Calendar.getInstance().getTime());
    order.setCustomer(customer);
    customer.getDeliveryOrders().add(order);
    return order;
  }
  
  
}
