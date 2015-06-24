package de.wwu.pi.acse.dsl.generator.workflow;

import org.eclipse.xtext.resource.generic.AbstractGenericResourceSupport;

import com.google.inject.Module;

import de.wwu.pi.acse.crudDslXX.CrudDslXXRuntimeModule;

public class CrudDslGeneratorSupport extends AbstractGenericResourceSupport {
	@Override
	protected Module createGuiceModule() {
		return new CrudDslXXRuntimeModule();
	}

}
