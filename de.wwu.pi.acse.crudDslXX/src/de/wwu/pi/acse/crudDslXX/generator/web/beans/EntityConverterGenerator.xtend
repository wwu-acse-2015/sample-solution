package de.wwu.pi.acse.crudDslXX.generator.web.beans

import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.generator.util.GeneratorWithImports

import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*

class EntityConverterGenerator extends GeneratorWithImports<Entity> {
	override doGenerate(Entity entity) '''
		package «entity.guiPackageString»;

		import javax.ejb.EJB;
		import javax.faces.bean.ManagedBean;

		import de.wwu.pi.acse.framework.logic.AbstractServiceBean;
		import de.wwu.pi.acse.framework.web.AbstractConverter;

		«IMPORTS_MARKER»

		@ManagedBean(name="«entity.converterClassName.toFirstLower»")
		public class «entity.converterClassName» extends AbstractConverter<«entity.entityClassName»> {

			@EJB
			private «imported(entity.logicPackageString + "." + entity.serviceClassName)» service;

			public AbstractServiceBean<«importedType(entity)»> getService() {
				return service;
			}
		}
	'''
}
