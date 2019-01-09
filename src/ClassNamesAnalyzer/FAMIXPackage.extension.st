Extension { #name : #FAMIXPackage }

{ #category : #'*ClassNamesAnalyzer' }
FAMIXPackage >> mouseAnnouncer [
	^RTPopup new text: self viewInClassBluePrint
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXPackage >> packageViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	<moosePresentationOrder: -20>
	composite roassal2
		title: 'NameBlueprint';
		initializeView: [ self vocabularyScanner classBluePrint]
]

{ #category : #'*ClassNamesAnalyzer' }
FAMIXPackage >> viewInClassBluePrint [
	^'package Name: ', (self vocabularyScanner classNamesScanReport at: 'packageName') asString
]
