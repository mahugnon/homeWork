Extension { #name : #FAMIXScopingEntity }

{ #category : #'*ClassNamesAnalyzer' }
FAMIXScopingEntity >> scanClassNames [
	^FAMIXPackageScanner scan: self
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXScopingEntity >> vocabularyScanner [
|a|
a := 
	self privateState attributeAt: #vocabularyScanner ifAbsentPut: (nil).
	a ifNil: [ a := (self privateState attributeAt: #vocabularyScanner put: (FAMIXPackageScanner scan: self)) value ].
	^a
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXScopingEntity >> vocabularyScanner: aFAMIXClassScanner [ 
	self privateState attributeAt: #vocabularyScanner put: aFAMIXClassScanner.
]
