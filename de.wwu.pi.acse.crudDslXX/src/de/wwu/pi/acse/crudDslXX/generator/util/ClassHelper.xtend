package de.wwu.pi.acse.crudDslXX.generator.util

import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property

import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

class ClassHelper { 
	
	def static entityClassName(Entity e) {
		e.name + ''
	}
	
	def static serviceClassName(Entity entity) {
		entity.name + 'ServiceBean'
	}

	def static listViewClassName(ListPage page) {
		page.name + ''
	}

	def static createBeanClassName(EntryPage page) {
		page.name + 'Create'
	}
	
	def static detailsBeanClassName(EntryPage page) {
		page.name + ''
	}

	def static converterClassName(Entity entity) {
		entity.name + 'Converter'
	}

	//-------------------------------------------------------------------------------------
	// Properties and references
	//-------------------------------------------------------------------------------------
	
	def static typeAndNameInJava(Property p) {
		'''«p.typeInJava» «p.nameInJava»'''
	}

	/** get the type representation of properties in Java 
	 * incl. multivalue type e.g. multivalued properties as List<p.javaType>
	 */
	def static typeInJava(Property p) {
		if (!p.singleValued)
			'Collection<' + p.javaType + '>'
		else
			p.javaType
	}

	def static dispatch javaType(Attribute p) {
		if(p.isDate)
			return 'Date'
		if(p.isNumberObject)
			return 'Integer'
		if(p.isString)
			return 'String'
	}
	
	def static dispatch javaType(AbstractReference ref) {
		ref.type.entityClassName
	}

	def static nameInJava(Property p) {
		p.name
	}

	def static adderMethodName(Property p)
		'''addTo«p.name.toFirstUpper»'''
		
	def static removeMethodName(Property p)
		'''removeFrom«p.name.toFirstUpper»'''

	def static getterMethodName(Property p)
		'''get«p.name.toFirstUpper»'''

	def static setterMethodName(Property p)
		'''set«p.name.toFirstUpper»'''

	/**
	 * get java object type for primitive java types
	 */
	def static objectType(String javaType) {
		switch (javaType) {
			case "boolean": "Boolean"
			case "int": "Integer"
			case "double": "Double"
			default: javaType
		}
	}
}
