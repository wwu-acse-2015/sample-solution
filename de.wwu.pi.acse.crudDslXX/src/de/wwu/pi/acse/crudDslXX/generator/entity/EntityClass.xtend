package de.wwu.pi.acse.crudDslXX.generator.entity

import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.CompositeRef
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property
import de.wwu.pi.acse.crudDslXX.crudDslXX.Reference

import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

class EntityClass {
	def generateEntityClass(Entity entity) '''
		package «entity.entityPackageString»;
		
		import de.wwu.pi.acse.framework.data.AbstractEntity;
		import javax.persistence.*;
		import javax.validation.constraints.*;
		import java.util.*;
		
		@SuppressWarnings("serial")
		@Entity
		public class «entity.entityClassName» extends AbstractEntity {

			//Default Constructor
			public «entity.entityClassName»() {
				super();
			}
			« //Declaration + Get/Set for primitive attributes
			FOR att : entity.attributes»
				
				«IF att.required»
					@NotNull(message="«att.readableName» is a required field")
				«ENDIF»
				«att.generateDeclaration»
				«att.generateGetter»
				«att.generateSetter»
			«ENDFOR»
			« //Single referenced objects
			FOR ref : entity.references.filter[singleValued]»
				
				«IF ref.required»
					@NotNull(message="«ref.readableName» is a required field")
				«ENDIF»
				«ref.associationAnnotation»
				protected «ref.typeAndNameInJava»;
				«ref.generateGetter»
				«ref.generateSetter(ref.opposite)»
			«ENDFOR»
			« //Multi referenced objects
			FOR ref : entity.multiReferences»
				
				«ref.associationAnnotation»
				protected «ref.typeInJava» «ref.nameInJava» = new ArrayList<«ref.javaType»>();
				«ref.generateGetter»
				«ref.generateAdder»
			«ENDFOR»
			
			@Override
			public String toString() {
				return «
				/* for each object concatenate the owned primitive attributes */
				entity.attributes.join(null, ' + ", " + ', ' + ', [generateToStringPart])»""«
				/* generates: (getA()) + ", " + (getB()) + ", " + (getC()) +  ""*/
				/* If nothing is returned return the object id */
				if(entity.attributes.size==0) ' + getId()'»;
			}
			«IF entity.isComposite»
				« val compositeRef = entity.eContainer as CompositeRef»«
				 val attributeName = compositeRef.oppositeNameInJava»«
				 val attributeType = compositeRef.entity.entityClassName»
				@NotNull(message="Reference to owning element is a required field")
				@ManyToOne
				protected «attributeType» «attributeName»;
				public «attributeType» «compositeRef.oppositeGetterName»() {
					return «attributeName»;
				}
				public void «compositeRef.oppositeSetterName»(«attributeType» «attributeName») {
					this.«attributeName» = «attributeName»;
				}
			«ENDIF»
		}
	'''

	def associationAnnotation(AbstractReference ref) {
		
		if(!ref.singleValued) {
			if(!ref.oppositeSingleValued) {
				throw new UnsupportedOperationException("ManyToMany is not supported")
			} else {
				'''@OneToMany(mappedBy="«ref.oppositeNameInJava»")'''
			}
		} else
			if(!ref.oppositeSingleValued) {
				'''@ManyToOne'''
			} else {
				throw new UnsupportedOperationException("OneToOne is not supported")
			}
	}
	
	def static dispatch oppositeNameInJava(Reference ref) {
		ref.opposite.nameInJava
	}
	def static dispatch oppositeNameInJava(CompositeRef ref) {
		'parentElement'
	}
	def private static dispatch oppositeSingleValued(Reference ref) {
		ref.opposite.singleValued
	}
	def private static dispatch oppositeSingleValued(CompositeRef ref) {
		true
	}
	def static oppositeGetterName(CompositeRef ref) {
		'''get«ref.oppositeNameInJava.toFirstUpper»'''
	}
	def static oppositeSetterName(CompositeRef ref) {
		'''set«ref.oppositeNameInJava.toFirstUpper»'''
	}
		
	def static generateAdder(Property p) '''
		protected void «p.adderMethodName»(«p.javaType» elem) {
			«p.nameInJava».add(elem);
		}
	'''

	def static generateGetter(Property p)
		'''«p.generateGetter('')»'''

	def static generateGetter(Property p, CharSequence appendix) '''
		public «p.typeInJava» «p.getterMethodName»«appendix»() {
			return «p.nameInJava»«appendix»;
		}
	'''

	def static generateDeclaration(Property p)
		'''«p.generateDeclaration('')»'''

	def static generateDeclaration(Property p, CharSequence appendix) '''
		protected «p.typeAndNameInJava»«appendix»;
	'''

	def static generateSetter(Property p)
		'''«p.generateSetter('')»'''

	def static generateSetter(Property p, CharSequence appendix) {
		generateSetter(p, null, appendix)
	}

	def static generateSetter(Property p, Property opposite) {
		generateSetter(p, opposite, '')
	}

	def static generateSetter(Property p, Property opposite, CharSequence appendix) '''
		public void «p.setterMethodName»«appendix»(«p.typeAndNameInJava») {
			this.«p.nameInJava»«appendix» = «p.nameInJava»;
		}
	'''

	//Generates toString part for one property 
	def generateToStringPart(Property p) {
		val callToGetter = '''«p.getterMethodName»()''';
		//if p is not required it might be null, then print '-'
		'''(«IF !p.required»(«callToGetter»==null)?"-":«ENDIF»«callToGetter»)'''
	}
}
