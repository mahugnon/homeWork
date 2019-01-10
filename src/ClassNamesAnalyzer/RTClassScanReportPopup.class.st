Class {
	#name : #RTClassScanReportPopup,
	#superclass : #RTPopup,
	#category : #'ClassNamesAnalyzer-Visualization'
}

{ #category : #'as yet unclassified' }
RTClassScanReportPopup >> initializeElement: element [
	super initializeElement: element.
	element
		when: TRMouseEnter
		do: [ :event | 
			element outgoingEdges
				do: [ :each | each colorEdgesToSuperClassesIn: Color red "each color: (Color red)"  ] .
			element incomingEdges 
				do: [ :each | each colorEdgesToSubClassesIn: Color black ]].
	element
		when: TRMouseLeave
		do: [ :event | 
			element incomingEdges do:[: each | each colorEdgesToSubClassesIn: ((each from color adjustBrightness: -0.1) alpha: 0.1).
					].
			element outgoingEdges
				do: [ :each | each colorEdgesToSuperClassesIn: ((each from color adjustBrightness: -0.1) alpha: 0.1) ].
			element trachelShape signalUpdate ]
	"element
		when: TRMouseDragging
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ]"
]
