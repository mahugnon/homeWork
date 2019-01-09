Class {
	#name : #RTClassScanReportPopupWithoutSubclasses,
	#superclass : #RTPopup,
	#category : #'ClassNamesAnalyzer-Visualization'
}

{ #category : #'as yet unclassified' }
RTClassScanReportPopupWithoutSubclasses >> initializeElement: element [
	super initializeElement: element.
	element
		when: TRMouseEnter
		do: [ :event | 
			element outgoingEdges
				do: [ :each | each colorEdgesToSuperClassesIn: Color red  ] .
			].
	element
		when: TRMouseLeave
		do: [ :event | 
			element outgoingEdges
				do: [ :each | each colorEdgesToSuperClassesIn: ((each from color adjustBrightness: -0.1) alpha: 0.1) ].
			element trachelShape signalUpdate ]
]
