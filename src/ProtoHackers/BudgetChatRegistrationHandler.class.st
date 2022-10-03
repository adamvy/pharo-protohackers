Class {
	#name : #BudgetChatRegistrationHandler,
	#superclass : #AbstractHandler,
	#instVars : [
		'stream',
		'client'
	],
	#category : #ProtoHackers
}

{ #category : #behavior }
BudgetChatRegistrationHandler >> doWork [
	| line |
	stream nextPutAll: 'Welcome to budget chat! What shall I call you? '.
	stream nextPut: (Character lf).
	stream flush.
	line := stream nextLineLf.
	client name: line ; doJoin.
	
]
