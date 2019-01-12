"
I specify the project dependencies and packages 
"
Class {
	#name : #BaselineOfHomework,
	#superclass : #BaselineOf,
	#category : #BaselineOfHomework
}

{ #category : #baselines }
BaselineOfHomework >> baseline: spec [
	"baselines"

	<baseline>
	spec
		for: #common
		do: [ spec preLoadDoIt: #preload:package:.
			spec postLoadDoIt: #postload:package:.
			"Dependencies"
			self
				baselineForRoassal2Spec: spec;
				baselineForClassNamesAnalyzer: spec.
			"Packages"
			spec
				package: 'Homework'
				with: [ spec requires: #('Roassal2' 'ClassNamesAnalyzer' 'ColorsExtensions') ] ]
]

{ #category : #baselines }
BaselineOfHomework >> baselineForClassNamesAnalyzer: spec [
	spec
		baseline: 'ClassNamesAnalyzer'
		with: [ spec repository: 'https://github.com/MoussaSak/BluePrintVisualization:master/repository']
			
		
]

{ #category : #baselines }
BaselineOfHomework >> baselineForRoassal2Spec: spec [
	spec
		project: 'Roassal2'
		with: [ spec
				className: #ConfigurationOfRoassal2;
				versionString: #stable;
				loads: #('NoGlamour');
				repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ]
]

{ #category : #baselines }
BaselineOfHomework >> postload: loader package: packageSpec [

  Transcript crLog: 'Project loaded!'
]

{ #category : #baselines }
BaselineOfHomework >> preload: aloader package: packageSpec [
	Transcript crLog: 'The fetching is finish. wait until loading finish'
]
