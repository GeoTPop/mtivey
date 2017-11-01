function  J=magfd(DATE,ITYPE,ALT,COLAT,ELONG)
%
%  MAGFD function to compute IGRF components:
%  X,Y,Z,T given lat lon date and altitude.
%
%  DATE = date of survey dec. years
%  ITYPE=1 for geodetic to geocentric (USE 1)
%  ALT = altitude of survey relative to sealevel
%  COLAT=90-lat
%  ELONG=longitude of survey
%
%  Usage: out=magfd(DATE,ITYPE,ALT,COLAT,ELONG);
%
%  output array out contains components X,Y,Z,T
%
%  ref: 1985 IGRF revision, EOS Trans. AGU, 1986.
% updated for DGRF's since 1945
%
%  Maurice A. Tivey March 5, 1996
%                   May 1997		
 
DGRF=[1945:5:1995];
pflag=0;
if DATE < 0, pflag=1; DATE=abs(DATE); end
% Determine year for base DGRF to use.
 if DATE < 1995,
  BASE=fix(DATE-1945); 
  i=fix(BASE/5)+1;
  BASE=DGRF(i);
  if pflag==1, 
   fprintf('Using base year %f \n',BASE);      
  end 
  eval(['load sh',num2str(BASE-1900)])
  % loads agh and agh41 but now need to get 
   iagh=agh;iagh41=agh41;
  % load next epoch
  eval(['load sh',num2str(DGRF(i+1)-1900)])
   eagh=agh;eagh41=agh41;
   dgh=(eagh-iagh)./5;dgh41=(eagh41-iagh41)./5;
   agh=iagh;agh41=iagh41;
   clear iagh iagh41 eagh eagh41
   T = DATE - BASE;
 else
  load sh95   % load in 1995 igrf
  T     = DATE - 1995.0;
 end
%
      R     = ALT;
      ONE   = COLAT*0.0174533;
      SLAT  = cos(ONE);
      CLAT  = sin(ONE);
      ONE   = ELONG*0.0174533;
      CL(1) = cos(ONE);
      SL(1) = sin(ONE);
      X     = 0.0;
      Y     = 0.0;
      Z     = 0.0;
      CD    = 1.0;
      SD    = 0.0;
      L     = 1;
      M     = 1;
      N     = 0;
if ITYPE == 1  % CONVERSION FROM GEODETIC TO GEOCENTRIC COORDINATES
	A2    = 40680925.;
	B2    = 40408585.;
	ONE   = A2*CLAT*CLAT;
	TWO   = B2*SLAT*SLAT;
	THREE = ONE + TWO;
	FOUR  = sqrt(THREE);
	R     = sqrt(ALT*(ALT + 2.0*FOUR) + (A2*ONE + B2*TWO)/THREE);
	CD    = (ALT + FOUR)/R;
	SD    = (A2 - B2)/FOUR*SLAT*CLAT/R;
	ONE   = SLAT;
	SLAT  = SLAT*CD - CLAT*SD;
	CLAT  = CLAT*CD +  ONE*SD;
end
	RATIO = 6371.2/R;
%
%     COMPUTATION OF SCHMIDT QUASI-NORMAL COEFFICIENTS  P AND X(=Q)
%
      P(1)  = 2.0*SLAT;
      P(2)  = 2.0*CLAT;
      P(3)  = 4.5*SLAT*SLAT - 1.5;
      P(4)  = 5.1961524*CLAT*SLAT;
      Q(1)  = -CLAT;
      Q(2)  =  SLAT;
      Q(3)  = -3.0*CLAT*SLAT;
      Q(4)  = 1.7320508*(SLAT*SLAT - CLAT*CLAT);

for K=1:44,
 if (N-M) < 0
	M     = 0;
	N     = N + 1;
	RR    = RATIO^(N + 2);
	FN    = N;
 end
 FM    = M;
 if (K-5) >= 0 %8,5,5
	if (M-N) == 0 %,7,6,7
		ONE   = sqrt(1.0 - 0.5/FM);
		J     = K - N - 1;
		P(K)  = (1.0 + 1.0/FM)*ONE*CLAT*P(J);
		Q(K)  = ONE*(CLAT*Q(J) + SLAT/FM*P(J));
		SL(M) = SL(M-1)*CL(1) + CL(M-1)*SL(1);
		CL(M) = CL(M-1)*CL(1) - SL(M-1)*SL(1);
	else
		ONE   = sqrt(FN*FN - FM*FM);
		TWO   = sqrt((FN - 1.0)^2 - FM*FM)/ONE;
		THREE = (2.0*FN - 1.0)/ONE;
		I     = K - N;
		J     = K - 2*N + 1;
		P(K)  = (FN + 1.0)*(THREE*SLAT/FN*P(I) - TWO/(FN - 1.0)*P(J));
		Q(K)  = THREE*(SLAT*Q(I) - CLAT/FN*P(I)) - TWO*Q(J);
	end
%
%     SYNTHESIS OF X, Y AND Z IN GEOCENTRIC COORDINATES
%
 end
 ONE   = (agh(L) + dgh(L)*T)*RR;

 if M == 0 %10,9,10
	X     = X + ONE*Q(K);
	Z     = Z - ONE*P(K);
	L     = L + 1;
 else
	TWO   = (agh(L+1) + dgh(L+1)*T)*RR;
	THREE = ONE*CL(M) + TWO*SL(M);
	X     = X + THREE*Q(K);
	Z     = Z - THREE*P(K);
	if CLAT > 0 %12,12,11
		Y = Y+(ONE*SL(M)-TWO*CL(M))*FM*P(K)/((FN + 1.0)*CLAT);
	else
		Y = Y + (ONE*SL(M) - TWO*CL(M))*Q(K)*SLAT;
	end
	L     = L + 2;
 end
	M     = M + 1;
end
%     CONVERSION TO COORDINATE SYSTEM SPECIFIED BY ITYPE
ONE   = X;
X     = X*CD +  Z*SD;
Z     = Z*CD - ONE*SD;
T     = sqrt(X*X + Y*Y + Z*Z);
J=[X,Y,Z,T];
%  END
