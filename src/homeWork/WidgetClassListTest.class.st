Class {
	#name : #WidgetClassListTest,
	#superclass : #TestCase,
	#category : #'homeWork-tests'
}

{ #category : #'as yet unclassified' }
WidgetClassListTest >> testFilter [
	"Je permet de test filtre d'une liste "

	self assert: ((WidgetClassList new filter: OrderedCollection allSubclasses with: 'GL') at: 1) equals: GLMMultiValue
]
