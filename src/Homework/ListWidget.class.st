"
I contain the list of elements and the filter
"
Class {
	#name : #ListWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'eltList',
		'filtre'
	],
	#category : #'Homework-version1'
}

{ #category : #overrides }
ListWidget class >> defaultSpec [
	| filtreHeight |
	filtreHeight := StandardFonts defaultFont height + 15.
	^ SpecLayout composed
		add: #eltList origin: 0 @ 0.05 corner: 1 @ 1;
		add: #filtre
			origin: 0 @ 0
			corner: 1 @ 0
			offsetOrigin: 0 @ 0
			offsetCorner: 0 @ filtreHeight;
		yourself
]

{ #category : #api }
ListWidget >> eltList [
	^ eltList
]

{ #category : #api }
ListWidget >> eltList: aCollection [
	eltList
		items: aCollection.
]

{ #category : #overrides }
ListWidget >> filter: aCollection with: aText [

	^aCollection
		select: [ :cl | 
			(cl name matchesRegex: aText , '.*')
				 ].
	
]

{ #category : #accessing }
ListWidget >> filtre [
	^ filtre
]

{ #category : #overrides }
ListWidget >> initializePresenter [
	filtre
		whenTextChanged: [ :text | 
			text = ''
				ifFalse: [ eltList items: (self filter: self eltList listItems with: text , '.*') ]
				ifTrue: [ eltList items: (Object allSubclasses sort: [ :a :b | a name < b name ]) ] ]
]

{ #category : #overrides }
ListWidget >> initializeWidgets [
	eltList := self newList.
	
	filtre := self newTextInput.
	"listClass items: (Object allSubclasses sort: [ :a :b | a name < b name ])."
	filtre
		ghostText: 'Enter a class name';
		autoAccept: true;
		removeEntryCompletion.
	self focusOrder
		add: eltList;
		add: filtre
]

{ #category : #api }
ListWidget >> onEltSelected: aBlock [
	self eltList whenSelectedItemChanged: aBlock
]

{ #category : #overrides }
ListWidget >> title [
^'Listes des classes'
]
