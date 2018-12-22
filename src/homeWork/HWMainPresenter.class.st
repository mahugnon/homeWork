"
REsponsible for opening a window with a list of elements on the left and a Roassal diagram on the right.
Selecting an elements in the list on the left will trigger a refresh of the roassal view on the right

[[[
			(HWMainPresenter withDrawer: HWDrawerSubclassesWithForceLayout) openWithSpec 
]]]
"
Class {
	#name : #HWMainPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'classes',
		'diagram',
		'roassalDrawer'
	],
	#category : #homeWork
}

{ #category : #specs }
HWMainPresenter class >> defaultSpec [
	^ SpecRowLayout composed
		add: #classes;
		add: #diagram;
		yourself
]

{ #category : #'as yet unclassified' }
HWMainPresenter class >> withDrawer: aDrawerClass [
	^self basicNew
		withDrawer: aDrawerClass new;
		initialize ;
		yourself
]

{ #category : #accessing }
HWMainPresenter >> classes [
	^ classes
]

{ #category : #accessing }
HWMainPresenter >> diagram [
	^ diagram
]

{ #category : #initialization }
HWMainPresenter >> initializePresenter [
	self classes
		onClassSelected: [ :item | 
			roassalDrawer selected: item.
			diagram refresh ]
]

{ #category : #initialization }
HWMainPresenter >> initializeWidgets [
	classes := self instantiate: WidgetClassList.
	classes listClass: (Collection withAllSubclasses sorted: [ :a :b | a name < b name ]).
	diagram := self instantiate: RoassalModel.
	diagram script: [ :view :canvas | roassalDrawer drawOnRoassalView: view ]
]

{ #category : #accessing }
HWMainPresenter >> withDrawer: aDrawerInstance [
	roassalDrawer := aDrawerInstance 
]
