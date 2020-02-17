TITLE Program 04     (project04.asm)

; Author: David An
; Last Modified: 2/16/20
; OSU email address: anda@oregonstate.edu
; Course number/section: cs271_c400_winter
; Project Number: 04              Due Date: 2/16/20
; Description: this program prompts the user to enter how many composite numbers they would
;				like to see displayed, within the range of 1-400

INCLUDE Irvine32.inc

upperBound = 400
lineLimit = 10

.data
programIntro01				BYTE		"Composite Numbers - written by David An", 0
programIntro02				BYTE		"Enter the number of composite numbers you would like to see.", 0
programIntro03				BYTE		"I'll accept a positive number up to 400", 0
userPrompt					BYTE		"Enter the number of composites to display [1 .. 400]: ", 0
rangeErrorPrompt			BYTE		"Input is out of bounds - try again", 0
spaces						BYTE		"   ", 0
farewell01					BYTE		"Results certified by David An. Goodbye.", 0

userInput					DWORD		?
currNum						DWORD		2
currLine					DWORD		0
compositeCount				DWORD		0
compositeTotal				DWORD		0

.code
main PROC

	; program introduction
		call		introduction
	; retrieve input from user
		call		getUserData
	; display composites
		call		showComposites
	; display farewell message
		call		farewell

	exit	; exit to operating system
main ENDP


; procedure to print details about program 
; registers changed: edx
introduction PROC
		mov			edx, OFFSET programIntro01
		call		WriteString
		call		CrLf
		mov			edx, OFFSET programIntro02
		call		WriteString
		call		CrLf
		mov			edx, OFFSET programIntro03
		call		WriteString
		call		CrLf
		ret
introduction ENDP

; procedure to read an int given by the user
getUserData PROC
		mov			edx, OFFSET userPrompt
		call		WriteString
		call		ReadInt
		call		validate
		mov			userInput, eax
		ret
getUserData ENDP

; procedure to validate the user input 
validate PROC
		cmp			eax, upperBound
		jg			rangeError
		cmp			eax, 0
		jle			rangeError
		ret
	; print out error message and retry
	rangeError:
		mov			edx, OFFSET rangeErrorPrompt
		call		WriteString
		call		CrLf
		call		getUserData
		ret
validate ENDP

; procedure to display composites to the user
showComposites PROC
		mov			eax, userInput

	; search for composites
	search:
		mov			compositeCount, 0
		call		isComposite
		cmp			compositeCount, 1
		je			print
		inc			currNum
		mov			eax, compositeTotal
		cmp			eax, userInput
		jl			search
		jmp			finished

	print:
		mov			eax, currNum
		call		WriteDec
		mov			edx, OFFSET spaces
		call		WriteString

		inc			currNum
		inc			currLine
		cmp			currLine, lineLimit
		je			newLine
		jmp			search

	newLine:
		call		CrLf
		mov			currLine, 0
		jmp			search 

	finished:
		call		CrLf
		ret
showComposites ENDP

; procedure to check if a number is a composite number
isComposite PROC
		mov			ecx, currNum
		dec			ecx

	validateComposite:
		cmp			ecx, 1
		je			finished

		mov			edx, 0
		mov			eax, currNum
		div			ecx
		cmp			edx, 0
		je			found

		loop		validateComposite
	found:
		mov			compositeCount, 1
		inc			compositeTotal

	finished:
		ret
isComposite ENDP

; procedure to print the farewell
; registers changed: edx
farewell PROC
		mov			edx, OFFSET farewell01
		call		WriteString
		call		CrLf
		ret
farewell ENDP


END main