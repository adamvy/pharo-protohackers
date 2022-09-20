Class {
	#name : #PrimeTimeTest,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #ProtoHackers
}

{ #category : #running }
PrimeTimeTest class >> on: aPort [
	| server |
	server := Server new.
	server port: aPort.
	server handlerClass: PrimeTime.
	server start.
	
	
]
