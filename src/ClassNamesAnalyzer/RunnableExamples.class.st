Class {
	#name : #RunnableExamples,
	#superclass : #Object,
	#category : #'ClassNamesAnalyzer-Reports'
}

{ #category : #'as yet unclassified' }
RunnableExamples class >> loadInMoose: aClassHierarchy [
	| packages model importer HierarchyToAnalze |
	HierarchyToAnalze := aClassHierarchy.
	model := MooseModel new.
	importer := MoosePharoImporterTask new model: model.
	importer
		importingContext:
			(MooseImportingContext new
				mergeClassAndMetaclass;
				importClass;
				importPackage;
				importInheritance;
				yourself).
	packages := HierarchyToAnalze allSubclasses collect: [ :each | each package name ] as: Set.
	packages do: [ :each | importer addFromPackageNamed: each ].
	importer run.
	model name: HierarchyToAnalze name.
	^ model install
]
