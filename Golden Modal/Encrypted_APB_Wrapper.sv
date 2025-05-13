package shared_pkg;
`protected

    MTI!#Ds,s2rxoC-sx\w'2Er;2S;aAw]^~{w'w[G?a]7~[-l$7iuTZj$nspe#OJuEonsl{^}GRV3{
    rI1~<m-skei>VK0<=Y#~xeIq^i,3_Yae==?OB_a#OB*=N,n+VU-;r_eV7vVDT_WYC{=<\)Dnxm[|
    l+mwR,mRv2p+>7gIRKAye<eO72[W_ETa']PE+>uN=Qx;gEZ^X|,+RBmjlie!R1+$G>F<5ZDbTxvG
    }Z<Jm'zU@5k?WV+w)z*A,X[2lwh4m$iv3&7?'B0Pu{Bik[DQDC<p;sQwM-<,-kaw#N#<w!aYA#;}
    ;A*o_[_'r?H<+r%}a'E}r!pU,Bx"l[r#L=Qm>nYJOe~uAYh_KoKl{''9}W+{2DO1D+}E7ZeK!*71
    }xkl2\,3;A1A$p]DR2XQ(_Tao^i\#&_5VUp;B}II#H2Dk2*GGu>{Vm,+V}t^+awB9B^vI:1;wQ_$
    eHsD-!*52pQe^Tf|{Yk{Y-@zp?\@@1Y^urx;Y5jTBplE5sm[p'A^*o'!,^#~*+$}#$Uk6m=OZcKY
    D?dOx;{,{sOxRX#s[uDkUHG!xDa26xVy[CKQ=koH$G{-Oa'@NDCn[_unVkG,s_<
`endprotected
endpackage : shared_pkg

module RegisterFile #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16			
) (
// Global Sinals
	input wire  						clk,
    input wire							rstn,  

    input wire [ADDR_WIDTH-1 : 0]   	addr,
    input wire [DATA_WIDTH-1 : 0]   	write_data,
    input wire                      	wr,
    input wire 							enable,

    output reg [DATA_WIDTH-1 : 0]   	read_data
    // output 	                      	RegSLVERR,
    // output reg                      	ACK      
);

	// RegSLVERR is pripherable 
	assign RegSLVERR = 0;
		
	// Registers
	reg [DATA_WIDTH-1:0] SYS_STATUS_REG;
	reg [DATA_WIDTH-1:0] INT_CTRL_REG;
	reg [DATA_WIDTH-1:0] DEV_ID_REG;
	reg [DATA_WIDTH-1:0] MEM_CTRL_REG;
	reg [DATA_WIDTH-1:0] TEMP_SENSOR_REG;
	reg [DATA_WIDTH-1:0] ADC_CTRL_REG;
	reg [DATA_WIDTH-1:0] DBG_CTRL_REG;
	reg [DATA_WIDTH-1:0] GPIO_DATA_REG;
	reg [DATA_WIDTH-1:0] DAC_OUTPUT_REG;
	reg [DATA_WIDTH-1:0] VOLTAGE_CTRL_REG;
	reg [DATA_WIDTH-1:0] CLK_CONFIG_REG;
	reg [DATA_WIDTH-1:0] TIMER_COUNT_REG;
	reg [DATA_WIDTH-1:0] INPUT_DATA_REG;
	reg [DATA_WIDTH-1:0] OUTPUT_DATA_REG;
	reg [DATA_WIDTH-1:0] DMA_CTRL_REG;
	reg [DATA_WIDTH-1:0] SYS_CTRL_REG;
`protected

    MTI!#I,WOJeB<UUZ'!]BBU<vakQjuj^K{TD[?}m<jf7~[JY$7i<T*Q$+DQRmr[l;UoN?sYXFeHan
    1+nDH7iuE2IVr\YGN{5nja<~[L~l$iYX3Brz$[&e5pu[!,j=@AD+wp@s~H!x3*>|nrvOl-nEzY?[
    r{=B&]aYivi]o2z3DT}@2i=nAZQe!I7xk}]!Tx3=EawTAxkOG;_<JH}W!?\}WgL<6np'~*iHOt>=
    Hz{V-@QC-ngXAj\/B!<z?>*Y^KX{T,oO,OZ1o]D}]5J<FNLS*W5]7e_11mH={5Z,^l5;~zzl=|J=
    $>0C'R\LI#V?mR4xi{_}VAYv*kezT]2)S|]2Cne*sT=*v3}I7z#Hx,9{rHHSl7wklx<#G;Xw^<I1
    Za7B#D}Go$>;Bv,slE=x,rQHEp5*5Ym{e$A?IVY=_V>Jx?^pw7_m/B3^#BHp@Ye*EvwnG,0G{_;o
    #KEpaCww]i[f2^*7z,mp^Aor4"Bxi+YVQ]i7kE+NaH=xyrjQ3KH>$DIl=vT$?ZEr#E$k\zO}{?ae
    OI_7_?Q]xX<{,UHBOwUTuuT<~pZ@'o>p2=CxR>ouTQ?pD9GH;evrUw*B-=]o<uXwO=^C?*-5n+j@
    7I4'${1zEHX*1$ocz]*_:?Vkae3-+W*7YzU3Ji'und>75u~sj~nG-<B5CvQD}oCWQKGTne<v\Rn*
    VnB]];~Y'v?^HJ!l5Bxxv;JXp2};o;Qp~oz5_^UA~nSYQ$kQ@C^xUmw_,_plo-l5!5#]uDi'*=$Q
    w3E,eJ~C+Y\B+@wT+!VuXo\v\RGRYs^!DeO.K\+H&+U25ssnQjsCj*^BXB+rWIXZ*I37VIKl^%=;
    *TC><x>js[BJXApTVjVi
`endprotected
endmodule

module APB_Slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter SLAVE_ID = 4'b0001
) (
// Global Sinals
    input PCLK                                 ,
    input PRESETn                              ,  

// input SLAVE FROM MASTER  
    input [ADDR_WIDTH-1 : 0]     PADDR         ,
    input                        PWRITE        ,
    input [DATA_WIDTH-1 : 0]     PWDATA        ,
    input                        PENABLE       ,

// input SLAVE FROM REG_FILE  
    input [DATA_WIDTH-1 : 0]     RegRDATA      ,
    input       PSELx         ,
  
// output SLAVE TO MASTER  
    output reg                       PREADY    ,
    output reg [DATA_WIDTH-1 : 0]    PRDATA    ,

// output SLAVE TO REG_FILE  
    output reg [ADDR_WIDTH-1 : 0]    RegADDR   ,
    output reg [DATA_WIDTH-1 : 0]    RegWDATA  ,
    output reg                       RegENABLE,
    output reg                       RegWRITE
);
    
    import shared_pkg::*;
    state_e NextState, CurrentState;
    wire correct_slave;
    reg [3:0] address_encoding;
    assign correct_slave = PSELx & (SLAVE_ID === address_encoding);
`protected 
    MTI!#?nzm]QC1]Xo\GK33G=paxQjuj^K{TDp1}m<jf7~[a3$7^<N*^'H=~w>GB[={C,Tn>maHt}@
    mZ\_jHaTQ5RTu!J7o[QUTX[M2w^i)}xv\YA~^Cw$$O1;I};x[9In^n@OITAei~$nHp,7wBAaI!L&
    l{}JUI^iU<nvBWpj=\#*?1$nDA_RmpW}t#^>I3_E~\+Oe7E\Y.7o=mjR?m$jsT,UU^-&?SBsZ5]}
    V_1@;[8-5>AYw5H7nAY(3{^i]}KUB~WwOe=ADYpz!rKvoTx#{I<>?-B2Qj@JGk-@e;3z7za+wo5r
    \BOCqYas3Ds~^Qlj=VCnw{+GpI6dJ<jak\I>[m!XMZv$i,O{1*!C+mYnWqU5l]0Q<'5e-H$Q&KVY
    }/BnEAS1j{-@sXm5?KE*n2npHvAhOExmi[Q]njW[t<7Q*[FWVB[-Dk\i7z7*rn[BiW3}D^VGjo{l
    r-?D{[.\'i[_5[5s<1##<+keRj_BX,k,n2vv3!I~HJzeVYsc4dRa{;]uQ+3za<I>U#OT]rbd]xi#
    -X!2Z=@uq2EX*jzNV{Du2ARAoOr^D~lI,JrA?EBu2*O{G3sKVes?Xn<BYXxsl5ApIO75zQE<xTzs
    Q<Kj3ET*9@$!Yjl!<Mh\__p'UV*GxT$V?Ol5bGO#1Ip;sIWeHA$k,sC3^UDHo~wA!7AGBLk}}v]z
    nO<Ez$}G3+sj+*Terr$Dmn.1?^>I=sA%ACsK[_wH+5G^pt$1_l}uOO^,H'<RR~5T<YXx;Y2[,1[z
    r,=}{!~RB3eO!Oo?}x2n5WHl?ulU*xC;WuN#X2v4]YI*\|~w='2H-e1B!2^mB>T+HH_a<$a1I,.l
    J\s3o^,}O<B2oZWRRp{jO\wC\$IRRX!\?C@!w*TR@G_Re7,Bz~@j@$z'*Rj^URijs{rd)E;3}t5O
    voQ2+U{O}Q;wYiB5!*,mYCcW\m;z=3<xO]1=i*~-'X\1Ulpx=vIYGkx,*?roEAzzDvauvX^~sCps
    pTAklDilIGQd#H;WpoCOoTsn=!RBx1*51YekWHR$1+l\CEiDl'A$WGe3SI=D"4=G--^alaBH*n|_
    m}!x{JO@<
`endprotected
endmodule

module APB_Wrapper #(
    parameter DATA_WIDTH = 32				 ,
    parameter ADDR_WIDTH = 16				 
) (

// Global Sinals
    input 						 	PCLK     ,  
    input 						 	PRESETn  ,  

// Slave FROM Master
    input [ADDR_WIDTH-1 : 0]     	PADDR    ,
    input                        	PWRITE   ,
    input [DATA_WIDTH-1 : 0]     	PWDATA   ,
    input                        	PENABLE  ,
    input                           PSELx    ,

// Slave TO Master
    output                          PREADY   ,
    output [DATA_WIDTH-1 : 0]    	PRDATA   
);
`protected

    MTI!#ieCX72[ucQ1~-ds>Aw$G[xB3E{]p~}n1k$3Y(Di{;(~['u,CI7Gw7,NOz@{@E]I#S+D,~}u
    !\,j][Golpuse'Q?ZW$7#].srpJHsD[w7m~6a-O}nR]7s}YnlpI<7BR+OHv~1jQ[^,zHR+*,X1Hz
    ?}x+iRn$-lYC>o+@1!{R;G!]/J$Is"fZ}JZ]7{H0s?C'v^[R3oX2wY-^=n!5<Yv]}>D[3I{x;-^$
    dSB{$WB_H!}H=Var!xZz!UR}^@b[*r}wBsOml>urixxHw]2eUU@#=J]CYeuuw_E3Au3/ljG[ou<e
    E[J?5i]r7lvjbjxzIwUvBWX{E>QiTaYZ2$2KV?aTr<|^?nW&O4-1?]a]}iGVE?,[u\5uJ+QG1Y^<
    C,WUbQv{?+}Ul}-UW57mQuOr+i_AIBu^eUs#-/*5mUu=zVE]o#:_Tu<N$GJV^@=o+,!VfI!}{{R{
    G'wHU\xJhmj=,}<>Z$Ba#;sYK1q7*jT$VoQtM'#d1eTobm\wXr{H1#GZK$#Ii^vOJ*m7i!oI[lZ*
    QXxDa>jIuZX][80QGI2Ydv\$U?+v\s<1]6OTpxTHw<'a-ZT[IvmrrkWD@JB,Q*G>QI[hI-wR6s'E
    >T=UvUjVBG+!2p~~},}*lRGe7HsK^W1Glk'?B-}TTTRjYuTs@BmVjQ={#,K\^OuVj[_m7[UJERpw
    ]#T~!d:~]3BD1ZX$@{EC,\15_D$\$'=<XO_l@wDV'1<mo-}\UUpjEXTAIs!an<ZuVZJU$k!d=a-2
    G-5ip@]up;p+(NdxsZnBTxm
`endprotected
endmodule