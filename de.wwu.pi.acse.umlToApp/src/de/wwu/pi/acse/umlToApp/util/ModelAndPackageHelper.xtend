package de.wwu.pi.acse.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.VisibilityKind

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import java.io.File

class ModelAndPackageHelper {
	
	def static Iterable<Class> allEntities(Model model) {
		model.allOwnedElements.filter(typeof(Class)).filter[it.entity]
	}
	def static getProjectBasePath(Model model) {
		"../../" + model.name.split("\\.").last // @TODO ATTENTION be carefull: src-gen is specified in UmlToAppGenerator
	}

	def static getJavaFolder() {
		"src-gen"
	}

	def static getPathEntity(Model model) {
		model.projectBasePath + "-Persistence" + File.separator + javaFolder
	}

	def static getPathService(Model model) {
		model.projectBasePath + "-EJB" + File.separator + javaFolder
	}

	private def static getPathGui(Model model) {
		model.projectBasePath + "-Web"
	}

	def static getPathGuiBeans(Model model) {
		model.getPathGui + File.separator + javaFolder
	}

	def static getPathGuiPages(Model model) {
		model.getPathGui + File.separator + "WebContent-gen"
	}

	def static toFolderString(String packageName) {
		packageName.replace('.', '/')
	}

	def static packageString(Class clazz) {
		clazz.package.name
	}

	def static entityPackageString(Class clazz) {
		clazz.packageString + ".entity"
	}

	def static logicPackageString(Class clazz) {
		clazz.packageString + ".ejb"
	}

	def static guiPackageString(Class clazz) {
		clazz.packageString + ".web"
	}

	def static visibilityInJava(VisibilityKind kind) {
		switch (kind) {
			case VisibilityKind.PACKAGE_LITERAL: 'package'
			case VisibilityKind.PROTECTED_LITERAL: 'protected'
			case VisibilityKind.PUBLIC_LITERAL: 'public'
			case VisibilityKind.PRIVATE_LITERAL: 'private'
		}
	}

	def static visibilityInJava(Property p) {
		p.visibility.visibilityInJava
	}
}
