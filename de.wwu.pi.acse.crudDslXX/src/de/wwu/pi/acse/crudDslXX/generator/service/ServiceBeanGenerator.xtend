package de.wwu.pi.acse.crudDslXX.generator.service



import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.entity.EntityClass.oppositeSetterName
import static extension de.wwu.pi.acse.crudDslXX.generator.entity.EntityClass.oppositeGetterName
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.generator.util.GeneratorWithImports
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property
import de.wwu.pi.acse.crudDslXX.crudDslXX.CompositeRef

class ServiceBeanGenerator extends GeneratorWithImports<Entity>{
	override doGenerate(Entity entity) {
	val entityObjectName = entity.entityClassName.toFirstLower
	val entityTypeName = entity.entityClassName
	
	'''
	package «entity.logicPackageString»;

	import javax.ejb.Stateless;

	«IMPORTS_MARKER»
	import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

	@Stateless
	public class «entity.serviceClassName» extends AbstractServiceBean<«importedType(entity)»> {

		public «entityTypeName» create(«entityTypeName» «entityObjectName») {
			em.persist(«entityObjectName»);
			return «entityObjectName»;
		}

		@Override
		public «entityTypeName» getWithFetchedReferences(long id) {
			«entityTypeName» «entityObjectName» = get(id);
			«FOR multiRef : entity.multiReferences»
				forceLoadOf«multiRef.nameInJava.toFirstUpper»(«entityObjectName»);
			«ENDFOR»
			return «entityObjectName»;
		}

		public void remove(long id) {
			em.remove(get(id));
		}

		public «entityTypeName» updateMasterData(«entityTypeName» «entityObjectName») {
			«entityTypeName» attached«entityObjectName.toFirstUpper» = get(«entityObjectName».getId());
			« // iterate over single value proerties and save value
			FOR singleValProp : entity.properties.filter[singleValued]»
				attached«entityObjectName.toFirstUpper».«singleValProp.setterMethodName»(«entityObjectName».«singleValProp.getterMethodName»());
			«ENDFOR»
			return «entityObjectName»;
		}
		« //helper methods for multi valued references
		FOR multiRef : entity.multiReferences»

			private void forceLoadOf«multiRef.nameInJava.toFirstUpper»(«entityTypeName» «entityObjectName») {
				«entityObjectName».«multiRef.getterMethodName»().size();
			}
			«
			//add methods for adding/remove multi value composite element
			IF multiRef instanceof CompositeRef»
				«var refEntity = multiRef.type»«
				 var refProperyList = refEntity.singleValueProperties
				/* adder method*/ »
				public void «multiRef.adderMethodName»(long id«refProperyList.asParameterString») {
					«entityTypeName» «entityObjectName» = get(id);
					«importedType(refEntity)» «multiRef.nameInJava» = new «refEntity.entityClassName»();
					«multiRef.nameInJava».«multiRef.oppositeSetterName»(«entityObjectName»);
					«FOR singleProp : refProperyList»
						«multiRef.nameInJava».«singleProp.setterMethodName»(«singleProp.nameInJava»);
					«ENDFOR»
					em.persist(«multiRef.nameInJava»);
				}

				public void «multiRef.removeMethodName»(«refEntity.entityClassName» detached«refEntity.entityClassName») {
					«refEntity.entityClassName» «multiRef.nameInJava» = em.merge(detached«refEntity.entityClassName»);
					«entityTypeName» «entityObjectName» = «multiRef.nameInJava».«multiRef.oppositeGetterName»();
					«entityObjectName».«multiRef.getterMethodName»().remove(«multiRef.nameInJava»);
					em.remove(«multiRef.nameInJava»);
				}
			«ENDIF»
		«ENDFOR»
	}
	'''
	}

	def asParameterString(Iterable<Property> properties) {
		properties.join(', ', ', ', null, [importedPropType.objectType + ' ' + nameInJava])
	}
}



