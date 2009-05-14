# Copyright:	Public domain.
# Filename:	ORBITAL_INTEGRATION.s
# Purpose:	Part of the source code for Colossus 2A, AKA Comanche 055.
#		It is part of the source code for the Command Module's (CM)
#		Apollo Guidance Computer (AGC), for Apollo 11.
# Assembler:	yaYUL
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	www.ibiblio.org/apollo.
# Pages:	1334-1354
# Mod history:	2009-05-14 RSB	Adapted from the Colossus249/ file of the
#				same name, using Comanche055 page images.
#
# This source code has been transcribed or otherwise adapted from digitized
# images of a hardcopy from the MIT Museum.  The digitization was performed
# by Paul Fjeld, and arranged for by Deborah Douglas of the Museum.  Many
# thanks to both.  The images (with suitable reduction in storage size and
# consequent reduction in image quality as well) are available online at
# www.ibiblio.org/apollo.  If for some reason you find that the images are
# illegible, contact me at info@sandroid.org about getting access to the 
# (much) higher-quality images which Paul actually created.
#
# Notations on the hardcopy document read, in part:
#
#	Assemble revision 055 of AGC program Comanche by NASA
#	2021113-051.  10:28 APR. 1, 1969  
#
#	This AGC program shall also be referred to as
#			Colossus 2A

# Page 1334
# ORBITAL INTEGRATION

# DELETE
		BANK	13
		SETLOC	ORBITAL
		BANK
		COUNT	11/ORBIT

# DELETE
KEPPREP		LXA,2	SETPD
			PBODY
			0
		DLOAD*	SQRT		# SQRT(MU) (+18 OR +15)		0D	PL 2D
			MUEARTH,2
		PDVL	UNIT		#					PL 8D
			RCV
		PDDL	NORM		# NORM R (+29 OR +27 - N1)	2D	PL 4D
			36D
			X1
		PDVL
		DOT	PDDL		# F*SQRT(MU) (+7 OR +5) 	4D	PL 6D
			VCV
			TAU.		# (+28)
		DSU	NORM
			TC
			S1
		SR1
		DDV	PDDL
			2D
		DMP	PUSH		# FS (+6 +N1-N2) 		6D	PL 8D
			4D
		DSQ	PDDL		# (FS)SQ (+12 +2(N1-N2))	8D	PL 10D
			4D
		DSQ	PDDL*		# SSQ/MU (-2 OR +2(N1-N2))	10D	PL 12D
			MUEARTH,2
		SR3	SR4
		PDVL	VSQ		# PREALIGN MU (+43 OR +37) 	12D	PL 14D
			VCV
		DMP	BDSU		#					PL 12D
			36D
		DDV	DMP		#					PL 10D
			2D		# -(1/R-ALPHA) (+12 +3N1-2N2)
		DMP	SL*
			DP2/3
			0 	-3,1	# 10L(1/R-ALPHA) (+13 +2(N1-N2))
		XSU,1	DAD		# 2(FS)SQ - ETCETERA			PL 8D
			S1		# X1 = N2-N1
		SL*	DSU		# -FS+2(FS)SQ ETC (+6 +N1-N2)		PL 6D
			8D,1
		DMP	DMP
			0D
			4D
		SL*	SL*
# Page 1335
			8D,1
			0,1		# S(-FS(1-2FS)-1/6...) (+17 OR +16)
		DAD	PDDL		#					PL 6D
			XKEP
		DMP	SL*		# S(+17 OR +16)
			0D
			1,1
		BOVB	DAD
			TCDANZIG
		STADR
		STORE	XKEPNEW
		STQ	AXC,1
			KEPRTN
		DEC	10
		BON	AXC,1
			MOONFLAG
			KEPLERN
		DEC	2
		GOTO
			KEPLERN

# Page 1336
FBR3		LXA,1	SSP
			DIFEQCNT
			S1
		DEC	-13
		DLOAD	SR
			DT/2
			9D
		TIX,1	ROUND
			+1
		PUSH	DAD
			TC
		STODL	TAU.
		DAD
			TET
		STCALL	TET
			KEPPREP

# Page 1337
# AGC ROUTINE TO COMPUTE ACCELERATION COMPONENTS.

ACCOMP		LXA,1	LXA,2
			PBODY
			PBODY
		VLOAD
			ZEROVEC
		STOVL	FV
			ALPHAV
		VSL*	VAD
			0 -7,2
			RCV
		STORE	BETAV
		BOF	XCHX,2
			DIM0FLAG
			+5
			DIFEQCNT
		STORE	VECTAB,2
		XCHX,2
			DIFEQCNT
		VLOAD	UNIT
			ALPHAV
		STODL	ALPHAV
			36D
		STORE	ALPHAM
		CALL
			GAMCOMP
		VLOAD	SXA,1
			BETAV
			S2
		STODL	ALPHAV
			BETAM
		STORE	ALPHAM
		BOF	DLOAD
			MIDFLAG
			OBLATE
			TET
		CALL
			LSPOS
		AXT,2	LXA,1
			2
			S2
		BOF
			MOONFLAG
			+3
		VCOMP	AXT,2
			0
		STORE	BETAV
		STOVL	RPQV
# Page 1338
			2D
		STORE	RPSV
		BOF	VLOAD
			DIM0FLAG
			GETRPSV
			ALPHAV
		VXSC	VSR*
			ALPHAM
			1,2
		VSU	XCHX,2
			BETAV
			DEFEQCNT
		STORE	VECTAB +6,2
		XCHX,2
			DIFEQCNT
GETRPSV		VLOAD	INCR,1
			RPQV
			4
		CLEAR	BOF
			RPQFLAG
			MOONFLAG
			+5
		VSR	VAD
			9D
			RPSV
		STORE	RPSV
		CALL
			GAMCOMP
		AXT,2	INCR,1
			4
			4
		VLOAD
			RPSV
		STCALL	BETAV
			GAMCOMP
		GOTO
			OBLATE
GAMCOMP		VLOAD	VSR1
			BETAV
		VSQ	SETPD
			0
		NORM	ROUND
			31D
		PDDL	NORM		# NORMED B SQUARED TO PD LIST
			ALPHAM		# NORMALIZE (LESS ONE) LENGTH OF ALPHA
			32D		# SAVING NORM SCALE FACTOR IN X1
		SR1	PDVL
			BETAV		# C(PDL+2) = ALMOST NORMED ALPHA
		UNIT
		STODL	BETAV
# Page 1339
			36D
		STORE	BETAM
		NORM	BDDV		# FORM NORMALIZE QUOTIEN ALPHAM/BETAM
			33D
		SR1R	PUSH		# C(PDL+2) = ALMOST NORMALIZE RHO.
		DLOAD*
			ASCALE,1
		STORE	S1
		XCHX,2	XAD,2
			S1
			32D
		XSU,2	DLOAD
			33D
			2D
		SR*	XCHX,2
			0 	-1,2
			S1
		PUSH	SR1R		# RHO/4 TO 4D
		PDVL	DOT
			ALPHAV
			BETAV
		SL1R	BDSU		# (RHO/4) - 2(ALPHAV/2.BETAV/2)
		PUSH	DMPR		# TO PDL+6
			4
		SL1
		PUSH	DAD
			DQUARTER
		PUSH	SQRT
		DMPR	PUSH
			10D
		SL1	DAD
			DQUARTER
		PDDL	DAD		# (1/4)+2((Q+1)/4)	TO PD+14D
			10D
			HALFDP
		DMPR	SL1
			8D
		DAD	DDV
			THREE/8
			14D
		DMPR	VXSC
			6
			BETAV
		PDVL	VSR3		# (G/2)(C(PD+4))B/2 TO PD+16D
			ALPHAV
		VAD	PUSH		# A12 + C(PD+16D) TO PD+16D
		DLOAD	DMP
			0
			12D
		NORM	ROUND
# Page 1340
			30D
		BDDV	DMP*
			2
			MUEARTH,2
		DCOMP	VXSC
		XCHX,2	XAD,2
			S1
			S2
		XSU,2	XSU,2
			30D
			31D
		BOV			# CLEAR OVIND
			+1
		VSR*	XCHX,2
			0 	-1,2
			S1
		VAD
			FV
		STORE	FV
		BOV	RVQ		# RETURN IF NO OVERFLOW
			+1
GOBAQUE		VLOAD	ABVAL
			TDELTAV
		BZE
			INT-ABRT
		DLOAD	SR
			H
			9D
		PUSH	BDSU
			TC
		STODL	TAU.
			TET
		DSU	STADR
		STCALL	TET
			KEPPREP
		CALL
			RECTIFY
		SETGO
			RPQFLAG
			TESTLOOP

INT-ABRT	EXIT
		TC	P00DOO
		OCT	00430

# Page 1341
# THE OBLATE ROUTINE COMPUTES THE ACCELERATION DUE TO OBLATENESS.  IT USES THE UNIT OF THE VEHICLE
# POSITION VECTOR FOUND IN ALPHAV AND THE DISTANCE TO THE CENTER IN ALPHAM.  THIS IS ADDED TO THE SUM OF THE
# DISTURBING ACCELERATIONS IN FV AND THE PROPER DIFEQ STAGE IS CALLED VIA X1.

OBLATE		LXA,2	DLOAD
			PBODY
			ALPHAM
		SETPD	DSU*
			0
			RDE,2
		BPL	BOF		# GET URPV
			NBRANCH
			MOONFLAG
			COSPHIE
		VLOAD	PDDL
			ALPHAV
			TET
		PDDL	CALL
			3/5
			R-TO-RP
		STORE	URPV
		VLOAD	VXV
			504LM
			ZUNIT
		VAD	VXM
			ZUNIT
			MMATRIX
		UNIT			# PROBABLY UNNECESSARY.
COMTERM		STORE	UZ
		DLOAD	DMPR
			COSPHI/2
			3/32
		PDDL	DSQ		# P2/64 TO PD0
			COSPHI/2
		DMPR	DSU
			15/16
			3/64
		PUSH	DMPR		# P3/32 TO PD2
			COSPHI/2
		DMP	SL1R
			7/12
		PDDL	DMPR
			0
			2/3
		BDSU	PUSH		# P4/128 TO PD4
		DMPR	DMPR
			COSPHI/2	# BEGIN COMPUTING P5/1024
			9/16
		PDDL	DMPR
			2
			5/128
# Page 1342
		BDSU
		DMP*
			J4REQ/J3,2
		DDV	DAD		#              -3
			ALPHAM		# (((P5/256)B 2  /R+P4/32)  /R+P3/8)ALPHAV
			4		#            4             3
		DMPR*	DDV
			2J3RE/J2,2
			ALPHAM
		DAD	VXSC
			2
			ALPHAV
		STODL	TVEC
		DMP*	SR1
			J4REQ/J3,2
		DDV	DAD
			ALPHAM
		DMPR*	SR3	           
			2J3RE/J2,2
		DDV	DAD	
			ALPHAM
		VXSC	VSL1	      
			UZ	
		BVSU		
			TVEC	        
		STODL	TVEC	
			ALPHAM	
		NORM	DSQ	
			X1	
		DSQ	NORM
			S1		#         4
		PUSH	BDDV*		# NORMED R  TO 0D
			J2REQSQ,2
		VXSC	BOV
			TVEC
			+1		# (RESET OVERFLOW INDICATOR)
		XAD,1	XAD,1
			X1
			X1
		XAD,1	VSL*
			S1
			0	-22D,1
		VAD	BOV
			FV
			GOBAQUE
		STCALL	FV
			QUALITY1
QUALITY3	DSQ			# J22 TERM X R**4 IN 2D.  SCALED B61
					# AS VECTOR.
		PUSH	DMP		# STORE COSPHI**2 SCALED B2 IN 8D.
# Page 1343		
			5/8		# 5 SCALED B3
		PDDL	SR2		# PUT 5 COSPHI**2, D5, IN 8D. GET
					# COSPHI**2 D2 FROM 8D
		DAT	BDSU		# END UP WITH (1-7 COSPHI**2), B5
			8D		# ADDING COSPHI**2 B4 SAME AS COSPHI**2
					# X 2 D5
			D1/32		# 1 SCALED B5
		DMP	DMP
			URPV		# X COMPONENT
			5/8		# 5 SCALED B3
		VXSC	VSL5		# AFTER SHIFT, SCALED B5
			URPV		# VECTOR, B1.
		PDDL			# VECTOR INTO 8D, 10D, 12D, SCALED B5.
					# GET 5 COSPHI**2 OUT OF 8D
		DSU	DAD
			D1/32		# 1 B5
			8D		# X COMPONENT (SAME AS MULTIPLYING
					# BY UNITX)
		STODL	8D
			URPV		# X COMPONENT
		DMP	DMP
			URPV	+4	# Z COMPONENT
			5/8		# 5 B3 ANSWER B5
		SL1	DAD		# FROM 12D FOR Z COMPONENT (SL1 GIVES 10
					# INSTEAD OF 5 FOR COEFFICIENT)
		PDDL	NORM		# BACK INTO 12D FOR Z COMPONENT
			ALPHAM		# SCALED B27 FOR MOON
			X2
		PUSH	SLOAD		# STORE IN 14D, DESTROYING URPV
					# X COMPONENT
			E32C31RM
		DDV	VXSC		# IF X2 = 0, DIVISION GIVES B53, VXSC
					# out of 8D B5 GIVES B58
		VSL*	VAD		# SHIFT MAKES B61, FOR ADDITION OF
					# VECTOR IN 2D
			0	-3,2
		VSL*	V/SC		# OPERAND FROM 0D, B108 FOR X1 = 0
			0	-27D,1	# FOR X1 = 0, MAKES B88, GIVING B-20
					# FOR RESULT.
		PDDL	PDDL
			TET
				5/8	# ANY NON-ZERO CONSTANT
		LXA,2	CALL		# POSITION IN 0D, TIME IN 6D. X2 LEFT
					# ALONE.
			PBODY
			RP-TO-R
		VAD	BOV		# OVERFLOW INDICATOR RESET IN *RP-TO-R*
			FV
			GOBAQUE
		STORE	FV
# Page 1344
NBRANCH		SLOAD	LXA,1
			DIFEQCNT
			MPAC
		DMP	CGOTO
			-1/12
			MPAC
			DIFEQTAB
COSPHIE		DLOAD
			ALPHAV +4
		STOVL	COSPHI/2
			ZUNIT
		GOTO
			COMTERM
DIFEQTAB	CADR	DIFEQ+0
		CADR	DIFEQ+1
		CADR	DIFEQ+2
		
TIMESTEP	BOF	CALL
			MIDFLAG
			RECTEST		# SKIP ORIGIN CHANGE LOGIC
			CHKSWTCH
		BWM
			DOSWITCH
			
RECTEST		VLOAD	ABVAL		# RECTIFY IF
			TDELTAV
		BOV
			CALLRECT
		DSU	BPL		#	1) EITHER TDELTAV OR TNUV EQUALS OR
			3/4		#	   EXCEEDS 3/4 IN MAGNITUDE
			CALLRECT	#
		DAD	SL*		#			OR
			3/4		#
			0 -7,2		#	2) ABVAL(TDELTAV) EQUALS OR EXCEEDS
		DDV	DSU		#	   .01(ABVAL(RCV))
			10D
			RECRATIO
		BPL	VLOAD
			CALLRECT
			TNUV
		ABVAL	DSU
			3/4
		BOV
			CALLRECT
		BMN
			INTGRATE
CALLRECT	CALL
			RECTIFY
INTGRATE	VLOAD
			TNUV
# Page 1345			
		STOVL	ZV
			TDELTAV
		STORE	YV
		CLEAR
			JSWITCH
DIFEQ0		VLOAD	SSP
			YV
			DIFEQCNT
			0
		STODL	ALPHAV
			DPZERO
		STORE	H		# START H AT ZERO.  GOES 0(DELT/2)DELT.
		BON	GOTO
			JSWITCH
			DOW..
			ACCOMP

CHKSWTCH	STQ	BOF
			ORIGEX
			RPQFLAG
			RPQOK		# MOON POSITION IS AVAILABLE
		DLOAD	CALL
			TET
			LUNPOS		# GET MOON POSITION
		BOF	VCOMP
			MOONFLAG
			+1
		STORE	RPQV

RPQOK		LXA,2	VLOAD		# RESTORE X2 AFTER USING LUNPOS
			PBODY
			TDELTAV		#  _
		VSL*	VAD		# |RQC|-RSPHERE WHEN OUTSIDE THE SPHERE.
			0	-7,2	# _   _            _
			RCV		# R = RDEVIATION + RCONIC
		BOF	ABVAL
			MOONFLAG
			EARSPH
		SR2	BDSU		# INSIDE
			RSPHERE
		GOTO	
			ORIGEX
EARSPH		VSU	ABVAL		# OUTSIDE
			RPQV
		DSU	GOTO
			RSPHERE
			ORIGEX
			
DOSWITCH	CALL
			ORIGCHNG
		GOTO
			INTGRATE

# Page 1346			
ORIGCHNG	STQ	CALL
			ORIGEX
			RECTIFY
		VLOAD	VSL*
			RCV
			0,2
		VSU	VSL*
			RPQV
			2,2
		STORE	RRECT
		STODL	RCV
			TET
		CALL
			LUNVEL
		BOF	VCOMP
			MOONFLAG
			+1
		PDVL	VSL*
			VCV
			0,2
		VSU
		VSL*
			0 +2,2
		STORE	VRECT
		STORE	VCV
		LXA,2	SXA,2
			ORIGEX
			QPRET
		BON	GOTO
			MOONFLAG
			CLRMOON
			SETMOON
# Page 1347
# THE RECTIFY SUBROUTINE IS CALLED BY THE INTEGRATION PROGRAM AND OCCASIONALLY BY THE MEASUREMENT INCORPORATION
# ROUTINES TO ESTABLISH A NEW CONIC.

RECTIFY		LXA,2	VLOAD
			PBODY
			TDELTAV
		VSL*	VAD
			0 	-7,2
			RCV
		STORE	RRECT
		STOVL	RCV
			TNUV
		VSL*	VAD
			0 	-4,2
			VCV
MINIRECT	STORE	VRECT
		STOVL	VCV
			ZEROVEC
		STORE	TDELTAV
		STODL	TNUV
			ZEROVEC
		STORE	TC
		STORE	XKEP
		RVQ

# Page 1348
# THE THREE DIFEQ ROUTINES -- DIFEQ+0, DIFEQ+12, DIFEQ+24 -- ARE ENTERED TO PROCESS THE CONTRIBUTIONS AT THE
# BEGINNING, MIDDLE, AND END OF THE TIMESTEP, RESPECTIVELY.  THE UPDATING IS DONE BY THE NYSTROM METHOD.

DIFEQ+0		VLOAD	VSR3
			FV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+1		VLOAD	VSR1
			FV
		PUSH	VAD
			PHIV
		STOVL	PSIV
		VSR1	VAD
			PHIV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+2		DLOAD	DMPR
			H
			DP2/3
		PUSH	VXSC
			PHIV
		VSL1	VAD
			ZV
		VXSC	VAD
			H
			YV
		STOVL	YV
			FV
		VSR3	VAD
			PSIV
		VXSC	VSL1
		VAD
			ZV
		STORE	ZV
		BOFF	CALL
			JSWITCH
			ENDSTATE
			GRP2PC
		LXA,2	VLOAD
			COLREG
			ZV
		VSL3			# ADJUST W-POSITION FOR STORAGE
		STORE	W 	+54D,2
		VLOAD
			YV
		VSL3	BOV
			WMATEND
		STORE	W,2

		CALL
			GRP2PC
# Page 1349
		LXA,2	SSP
			COLREG
			S2
			0
		INCR,2	SXA,2
			6
			YV
		TIX,2	CALL
			RELOADSV
			GRP2PC
		LXA,2	SXA,2
			YV
			COLREG

NEXTCOL		CALL
			GRP2PC
		LXA,2	VLOAD*
			COLREG
			W,2
		VSR3			# ADJUST W-POSITION FOR INTEGRATION
		STORE	YV
		VLOAD*	AXT,1
			W 	+54D,2
			0
		VSR3			# ADJUST W-VELOCITY FOR INTEGRATION
		STCALL	ZV
			DIFEQ0

ENDSTATE	BOV	VLOAD
			GOBAQUE
			ZV
		STOVL	TNUV
			YV
		STORE	TDELTAV
		BON	BOFF
			MIDAVFLG
			CKMID2		# CHECK FOR MID2 BEFORE GOING TO TIMEINC
			DIM0FLAG
			TESTLOOP
		EXIT
		TC	PHASCHNG
		OCT	04022		# PHASE 1
		TC	UPFLAG		# PHASE CHANGE HAS OCCURRED BETWEEN
		ADRES	REINTFLG	# INTSTALL AND INTWAKE
		TC	INTPRET
		SSP
			QPRET
			AMOVED
		BON	GOTO
			VINTFLAG
# Page 1350
			ATOPCSM
			ATOPLEM
AMOVED		SET	SSP
			JSWITCH
			COLREG
		DEC	-30
		BOFF	SSP
			D6OR9FLG
			NEXTCOL
			COLREG
		DEC	-48
		GOTO
			NEXTCOL

RELOADSV	DLOAD			# RELOAD TEMPORARY STATE VECTOR
			TDEC		# FROM PERMANENT IN CASE OF
		STCALL	TDEC1
			INTEGRV2	# BY STARTING AT INTEGRV2.
DIFEQCOM	DLOAD	DAD		# INCREMENT H AND DIFEQCNT.
			DT/2
			H
		INCR,1	SXA,1
		DEC	-12
			DIFEQCNT	# DIFEQCNT SET FOR NEXT ENTRY.
		STORE	H
		VXSC	VSR1
			FV
		VAD	VXSC
			ZV
			H
		VAD
			YV
		STORE	ALPHAV
		BON	GOTO
			JSWITCH
			DOW..
			FBR3

WMATEND		CLEAR	CLEAR
			DIM0FLAG	# DON'T INTEGRATE W THIS TIME
			ORBWFLAG	# INVALIDATE W
		CLEAR
			RENDWFLG
		SET	EXIT
			STATEFLG	# PICK UP STATE VECTOR UPDATE
		TC	ALARM
		OCT	421
		TC	INTPRET
# Page 1351
		GOTO
			TESTLOOP	# FINISH INTEGRATING STATE VECTOR

# Page 1352
# ORBITAL ROUTINE FOR EXTRAPOLATION OF THE W MATRIX.  IT COMPUTES THE SECOND DERIVATIVE OF EACH COLUMN POSITION
# VECTOR OF THE MATRIX AND CALLS THE NYSTROM INTEGRATION ROUTINES TO SOLVE THE DIFFERENTIAL EQUATIONS.  THE PROGRAM
# USES A TABLE OF VEHICLE POSITION VECTORS COMPUTED DURING THE INTEGRATION OF THE VEHICLE'S POSITION AND VELOCITY.

DOW..		LXA,2	DLOAD*
			PBODY
			MUEARTH,2
		STCALL	BETAM
			DOW..1
		STORE	FV
		BOF	INCR,1
			MIDFLAG
			NBRANCH
		DEC	-6
		LXC,2	DLOAD*
			PBODY
			MUEARTH 	-2,2
		STCALL	BETAM
			DOW..1
		BON	VSR6
			MOONFLAG
			+1
		VAD
			FV
		STCALL	FV
			NBRANCH
DOW..1		VLOAD	VSR4
			ALPHAV
		PDVL*	UNIT
			VECTAB,1
		PDVL	VPROJ
			ALPHAV
		VXSC	VSU
			3/4
		PDDL	NORM
			36D
			S2
		PUSH	DSQ
		DMP
		NORM	PDDL
			34D
			BETAM
		SR1	DDV
		VXSC
		LXA,2	XAD,2
			S2
			S2
		XAD,2	XAD,2
			S2
			34D
		VSL*	RVQ
# Page 1353
			0 -8D,2	

		SETLOC	ORBITAL1
		BANK

3/5		2DEC	.6 B-2

THREE/8		2DEC	.375

.3D		2DEC	.3 B-2

3/64		2DEC	3 B-6

DP1/4		2DEC	.25

DQUARTER	EQUALS	DP1/4
POS1/4		EQUALS	DP1/4
3/32		2DEC	3 B-5

15/16		2DEC	15. B-4

3/4		2DEC	3.0 B-2

7/12		2DEC	.5833333333

9/16		2DEC	9 B-4

5/128		2DEC	5 B-7

DPZERO		EQUALS	ZEROVEC
DP2/3		2DEC	.6666666667

2/3		EQUALS	DP2/3
OCT27		OCT	27

		BANK	13
		SETLOC	ORBITAL2
		BANK
# IT IS VITAL THAT THE FOLLOWING CONSTANTS NOT BE SHUFFLED
		DEC	-11
		DEC	-2
		DEC	-9
		DEC	-6
		DEC	-2
		DEC	-2
		DEC	0
		DEC	-12
		DEC	-9
		DEC	-4
ASCALE		DEC	-7
		DEC	-6
# Page 1354
		2DEC*	1.32715445 E16 B-54*	# S
		
		2DEC*	4.9027780 E8 B-30*	# M
		
MUEARTH		2DEC*	3.986032 E10 B-36*

		2DEC	0
		
J4REQ/J3	2DEC*	.4991607391 E7 B-26*

		2DEC	-176236.02 B-25
		
2J3RE/J2	2DEC*	-.1355426363 E5 B-27*

		2DEC*	.3067493316 E18 B-60*
		
J2REQSQ		2DEC*	1.75501139 E21 B-72*

3J22R2MU	2DEC*	9.20479048 E16 B-58*		
		
5/8		2DEC	5 B-3

-1/12		2DEC	-.1

MUM		=	MUEARTH -2
RECRATIO	2DEC	.01

RSPHERE		2DEC	64373.76 E3 B-29

RDM		2DEC	16093.44 E3 B-27

RDE		2DEC	80467.20 E3 B-29

RATT		EQUALS 	00
VATT		EQUALS	6D
TAT		EQUALS	12D
RATT1		EQUALS	14D
VATT1		EQUALS	20D
MU(P)		EQUALS	26D
TDEC1		EQUALS	32D
URPV		EQUALS	14D
COSPHI/2	EQUALS	URPV 	+4
UZ		EQUALS	20D
TVEC		EQUALS	26D



