"
Responsible for drawing a Roassal view in the HWMainPresenter

It knows the list of elements that the HWMainPresenter is showing, and the element in this list that is selected.
It is responsible to show this element in some way
"
Class {
	#name : #HWRoassalDrawer,
	#superclass : #Object,
	#instVars : [
		'elements',
		'selected',
		'name'
	],
	#category : #'Homework-version1'
}

{ #category : #drawing }
HWRoassalDrawer class >> isApplicableOn: aType [
	self subclassResponsibility
]

{ #category : #drawing }
HWRoassalDrawer >> drawOnRoassalView: aView [
	self subclassResponsibility
]

{ #category : #accessing }
HWRoassalDrawer >> elements [
	^ elements
]

{ #category : #accessing }
HWRoassalDrawer >> elements: anObject [
	elements := anObject
]

{ #category : #accessing }
HWRoassalDrawer >> selected [
	^ selected
]

{ #category : #accessing }
HWRoassalDrawer >> selected: anObject [
	selected := anObject
]
