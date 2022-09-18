Class {
	#name : #SmokeTest,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
SmokeTest class >> on: port [
	"comment stating purpose of class-side method"
	"scope: class-variables  &  class-instance-variables"	
			
	| server |
	server := Server new.
	server handlerClass: EchoHandler.
	server port: port.
	server start.
]
