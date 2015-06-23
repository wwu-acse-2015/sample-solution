package de.wwu.pi.acse.crudDslXX.generator.web.pages

import de.wwu.pi.acse.crudDslXX.crudDslXX.CrudModel
import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage

import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

class NavigationGenerator {
	def generate(CrudModel model) '''
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml"
		  xmlns:h="http://java.sun.com/jsf/html"
		  xmlns:f="http://java.sun.com/jsf/core"
		  xmlns:c="http://java.sun.com/jsp/jstl/core"
		  xmlns:ui="http://java.sun.com/jsf/facelets">
		<body>
			«model.generateListLinks»
		</body>
		</html>
	'''

	def generateListLinks(CrudModel model) {
		model.listPages.map[generateListLink].join(" | ")
	}
		
	def generateListLink(ListPage page) '''
		<h:link outcome="«page.entity.urlToListPage»">«page.actualTitle»</h:link>
	'''
	
}
