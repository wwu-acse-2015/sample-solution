package de.wwu.pi.acse.dsl.generator.workflow;

import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.xtext.generator.IGenerator;
import org.eclipse.xtext.resource.generic.AbstractGenericResourceRuntimeModule;

import de.wwu.pi.acse.crudDslXX.generator.CrudDslXXGenerator;

public class CrudDslGeneratorModule extends
		AbstractGenericResourceRuntimeModule {

	@Override
	protected String getLanguageName() {
		return "de.wwu.pi.acse.crudDslXX.CrudDslXX.xtext";
	}

	@Override
	protected String getFileExtensions() {
		return "crudXX";
	}

	public Class<? extends IGenerator> bindIGenerator() {
		return CrudDslXXGenerator.class;

	}

	public Class<? extends ResourceSet> bindResourceSet() {
		return ResourceSetImpl.class;
	}
}
