Extension { #name : #MooseGroup }

{ #category : #'*ClassNamesAnalyzer' }
MooseGroup >> scanClassNames [
	^FAMIXPackagesGroupScanner scan: self.
]

{ #category : #'*ClassNamesAnalyzer' }
MooseGroup >> vocabularyScanner [
|a|
a := 
	self privateState attributeAt: #vocabularyScanner ifAbsentPut: (nil).
	a ifNil: [ a := (self privateState attributeAt: #vocabularyScanner put: (FAMIXPackagesGroupScanner scan: self)) value ].
	^a
]

{ #category : #'*ClassNamesAnalyzer' }
MooseGroup >> vocabularyScanner: aFAMIXPackagesGroupScanner [ 
	self privateState attributeAt: #vocabularyScanner put: aFAMIXPackagesGroupScanner
]
