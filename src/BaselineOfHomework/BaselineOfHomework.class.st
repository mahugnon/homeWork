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
				baselineForClassNamesAnalyzer: spec;
				baselineForColors: spec.
			"Packages"
			spec package: 'Homework' with: [ spec requires: #('Roassal2' 'ClassNamesAnalyzer' 'Colors') ] ]
]

{ #category : #baselines }
BaselineOfHomework >> baselineForClassNamesAnalyzer: spec [
	spec
		project: 'ClassNamesAnalyzer'
		with: [ spec
				className: #ConfigurationOfClassNamesAnalyzer;
				versionString: #'AbdelghaniAlidra.31';
				repository: 'http://smalltalkhub.com/mc/Alidra/ClassNamesAnalyzer/main/' ]
]

{ #category : #baselines }
BaselineOfHomework >> baselineForColors: spec [
	spec
		project: 'Colors'
		with: [ spec
				className: #ConfigurationOfColors;
				versionString: #'StephaneDucasse.8';
				repository: 'http://smalltalkhub.com/mc/StephaneDucasse/Colors/main' ]
]

{ #category : #baselines }
BaselineOfHomework >> baselineForRoassal2Spec: spec [
	spec
		project: 'Roassal2'
		with: [ spec
				className: #ConfigurationOfRoassal2;
				versionString: #'AlexandreBergel.16';
				loads: #('Roassal2Spec-core');
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
