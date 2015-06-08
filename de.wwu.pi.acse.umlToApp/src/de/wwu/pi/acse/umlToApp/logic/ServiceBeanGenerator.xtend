package de.wwu.pi.acse.umlToApp.logic

import de.wwu.pi.acse.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import org.eclipse.uml2.uml.AggregationKind

class ServiceBeanGenerator extends GeneratorWithImports{
	override doGenerate(Class clazz) '''
	«val objectType = clazz.name»
	«val objectName = clazz.nameInJava»
	package «clazz.logicPackageString»;

	import javax.ejb.Stateless;

	«IMPORTS_MARKER»
	import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

	@Stateless
	public class «clazz.serviceClassName» extends AbstractServiceBean<«importedType(clazz)»> {

		public «objectType» create(«objectType» «objectName») {
			em.persist(«objectName»);
			return «objectName»;
		}

		@Override
		public «objectType» getWithFetchedReferences(long id) {
			«objectType» «objectName» = get(id);
			«FOR multiRef : clazz.multiReferences»
				forceLoadOf«multiRef.nameInJava.toFirstUpper»(«objectName»);
			«ENDFOR»
			return «objectName»;
		}

		public void remove(long id) {
			em.remove(get(id));
		}

		public «objectType» updateMasterData(«objectType» «objectName») {
			«objectType» attached«clazz.nameInJava.toFirstUpper» = get(«objectName».getId());
			« // iterate over single value proerties and save value
			FOR singleValProp : clazz.singleValueProperties»
				attached«clazz.nameInJava.toFirstUpper».«singleValProp.setterMethodName»(«objectName».«singleValProp.getterMethodName»());
			«ENDFOR»
			return «clazz.nameInJava»;
		}
		« //helper methods for multi valued references
		FOR multiRef : clazz.multiReferences»

			«var refClass = (multiRef.type as Class)»
			private void forceLoadOf«multiRef.nameInJava.toFirstUpper»(«objectType» «objectName») {
				«objectName».«multiRef.getterMethodName»().size();
			}
			«
			//add methods for adding/remove multi value composite element
			IF multiRef.aggregation == AggregationKind.COMPOSITE_LITERAL»
				«var refProperyList = refClass.singleValueProperties.filter[it.name != multiRef.opposite.name]
				/* adder method*/ »
				public void «multiRef.adderMethodName»(long id«refProperyList.asParameterString») {
					«objectType» «objectName» = get(id);
					«importedType(refClass)» «multiRef.nameInJava» = new «refClass.name»();
					«multiRef.nameInJava».«multiRef.opposite.setterMethodName»(«objectName»);
					«FOR singleProp : refProperyList»
						«multiRef.nameInJava».«singleProp.setterMethodName»(«singleProp.nameInJava»);
					«ENDFOR»
					em.persist(«multiRef.nameInJava»);
				}

				public void removeFrom«multiRef.nameInJava.toFirstUpper»(«refClass.name» detached«refClass.name») {
					«refClass.name» «multiRef.nameInJava» = em.merge(detached«refClass.name»);
					«objectType» «objectName» = «multiRef.nameInJava».«multiRef.opposite.getterMethodName»();
					«objectName».«multiRef.getterMethodName»().remove(«multiRef.nameInJava»);
					em.remove(«multiRef.nameInJava»);
				}
			«ENDIF»
		«ENDFOR»
	}
	'''

	def nameInJava(Class clazz) {
		return clazz.name.toFirstLower
	}
	
		def asParameterString(Iterable<Property> properties) {
		properties.forEach[importedType(type)]
		properties.join(', ', ', ', null, [typeInJava.objectType + " " + nameInJava])
	}
}



