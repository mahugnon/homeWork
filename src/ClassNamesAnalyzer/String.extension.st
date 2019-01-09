Extension { #name : #String }

{ #category : #'*ClassNamesAnalyzer' }
String >> splitWithCamelCase [
"
'GoodMoriningAmerica' splitWithCamelCase = (OrderedCollection with:'Good' with:'Morining' with:'America')"
"'GCOptimizer' splitWithCamelCase = (OrderedCollection with:'GC' with:'Optimizer')"
"'optimizerOfGC' splitWithCamelCase  = (OrderedCollection with:'optimizer' with: 'Of' with: 'GC')
"

	| pastIndex  tokens newWord |
	self flag:' must consider the case of multiple uppercase letters :FMGenerator'.
	tokens := OrderedCollection new.
	newWord := false.
	pastIndex := 1.
	2 to: self size do: [ :index | 
		((((self at: index) asciiValue) > 64 and: [ ((self at: index) asciiValue) < 91 ]) and:[newWord])
			ifTrue: [ tokens add: (self collect: [ :each | each ] from: pastIndex to: index-1).
				pastIndex := index.newWord := false]ifFalse:[newWord := true]] .
		tokens add:(self collect:[:each | each ] from: pastIndex to: self size).
		^tokens

]
