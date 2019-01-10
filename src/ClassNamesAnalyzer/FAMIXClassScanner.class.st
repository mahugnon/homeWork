Class {
	#name : #FAMIXClassScanner,
	#superclass : #VocabularyScanner,
	#category : #ClassNamesAnalyzer
}

{ #category : #'*ClassNamesAnalyzer' }
FAMIXClassScanner class >> reportClass [
	^ClassScanReport
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXClassScanner >> defaultMetrics [
	"use 'aFAMIXClassScanner classNamesScanReport' whenever an expensive computation is required and has been computed in a previous metric
	Example : rootClass uses the metric superclasses"
	
		^ Dictionary new
		at: 'scannedClasses' put: [ :aFAMIXClassScanner | aFAMIXClassScanner scannedClass  ];
		at: 'className' put: [ :aFAMIXClassScanner | aFAMIXClassScanner scannedClass name ];
		at: 'classSuffix' put: [ :aFAMIXClassScanner | aFAMIXClassScanner scannedClass name splitWithCamelCase last];
		at: 'superclasses' put: [  :aFAMIXClassScanner | aFAMIXClassScanner scannedClass superclasses ];
		at: 'package' put: [  :aFAMIXClassScanner | aFAMIXClassScanner scannedClass parentPackage ];
		at: 'superclassesInCurrentPackage' put: [  :aFAMIXClassScanner | (aFAMIXClassScanner classNamesScanReport at: 'superclasses' ifAbsentPut: [  (self defaultMetrics at: 'superclasses') value: aFAMIXClassScanner  ]) select: [ :aFamixPackage| aFamixPackage parentPackage = aFAMIXClassScanner scannedClass parentPackage] ];
		at: 'superclasse' put: [  :aFAMIXClassScanner | aFAMIXClassScanner scannedClass superclass ];
		at: 'rootClass' put: [  :aFAMIXClassScanner | (aFAMIXClassScanner classNamesScanReport at: 'superclasses' ifAbsentPut: [  (self defaultMetrics at: 'superclasses') value: aFAMIXClassScanner  ]) first  ];
		at: 'isRoot' put: [ :aFAMIXClassScanner |
			scannedEntities isaRootClass
			] ;
		at: 'isMetaRoot' put: [ :aFAMIXClassScanner |
			scannedEntities isMetaRoot
			] ;
		"|className rootClassName| 
			className := aFAMIXClassScanner classNamesScanReport
				at: 'className'
				ifAbsentPut: [ (self defaultMetrics at: 'className') value: aFAMIXClassScanner ].
			rootClassName := (aFAMIXClassScanner classNamesScanReport
				at: 'rootClass'
				ifAbsentPut: [ (self defaultMetrics at: 'rootClass') value: aFAMIXClassScanner ]) name.
				
				className = rootClassName ]"


		yourself
]

{ #category : #VocabularyScanning }
FAMIXClassScanner >> generateaClassNamesScanReport [
	classNamesScanReport := ClassScanReport new.
	classNamesScanReport scannedEntity: scannedEntities.
	self definedMetrics associations do:[:each| classNamesScanReport at: each key ifAbsentPut: (each value value: self)].
	^classNamesScanReport
]

{ #category : #accessing }
FAMIXClassScanner >> scannedClass [
	^ self scannedEntities
]

{ #category : #accessing }
FAMIXClassScanner >> scannedClass: aFAMIXClass [ 
	self scannedEntities: aFAMIXClass 
]
