package de.wwu.pi.acse.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.NamedElement
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import java.util.Collection

class GUIHelper { 
	// from http://stackoverflow.com/a/2560017
	static val REGEX_SPLIT_CAMEL_CASE = 
		"(?<=[A-Z])(?=[A-Z][a-z])" + '|' + //UC behind me, UC followed by LC in front of me (e.g. PDFReader > PDF Reader)
		"(?<=[^A-Z])(?=[A-Z])" + '|' + //non-UC behind me, UC in front of me (e.g. MyClass > My Class; 99Bottles > 99 Bottles)
		"(?<=[A-Za-z])(?=[^A-Za-z])" //Letter behind me, non-letter in front of me  (e.g. May15 > May 15
	def static camelCaseToLabel(String camelCaseString) {
		camelCaseString.replaceAll(REGEX_SPLIT_CAMEL_CASE, " ")
	}

	def static readableLabel(NamedElement named) {
		named.name.camelCaseToLabel.toFirstUpper
	}
	
	def static generateEjbDefinition(Class clazz, GeneratorWithImports generator)
		'''«clazz.generateEjbDefinition(generator, clazz.ejbServiceName)»'''

	def static generateEjbDefinition(Class clazz, GeneratorWithImports generator, CharSequence ejbName) {
		'''
			@EJB« /* pay attention to the imported declaration */»
			private «generator.imported(clazz.logicPackageString + '.' + clazz.serviceClassName)» «ejbName»;
		'''
	}

	def static ejbServiceName(Class clazz)
		'''«clazz.name.toFirstLower»Service'''

	def static generateServiceBeanAndGetAllForReferencedClasses(GeneratorWithImports generator, Class clazz) {
		generateServiceBeanAndGetAllForReferencedClasses(generator, #[clazz], #[])
	}

	def static generateServiceBeanAndGetAllForReferencedClasses(GeneratorWithImports generator, Collection<Class> clazzes, Collection<Class> excludeClazzes) {
		'''
		«FOR referencedClass : clazzes.map[singleReferences.map[type as Class]].reduce[p1, p2| p1 + p2].toSet.filter[ !excludeClazzes.contains(it)]»
			«referencedClass.generateEjbDefinition(generator)»

			public Collection<«generator.importedType(referencedClass)»> getAllOfType«referencedClass.javaType»() {
				return «referencedClass.ejbServiceName».getAll();
			}
		«ENDFOR»
		'''
	}
	
	def static generateElementsFor(Class clazz, Property property) {
		clazz.generateElementsFor(property, clazz.createBeanClassName.toFirstLower)
	}
	
	def static generateElementsFor(Class clazz, Property property, CharSequence beanName) {
		val idValue = '''#{«beanName».«clazz.javaType.toFirstLower».«property.name»}'''
		val elementId = property.name
		'''
		<h:outputLabel value="«property.readableLabel»" for="«property.name»" />
		«generateInputElementFor(property, idValue, beanName, elementId)»
		<h:message for="«property.name»" />
		'''
	}

	def static generateInputElementFor(Property property, CharSequence idValue, CharSequence beanName, CharSequence elementId) {
		if (property.type.isEntity) '''
			<h:selectOneMenu id="«elementId»" value="«idValue»" converter="#{«(property.type as Class).converterClassName.toFirstLower»}">
				«IF !property.required»
					<f:selectItem itemLabel="Select nothing" itemValue="#{null}"/>
				«ENDIF»
				<f:selectItems value="#{«beanName».allOfType«property.type.name»}" />
			</h:selectOneMenu>
		''' else if (property.isDate) '''
			<h:inputText id="«elementId»" value="«idValue»" p:placeholder="e.g. 2015-06-30 13:30">
				<f:convertDateTime pattern="yyyy-MM-dd HH:mm" timeZone="Europe/Berlin"/>
			</h:inputText>
		''' else '''
			<h:inputText id="«elementId»" value="«idValue»" />
		'''
	}
		
	def static generateLink(Class clazz, CharSequence idValue) {
		clazz.generateLink(idValue, "Details")
	}

	def static generateLink(Class clazz, CharSequence idValue, CharSequence displayValue) {
		clazz.generateLink(idValue, displayValue, null)
	}

	def static generateLink(Class clazz, CharSequence idValue, CharSequence displayValue, CharSequence linkId) '''
		<h:link«if(linkId!=null) {' id="' + linkId +'"'}» outcome="/«clazz.javaType.toFirstLower»/details.xhtml">
			<f:param name="id" value="«idValue»"></f:param>
			«displayValue»
		</h:link>
	'''
}
