"
My I store user config 
"
Class {
	#name : #DrawConfig,
	#superclass : #Object,
	#instVars : [
		'type',
		'selectedDrawer',
		'applicableDrawers',
		'zoom',
		'center'
	],
	#category : #'homeWork-version2'
}

{ #category : #accessing }
DrawConfig >> applicableDrawers [
	^self
		getDrawers.
	
]

{ #category : #accessing }
DrawConfig >> center [
	^ center
]

{ #category : #accessing }
DrawConfig >> center: anObject [
	center := anObject
]

{ #category : #utilities }
DrawConfig >> drawers [
applicableDrawers drawersFor: type.
]

{ #category : #utilities }
DrawConfig >> getDrawers [
	^ApplicableDrawers
		new
		drawersFor: type
]

{ #category : #accessing }
DrawConfig >> selectedDrawer [
	^ selectedDrawer
]

{ #category : #accessing }
DrawConfig >> selectedDrawer: anObject [
	selectedDrawer := anObject
]

{ #category : #accessing }
DrawConfig >> type [
	^ type
]

{ #category : #accessing }
DrawConfig >> type: anObject [
	type := anObject
]

{ #category : #accessing }
DrawConfig >> zoom [
	^ zoom
]

{ #category : #accessing }
DrawConfig >> zoom: anObject [
	zoom := anObject
]
