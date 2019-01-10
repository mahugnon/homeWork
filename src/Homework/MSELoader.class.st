"
I'm responsable of loading mse files
"
Class {
	#name : #MSELoader,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Homework-version2'
}

{ #category : #initialization }
MSELoader >> initialize [ 
super initialize .
model:=MooseModel new.
]

{ #category : #utilities }
MSELoader >> loadMSE [
	| fileRef |
	fileRef := UIManager default
		chooseExistingFileReference: 'Import model from MSE file'
		extensions: #('mse')
		path: ''
		preview: ''.
	fileRef isNotNil
		ifTrue: [  ^ MooseModel new importFromMSEStream: fileRef asFileReference readStream ]
]

{ #category : #accessing }
MSELoader >> model [
	^ model
]

{ #category : #accessing }
MSELoader >> model: anObject [
	model := anObject
]
