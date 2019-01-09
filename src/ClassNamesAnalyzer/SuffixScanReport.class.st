Class {
	#name : #SuffixScanReport,
	#superclass : #VocabularyScanReport,
	#instVars : [
		'suffix',
		'classes',
		'classNames',
		'hierarchies',
		'packages',
		'classScanReports',
		'dominantHierarchieInPackages',
		'packagesWithClasses'
	],
	#category : #'ClassNamesAnalyzer-Reports'
}

{ #category : #'as yet unclassified' }
SuffixScanReport class >> with: aSingleClassScanReport [
	^self new
		classScanReports: (Set with: aSingleClassScanReport)
		"classNames: (Set with: (aSingleClassScanReport at: 'className'));
		classes: (Set with: (aSingleClassScanReport at: 'scannedClasses'));
		hierarchies: (Bag with: (aSingleClassScanReport at: 'rootClass'));
		suffix: (aSingleClassScanReport at: 'classSuffix'); 
		packages: (Set with: (aSingleClassScanReport at: 'package'))"
]

{ #category : #visualization }
SuffixScanReport >> SuffixViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	<moosePresentationOrder: -20>
	composite roassal2
		title: 'SuffixBlueprint';
		initializeView: [ self layeredSuffixBlueprint ]
]

{ #category : #accessing }
SuffixScanReport >> classNames [
	^ classNames ifNil: [ classNames := classScanReports collect: [ :each| each at: 'className' ] ]
]

{ #category : #accessing }
SuffixScanReport >> classScanReports [
	^ classScanReports
]

{ #category : #accessing }
SuffixScanReport >> classScanReports: aSet [
	classScanReports := aSet
]

{ #category : #accessing }
SuffixScanReport >> classes [
	^ classes ifNil: [ classes := classScanReports collect: [ :each| each at: 'className' ] ]
]

{ #category : #visualization }
SuffixScanReport >> dominanceLevel [ 
	^0.8
]

{ #category : #accessing }
SuffixScanReport >> dominantHierarchie [
	^self dominantHierarchies first
]

{ #category : #'as yet unclassified' }
SuffixScanReport >> dominantHierarchieInPackage: aFAMIXPackage [ 
	^((self packagesWithClasses at: aFAMIXPackage) collect: [ :each | each at: 'rootClass' ]) asBag sortedCounts first value
	
	
]

{ #category : #statistics }
SuffixScanReport >> dominantHierarchieInPackages [
	|associationsOfPackagesAndHierarchies numberOfclassesBelongingToDominantHierarchy|
	^dominantHierarchieInPackages ifNil:
	[associationsOfPackagesAndHierarchies := classScanReports asBag collect: [ :each| (each at: 'package')->(each at: 'rootClass') ].
	numberOfclassesBelongingToDominantHierarchy := (associationsOfPackagesAndHierarchies select: [ :each| each value = self dominantHierarchie key first]).
	dominantHierarchieInPackages := self packages collect: [:each| each -> ((numberOfclassesBelongingToDominantHierarchy select: [:ass| ass key = each ]) size / (classScanReports select: [ :report| (report at: 'package') = each]) size) ]]
]

{ #category : #accessing }
SuffixScanReport >> dominantHierarchies [

	^self hierarchies sortedCounts collect: [ :association| {association value . association value parentPackage} -> (association key/self hierarchies size) ]
]

{ #category : #accessing }
SuffixScanReport >> hierarchies [
	^ hierarchies ifNil: [ hierarchies := classScanReports asBag collect: [ :each| each at: 'rootClass' ] ]
]

{ #category : #visualization }
SuffixScanReport >> layeredSuffixBlueprint [
	| index sortedPackages sortedHierarchies dictionaryOfHierarchiesIndices dictionaryOfPackageIndices view nodes layers |
	index := 0.
	sortedPackages := (self dominantHierarchieInPackages
		asOrderedCollection
		sort: [ :first :second | first value > second value ]) collect: #key.
	sortedHierarchies := self dominantHierarchies.
	dictionaryOfHierarchiesIndices := (sortedHierarchies
		collect: [ :each | 
			index := index + 1.
			each key first -> index ]) asDictionary.
	index := 0.
	dictionaryOfPackageIndices := (sortedPackages
		collect: [ :each | 
			index := index + 1.
			each -> index ]) asDictionary.
	view := RTView new.
	view @ RTDraggableView.
	view @ RTZoomableView.
	layers := sortedPackages
		collect: [ :aPackage | 
			| layer |
			layer := (RTElement on: aPackage)
				+ (RTBox new borderColor: Color gray; color: Color transparent); @ RTPopup.
			nodes := (self packagesWithClasses at: aPackage) collect: [ :aClass|
				|colorOfHierarchy| 
				colorOfHierarchy := (aClass at: 'scannedClasses') mooseModel dictionaryOfRootClassColors at: (aClass at: 'rootClass').
				(RTElement on: aClass) + (RTBox new color: colorOfHierarchy; borderWidth: ((aClass at: 'isRoot') ifTrue: [1] ifFalse: [0]); borderColor: Color black; width: 1; height: 1); @ aClass mouseAnnouncer; @ RTDraggable.].
				view add: layer.
				view addAll: nodes.
				(layer -> nodes)
			].
	layers do: [ 
		 :layer | 
RTTreeLayout new
layered.
layer value do: [ :node| node @ RTDraggableChildren ].
RTNest new
"centerOn: layer key elements: layer value;"
makeElements: layer value draggableBy: layer key 
		 ]	.
	
layers do: [ :each| 
	|sortedElements|
	each key width: (sortedHierarchies size) * 2 + 1 ; height: ((self packagesWithClasses at: each key model) size) * 2 + 1.
	sortedElements := each value sort: [ :first :second | first model at: 'isRoot' ].
	(1 to: sortedElements size) do: [ :i| 
		| indiceOfHierarchy x y |
		indiceOfHierarchy := dictionaryOfHierarchiesIndices at: ((sortedElements at: i) model at: 'rootClass').
		
		x := indiceOfHierarchy  -1 * 2 + (3/2).
		y := i - 1 * 2 + (3/2).
		
		(sortedElements at: i) trachelShape position: each key encompassingRectangle origin + (x@y).
		]
	
	 ].

RTVerticalLineLayout new
gapSize: 0;
on: (layers collect: #key).

"TRConstraint setAllToMaxHeight: (layers collect: #key)."
RTResize new elements: (layers collect: #key); sameWidth;left.


		^view
		
]

{ #category : #statistics }
SuffixScanReport >> mergeWith: aCollection [ 
	aCollection do: [ :each| each suffix = suffix ifFalse: ["Fatal error: trying to merge two different suffixes in one"self halt.]].
	self classScanReports addAll: (aCollection flatCollect: #classScanReports).
	self resetClasses.
	self resetClassNames.
	self resetHierarchies.
	self resetPackages.
]

{ #category : #accessing }
SuffixScanReport >> mouseAnnouncer [
	^RTSuffixScanReportPopup new text: self viewInClassBluePrint
]

{ #category : #accessing }
SuffixScanReport >> numberOfClasses [
	^self classes size.
]

{ #category : #accessing }
SuffixScanReport >> packages [
	^ packages ifNil: [ packages := classScanReports collect: [ :each| each at: 'package' ] ]
]

{ #category : #'as yet unclassified' }
SuffixScanReport >> packagesWithClasses [
^packagesWithClasses ifNil:[
	|aDictionary|
aDictionary := Dictionary new.
self classScanReports do: [ :each| aDictionary at: (each at: 'package') ifPresent: [ (aDictionary at: (each at: 'package')) add: each ] ifAbsentPut: [ OrderedCollection with: each ]  ].
packagesWithClasses := aDictionary
]
]

{ #category : #accessing }
SuffixScanReport >> resetClassNames [
	classNames := nil
]

{ #category : #accessing }
SuffixScanReport >> resetClasses [
	classes := nil
]

{ #category : #accessing }
SuffixScanReport >> resetHierarchies [
	hierarchies := nil
]

{ #category : #accessing }
SuffixScanReport >> resetPackages [
	packages := nil
]

{ #category : #exporting }
SuffixScanReport >> saveTo: aMultiByteFileStream [ 
	aMultiByteFileStream << (self suffix) << ';'
	<< (self at: 'isUsedInManyHierarchies') << ';'
	<< (self at: 'isFalsePositive') << ';'
	<< (self at: 'isTrueAmbiguous') << ';'
	<< (self at: 'note' ) << ';'
	<< (self at: 'canBeFixedConformingToUnicityHypothesis').
	aMultiByteFileStream crlf
]

{ #category : #visualization }
SuffixScanReport >> simpleGridLayoutVisualisation [
|b|
b := RTMondrian new.

b shape rectangle withTextAbove: [:aSuffix| 'suffix: ', aSuffix suffix].
b shape color: [ :aSuffix| self value hierarchies anyOne mooseModel dictionaryOfRootClassColors at: self value dominantHierarchie key first].
b nodes: {self value}
forEach: [:e |
b shape rectangle withTextAbove: #name.
b nodes: self value packages forEach: [ :aPackage|
	b shape rectangle size: [:each| each key * 10].
	b shape withTextAbove: [ :each| each value name ].
	b shape color: [ :each| each value mooseModel dictionaryOfRootClassColors at: each value ].
	b nodes: ((aPackage  vocabularyScanner classNamesScanReport at: 'dominantRootsInSuffix') at: self value suffix) ].
b layout grid.
].
^b
]

{ #category : #accessing }
SuffixScanReport >> suffix [
	^ suffix ifNil: [ suffix := classScanReports anyOne at: 'classSuffix' ]
]

{ #category : #accessing }
SuffixScanReport >> suffix: aString [ 
	suffix := aString 
]

{ #category : #visualization }
SuffixScanReport >> viewInClassBluePrint [
	|dominantHierarchyStatName packageOfDominantHierarchy RatioOfClassesBelongingToDominantHierarchy hierarchyDominantedpackages mediumDominanceInDominatedPackages mediumDominanceInDominatedPackagesMsg numberOfClassesUsingThisSuffixInTheDominatedPackage |
	dominantHierarchyStatName := self dominantHierarchie key first name.
	packageOfDominantHierarchy := self dominantHierarchie key second name.
	RatioOfClassesBelongingToDominantHierarchy := (self dominantHierarchie value * 100) asFloat rounded asString, '% '.
	
	
	hierarchyDominantedpackages := (self dominantHierarchieInPackages select: [ :asso|
	asso value > self dominanceLevel
	 ]).

hierarchyDominantedpackages ifNotEmpty:[ mediumDominanceInDominatedPackages := (hierarchyDominantedpackages inject: 0 into: [ :sum :each| sum + each value ]) / hierarchyDominantedpackages size.
	numberOfClassesUsingThisSuffixInTheDominatedPackage := (self classScanReports select: [ :each| (hierarchyDominantedpackages collect: #key) includes: (each at: 'package')]) size.
	mediumDominanceInDominatedPackagesMsg := (mediumDominanceInDominatedPackages * 100) asFloat rounded asString, '% of the ', numberOfClassesUsingThisSuffixInTheDominatedPackage asString, ' classes using this suffix in these packages are subclasses of the dominant hierarchy']
ifEmpty: [ |maxDominance|
	maxDominance := (self dominantHierarchieInPackages collect: #value)max.
	mediumDominanceInDominatedPackages := self dominantHierarchieInPackages select: [ :each| each value >= (1/2)"maxDominance" ].
	 mediumDominanceInDominatedPackagesMsg := 'Only ', mediumDominanceInDominatedPackages size asString, 'package(s) associate this suffix to the dominant hierarchy in ', (maxDominance*100) asFloat rounded asString, '% of cases' ] .
	^'Suffix: ',(self suffix), String cr,
	
	 RatioOfClassesBelongingToDominantHierarchy, 'of the ', self classes size asString, ' classes using this suffix are subclasses of ', packageOfDominantHierarchy, '>>', dominantHierarchyStatName, String cr,
	
self dominantHierarchies size asString, 'hierarchies use this suffix', String cr,
self dominantHierarchieInPackages size asString , ' package(s) use this suffix', String cr,
'out of which ', hierarchyDominantedpackages size asString, ' package(s) associate it to the dominant hierarchy at more than ', (self dominanceLevel * 100) asString ,'%', String cr,
mediumDominanceInDominatedPackagesMsg
]

{ #category : #visualization }
SuffixScanReport >> viewInMooseIn: composite [ 
	
	composite roassal2
		title: 'SuffixBlueprint';
		initializeView: [ self layeredSuffixBlueprint]
]
