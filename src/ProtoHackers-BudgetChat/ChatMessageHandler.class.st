Class {
	#name : #ChatMessageHandler,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'ProtoHackers-BudgetChat'
}

{ #category : #accessing }
ChatMessageHandler >> context [

	^ context
]

{ #category : #accessing }
ChatMessageHandler >> context: anObject [

	context := anObject
]

{ #category : #behavior }
ChatMessageHandler >> handle: aLine [
	self context doMessage: aLine.
]

{ #category : #behavior }
ChatMessageHandler >> onConnect [
]
