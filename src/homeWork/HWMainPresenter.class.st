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
		'roassalDrawer',
		'menu'
	],
	#category : #'homeWork-version1'
}

{ #category : #specs }
HWMainPresenter class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | 
					c add: #menu height: self toolbarHeight.
					c newRow: [ :row | row add: #classes ] ];
				newColumn: [ :c | c add: #diagram ] ]
			
		yourself
]

{ #category : #'as yet unclassified' }
HWMainPresenter class >> runMe [
	<script>
	(HWMainPresenter
		withDrawer: HWDrawerSubclassesWithForceLayout
		elements: Object withAllSubclasses) openWithSpec
]

{ #category : #'as yet unclassified' }
HWMainPresenter class >> withDrawer: aDrawerClass [
	^self basicNew
		withDrawer: aDrawerClass new;
		initialize ;
		yourself
]

{ #category : #'as yet unclassified' }
HWMainPresenter class >> withDrawer: aDrawerClass elements: aCollection [
	^ self basicNew 
		withDrawer: aDrawerClass new;
		initialize;
		listClass:aCollection;
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

{ #category : #api }
HWMainPresenter >> extent [
	^ 900 @ 900
]

{ #category : #initialization }
HWMainPresenter >> initializePresenter [
	self classes
		onClassSelected: [ :item |
			item=nil ifFalse: [  
			diagram refresh.
			roassalDrawer selected: item  ]]
]

{ #category : #initialization }
HWMainPresenter >> initializeWidgets [
	classes := self instantiate: WidgetClassList.
	menu := self mainMenu.
	menu applyTo: self.
	classes listClass: #().
	diagram := self instantiate: RoassalModel.
	diagram script: [ :view :canvas | roassalDrawer drawOnRoassalView: view ]
]

{ #category : #api }
HWMainPresenter >> listClass: aCollection [
self classes listClass: aCollection  
]

{ #category : #initialization }
HWMainPresenter >> mainMenu [
	| aMenu |
	aMenu := MenuPresenter new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						icon: (self iconNamed: #openIcon)].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Open file';
						icon: (self iconNamed: #openIcon);
						action: [ self inform: 'Open File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Save File';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self inform: 'Save File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Print file';
						icon: (self iconNamed: #smallPrintIcon);
						action: [ self inform: 'Print file' ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Undo';
						icon: (self iconNamed: #smallUndoIcon);
						action: [ self inform: 'Undo' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Redo';
						icon: (self iconNamed: #smallRedoIcon);
						action: [ self inform: 'Redo' ] ] ].
	^ aMenu
]

{ #category : #accessing }
HWMainPresenter >> menu [
	^ menu
]

{ #category : #accessing }
HWMainPresenter >> menu: anObject [
	menu := anObject
]

{ #category : #'as yet unclassified' }
HWMainPresenter >> title [ 
^'Visualization'.
]

{ #category : #accessing }
HWMainPresenter >> withDrawer: aDrawerInstance [
	roassalDrawer := aDrawerInstance 
]
