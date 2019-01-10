Class {
	#name : #WidgetClassListTest,
	#superclass : #TestCase,
	#category : #'Homework-tests'
}

{ #category : #'event testing' }
WidgetClassListTest >> testFilter [
	"Je permet de test filtre d'une liste "

	self assert: ((ListWidget new filter: OrderedCollection allSubclasses with: 'GL') at: 1) equals: GLMMultiValue
]
