"
I am a Modal to allow user to select a draw beyond different options
"
Class {
	#name : #DrawerOptions,
	#superclass : #DynamicComposablePresenter,
	#instVars : [
		'typeLabel',
		'selectedDrawer',
		'drawerList',
		'config',
		'buttonOk'
	],
	#category : #'Homework-version2'
}

{ #category : #specs }
DrawerOptions class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r1 | r1 add: #typeLabel ] origin: 0 @ 0 corner: 1 @ 0.2;
		newRow: [ :r2 | r2 add: #drawerList ] origin: 0 @ 0.2 corner: 1 @ 0.4;
		add: #buttonOk height: 30;
		yourself
]

{ #category : #specs }
DrawerOptions class >> runMe [
<script>
DrawerOptions new openWithSpec 
]

{ #category : #accessing }
DrawerOptions >> buttonOk [
	^ buttonOk
]

{ #category : #accessing }
DrawerOptions >> config [
	^ config
]

{ #category : #accessing }
DrawerOptions >> config: anObject [
	config := anObject
]

{ #category : #api }
DrawerOptions >> drawerList [
	^ drawerList
]

{ #category : #accessing }
DrawerOptions >> drawerList: anObject [
	drawerList := anObject
]

{ #category : #initialization }
DrawerOptions >> initButtonOk [
	buttonOk := self newButton.
	buttonOk label: 'Draw'
]

{ #category : #initialization }
DrawerOptions >> initConfig [
	config := self instantiateDrawConfig
]

{ #category : #initialization }
DrawerOptions >> initConfigWith: aType [
	config := self instantiateDrawConfigWith: aType
]

{ #category : #initialization }
DrawerOptions >> initDrawerList [
	drawerList := self
		newDropList.
	"Select a drawer for ' , config type printString."
	self
		drawerList
		
			items:
			self
				config
				applicableDrawers
				asOrderedCollection;
		
			whenSelectedItemChanged:
				[ :item | 
			config selectedDrawer: item
				new ]
]

{ #category : #initialization }
DrawerOptions >> initTypeLabel [
	typeLabel := self newLabel.
	"typeLabel label: text"
]

{ #category : #initialization }
DrawerOptions >> initializeWidgets [
	self initConfig.
	self initDrawerList.
	self initTypeLabel.
	self initButtonOk.
	self focusOrder
		add: typeLabel;
		add: drawerList;
		add: buttonOk
]

{ #category : #initialization }
DrawerOptions >> instantiateDrawConfig [
	^ DrawConfig new 
]

{ #category : #initialization }
DrawerOptions >> instantiateDrawConfigWith: aType [
	^ DrawConfig new type: aType
]

{ #category : #accessing }
DrawerOptions >> selectedDrawer [
	^ selectedDrawer
]

{ #category : #api }
DrawerOptions >> title [ 
^'Drawing options'
]

{ #category : #accessing }
DrawerOptions >> typeLabel [
	^ typeLabel
]

{ #category : #accessing }
DrawerOptions >> typeLabel: anObject [
	typeLabel := anObject
]
