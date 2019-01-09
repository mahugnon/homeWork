"
this class/method is not executable.
it is just inteded to give guidelines on how to update a SuffixScanReport with manual analysis information
"
Class {
	#name : #SuffixScanReportFillingExample,
	#superclass : #Object,
	#category : #'ClassNamesAnalyzer-Examples'
}

{ #category : #'as yet unclassified' }
SuffixScanReportFillingExample >> example1 [
"this class/method is not executable.
it is just inteded to give guidelines on how to update a SuffixScanReport with manua analysis information"
| aGroupOfPackagesScanReport associations |
associations := aGroupOfPackagesScanReport allInCoherentSuffixes
associations do: [:each | each value 
	at: 'suffix:' put: self value suffix;
	at: 'isUsedInManyHierarchies' put: 'YES'; "put yes if the suffix is used in more than one hierarchy"
	at: 'isFalsePositive' put: 'NO'; "put the name of the categorie of the false positive that violates the concept unicity assumption : synonyms, GeneralTermSuffix, suffixDropping, SameSuffixDifferentRepresentations, ... The false positive means that the suffix is not ambiguous despite it violates the concept unicity assumption
	Put NO otherwise "
	at: 'isTrueAmbiguous' put: 'YES'; "put YES if the suffix is used improperly and some classes should be renamed"
	at: 'note' put: 'Why RTAction different from GLMRoassal2Action?'; "Explain why you consider the suffix is ambiguous/falsepositive"
	at: 'canBeFixedConformingToUnicityHypothesis' put: 'Unknown' "Put YES if you beleive that some classes could be renamed conforming to unicity hypothesis"
	].
]

{ #category : #'as yet unclassified' }
SuffixScanReportFillingExample >> example2 [
"Where self is aFAMIXPAckageGroupScanner :) "

self allCoherentSuffixes do: [:each | each value 
	at: 'suffix:' put: each value suffix;
	at: 'isUsedInManyHierarchies' put: 'NO'; 
	at: 'isFalsePositive' put: ''; 
	at: 'isTrueAmbiguous' put: ''; 
	at: 'note' put: ''; 
	at: 'canBeFixedConformingToUnicityHypothesis' put: '' 
	].

"then expect the following:"
self allInCoherentSuffixes do: [:each | each value 
	at: 'suffix:' put: each value suffix;
	at: 'isUsedInManyHierarchies' put: 'YES'].
"and in the new window, click on each suffixReport then evaluate the correct expression between brackets (without the brackets)"
[self value 
	at: 'isFalsePositive' put: 'GeneralTerm_Actor';
	at: 'isTrueAmbiguous' put: 'NO';
	at: 'note' put: 'Verb+ER/OR';
	at: 'canBeFixedConformingToUnicityHypothesis' put: '';
	at: 'others' put: ''.
	self value].
	
[self value 
	at: 'isFalsePositive' put: 'NO';
	at: 'isTrueAmbiguous' put: 'YES';
	at: 'note' put: 'Mostly Classes intended for test. Should be ignored';
	at: 'canBeFixedConformingToUnicityHypothesis' put: 'Whatever';
	at: 'others' put: ''.
	self value].

[ self value 
	at: 'isFalsePositive' put: 'GeneralTerm_Presuffix';
	at: 'isTrueAmbiguous' put: 'NO';
	at: 'note' put: 'depends on the pre-suffix';
	at: 'canBeFixedConformingToUnicityHypothesis' put: '';
	at: 'others' put: ''.
	self value ].

[ self value 
	at: 'isFalsePositive' put: 'NO';
	at: 'isTrueAmbiguous' put: 'YES';
	at: 'note' put: 'Improper suffix Dropping';
	at: 'canBeFixedConformingToUnicityHypothesis' put: 'YES';
	at: 'others' put: ''.
	self value ].

[  self value 
	at: 'isFalsePositive' put: 'NO';
	at: 'isTrueAmbiguous' put: 'YES';
	at: 'note' put: 'It is not obvious why a BrowserQueryCursor is different from ClosedQueryCursor';
	at: 'canBeFixedConformingToUnicityHypothesis' put: 'UNKNOWN';
	at: 'others' put: ''.
	self value  ]
]
