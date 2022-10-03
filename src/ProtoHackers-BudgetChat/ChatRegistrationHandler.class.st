Class {
	#name : #ChatRegistrationHandler,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'ProtoHackers-BudgetChat'
}

{ #category : #accessing }
ChatRegistrationHandler >> context [

	^ context
]

{ #category : #accessing }
ChatRegistrationHandler >> context: anObject [

	context := anObject
]

{ #category : #behavior }
ChatRegistrationHandler >> handle: aLine [
	self context doRegistration: aLine.
	
]

{ #category : #behavior }
ChatRegistrationHandler >> onConnect [
	self context doWelcome.
]
