Extension { #name : #MooseModel }

{ #category : #'*ClassNamesAnalyzer' }
MooseModel >> dictionaryOfRootClassColors [

	^self privateState attributeAt: #dictionaryOfRootClassColors ifAbsentPut: nil
]

{ #category : #'*ClassNamesAnalyzer' }
MooseModel >> dictionaryOfRootClassColors: aCollection [ 
	self privateState attributeAt: #dictionaryOfRootClassColors put: aCollection 
]
