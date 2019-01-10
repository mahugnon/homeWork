Class {
	#name : #ClassScanReport,
	#superclass : #VocabularyScanReport,
	#category : #'ClassNamesAnalyzer-Reports'
}

{ #category : #'visualization-private' }
ClassScanReport >> affectIndicesToSubhierarchyClasses: aDoubleEntryDictionary [
	| aDictionary i |
	aDictionary := Dictionary new.
	aDoubleEntryDictionary do: [ :aDico | 
			i := 1.
			aDico do: [ :subClassesOfSubRoot | 
					subClassesOfSubRoot do: [ :each | aDictionary at: (each at: 'className') put: i ].
					i := i + 1 ] ].
	^ aDictionary
]

{ #category : #'visualization-private' }
ClassScanReport >> affectRandomColorsTo: subRootClasses [
	 
	| dicoOfColors |
	dicoOfColors := Dictionary new.
	subRootClasses do: [:each| dicoOfColors at: (each at: 'className') put: Color random].
	^dicoOfColors
]

{ #category : #queries }
ClassScanReport >> allHierarchySuffixes [
	^(self at: 'rootClass') classNamesScanReport hierarchieSuffixesAndClasses keys
]

{ #category : #'visualization-private' }
ClassScanReport >> buildHierarchyBlueprintOf: aDicoOfSuffixesAndSubhierarchies using: dicoOfColors and: dicoOfVisualElementsIndices [
	| view allHierarchieClasses aDicoOfSuffixesAndClasses layers |
	view := RTView new.
	view @ RTDraggableView.
	view @ RTZoomableView.
	aDicoOfSuffixesAndClasses := (aDicoOfSuffixesAndSubhierarchies keys
		collect:
			[ :aSuffix | aSuffix -> ((aDicoOfSuffixesAndSubhierarchies at: aSuffix) values flatCollect: #yourself) ])
		asDictionary.
	allHierarchieClasses := aDicoOfSuffixesAndClasses values flatCollect: #yourself.
	layers := self createLayersFor: aDicoOfSuffixesAndClasses with: dicoOfColors in: view.
	self setDimentionsOf: layers.
	self nestLayers: layers with: dicoOfVisualElementsIndices.
	allHierarchieClasses do: [ :aClass | self createEdgesFor: aClass on: view ].
	^ view
]

{ #category : #Visualisation }
ClassScanReport >> classReportViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	<moosePresentationOrder: -20>
	composite roassal2
		title: 'NameBlueprint';
		initializeView: [ self hierarchicalVisualisationWithCouleredSuffixes]

]

{ #category : #queries }
ClassScanReport >> classesGroupedBySuffixes [
	| classes aCollection aDico |
	classes := self classesGroupedBySuffixesAndSubhierarchies.
	aCollection := OrderedCollection new.
	aDico := Dictionary new.
	classes keys
		do: [ :aSuffix | aDico at: aSuffix put: ((classes at: aSuffix) values flatCollect: #yourself) ].
	^aDico
]

{ #category : #queries }
ClassScanReport >> classesGroupedBySuffixesAndSubhierarchies [
	| aDoubleEntryDictionary |
	aDoubleEntryDictionary := Dictionary new.
	self hierarchieSuffixesAndClasses associations do: [ :aSuffixAndClasses| | suffix collectionOfClasses | 
		suffix := aSuffixAndClasses key.
		aDoubleEntryDictionary at: suffix put: Dictionary new.
		collectionOfClasses := aSuffixAndClasses value.
		collectionOfClasses do:[:aClass| 
			|subRoot|
			subRoot := (aClass at: 'superclasses') reversed at: (aClass indiceOfTheClassInSubHierarchy).
			
			(aDoubleEntryDictionary at: suffix) at: subRoot ifPresent: [ ((aDoubleEntryDictionary at: suffix) at: subRoot) add: aClass  ] ifAbsent: [  (aDoubleEntryDictionary at: suffix) at: subRoot put: (OrderedCollection with: aClass)] ]
		].
	^aDoubleEntryDictionary
]

{ #category : #'visualization-private' }
ClassScanReport >> createEdgesFor: aClass on: view [
	| eb |
	"Dont display ingoing edges for subRoot classes"
	eb := RTEdgeBuilder new.
	eb view: view.
	eb shape line width: 0.1; color: (aClass indiceOfTheClassInHierarchy = 1 
	ifTrue: Color transparent ifFalse: ((Color black adjustBrightness: -0.1) alpha: 0.1)).
	eb connectFrom: aClass  to: ((aClass at: 'superclasse') ifNotNil: [(aClass at: 'superclasse') classNamesScanReport])  
]

{ #category : #'visualization-private' }
ClassScanReport >> createLayersFor: aDicoOfSuffixesAndClasses with: dicoOfColors in: view [
	| orderedSuffixes nodes |
	orderedSuffixes := self orderSuffixesAccordingToLongestSubHierarchy: aDicoOfSuffixesAndClasses.
	^orderedSuffixes collect: [:aSuffix | | layer |
	layer := (RTElement on: aSuffix)
				+ (RTBox new borderColor: Color gray; color: Color transparent); @ RTPopup.
				
	nodes := (aDicoOfSuffixesAndClasses at: aSuffix) collect: [ :aClassReport| 
		| supposedSubRoot |
		supposedSubRoot := ((aClassReport at: 'superclasses') reversed detect: [ :each | each indiceOfTheClassInHierarchy = 1 ]) name .
		(RTElement on: aClassReport) + (RTBox new color: (dicoOfColors at: supposedSubRoot); borderWidth: ((aClassReport at: 'isRoot') ifTrue: [1] ifFalse: [0]); borderColor: Color black; width: 1; height: 1); @ aClassReport mouseAnnouncerWithoutSubclasses; @ RTDraggable].
	view add: layer.
	view addAll: nodes.
	(layer -> nodes)
		].
]

{ #category : #accessing }
ClassScanReport >> groupOfPackagesScanReport [
	"Ugly hack. Should be removed once suffixes are grouped in a dedicated report"
	^self scannedEntity mooseModel allPackages scanClassNames classNamesScanReport
]

{ #category : #Visualisation }
ClassScanReport >> hierarchicalVisualisationWithCouleredSuffixes [
	| b allHierarchyClasses allPackages aDico |
	aDico := Dictionary new.
allHierarchyClasses := ((((self at: 'rootClass') allSubInheritances collect: #from) addFirst: (self at: 'rootClass'); yourself) collect: #vocabularyScanner) collect: #classNamesScanReport.	
allPackages := (allHierarchyClasses collect: [ :each | each at: 'package' ]) asSet.

b := RTMondrian new.
b shape rectangle withTextAbove: [:each| each name];
color: Color transparent;
borderColor: Color gray.
b nodes: allPackages forEach: [ 
	:aPackage |
	b shape rectangle "withTextAbove: [:aReport | '']";
	size: 40;
	color: [ :aReport | 
					aDico at: (aReport at: 'classSuffix') ifAbsentPut: Color random].

	b nodes: (allHierarchyClasses select: [ :aReport | (aReport at: 'package') = aPackage ] ).
	b layout tree.
	
	b edges connectFrom: [ :each|
	 (each at: 'superclasse') vocabularyScanner classNamesScanReport]
	].
b view elements do: [:element| element removeConnectedEdges].

	b view elements do: [ :element| element announcer subscriptions  subscriptions do: [ :each | element announcer subscriptions  subscriptions remove: each ]].
	b view elements do: [ :element| element @ (element model mouseAnnouncer)].
b layout tree.

b shape line color: (Color gray).
b edges: allHierarchyClasses from: #yourself to: [ :aClassScanReport| (aClassScanReport at: 'superclasse') ifNotNil: [ (aClassScanReport at: 'superclasse') vocabularyScanner classNamesScanReport ] ].
b shape line color: (Color transparent).
b edges connectFromAll: [ :aPackage| 
	 aPackage queryOutgoingInheritances atPackageScope withoutSelfLoops asSet
	 ].



^b



]

{ #category : #queries }
ClassScanReport >> hierarchieBluePrintViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	<moosePresentationOrder: -21>
	composite roassal2
		title: 'HierarchieBlueprint';
		initializeView: [ self hierarchieBlueprint ]

]

{ #category : #Visualisation }
ClassScanReport >> hierarchieBlueprint [
|  allHierarchieClasses subRootClasses aDico dicoOfVisualElementsIndices dicoOfColors |

	allHierarchieClasses := self hierarchieSuffixesAndClasses values flatCollect: #yourself.
	subRootClasses := allHierarchieClasses  select: [ :aScanReport | aScanReport indiceOfTheClassInSubHierarchy = 1 ].
	dicoOfColors := self affectRandomColorsTo: subRootClasses.
	aDico := self classesGroupedBySuffixesAndSubhierarchies.
	dicoOfVisualElementsIndices := self affectIndicesToSubhierarchyClasses: aDico.
	aDico := self classesGroupedBySuffixesAndSubhierarchies.
	^self buildHierarchyBlueprintOf: aDico using: dicoOfColors and: dicoOfVisualElementsIndices.

]

{ #category : #accessing }
ClassScanReport >> hierarchieSuffixesAndClasses [
	| allHierarchieClasses dico |
	dico := Dictionary new.
	allHierarchieClasses := ((self at: 'rootClass' )allSubInheritances collect: [:anAssociation | anAssociation from classNamesScanReport]) addFirst: (self at: 'rootClass') classNamesScanReport;yourself.
	allHierarchieClasses collect: [ :aScanReport | dico at: (aScanReport at: 'classSuffix') ifPresent: [ (dico at: (aScanReport at: 'classSuffix')) add: aScanReport  ] ifAbsentPut: [ OrderedCollection with: aScanReport ] ].
	^dico
	

]

{ #category : #queries }
ClassScanReport >> indiceOfTheClassInHierarchy [
	| indiceOfSuperclass subclassesWithSameSuffix aDico i mySuffix subclassesWithSameSuffixIndices myIndice |
	
	^self at: 'indiceOfTheClassInHierarchy' ifAbsent:[
		
	(self indiceOfTheClassInSubHierarchy = 1) ifTrue: [^self at: 'indiceOfTheClassInHierarchy' put: 1].
	indiceOfSuperclass := (self at: 'superclasse') indiceOfTheClassInHierarchy.
	mySuffix := self at: 'classSuffix'.
	subclassesWithSameSuffix := ((self at: 'rootClass') allSubInheritances collect: [:each | each from classNamesScanReport]) select: [:each | (each at: 'classSuffix') = mySuffix].
	subclassesWithSameSuffixIndices := subclassesWithSameSuffix collect: [ :each | each at: 'indiceOfTheClassInHierarchy' ifAbsent: 0 ].
	
	myIndice := (subclassesWithSameSuffixIndices max max: indiceOfSuperclass) + 1.	
	^self at: 'indiceOfTheClassInHierarchy' put: myIndice ]
]

{ #category : #queries }
ClassScanReport >> indiceOfTheClassInSubHierarchy [
	"answers the order of the class in the subhierarchy of its suffix.
	"
	| i j superclasses |
	i := 2.
	j := 1.
	superclasses := (self at: 'superclasses') reversed.
 	[ i <= superclasses size ]
		whileTrue: [ (((superclasses at: i) classNamesScanReport at: 'classSuffix') = (self at: 'classSuffix')) ifTrue: [j:= i]. "j receives i if a subRoot with the same suffix exists"
			i := i + 1 ].
	^ j
]

{ #category : #Visualisation }
ClassScanReport >> mouseAnnouncer [
	^RTClassScanReportPopup new text: self viewInClassBluePrint; alphaPopupBackground: 0.7; textColor: Color green; backgroundColor: Color black
]

{ #category : #Visualisation }
ClassScanReport >> mouseAnnouncerWithoutSubclasses [
	^RTClassScanReportPopupWithoutSubclasses new text: self viewInClassBluePrint; alphaPopupBackground: 0.7; textColor: Color green; backgroundColor: Color black
]

{ #category : #'visualization-private' }
ClassScanReport >> nestLayers: layers with: dicoOfVisualElementsIndices [
	RTHorizontalLineLayout new
		gapSize: 0;
		on: (layers collect: #key).
	RTAlignment new elements: (layers collect: #key); top.
	
	layers
		do: [ :layer|
			layer value do: [ :anElement|
				| x y classScanReport indiceOfSubHierarchy |
				classScanReport := anElement model.
				indiceOfSubHierarchy := dicoOfVisualElementsIndices at: (classScanReport at: 'className').
				x := indiceOfSubHierarchy  -1 * 2 + (3/2).
				y := classScanReport indiceOfTheClassInHierarchy - 1 * 2 + (3/2).
				anElement trachelShape position: layer key encompassingRectangle origin + (x@y).
				 ]
			]
]

{ #category : #'visualization-private' }
ClassScanReport >> orderSuffixesAccordingToLongestSubHierarchy: aDicoOfSuffixesAndClasses [

	| allSuffixes |
	allSuffixes := aDicoOfSuffixesAndClasses keys.
	^allSuffixes
		sort: [ :first :second | 
			| firstSuffixIndiceOfClasses secondSuffixIndiceOfClasses |
			firstSuffixIndiceOfClasses := ((aDicoOfSuffixesAndClasses at: first)
				collect: #indiceOfTheClassInHierarchy) max.
			secondSuffixIndiceOfClasses := ((aDicoOfSuffixesAndClasses at: second)
				collect: #indiceOfTheClassInHierarchy) max.
			firstSuffixIndiceOfClasses > secondSuffixIndiceOfClasses ]
]

{ #category : #storage }
ClassScanReport >> saveClassNameInformationTo: aMultiByteFileStream [ 
	aMultiByteFileStream << (self at: 'className') << ';'
	<< ((self at: 'rootClass') name) << ';'
	<< (self at: 'CLASSNAME_usesSameSuffixeAsRoot') << ';'
	<< (self at: 'CLASSNAME_isFalsePositive') << ';'
	<< (self at: 'CLASSNAME_isNamedConsistently') << ';'
	<< (self at: 'CLASSNAME_noteOnCoherence' ) << ';'
	<< (self at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis').
	aMultiByteFileStream crlf.
	
" CLASSNAME_usesAdifferentSuffixeThanRoot;CLASSNAME_isFalsePositive;CLASSNAME_isNamedInconsistently;CLASSNAME_noteOnCoherence;CLASSNAME_canBeFixedConformingToUnicityHypothesis"
]

{ #category : #storage }
ClassScanReport >> saveTo: aMultiByteFileStream [ 
	aMultiByteFileStream << (self at: 'className') << ';'
	<< (self at: 'HIERARHCY_usesManySuffixes') << ';'
	<< (self at: 'HIERARHCY_isFalsePositive') << ';'
	<< (self at: 'HIERARHCY_isNamedInconsistently') << ';'
	<< (self at: 'HIERARHCY_noteOnCoherence' ) << ';'
	<< (self at: 'HIERARHCY_canBeFixedConformingToUnicityHypothesis').
	aMultiByteFileStream crlf
]

{ #category : #accessing }
ClassScanReport >> scannedClass [
	^self at: 'scannedClasses'.
]

{ #category : #'visualization-private' }
ClassScanReport >> setDimentionsOf: aCollection [ 

	| height |
	height := ((aCollection flatCollect: #value) collect: [:element| element model indiceOfTheClassInHierarchy ]) max * 2 + 1.
	aCollection do: [ :layer|
		| numberOfSubhierarchies width |
		numberOfSubhierarchies := (layer value select: [ :element| element model indiceOfTheClassInHierarchy = 1 ]) size.
		width := numberOfSubhierarchies * 2 + 1.
		layer key  height: height.
		layer key width: width
		 ]
]

{ #category : #Visualisation }
ClassScanReport >> viewInClassBluePrint [
	^'className: ',(self at: 'className'), String cr,
	 'superclass: ',(self at: 'superclasse') name, String cr,
	 'Root Class: ',(self at: 'rootClass') name. 
]
