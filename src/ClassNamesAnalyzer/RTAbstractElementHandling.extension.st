Extension { #name : #RTAbstractElementHandling }

{ #category : #'*ClassNamesAnalyzer' }
RTAbstractElementHandling >> alignFromLeftUsing: anElement [
	| topX newX |
	topX := anElement encompassingRectangle topLeft x.
	elements do: [ :s |
		newX := topX + (s encompassingRectangle width / 2).
		s translateTo: newX @ s position y
	]
]

{ #category : #'*ClassNamesAnalyzer' }
RTAbstractElementHandling >> hasElement [
	"Return true if some elements have been set"
	^ (elements isNil or: [ elements isEmpty ]) not
]

{ #category : #'*ClassNamesAnalyzer' }
RTAbstractElementHandling >> left [
	self hasElement ifFalse: [ ^ self ].
	self alignFromLeftUsing: self leftMostElement 
]

{ #category : #'*ClassNamesAnalyzer' }
RTAbstractElementHandling >> leftMostElement [
	fixedElement ifNotNil: [ ^ fixedElement ].
	^ elements inject: elements first into: [ :maxS :s | 
			maxS encompassingRectangle left >= s encompassingRectangle left
					ifTrue: [ s ] ifFalse: [ maxS ] ] 
]
