"
this class/method is not executable.
it is just inteded to give guidelines on how to update a HierarchyScanReport with manual analysis information
"
Class {
	#name : #HierarchyScanReportFillingExample,
	#superclass : #Object,
	#category : #'ClassNamesAnalyzer-Examples'
}

{ #category : #'as yet unclassified' }
HierarchyScanReportFillingExample >> example1 [
"this class/method is not executable.
it is just inteded to give guidelines on how to update a HierarchyScanReport with manual analysis information"
| aGroupOfPackagesScanReport associations |
associations := aGroupOfPackagesScanReport allIncoherentHierarchies .
associations do: [:each | each value 
	at: 'usesManySuffixes' put: 'YES'; "put yes if the hierarchy uses  more than one suffix"
	at: 'isFalsePositive' put: 'NO'; "put the name of the categorie of the false positive that violates the suffix unicity assumption : specialization, FrenchStyle, ... The false positive means that the hierarchy naming is coherent despite it violates the suffix unicity assumption
	Put NO otherwise "
	at: 'isHyerarchyNamedInconsistently' put: 'YES'; "put NO if the hierarchy uses many suffixes improperly and some classes should be renamed (independently from our assumptions)"
	at: 'noteOnHierarchyCoherence' put: 'some explanation on the disgnisis and how to fix in case of inconsistency'; 
	at: 'canBeFixedConformingToUnicityHypothesis' put: 'Unknown' "Put YES if you beleive that some classes could be renamed conforming to unicity hypothesis"
	].
]

{ #category : #'as yet unclassified' }
HierarchyScanReportFillingExample >> example3 [ 
"Where self is a FAMIXPackagesGroupScanner"
self allHierarchies
		do: [ :aHierarchy | 
			aHierarchy classesGroupedBySuffixes
				do: [ :suffixAndClasses | 
					suffixAndClasses
						do: [ :each | 
							
							(each at: 'classSuffix') = (aHierarchy at: 'classSuffix') "Coherent Hierarchies and classes with same suffix as Root"
								ifTrue: [ each at: 'CLASSNAME_usesSameSuffixeAsRoot' put: 'YES'.
									each at: 'CLASSNAME_isFalsePositive' put: ''.
									each at: 'CLASSNAME_isNamedConsistently' put: 'YES'.
									each at: 'CLASSNAME_noteOnCoherence' put: ''.
									each at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis' put: '' ]
								ifFalse: [ "PLEASE Inspect self allIncoherentHierarchies and edit one by one" ] ] ].
	aHierarchy at: 'CLASSNAME_usesSameSuffixeAsRoot' put: ''.
	aHierarchy at: 'CLASSNAME_isNamedConsistently' put: ''.	
		aHierarchy at: 'CLASSNAME_noteOnCoherence' put: 'Root'
						].
	"then inspect the following :"
	self allIncoherentHierarchies. 	
		"and in the new window, click on each HierarchyReport then evaluate the correct expression between brackets (without the brackets)" 
					
	[self classesGroupedBySuffixes 
		do: [ :suffixAndClasses | 
			(suffixAndClasses first at: 'classSuffix') = (self at: 'classSuffix') ifFalse: [
			suffixAndClasses
	do: [ :each | 
	each at: 'CLASSNAME_usesSameSuffixeAsRoot' put: 'NO'.
	each at: 'CLASSNAME_isFalsePositive' put: 'Specialization'.
	each at: 'CLASSNAME_isNamedConsistently' put: 'YES'.
	each at: 'CLASSNAME_noteOnCoherence' put: ''.
	each at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis' put: '' ] ]]].

[ self classesGroupedBySuffixes 
		do: [ :suffixAndClasses | 
			(suffixAndClasses first at: 'classSuffix') = (self at: 'classSuffix') ifFalse: [
			suffixAndClasses
	do: [ :each | 
	each at: 'CLASSNAME_usesSameSuffixeAsRoot' put: 'NO'.
	each at: 'CLASSNAME_isFalsePositive' put: 'NO'.
	each at: 'CLASSNAME_isNamedConsistently' put: 'NO'.
	each at: 'CLASSNAME_noteOnCoherence' put: 'Improper suffix dropping'.
	each at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis' put: 'YES' ] ]] ].
			
[self classesGroupedBySuffixes 
		do: [ :suffixAndClasses | 
			(suffixAndClasses first at: 'classSuffix') = (self at: 'classSuffix') ifFalse: [
			suffixAndClasses
				do: [ :each | 
					each at: 'CLASSNAME_usesSameSuffixeAsRoot' put: 'NO'.
					each at: 'CLASSNAME_isFalsePositive' put: 'NO'.
					each at: 'CLASSNAME_isNamedConsistently' put: 'NO'.
					each at: 'CLASSNAME_noteOnCoherence' put: 'OLD CLass may be should be removed or renamed'.
					each
						at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis'
						put: 'YES' ] ]]].
		
[self classesGroupedBySuffixes 
		do: [ :suffixAndClasses | 
			false ifFalse: [
			suffixAndClasses
				do: [ :each | 
					each at: 'CLASSNAME_usesSameSuffixeAsRoot' put: 'UNKNOWN'.
					each at: 'CLASSNAME_isFalsePositive' put: 'UNKNOWN'.
					each at: 'CLASSNAME_isNamedConsistently' put: 'UNKNOWN'.
					each at: 'CLASSNAME_noteOnCoherence' put: 'UNKNOWN'.
					each
						at: 'CLASSNAME_canBeFixedConformingToUnicityHypothesis'
						put: 'UNKNOWN' ] ]]]			
			self generateCSVFor: 'Reports/Calypso'

]
