Extension { #name : #FAMIXPackageGroup }

{ #category : #'*ClassNamesAnalyzer' }
FAMIXPackageGroup >> packageViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	<moosePresentationOrder: -20>
	composite roassal2
		title: 'NameBlueprint';
		initializeView: [ self vocabularyScanner classBluePrint ]
]
