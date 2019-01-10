"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifesthomeWork,
	#superclass : #PackageManifest,
	#category : #'Homework-Manifest'
}

{ #category : #'code-critics' }
ManifesthomeWork class >> ruleRBCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BaselineOfHomework #postload:package: #false)) #'2019-01-10T11:43:23.339246+01:00') #(#(#RGMethodDefinition #(#BaselineOfHomework #preload:package: #false)) #'2019-01-10T11:43:51.805055+01:00') )
]
