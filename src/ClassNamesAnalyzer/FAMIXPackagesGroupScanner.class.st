Class {
	#name : #FAMIXPackagesGroupScanner,
	#superclass : #VocabularyScanner,
	#instVars : [
		'availableColors'
	],
	#category : #ClassNamesAnalyzer
}

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner class >> allColors [
	^(((Color colorNamesXKCD collect:#second) reject: [ :each|each size<3 ] )collect: [ :each|
	Color fromRgbTriplet: each ])
]

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner class >> reportClass [
	^GroupOfPackagesScanReport
]

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner class >> scan: aFAMIXPackageGroup [ 
	"^(self new scannedEntities: aFAMIXPackageGroup) generateaClassNamesScanReport;yourself."
	^super scan: aFAMIXPackageGroup 
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allCoherentHierarchies [
	^self allHierarchies select: [:each | each allHierarchySuffixes size = 1].
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allCoherentSuffixes [
	^self allSuffixes select: [ :each | each value hierarchies asSet size = 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allHierarchies [
	^((self classNamesScanReport at: 'allRootClassesSortedByNumberOfSubClasses') reject: [ :each | each value classNamesScanReport at: 'isMetaRoot']) collect: [ :each | each value classNamesScanReport ].
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allInCoherentSuffixes [
	^self allSuffixes select:  [ :each| each value hierarchies asSet size > 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allIncoherentHierarchies [
	^self allHierarchies select: [:each | each allHierarchySuffixes size > 1].
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allMultiClassCoherentHierarchies [
	^self allMultiClassHierarchies select: [ :each| each allHierarchySuffixes size = 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allMultiClassCoherentSuffixes [
	^self allMultiClassSuffixes select: [ :each| each value hierarchies asSet size = 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allMultiClassHierarchies [
	^self allHierarchies select: [ :each | each scannedEntity allSubInheritances size >= 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allMultiClassSuffixes [
	^self allSuffixes select: [ :each | each key > 1 ]
]

{ #category : #queries }
FAMIXPackagesGroupScanner >> allSuffixes [
	^self classNamesScanReport at: 'allClassNameSuffixesSorted'.
]

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner >> defaultMetrics [
	^ Dictionary new
		at: 'numberOfPackages' put: [ :aGroupOfScanReports | aGroupOfScanReports size ];
		at: 'allClasses' put: [ :aGroupOfScanReports | aGroupOfScanReports flatCollect: [ :aPackageScanReport| aPackageScanReport at: 'allClasses']  ];
		at: 'classNames' put: [ :aGroupOfScanReports | aGroupOfScanReports flatCollect: [ :aPackageScanReport| aPackageScanReport at: 'classNames']];
		at: 'allRootClasses' put: [ :aGroupOfScanReports | aGroupOfScanReports flatCollect: [ :aPackageScanReport| aPackageScanReport at: 'allRootClasses']];
		
				at: 'hierarchiesGroupedBySuffixes' put: [ :aGroupOfScanReports | 
					((self classNamesScanReport at: 'allClassNameSuffixesSorted' ifAbsentPut: [(self defaultMetrics at:'allClassNameSuffixesSorted') value: aGroupOfScanReports]) collect: [:association|
						association value suffix->association value hierarchies]) asDictionary
					];

		
		at: 'allClassNameSuffixesSorted' put: [ :aGroupOfScanReports | 
			|suffixScanReports|
			suffixScanReports := ((self classNamesScanReport subEntityScanReports collect: [ :aPackageScanReport|  aPackageScanReport at: 'allClassNameSuffixesSorted']) flatCollect: #value)collect: #value.
			self allClassNameSuffixesSorted: suffixScanReports.
			
			"|aDictionary|
			aDictionary := Dictionary new.
(self classNamesScanReport at: 'allRootClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClasses') value: aGroupOfScanReports]) collect: [:association|
	|suffix rootClass|
	suffix := association value at: 'classSuffix'.
	rootClass := association key.
	aDictionary at: suffix ifPresent: [(aDictionary at: suffix) add: rootClass ] ifAbsentPut: [Bag with: rootClass] ].
	aDictionary"];

		at: 'dominantRootsInSuffix' put: [ :aGroupOfScanReports | 
			((self classNamesScanReport at: 'hierarchiesGroupedBySuffixes' ifAbsentPut: [(self defaultMetrics at:'hierarchiesGroupedBySuffixes') value: aGroupOfScanReports])associations collect: [:association|association key -> association value sortedCounts])asDictionary];


		at: 'suffixesGroupedByRootClasses' put: [ :aGroupOfScanReports | 
			|aDictionary|
			aDictionary := Dictionary new.
(self classNamesScanReport at: 'allClassesGroupedByRootClasses' ifAbsentPut: [(self defaultMetrics at:'allClassesGroupedByRootClasses') value: aGroupOfScanReports]) associations collect: [:association|
	association key -> (association value collect: [:aReport| aReport at: 'classSuffix'])
	]];
		
		
		at: 'allClassesGroupedByRootClasses' put: [ :aGroupOfScanReports | 
			|aDictionary|
			aDictionary := Dictionary new.
			(self classNamesScanReport at: 'allRootClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClasses') value: aGroupOfScanReports]) do:[:anAssociation|
				|root subClass|
				root := anAssociation key.
				subClass := anAssociation value.
				aDictionary at: root ifPresent: [ (aDictionary at: root) add: subClass;yourself ] ifAbsentPut: [ Bag with: subClass ]
			
				].
			aDictionary];
		
		at: 'allRootClassesSortedByNumberOfSubClasses' put: [ :aGroupOfScanReports | ((self classNamesScanReport at: 'allRootClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClasses') value: aGroupOfScanReports]) collect:#key) asBag sortedCounts];
		
		at: 'allRootClassesAsaSet' put: [ :aGroupOfScanReports | (self classNamesScanReport at: 'allRootClassesSortedByNumberOfSubClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClassesSortedByNumberOfSubClasses') value: aGroupOfScanReports] ) collect: #value ];
		
		at: 'colorsOfRootClasses' put: [ :aGroupOfScanReports | 
			self scannedEntities mooseModel dictionaryOfRootClassColors ifNil:
			[|aDictionaryOfColors i|
			i := 0.
			aDictionaryOfColors := Dictionary new.
			
			(self classNamesScanReport at: 'allRootClassesSortedByNumberOfSubClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClassesSortedByNumberOfSubClasses') value: aGroupOfScanReports] ) do: [ :aRootClass| aRootClass value isMetaRoot ifTrue: [aDictionaryOfColors at: aRootClass value put: (Color gray: 1) ] ifFalse: [ i:= i+1. aDictionaryOfColors at: aRootClass value put: (self pickAnAvailableColorNumber: i) ]. self saveInMooseModel: aDictionaryOfColors ]]];
		
		yourself
]

{ #category : #storage }
FAMIXPackagesGroupScanner >> generateCSVFor: aProject [
	| stream anOutputFileName |
	
	anOutputFileName := aProject, Date today yyyymmdd, Time now hhmm24,'.txt'.
	[ stream := anOutputFileName asFileReference writeStream.
	stream setToEnd.
	stream << 'Project '<< ';' << aProject.
	stream crlf.
	stream << 'numberOfSuffixes'<< ';' << self allSuffixes size asString.
	stream crlf.
	stream << 'numberOfCoherentSuffixes'<< ';' << self allCoherentSuffixes size asString.
	stream crlf.
	stream << 'numberOfMultiClassSuffixes'<< ';' << self allMultiClassSuffixes size asString.
	stream crlf.
	stream << 'numberOfMultiClassCoherentSuffixes'<< ';' << self allMultiClassCoherentSuffixes size asString.
	stream crlf.stream crlf.
	stream << 'numberOfHierarchies'<< ';' << self allHierarchies size asString.
	stream crlf.
	stream << 'numberOfCoherentHierarchies'<< ';' << self allCoherentHierarchies size asString.
	stream crlf.
	stream << 'numberOfMultiClassHierarchies'<< ';' << self allMultiClassHierarchies size asString.
	stream crlf.
	stream << 'numberOfMultiClassCoherentHierarchies'<< ';' << self allMultiClassCoherentHierarchies size asString.
	stream crlf.
	] ensure:[stream close].

	self generateCSVSuffixReportFor: aProject.
"anOutputFileName := aProject, 'HierarchiesReport', Date today yyyymmdd, '_', Time now hhmm24,'.txt'.
	[ stream := anOutputFileName asFileReference writeStream.
	stream setToEnd.
	stream << 'Hierarchy;HIERARHCY_usesManySuffixes;HIERARHCY_isFalsePositive;HIERARHCY_isNamedInconsistently;HIERARHCY_noteOnCoherence;HIERARHCY_canBeFixedConformingToUnicityHypothesis'.
	stream crlf.
self allHierarchies do: [ :aHierarchyScanReport| 
		aHierarchyScanReport value saveTo: stream].
	] ensure:[stream close].
"
	self generateCSVHierarchyFor: aProject.

]

{ #category : #storage }
FAMIXPackagesGroupScanner >> generateCSVHierarchyFor: aProject [
	| anOutputFileName stream |
	anOutputFileName := aProject, 'ClassesReport', Date today yyyymmdd, '_', Time now hhmm24,'.txt'.
	[ stream := anOutputFileName asFileReference writeStream.
	stream setToEnd.
	stream << 'ClassName;HierarchyName; CLASSNAME_usesSameSuffixeAsRoot;CLASSNAME_isFalsePositive;CLASSNAME_isNamedConsistently;CLASSNAME_noteOnCoherence;CLASSNAME_canBeFixedConformingToUnicityHypothesis'.
	stream crlf.
(self classNamesScanReport at: 'allClasses') do: [ :aClass| 
		(aClass classNamesScanReport at: 'isMetaRoot') ifFalse: [aClass classNamesScanReport saveClassNameInformationTo: stream]].
	] ensure:[stream close].

]

{ #category : #storage }
FAMIXPackagesGroupScanner >> generateCSVSuffixReportFor: aProject [
	| stream anOutputFileName |
	
	anOutputFileName := aProject, 'SuffixReport', Date today yyyymmdd, '_', Time now hhmm24,'.txt'.
	[ stream := anOutputFileName asFileReference writeStream.
	stream setToEnd.
	stream << 'suffix;isUsedInManyHierarchies;isFalsePositive;isTrueAmbiguous;note;canBeFixedConformingToUnicityHypothesis'.
	stream crlf.
self allSuffixes do: [ :aSuffixScanReport| 
		aSuffixScanReport value saveTo: stream].
	] ensure:[stream close].

]

{ #category : #accessing }
FAMIXPackagesGroupScanner >> groupOfPackagesScanReport [
	^ self classNamesScanReport
]

{ #category : #accessing }
FAMIXPackagesGroupScanner >> initialize [
	super initialize.
	availableColors := self class allColors
]

{ #category : #VocabularyScanning }
FAMIXPackagesGroupScanner >> mergeSinglePackageScanReports: aCollectionOfPackageScanReports [ 
	self 
		deprecated: 'Use generateaClassNamesScanReport instead'
		on: 	'27 April 2018' 
		in: 'Pharo-5.0-50761-'.
	^ self generateaClassNamesScanReport 
]

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner >> pickAnAvailableColorNumber: indexOfColors [
"Color grey: 1 is used for Meta Root classes"
	indexOfColors <= (availableColors size) ifTrue:[^availableColors at: indexOfColors]
	ifFalse:[ ^Color gray: indexOfColors / (availableColors size) ]
]

{ #category : #'instance-creation' }
FAMIXPackagesGroupScanner >> saveInMooseModel: aDictionaryOfColors [
	self scannedPackages mooseModel dictionaryOfRootClassColors: aDictionaryOfColors.
	^aDictionaryOfColors
]

{ #category : #accessing }
FAMIXPackagesGroupScanner >> scannedPackages [
	^ self scannedEntities
]

{ #category : #accessing }
FAMIXPackagesGroupScanner >> scannedPackages: aFAMIXPackageGroup [ 
	self scannedEntities: aFAMIXPackageGroup 
]

{ #category : #accessing }
FAMIXPackagesGroupScanner >> subEntities [
	^self scannedPackages.
]
