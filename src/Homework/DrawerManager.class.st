"
I collect Roassal drawers applicable on a specific type of object.
"
Class {
	#name : #DrawerManager,
	#superclass : #Object,
	#category : #'Homework-version2'
}

{ #category : #utility }
DrawerManager >> drawersFor: aType [
	^ HWRoassalDrawer selectSubclasses: [ :drawerClass | drawerClass isApplicableOn: aType ]
]
