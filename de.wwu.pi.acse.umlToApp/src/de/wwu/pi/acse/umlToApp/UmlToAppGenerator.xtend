package de.wwu.pi.acse.umlToApp

import de.wwu.pi.acse.umlToApp.data.EntityClass
import de.wwu.pi.acse.umlToApp.logic.ServiceBeanGenerator
import de.wwu.pi.acse.umlToApp.web.beans.CreateBeanGenerator
import de.wwu.pi.acse.umlToApp.web.beans.DetailsBeanGenerator
import de.wwu.pi.acse.umlToApp.web.beans.EntityConverterGenerator
import de.wwu.pi.acse.umlToApp.web.beans.ListBeanGenerator
import de.wwu.pi.acse.umlToApp.web.pages.CreateViewGenerator
import de.wwu.pi.acse.umlToApp.web.pages.DetailsViewGenerator
import de.wwu.pi.acse.umlToApp.web.pages.ListViewGenerator
import de.wwu.pi.acse.umlToApp.web.pages.MasterPageGenerator
import de.wwu.pi.acse.umlToApp.web.pages.NavigationGenerator
import de.wwu.pi.acse.umlToApp.web.pages.WebDescriptionGenerator
import java.io.File
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*

class UmlToAppGenerator implements IGenerator {
	static val INTERNAL_MODEL_EXTENSIONS = newArrayList(".library.uml", ".profile.uml", ".metamodel.uml")

	def static isModel(Resource input) {
		!INTERNAL_MODEL_EXTENSIONS.exists(ext|input.URI.path.endsWith(ext))
	}

	override doGenerate(Resource input, IFileSystemAccess fsa) {
		System::out.print("UmlToAppGenerator.doGenerate called with resource " + input.URI)
		if (isModel(input)) {
			System::out.println(" - Generating ...")
			input.contents.filter(typeof(Model)).forEach[doGenerate(fsa)]
		} else
			System::out.println(" - Skipped.")
	}

	def doGenerate(Model model, IFileSystemAccess fsa) {
		//process single entities
		model.allEntities.forEach[processEntity(fsa)]
		
		//Process model specific elements
		generateNavigation(fsa, model)
		generateXMLDescriptor(fsa, model)
	}
	
	def processEntity(Class clazz, IFileSystemAccess fsa) {
		//Generate Entity Class
		fsa.createAndGenerateFile(
			'''«clazz.model.pathEntity»/«clazz.entityPackageString.toFolderString»/«clazz.name».java''',
			new EntityClass().generateEntityClass(clazz)
		)
		
		if(clazz.isCompositeEntity) {
			// no dedicated beans and views required
		} else {
  		// Generate Service Bean
			fsa.createAndGenerateFile(
				'''«clazz.model.pathService»/«clazz.logicPackageString.toFolderString»/«clazz.serviceClassName».java''',
				new ServiceBeanGenerator().generate(clazz)
			)
			// Generate entity converters
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiBeans»/«clazz.guiPackageString.toFolderString»/«clazz.javaType»Converter.java''',
				new EntityConverterGenerator().generate(clazz)
			)

			//Generate list backing beans
	  		fsa.createAndGenerateFile(
	  		  '''«clazz.model.pathGuiBeans»/«clazz.guiPackageString.toFolderString»/«clazz.listViewClassName».java''',
	  			new ListBeanGenerator().generate(clazz)
	  		)
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiPages»/«clazz.name.toFirstLower»/list.xhtml''',
				new ListViewGenerator().generate(clazz)
			)

			//Generate create beans
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiBeans»/«clazz.guiPackageString.toFolderString»/«clazz.createViewClassName».java''',
				new CreateBeanGenerator().generate(clazz)
			)
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiPages»/«clazz.name.toFirstLower»/create.xhtml''',
				new CreateViewGenerator().generate(clazz)
			)

			//Generate details beans
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiBeans»/«clazz.guiPackageString.toFolderString»/«clazz.detailsViewClassName».java''',
				new DetailsBeanGenerator().generate(clazz)
			)
			fsa.createAndGenerateFile(
				'''«clazz.model.pathGuiPages»/«clazz.name.toFirstLower»/details.xhtml''',
				new DetailsViewGenerator().generate(clazz)
			)
		}
	}
	
	def generateXMLDescriptor(IFileSystemAccess fsa, Model model) {
		fsa.createAndGenerateFile('''«model.allEntities.head.model.pathGuiPages»/WEB-INF/web.xml''',
			new WebDescriptionGenerator().generate(model))
	}
	
	def generateNavigation(IFileSystemAccess fsa, Model model) {
		//Generate navigation component and xml descriptors
		fsa.createAndGenerateFile('''«model.allEntities.head.model.pathGuiPages»/resources/navigation.xhtml''',
			new NavigationGenerator().generate(model))
		fsa.createAndGenerateFile('''«model.allEntities.head.model.pathGuiPages»/resources/master.xhtml''',
			new MasterPageGenerator().generate(model))
	}
	
	/**
	 * workaround to prevent "ERROR esource.generic.XMLEncodingProvider  - Error detecting encoding"
	 */
	def static createAndGenerateFile(IFileSystemAccess fsa, String fileName, CharSequence contents) {
		var targetFile = new File("src-gen" + File.separator + fileName) //@TODO ATTENTION be carefull: src-gen is specified in UmlToAppGenerator 
		var parent = targetFile.parentFile
		if (!parent.exists() && !parent.mkdirs()) {
			throw new IllegalStateException("Couldn't create dir: " + parent);
		}
		targetFile.createNewFile
		fsa.generateFile(fileName, contents)
	}
}
