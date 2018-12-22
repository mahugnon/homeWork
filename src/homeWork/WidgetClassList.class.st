Class {
	#name : #WidgetClassList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listClass',
		'filtre'
	],
	#category : #homeWork
}

{ #category : #overrides }
WidgetClassList class >> defaultSpec [
	| filtreHeight |
	filtreHeight := StandardFonts defaultFont height + 15.
	^ SpecLayout composed
				
				add: #listClass origin: 0 @ 0.2 corner: 1 @ 1;
				add: #filtre
					origin: 0 @ 0
					corner: 1 @ 0
					offsetOrigin: 0 @ 0
					offsetCorner: 0 @ filtreHeight;
		yourself
]

{ #category : #overrides }
WidgetClassList >> filter: aCollection with: aText [

	^aCollection
		select: [ :cl | 
			(cl name matchesRegex: aText , '.*')
				 ].
	
]

{ #category : #accessing }
WidgetClassList >> filtre [
	^ filtre
]

{ #category : #overrides }
WidgetClassList >> initializePresenter [
	filtre
		whenTextChanged: [ :text | 
			text = ''
				ifFalse: [ listClass items: (self filter: self listClass listItems with: text , '.*') ]
				ifTrue: [ listClass items: (Object allSubclasses sort:[:a :b|a name<b name])] ]
]

{ #category : #overrides }
WidgetClassList >> initializeWidgets [
	listClass := self newList.
	filtre := self newTextInput.
	"listClass items: (Object allSubclasses sort: [ :a :b | a name < b name ])."
	filtre
		ghostText: 'Enter a class name';
		autoAccept: true;
		removeEntryCompletion.
	self focusOrder
		add: listClass;
		add: filtre
]

{ #category : #accessing }
WidgetClassList >> listClass [
^listClass.
]

{ #category : #api }
WidgetClassList >> listClass: aCollection [
	listClass items: aCollection .
]

{ #category : #api }
WidgetClassList >> onClassSelected: aBlock [
	self listClass whenSelectedItemChanged: aBlock
]

{ #category : #overrides }
WidgetClassList >> title [
^'Listes des classes'
]
