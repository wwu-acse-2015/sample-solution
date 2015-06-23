package de.wwu.pi.acse.crudDslXX.generator.web.pages


import de.wwu.pi.acse.crudDslXX.crudDslXX.Page

abstract class AbstractViewGenerator<E extends Page> {
	def generate(E page) '''
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml"
			xmlns:h="http://java.sun.com/jsf/html"
			xmlns:f="http://java.sun.com/jsf/core"
			xmlns:p="http://xmlns.jcp.org/jsf/passthrough"
			xmlns:ui="http://java.sun.com/jsf/facelets">
		«page.generateBody»
		</html>
	'''
	
	def CharSequence generateBody(E page)
}