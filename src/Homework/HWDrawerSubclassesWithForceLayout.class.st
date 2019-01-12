Class {
	#name : #HWDrawerSubclassesWithForceLayout,
	#superclass : #HWRoassalDrawer,
	#category : #'Homework-version1'
}

{ #category : #drawing }
HWDrawerSubclassesWithForceLayout class >> isApplicableOn: aType [
	^ aType isClass & ((aType className = 'ClassScanReport') not)
]

{ #category : #drawing }
HWDrawerSubclassesWithForceLayout >> drawOnRoassalView: roassalView [
	| es |
	roassalView @ RTDraggableView.
	es := (RTEllipse new
		size: 15;
		color: [ :c | 
			c = selected
				ifTrue: [ Color green ]
				ifFalse: [ Color black alpha: 0.5 ] ]) elementsOn: selected withAllSubclasses.
	roassalView addAll: es.
	es @ RTDraggable @ RTPopup.
	RTEdgeBuilder new
		view: roassalView;
		elements: es;
		connectFrom: #superclass.
	RTForceBasedLayout new on: es
]
