package de.wwu.pi.acse.umlToApp.util

import org.eclipse.uml2.uml.AggregationKind
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Element
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.Type

import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*

class ClassHelper { 
	
	def static serviceClassName(Type clazz) {
		clazz.name + 'ServiceBean'
	}

	def static listViewClassName(Type clazz) {
		clazz.name + 'List'
	}

	def static createBeanClassName(Type clazz) {
		clazz.name + 'Create'
	}
	
	def static detailsBeanClassName(Type clazz) {
		clazz.name + 'Details'
	}

	def static converterClassName(Type clazz) {
		clazz.name + 'Converter'
	}

	def static createViewClassName(Type clazz) {
		clazz.name + 'Create'
	}
	
	def static detailsViewClassName(Type type) {
		type.name +'Details'
	}
	
	def static isDate(Property p) {
		"Date".equals(p.type.name)
	}

	def static isString(Property p) {
		"String".equals(p.type.name)
	}
	
	def static isNumberObject(Property p) {
		"Integer".equals(p.type.name)
	}
	
	def static isNumberPrimitiv(Property p) {
		"int".equals(p.type.name)
	}
	
	//Note that more specific types are handled first, thus 'Class' is handled before 'Element'.
	// org.eclipse.uml2.uml.Class is subclass of org.eclipse.uml2.uml.Element
	def static dispatch isEntity(Element element) {
		false
	}

	def static dispatch isEntity(Class clazz) {
		clazz.appliedStereotypes.exists[name == "Entity"]
	}

	def static isCompositeEntity(Class clazz) {
		clazz.owningReferenceForComposite != null
	}

	def static owningReferenceForComposite(Class clazz) {
		clazz.entityReferences.findFirst[it.opposite.aggregation == AggregationKind.COMPOSITE_LITERAL]
	}
	
	//-------------------------------------------------------------------------------------
	// Properties and references
	//-------------------------------------------------------------------------------------

	def static Iterable<Property> attributes(Class clazz) {
			clazz.attributes
	}
	
	def static primitiveAttributes(Class clazz) {
		/* For now, only consider single-valued attributes */
		clazz.attributes.filter[!it.multivalued && !type.entity]
	}

	def static entityReferences(Class clazz) {
		clazz.attributes.filter[type.entity]
	}

	def static singleReferences(Class clazz) {
		clazz.entityReferences.filter[!it.multivalued]
	}

	def static multiReferences(Class clazz) {
		clazz.entityReferences.filter[it.multivalued]
	}

	/** primitive attributes and single References */
	def static singleValueProperties(Class clazz) {
		clazz.attributes.filter[!multivalued]
	}

	def static Iterable<Property> required(Iterable<Property> properties) {
		properties.filter[it.required]
	}

	def static isRequired(Property p) {
		p.lowerBound >= 1
	}

	def static requiredProperties(Class clazz) {
		clazz.singleValueProperties.required
	}

	def static optionalProperties(Class clazz) {
		clazz.singleValueProperties.filter[!it.required]
	}


	def static typeAndNameInJava(Property p) {
		'''«p.typeInJava» «p.nameInJava»'''
	}

	/** get the type representation of properties in Java 
	 * incl. multivalue type e.g. multivalued properties as List<p.javaType>
	 */
	def static typeInJava(Property p) {
		if (p.multivalued)
			'Collection<' + p.type.javaType + '>'
		else
			p.type.javaType
	}

	def static javaType(Type type) {
		type.name
	}

	def static nameInJava(Property p) {
		p.name
	}

	def static adderMethodName(Property p)
		'''addTo«p.name.toFirstUpper»'''

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
