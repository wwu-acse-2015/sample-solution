package de.wwu.pi.acse.framework.logic;

import java.lang.reflect.ParameterizedType;
import java.util.Collection;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import de.wwu.pi.acse.framework.data.AbstractEntity;

public abstract class AbstractServiceBean<T extends AbstractEntity> {

  protected Class<T> entityClass;
  
  @PersistenceContext
  protected EntityManager em;
  
  public AbstractServiceBean() {
    this.entityClass = determineEntityClass();
  }

  public Collection<T> getAll() {
    CriteriaBuilder cb = em.getCriteriaBuilder();
    CriteriaQuery<T> cq = cb.createQuery(entityClass);
    Root<T> rootEntry = cq.from(entityClass);
    return em.createQuery(cq.select(rootEntry)).getResultList();
  }

  public T get(long id) {
    return em.find(entityClass, id);
  }

  public abstract T getWithFetchedReferences(long id);
  
  // helper classes to determine entity class
  private Class<T> determineEntityClass() {
    if (superclassIsThisAbstractClass()) {
      return getEntityClassFromTypeArguments(getClass());
    } else {
      return getEntityClassFromTypeArguments(getClass().getSuperclass());
    }
  }

  private boolean superclassIsThisAbstractClass() {
    Class<?> superclass = getClass().getSuperclass();
    return superclass.equals(AbstractServiceBean.class);
  }

  @SuppressWarnings("unchecked")
  private Class<T> getEntityClassFromTypeArguments(Class<?> clazz) {
    ParameterizedType genericSuperclass = (ParameterizedType) clazz
        .getGenericSuperclass();
    return (Class<T>) genericSuperclass.getActualTypeArguments()[0];
  }
}
