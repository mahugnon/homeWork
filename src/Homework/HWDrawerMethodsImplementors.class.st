"
I am in charge of drawing a selector implemetors
"
Class {
	#name : #HWDrawerMethodsImplementors,
	#superclass : #HWRoassalDrawer,
	#category : #'Homework-version1'
}

{ #category : #drawing }
HWDrawerMethodsImplementors class >> isApplicableOn: aType [
	^ aType isSymbol & ((aType className = 'ClassScanReport') not)
]

{ #category : #drawing }
HWDrawerMethodsImplementors >> drawOnRoassalView: aView [
	| shape |
	shape := RTBox new
		size: 50;
		color: Color gray trans.
	elements := shape elementsOn: self selected senders.
	aView addAll: elements.
	elements @ RTPopup.
	RTFlowLayout on: elements.
	
]
