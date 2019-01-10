Class {
	#name : #FAMIXPackageScanner,
	#superclass : #VocabularyScanner,
	#category : #ClassNamesAnalyzer
}

{ #category : #'as yet unclassified' }
FAMIXPackageScanner class >> reportClass [
	^PackageScanReport
]

{ #category : #accessing }
FAMIXPackageScanner >> defaultMetrics [
	
	^ Dictionary new
		at: 'numberOfPackages' put: [ :argh | 1 ];
		at: 'packageName' put: [ :argh | self scannedPackage name ];
		at: 'allClasses' put: [ :aSingleClassScanReports | aSingleClassScanReports collect: #scannedClass ];
		at: 'dominantRootsInSuffix' put: [ :aGroupOfScanReports | 
			((self classNamesScanReport at: 'rootClassesGroupedBySuffixes' ifAbsentPut: [(self defaultMetrics at:'rootClassesGroupedBySuffixes') value: aGroupOfScanReports]) collect: [:association|association key -> association value asBag sortedCounts])asDictionary];
		at: 'colorsOfRootClasses' put: [ :aSingleClassScanReports | self scannedPackage mooseModel dictionaryOfRootClassColors ];
		at: 'allRootClassesSortedByNumberOfSubClasses' put: [ :aGroupOfScanReports | ((self classNamesScanReport at: 'allRootClasses' ifAbsentPut: [(self defaultMetrics at:'allRootClasses') value: aGroupOfScanReports]) collect:#key) asBag sortedCounts];
		at: 'classNames'
			put:
				[ :aSingleClassScanReports | aSingleClassScanReports collect: [ :aSingleClassScanReport | aSingleClassScanReport at: 'className' ] ];
		at: 'classesAndSuffixes'
			put: [ :aSingleClassScanReports | 
			aSingleClassScanReports
				collect: [ :aSingleClassScanReport | (aSingleClassScanReport "scannedClass") -> (aSingleClassScanReport at: 'classSuffix') ] ];
			
		at: 'rootClassesGroupedBySuffixes'
			put: [ :aSingleClassScanReports | 
			| classesGroupedBySuffixes |
			classesGroupedBySuffixes := self classNamesScanReport
				at: 'classesGroupedBySuffixes'
				ifAbsentPut: [ (self defaultMetrics at: 'classesGroupedBySuffixes') value: aSingleClassScanReports ].
			classesGroupedBySuffixes associations collect: [:anAssociation| (anAssociation key -> (anAssociation value collect: [:each|each at:'rootClass']))]
				  ]	;
			
		at: 'classesGroupedBySuffixes'
			put: [ :aSingleClassScanReports | 
			| aDictionary classNamesAndSuffixes |
			aDictionary := Dictionary new.
			classNamesAndSuffixes := self classNamesScanReport
				at: 'classesAndSuffixes'
				ifAbsentPut: [ (self defaultMetrics at: 'classesAndSuffixes') value: aSingleClassScanReports ].
			classNamesAndSuffixes
				do: [ :anAssociation | 
					|aSuffix aClass classIsRoot|
					aSuffix := anAssociation value.
					aClass := anAssociation key.
					classIsRoot := aClass at: 'isRoot'" ifAbsentPut: [ (self defaultMetrics at: 'isRoot') value: aClass ]".
					aDictionary
						at: aSuffix
						ifPresent: [ (classIsRoot) ifTrue: [(aDictionary
								at: aSuffix)
								addFirst:
									 aClass;
										yourself]
									ifFalse: [ (aDictionary
								at: aSuffix)
								addLast:
									 aClass;
										yourself ] ]
						ifAbsentPut: [ OrderedCollection with: aClass ] ].
			aDictionary ];
		at: 'allClassNameSuffixes'
			put:
				[ :aSingleClassScanReports | aSingleClassScanReports collect: [ :aPackageScanReport | aPackageScanReport at: 'classSuffix' ] ];
			
		at: 'allClassNameSuffixesSorted'
			put: [ :aSingleClassScanReports | 
				|suffixScanReports|
				suffixScanReports := (aSingleClassScanReports collect:[:aSingleClassReport| SuffixScanReport with: aSingleClassReport]).
				self allClassNameSuffixesSorted: suffixScanReports
				];
			
		at: 'allClassNameSuffixesAsSet'
			put: [ :aSingleClassScanReports | 
			(self classNamesScanReport
				at: 'allClassNameSuffixesSorted'
				ifAbsentPut: [ (self defaultMetrics at: 'allClassNameSuffixesSorted') value: aSingleClassScanReports ])
				collect: #value ];
		at: 'allRootClasses'
			put:
				[ :aSingleClassScanReports | aSingleClassScanReports collect: [ :aSingleClassScanReport | (aSingleClassScanReport at: 'rootClass')->(aSingleClassScanReport) ] ];
		at: 'allRootClassesAsaSet'
			put: [ :aSingleClassScanReports | 
			(self classNamesScanReport
				at: 'allRootClasses'
				ifAbsentPut: [ (self defaultMetrics at: 'allRootClasses') value: aSingleClassScanReports ]) asSet ];
		yourself
]

{ #category : #accessing }
FAMIXPackageScanner >> groupOfPackagesScanReport [
	"Ugly hack. Should be removed once suffixes are grouped in a dedicated report"
	^self scannedEntities mooseModel allPackages vocabularyScanner classNamesScanReport
]

{ #category : #accessing }
FAMIXPackageScanner >> scannedPackage [
	^ self scannedEntities
]

{ #category : #accessing }
FAMIXPackageScanner >> scannedPackage: aFAMIXPackage [ 
	self scannedEntities: aFAMIXPackage
]

{ #category : #accessing }
FAMIXPackageScanner >> scannedPackages [
	^{self scannedPackage}.
]

{ #category : #accessing }
FAMIXPackageScanner >> subEntities [
	^self scannedPackage classes
]
