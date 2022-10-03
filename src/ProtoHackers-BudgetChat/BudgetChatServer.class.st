Class {
	#name : #BudgetChatServer,
	#superclass : #Object,
	#instVars : [
		'port',
		'listener',
		'clients'
	],
	#category : #'ProtoHackers-BudgetChat'
}

{ #category : #'instance creation' }
BudgetChatServer class >> onPort: aPort [
	^self new port: aPort ; start ; yourself.
]

{ #category : #accessing }
BudgetChatServer >> clients [

	^ clients
]

{ #category : #accessing }
BudgetChatServer >> clients: anObject [

	clients := anObject
]

{ #category : #behavior }
BudgetChatServer >> handleConnection: aSocket [
	(ChatClient forSocket: aSocket onServer: self) fork.
]

{ #category : #registry }
BudgetChatServer >> initialize [ 
	clients := IdentitySet new.
]

{ #category : #behavior }
BudgetChatServer >> listenLoop [ 
	| socket |
	socket := listener waitForAcceptFor: 30 ifTimedOut: [ ^self ].
	self handleConnection: socket.
	
]

{ #category : #accessing }
BudgetChatServer >> listener [

	^ listener
]

{ #category : #accessing }
BudgetChatServer >> listener: anObject [

	listener := anObject
]

{ #category : #behavior }
BudgetChatServer >> message: aMessage from: aClient [
	clients
		select: [ :client | client ~~ aClient ]
		thenDo: [ :client | client message: aMessage from: aClient ]
]

{ #category : #accessing }
BudgetChatServer >> port [

	^ port
]

{ #category : #accessing }
BudgetChatServer >> port: anObject [

	port := anObject
]

{ #category : #registry }
BudgetChatServer >> register: aClient [
	(aClient name isNotEmpty and: [ 
		 aClient name allSatisfy: [ :c | c isAlphaNumeric ] ]) ifFalse: [ 
		^ self error: 'Invalid name' ].
	clients add: aClient.
	clients
		select: [ :client | client ~~ aClient ]
		thenDo: [ :client | client announceJoin: aClient ].
	aClient members: clients
]

{ #category : #'start-stop' }
BudgetChatServer >> start [
	self stop.
	listener := Socket newTCP.
	listener listenOn: port backlogSize: 10 interface: SocketAddress zero.
	Transcript << 'Budget Chat' ; cr ;
		<< 'listening for connections on ' ;
		<< listener localAddress printString ;
		<< ' port ' ;
		<< port printString ;
		cr ; endEntry.
	[ [ 
		[ listener isValid ] whileTrue: [ self listenLoop ] ]
			ensure: [  listener closeAndDestroy  ] ]
		forkNamed: 'BudgetChatListener'.
]

{ #category : #'start-stop' }
BudgetChatServer >> stop [
	listener ifNotNil: [
		listener closeAndDestroy.
		listener := nil.
		clients do: [ :c | c stop ].
	]

]

{ #category : #registry }
BudgetChatServer >> unregister: aClient [
	clients remove: aClient ifAbsent: [ ^self ].
	clients do: [ :c | c announceLeave: aClient ].
	
]
