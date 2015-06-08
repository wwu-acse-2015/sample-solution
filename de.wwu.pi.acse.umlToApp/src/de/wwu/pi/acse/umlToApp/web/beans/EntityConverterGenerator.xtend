package de.wwu.pi.acse.umlToApp.web.beans

import de.wwu.pi.acse.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*

class EntityConverterGenerator extends GeneratorWithImports {
	override doGenerate(Class clazz) '''
		package «clazz.guiPackageString»;

		import javax.ejb.EJB;
		import javax.faces.bean.ManagedBean;

		import de.wwu.pi.acse.framework.logic.AbstractServiceBean;
		import de.wwu.pi.acse.framework.web.AbstractConverter;

		«IMPORTS_MARKER»

		@ManagedBean(name="«clazz.converterClassName.toFirstLower»")
		public class «clazz.converterClassName» extends AbstractConverter<«clazz.javaType»> {

			@EJB
			private «imported(clazz.logicPackageString + "." + clazz.serviceClassName)» service;

			public AbstractServiceBean<«importedType(clazz)»> getService() {
				return service;
			}
		}
	'''
}
