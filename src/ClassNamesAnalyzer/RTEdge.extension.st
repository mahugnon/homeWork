Extension { #name : #RTEdge }

{ #category : #'*ClassNamesAnalyzer' }
RTEdge >> colorEdgesToSubClassesIn: aColor [ 
	self color: aColor.
	self from incomingEdges do: [:each| each colorEdgesToSubClassesIn: aColor] 
]

{ #category : #'*ClassNamesAnalyzer' }
RTEdge >> colorEdgesToSuperClassesIn: aColor [ 
	self color: aColor.
	self to outgoingEdges do: [:each| each colorEdgesToSuperClassesIn: aColor] 
]
