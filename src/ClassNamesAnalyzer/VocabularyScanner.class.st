Class {
	#name : #VocabularyScanner,
	#superclass : #Object,
	#instVars : [
		'classNamesScanReport',
		'scannedEntities',
		'definedMetrics'
	],
	#category : #ClassNamesAnalyzer
}

{ #category : #'as yet unclassified' }
VocabularyScanner class >> defaultMetrics [
	^self subclassResponsibility
]

{ #category : #'instance-creation' }
VocabularyScanner class >> reportClass [
	^self subclassResponsibility
]

{ #category : #'instance-creation' }
VocabularyScanner class >> scan: aFAMIXPackageGroup [ 
	|aVocabularyScanner|
	
	aVocabularyScanner := (self new scannedEntities: aFAMIXPackageGroup) generateaClassNamesScanReport;yourself.
	aFAMIXPackageGroup vocabularyScanner: aVocabularyScanner.
	^aVocabularyScanner
]

{ #category : #metrics }
VocabularyScanner >> addaMetric: metricName with: aBlock [
	definedMetrics at: metricName put: aBlock
	
]

{ #category : #metrics }
VocabularyScanner >> allClassNameSuffixesSorted: suffixScanReports [

	| agregatedSuffixScanReports |
	agregatedSuffixScanReports := OrderedCollection new.
				[suffixScanReports notEmpty] whileTrue: [ 
				|aSuffixDescriptor descriptorsOfSameSuffix indexesOfDescriptorsOfSameSuffix| 
				indexesOfDescriptorsOfSameSuffix := OrderedCollection new.
				aSuffixDescriptor := suffixScanReports first.
				suffixScanReports removeFirst.
				1 to: suffixScanReports size do: [:index| (((suffixScanReports at:index) suffix) = aSuffixDescriptor suffix) ifTrue: [indexesOfDescriptorsOfSameSuffix add: index]].
				descriptorsOfSameSuffix := indexesOfDescriptorsOfSameSuffix collect: [ :i| suffixScanReports at: i ].
				
				aSuffixDescriptor mergeWith: descriptorsOfSameSuffix.
				"aSuffixDescriptor at: #suffix put: aSuffixDescriptor suffix."
				agregatedSuffixScanReports add: aSuffixDescriptor.
				
							indexesOfDescriptorsOfSameSuffix reversed do: [:i| suffixScanReports removeAt: i]
				]. 
				agregatedSuffixScanReports sort: [:first :second| first numberOfClasses > second numberOfClasses].
				^agregatedSuffixScanReports collect: [ :each| each numberOfClasses->each  ].

]

{ #category : #Visualizations }
VocabularyScanner >> classBluePrint [
		| b sortedRootClasses  delay |
	^classNamesScanReport at: 'classBlueprint' ifAbsentPut:[ 	b := RTMondrian new.
			delay:=Time now.
			
	"TimeProfiler spyOn:["sortedRootClasses := (self classNamesScanReport
		at: 'allRootClassesSortedByNumberOfSubClasses') collect: #value.
	"dictionaryOfColors := self classNamesScanReport
		at: 'colorsOfRootClasses'."
	b shape rectangle withTextAbove.
	b shape color: [ :each| Color white ];
	borderColor: [ :aPackage| Color gray ] .
	b
		nodes: self scannedPackages
		forEach: [ :aSinglePackage | 
			| aSinglePackageScanReport sortedSuffixes unSortedSuffixes |
			aSinglePackageScanReport := aSinglePackage vocabularyScanner
				classNamesScanReport.
			b shape rectangle.
			b shape
				color: [ :aSuffix | 
					| dominantClasse |
					dominantClasse := ((self groupOfPackagesScanReport
						at: 'dominantRootsInSuffix') at: aSuffix value suffix) first value.
						"if DictionaryOfColors is nil this means that the group of packages has not been scanned yet. Then scan it"
						self dictionaryOfColors ifNil:[
							self scannedEntities mooseModel allPackages scanClassNames
							].
					(self dictionaryOfColors at: dominantClasse) alpha: ((aSuffix value dominantHierarchieInPackages select: [ :each| each value >= aSuffix value dominanceLevel ]) size / aSuffix value dominantHierarchieInPackages size) ];
				withTextAbove: [:each| each value suffix];
				borderWidth: 2.
							b shape borderColor: [  :aSuffix | 
					| dominantClasse |
					dominantClasse := ((self groupOfPackagesScanReport
						at: 'dominantRootsInSuffix') at: aSuffix value suffix) first value.
					(self dictionaryOfColors at: dominantClasse)  ] .
unSortedSuffixes := (self groupOfPackagesScanReport at: 'allClassNameSuffixesSorted') select: [ :association| association value packages includes: aSinglePackageScanReport scannedEntity ]  .
"sortedSuffixes := sortedSuffixes sort: [ :first :second | (first value dominantHierarchie key first = second value dominantHierarchie key first) and: ].
"
sortedSuffixes := aSinglePackageScanReport sortSuffixes: unSortedSuffixes.
			b
				nodes: sortedSuffixes
				forEach: [ :suffix | 
					
					b shape rectangle.
					b shape
						size:
							[ :aClassScanReport | 50 / ((aClassScanReport at: 'superclassesInCurrentPackage') size + 1) ].
					b shape
						color: [ :aClassScanReport | 
							 self dictionaryOfColors at: (aClassScanReport at: 'rootClass')  ];
						borderColor: [ :aClassScanReport | 
							(aClassScanReport at: 'className')
								= (aClassScanReport at: 'rootClass') name
								ifTrue: [ Color black ]
								ifFalse: [ (self dictionaryOfColors at: (aClassScanReport at: 'rootClass'))
										adjustBrightness: -0.1 ] ];
						borderWidth: 1.
					b
						nodes:
							((aSinglePackageScanReport at: 'classesGroupedBySuffixes')
								at: suffix value suffix).
								
					
					b layout grid ].
			b layout grid ].
	b layout grid.
	
	
	b view elements do: [ :element| element announcer subscriptions  subscriptions do: [ :each | element announcer subscriptions  subscriptions remove: each ]].
	b view elements do: [ :element| element @ (element model mouseAnnouncer)].

b shape line color: (Color white alpha: 0.05).
	b edges: ((self classNamesScanReport at:'allClasses') collect: [ :each| 
								each vocabularyScanner classNamesScanReport ]) from: #yourself to: [ :aClassScanReport| (aClassScanReport at: 'superclasse') ifNotNil: [ (aClassScanReport at: 'superclasse') vocabularyScanner classNamesScanReport ] ]."]"
	
	Transcript show: (Time now asSeconds - delay asSeconds )asString;cr.
	
	
	^ b
	]
]

{ #category : #Accessing }
VocabularyScanner >> classNamesScanReport [
	^ classNamesScanReport
]

{ #category : #metrics }
VocabularyScanner >> definedMetricNames [
	^definedMetrics allKeys
	
]

{ #category : #metrics }
VocabularyScanner >> definedMetrics [
	^definedMetrics
	
]

{ #category : #'instance-creation' }
VocabularyScanner >> dictionaryOfColors [

	^self scannedEntities mooseModel dictionaryOfRootClassColors
]

{ #category : #VocabularyScanning }
VocabularyScanner >> generateaClassNamesScanReport [
	| subEntityScanReports |
	classNamesScanReport := self reportClass new.
	classNamesScanReport scannedEntity: scannedEntities.
	subEntityScanReports := (self subEntities collect: #scanClassNames) collect: #classNamesScanReport.
	classNamesScanReport subEntityScanReports: subEntityScanReports.
	self definedMetrics associations do:[:each| 
		classNamesScanReport at: each key ifAbsentPut: (each value value: (subEntityScanReports))].
	^classNamesScanReport.

]

{ #category : #initialization }
VocabularyScanner >> initialize [
	super initialize.
	definedMetrics := self defaultMetrics.
]

{ #category : #metrics }
VocabularyScanner >> removeaMetrics: metricName [
	definedMetrics removeKey: metricName ifAbsent: [  ]
	
]

{ #category : #accessing }
VocabularyScanner >> reportClass [
	^self class reportClass
]

{ #category : #accessing }
VocabularyScanner >> scannedEntities [
	^ scannedEntities
]

{ #category : #accessing }
VocabularyScanner >> scannedEntities: aFAMIXClassOrPackageOrPackageGroup [ 
	scannedEntities := aFAMIXClassOrPackageOrPackageGroup
]
