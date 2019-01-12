Class {
	#name : #HWMooseQueryHandler,
	#superclass : #Object,
	#category : #'Homework-version2'
}

{ #category : #'as yet unclassified' }
HWMooseQueryHandler >> buildQueryBlockFrom: aText [
	^ OpalCompiler new
		source: '[:each |',aText,']';
		logged: false;
		evaluate
]

{ #category : #'as yet unclassified' }
HWMooseQueryHandler >> executeQueryBlock: aBlock on: aFamixClassGroup [
	^aFamixClassGroup collect: aBlock 
]

{ #category : #'as yet unclassified' }
HWMooseQueryHandler >> executeQueryWith: aText on: aFamixClassGroup [
	^ self executeQueryBlock: (self buildQueryBlockFrom: aText) on: aFamixClassGroup
]
