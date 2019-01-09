Class {
	#name : #VocabularyScanReport,
	#superclass : #Dictionary,
	#instVars : [
		'subEntityScanReports',
		'scannedEntity'
	],
	#category : #'ClassNamesAnalyzer-Reports'
}

{ #category : #accessing }
VocabularyScanReport >> = aReport [
	^ aReport ifNotNil: [scannedEntity = aReport scannedEntity]
	ifNil:[false]
]

{ #category : #accessing }
VocabularyScanReport >> scannedEntity [
	^ scannedEntity
]

{ #category : #accessing }
VocabularyScanReport >> scannedEntity: aFAMIXPackageGroup [ 
	scannedEntity := aFAMIXPackageGroup
]

{ #category : #accessing }
VocabularyScanReport >> subEntityScanReports [
	^ subEntityScanReports
]

{ #category : #accessing }
VocabularyScanReport >> subEntityScanReports: aMooseGroup [ 
	subEntityScanReports := aMooseGroup
]
