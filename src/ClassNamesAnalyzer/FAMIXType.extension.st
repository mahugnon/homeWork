Extension { #name : #FAMIXType }

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> allSubInheritances [
	|aCollection|
	aCollection := OrderedCollection new.
	aCollection addAll: subInheritances.
	^aCollection addAll: ((subInheritances collect: #from) flatCollect: #allSubInheritances);yourself
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> classNamesScanReport [
	^self vocabularyScanner classNamesScanReport.
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> indiceOfTheClassInHierarchy [
	^self classNamesScanReport indiceOfTheClassInHierarchy.
]

{ #category : #'*classNamesAnalyzer' }
FAMIXType >> indiceOfTheClassInSubHierarchy [
	^self vocabularyScanner classNamesScanReport indiceOfTheClassInSubHierarchy.
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> isMetaRoot [
	^self nameSuffix = 'Object'
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> isaRootClass [
	^self superclass = nil or: [self superclass isMetaRoot].
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> nameSuffix [
	^self name splitWithCamelCase last.
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> rootClass [
	^self superclasses first.
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> scanClassNames [
	^FAMIXClassScanner scan: self
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> superclasses [
	self isaRootClass 
		ifTrue:[ ^ OrderedCollection with: self ]
		ifFalse: [ ^self superclass superclasses add: self;yourself ]
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> vocabularyScanner [
|a|
a := 
	self privateState attributeAt: #vocabularyScanner ifAbsentPut: (nil).
	a ifNil: [ a := (self privateState attributeAt: #vocabularyScanner put: ( self scanClassNames )) value ].
	^a
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXType >> vocabularyScanner: aFAMIXClassScanner [ 
	self privateState attributeAt: #vocabularyScanner put: aFAMIXClassScanner.
]
