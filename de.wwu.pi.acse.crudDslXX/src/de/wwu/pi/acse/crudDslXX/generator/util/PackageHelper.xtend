package de.wwu.pi.acse.crudDslXX.generator.util

//import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import java.io.File
import de.wwu.pi.acse.crudDslXX.crudDslXX.CrudModel
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity

class PackageHelper {
	
	def static getProjectBasePath(CrudModel model) {
		model.title ?: model.name.split("\\.").last
	}

	def static getJavaFolder() {
		"src-gen"
	}

	def static getPathEntity(CrudModel model) {
		model.projectBasePath + "-Persistence" + File.separator + javaFolder
	}

	def static getPathService(CrudModel model) {
		model.projectBasePath + "-EJB" + File.separator + javaFolder
	}

	private def static getPathGui(CrudModel model) {
		model.projectBasePath + "-Web"
	}

	def static getPathGuiBeans(CrudModel model) {
		model.getPathGui + File.separator + javaFolder
	}

	def static getPathGuiPages(CrudModel model) {
		model.getPathGui + File.separator + "WebContent-gen"
	}

	def static toFolderString(String packageName) {
		packageName.replace('.', File.separator)
	}

	def static packageString(Entity entity) {
		entity.modelElement.name
	}

	def static entityPackageString(Entity entity) {
		entity.packageString + ".entity"
	}

	def static logicPackageString(Entity entity) {
		entity.packageString + ".ejb"
	}

	def static guiPackageString(Entity entity) {
		entity.packageString + ".web"
	}
}
