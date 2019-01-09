Class {
	#name : #GroupOfPackagesScanReport,
	#superclass : #VocabularyScanReport,
	#category : #'ClassNamesAnalyzer-Reports'
}

{ #category : #accessing }
GroupOfPackagesScanReport >> singlePackageScanReports [
	^ self subEntityScanReports
]

{ #category : #accessing }
GroupOfPackagesScanReport >> singlePackageScanReports: aGroupOfReports [
	self subEntityScanReports: aGroupOfReports
]
