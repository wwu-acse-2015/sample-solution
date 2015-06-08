package de.wwu.pi.acse.umlToApp.web.beans

import de.wwu.pi.acse.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*

class ListBeanGenerator extends GeneratorWithImports {
	override doGenerate(Class clazz) '''
		package «clazz.guiPackageString»;
		
		import java.util.Collection;
		
		import javax.ejb.EJB;
		import javax.faces.bean.ManagedBean;
		«IMPORTS_MARKER»
		
		@ManagedBean
		public class «clazz.listViewClassName» {
		
			«clazz.generateEjbDefinition(this)»
		
			public Collection<«importedType(clazz)»> getAll() {
				return «clazz.ejbServiceName».getAll();
			}
		}
	'''
}
