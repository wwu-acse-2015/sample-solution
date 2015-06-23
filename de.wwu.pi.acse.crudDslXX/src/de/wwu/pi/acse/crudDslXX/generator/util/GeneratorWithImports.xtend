package de.wwu.pi.acse.crudDslXX.generator.util

import java.util.HashSet

import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference

abstract class GeneratorWithImports<E> {
	public static val IMPORTS_MARKER = "//$GENERATED_IMPORTS_HERE$"
	val HashSet<String> imports = newHashSet

	def generate(E elem) {
		elem.doGenerate.toString.replace(IMPORTS_MARKER, imports.sort.map['''import «it»;'''].join('\n'))
	}

	def CharSequence doGenerate(E elem)

	def imported(String imp) {
		imports.add(imp)
		imp.substring(imp.lastIndexOf('.') + 1)
	}

	def importedType(Entity type) {
		imported(type.entityPackageString + '.' + type.entityClassName)
		type.entityClassName
	}

	def dispatch importedPropType(Attribute prop) {
		prop.typeInJava
	}

	def dispatch importedPropType(AbstractReference prop) {
		prop.type.importedType
	}
}
