"
Je permet de dessiner l'hierachy à laquelle une classe appartient 
"
Class {
	#name : #ClassHierachyWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'classes',
		'diagram',
		'selectedClass',
		'diagramView'
	],
	#category : #homeWork
}

{ #category : #'as yet unclassified' }
ClassHierachyWidget class >> defaultRunSize [
	<script>
	ClassHierachyWidget new
		listView: Collection  withAllSubclasses;
		"ClassHierachyWidget new
		diagramView: MyNewRoassalView new ;
		listView: Collection withAllSubClasses ;
		openWithSpec."
			openWithSpec
]

{ #category : #overrides }
ClassHierachyWidget class >> defaultSpec [
	^ SpecRowLayout composed
		add: #classes;
		add: #diagram;
		yourself
]

{ #category : #accessing }
ClassHierachyWidget >> classes [
^classes
]

{ #category : #accessing }
ClassHierachyWidget >> diagram [
	^diagram 
]

{ #category : #accessing }
ClassHierachyWidget >> diagram: anObject [
	diagram := anObject
]

{ #category : #accessing }
ClassHierachyWidget >> diagramView [
	^ diagramView
]

{ #category : #accessing }
ClassHierachyWidget >> diagramView: aMyViewRoassal [
	diagramView := aMyViewRoassal
]

{ #category : #overrides }
ClassHierachyWidget >> initializePresenter [
	self classes
		onClassSelected: [ :item | 
			selectedClass := item.
			diagram refresh.
			 ]
]

{ #category : #overrides }
ClassHierachyWidget >> initializeWidgets [
	classes := self instantiate: WidgetClassList.
	diagram := self instantiate: RoassalModel.
	selectedClass := #().

	"This is the code for the Roassal view.
	The block takes both a view and a canvas."
	diagram
		script: [ :view :canvas  | self diagramView viewScript value: view value: canvas value: selectedClass  ]
]

{ #category : #accessing }
ClassHierachyWidget >> listView:aCollection [
classes listClass: aCollection .
]

{ #category : #accessing }
ClassHierachyWidget >> visualizationForView: view on: canvas [
	| data shape elements |
	data := OrderedCollection new.
	selectedClass withAllSubAndSuperclassesDo: [ :cl | data add: cl ].
	shape := RTBox new color: [ :c | c = selectedClass ifTrue: [Color red] ifFalse: [Color blue trans]].
	elements := shape elementsOn: data.
	view addAll: elements.
	elements @ RTPopup.
	RTEdgeBuilder new
		view: view;
		objects: data;
		connectFrom: [ :cl | cl superclass ].
	RTTreeLayout on: elements.
	view @ RTDraggableView.
	canvas camera focusOnCenterScaled: 300
]
