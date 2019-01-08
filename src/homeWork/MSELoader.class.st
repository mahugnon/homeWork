"
I'm responsable of loading mse files
"
Class {
	#name : #MSELoader,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'homeWork-version2'
}

{ #category : #initialization }
MSELoader >> initialize [ 
super initialize .
model:=MooseModel new.
]

{ #category : #'as yet unclassified' }
MSELoader >> loadMSE [
	| fileRef |
	fileRef := UIManager default
		chooseExistingFileReference: 'Import model from MSE file'
		extensions: #('mse')
		path: ''
		preview: ''.
	fileRef isNotNil
		ifTrue: [ "ifFalse: (self error: 'select a mse file please')"
			^ MooseModel new
				importFromMSEStream:fileRef asFileReference readStream ]
]

{ #category : #accessing }
MSELoader >> model [
	^ model
]

{ #category : #accessing }
MSELoader >> model: anObject [
	model := anObject
]
