Extension { #name : #Float }

{ #category : #'*ProtoHackers' }
Float >> isPrime [
	^self fractionPart = 0.0
		ifTrue: [ self asInteger isPrime ]
		ifFalse: [ false ]
]
