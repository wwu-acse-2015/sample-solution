package de.wwu.pi.acse.umlToApp.data

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.readableLabel

class EntityClass {
	def generateEntityClass(Class clazz) '''
		package «clazz.entityPackageString»;
		
		import de.wwu.pi.acse.framework.data.AbstractEntity;
		import javax.persistence.*;
		import javax.validation.constraints.*;
		import java.util.*;
		
		@SuppressWarnings("serial")
		@Entity
		public class «clazz.name» extends AbstractEntity {

			//Default Constructor
			public «clazz.name»() {
				super();
			}
			« //Declaration + Get/Set for primitive attributes
			FOR att : clazz.primitiveAttributes»
				
				«IF att.required»
					@NotNull(message="«att.readableLabel» is a required field")
				«ENDIF»
				«att.generateDeclaration»
				«att.generateGetter»
				«att.generateSetter»
			«ENDFOR»
			« //Single referenced objects
			FOR ref : clazz.singleReferences»
				
				«IF ref.required»
					@NotNull(message="«ref.readableLabel» is a required field")
				«ENDIF»
				«ref.associationAnnotation»
				protected «ref.typeAndNameInJava»;
				«ref.generateGetter»
				«ref.generateSetter(ref.opposite)»
			«ENDFOR»
			« //Multi referenced objects
			FOR ref : clazz.multiReferences»
				
				«ref.associationAnnotation»
				protected «ref.typeInJava» «ref.nameInJava» = new ArrayList<«ref.type.javaType»>();
				«ref.generateGetter»
				«ref.generateAdder»
			«ENDFOR»
			
			@Override
			public String toString() {
				return «
				/* for each object concatenate the owned primitive attributes */
				clazz.primitiveAttributes.join(null, ' + ", " + ', ' + ', [generateToStringPart])»""«
				/* generates: (getA()) + ", " + (getB()) + ", " + (getC()) +  ""*/
				/* If nothing is returned return the object id */
				if(clazz.primitiveAttributes.size==0) ' + getId()'»;
			}
		}
	'''

	def associationAnnotation(Property ref) {
		if(ref.isMultivalued) {
			if(ref.opposite.isMultivalued) {
				throw new UnsupportedOperationException("ManyToMany is not supported")
			} else {
				'''@OneToMany(mappedBy="«ref.opposite.nameInJava»")'''
			}
		} else
			if(ref.opposite.isMultivalued) {
				'''@ManyToOne'''
			} else {
				throw new UnsupportedOperationException("OneToOne is not supported")
			}
	}
	
	def static generateAdder(Property p) '''
		protected void «p.adderMethodName»(«p.type.name» elem) {
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
		«p.visibilityInJava» «p.typeAndNameInJava»«appendix»;
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
