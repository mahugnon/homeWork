"
I collect Roassal drawers applicable on a specific type of object.
"
Class {
	#name : #ApplicableDrawers,
	#superclass : #Object,
	#category : #'Homework-version2'
}

{ #category : #utility }
ApplicableDrawers >> drawersFor: aType [
	^ HWRoassalDrawer selectSubclasses: [ :drawerClass | drawerClass isApplicableOn: aType ]
]
