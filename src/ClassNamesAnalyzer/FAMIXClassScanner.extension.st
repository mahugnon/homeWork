Extension { #name : #FAMIXClassScanner }

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

{ #category : #'*ClassNamesAnalyzer' }
FAMIXClassScanner class >> reportClass [
	^ClassScanReport
]
