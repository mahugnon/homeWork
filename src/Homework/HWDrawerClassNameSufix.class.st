"
I draw class name suffix dependecies graph
"
Class {
	#name : #HWDrawerClassNameSufix,
	#superclass : #HWRoassalDrawer,
	#category : #'Homework-version1'
}

{ #category : #drawing }
HWDrawerClassNameSufix class >> isApplicableOn: aType [
	^aType className = 'ClassScanReport'
]

{ #category : #Visualisation }
HWDrawerClassNameSufix >> buildHierarchyBlueprintOf: aDicoOfSuffixesAndSubhierarchies using: dicoOfColors and: dicoOfVisualElementsIndices on: aView [
	| allHierarchieClasses aDicoOfSuffixesAndClasses layers |
	aView @ RTDraggableView.
	aView @ RTZoomableView.
	aDicoOfSuffixesAndClasses := (aDicoOfSuffixesAndSubhierarchies keys collect: [ :aSuffix | aSuffix -> ((aDicoOfSuffixesAndSubhierarchies at: aSuffix) values flatCollect: #yourself) ]) asDictionary.
	allHierarchieClasses := aDicoOfSuffixesAndClasses values flatCollect: #yourself.
	layers := selected createLayersFor: aDicoOfSuffixesAndClasses with: dicoOfColors in: aView.
	selected setDimentionsOf: layers.
	selected nestLayers: layers with: dicoOfVisualElementsIndices.
	allHierarchieClasses do: [ :aClass | selected createEdgesFor: aClass on: aView ]
]

{ #category : #drawing }
HWDrawerClassNameSufix >> drawOnRoassalView: aView [
self hierarchieBlueprintOn: aView 
]

{ #category : #Visualisation }
HWDrawerClassNameSufix >> hierarchieBlueprint [
	| allHierarchieClasses subRootClasses aDico dicoOfVisualElementsIndices dicoOfColors |
	allHierarchieClasses := selected hierarchieSuffixesAndClasses values flatCollect: #yourself.
	subRootClasses := allHierarchieClasses select: [ :aScanReport | aScanReport indiceOfTheClassInSubHierarchy = 1 ].
	dicoOfColors := selected  affectRandomColorsTo: subRootClasses.
	aDico := selected  classesGroupedBySuffixesAndSubhierarchies.
	dicoOfVisualElementsIndices := selected  affectIndicesToSubhierarchyClasses: aDico.
	aDico := selected  classesGroupedBySuffixesAndSubhierarchies.
	^ selected  buildHierarchyBlueprintOf: aDico using: dicoOfColors and: dicoOfVisualElementsIndices
]

{ #category : #Visualisation }
HWDrawerClassNameSufix >> hierarchieBlueprintOn:aView [
	| allHierarchieClasses subRootClasses aDico dicoOfVisualElementsIndices dicoOfColors |
	allHierarchieClasses := selected hierarchieSuffixesAndClasses values flatCollect: #yourself.
	subRootClasses := allHierarchieClasses select: [ :aScanReport | aScanReport indiceOfTheClassInSubHierarchy = 1 ].
	dicoOfColors := selected affectRandomColorsTo: subRootClasses.
	aDico := selected classesGroupedBySuffixesAndSubhierarchies.
	dicoOfVisualElementsIndices := selected affectIndicesToSubhierarchyClasses: aDico.
	aDico := selected classesGroupedBySuffixesAndSubhierarchies.
	^ self buildHierarchyBlueprintOf: aDico using: dicoOfColors and: dicoOfVisualElementsIndices on: aView
]
