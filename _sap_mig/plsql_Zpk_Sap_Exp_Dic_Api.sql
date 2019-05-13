set define off
CREATE OR REPLACE PACKAGE IFSAPP.ZPK_SAP_EXP_DIC_API IS
  -- Author  : PKOSNIK
  -- Created : 24.09.2018 08:39:47
  -- Purpose : Export data to sap
  --
  PROCEDURE Prepare_All_Store_Tab;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0000);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0001);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0002);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0003);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0006);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0007);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0008);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0009);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0014);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0015);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0015,Chunk_No_ in NUMBER);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0016);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0019);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0021);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0022);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0023);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0024);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0041);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0105);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0185);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0267);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0413);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0414);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0515);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0517);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0558);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2001);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2003);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2010);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2006);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0866);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It9950);
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558a,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1);
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558b,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1);
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558c,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1);
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.Paybase);
END Zpk_Sap_Exp_Dic_Api;
/
CREATE OR REPLACE PACKAGE BODY IFSAPP.ZPK_SAP_EXP_DIC_API IS

  --
  FUNCTION Init_Head_Store___( --
                              Pakey_ IN Zpk_Sap_Exp.Pakey,
                              Pshd1_ IN Zpk_Sap_Exp.Pshd1,
                              Meta_  IN Zpk_Sap_Exp.Meta) RETURN Ic_Xx_Import_Tab%ROWTYPE IS
    Ot_ Ic_Xx_Import_Tab%ROWTYPE;
  BEGIN
    --
    Ot_.S1 := Pakey_.Mandt;
    Ot_.S2 := Pakey_.Pernr;
    Ot_.S3 := Pakey_.Subty;
    Ot_.S4 := Pakey_.Objps;
    Ot_.S5 := Pakey_.Sprps;
    Ot_.S6 := Pakey_.Endda;
    Ot_.S7 := Pakey_.Begda;
    Ot_.S8 := Pakey_.Seqnr;
    --
    Ot_.S9  := Pshd1_.Aedtm;
    Ot_.S10 := Pshd1_.Uname;
    Ot_.S11 := Pshd1_.Histo;
    Ot_.S12 := Pshd1_.Itxex;
    Ot_.S13 := Pshd1_.Refex;
    Ot_.S14 := Pshd1_.Ordex;
    Ot_.S15 := Pshd1_.Itbld;
    Ot_.S16 := Pshd1_.Preas;
    Ot_.S17 := Pshd1_.Flag1;
    Ot_.S18 := Pshd1_.Flag2;
    Ot_.S29 := Pshd1_.Flag3;
    Ot_.S20 := Pshd1_.Flag4;
    Ot_.S21 := Pshd1_.Rese1;
    Ot_.S22 := Pshd1_.Rese2;
    Ot_.S23 := Pshd1_.Grpvl;
    --
    Ot_.S99 := To_Char(Meta_.Lineno, '000000000');
    --
    RETURN Ot_;
  END Init_Head_Store___;
  --
  PROCEDURE Prepare_Store_Tab IS
  BEGIN
    DELETE FROM Ic_Xx_Import_Tab WHERE Session_Id = Userenv('SESSIONID');
  END Prepare_Store_Tab;
  PROCEDURE Prepare_All_Store_Tab IS
  BEGIN
    DELETE FROM Ic_Xx_Import_Tab;
  END Prepare_All_Store_Tab;
  --
  PROCEDURE Save_Store_Tab( --
                           Ot_ IN OUT Zpk_Sap_Exp.Stab_) IS
    i_ NUMBER;
  BEGIN
    i_ := Ot_.First;
    WHILE i_ IS NOT NULL LOOP
      Ot_(i_).Session_Id := Userenv('SESSIONID');
      i_ := Ot_.Next(i_);
    END LOOP;
    IF Ot_.Last IS NOT NULL THEN
      FORALL x IN Ot_.First .. Ot_.Last
        INSERT INTO Ic_Xx_Import_Tab VALUES Ot_ (x);
    END IF;
    --
  END Save_Store_Tab;
  --
  FUNCTION Prepare_Header_Line(Infotype VARCHAR2) RETURN Ic_Xx_Import_Tab%ROWTYPE IS
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
  BEGIN
    --.INCLUDE  PAKEY        Key for HR Master Data
    Oa_.S1 := 'MANDT'; -- varchar2(3), --MANDT CLNT  3  T000  Client
    Oa_.S2 := 'PERNR'; --  varchar2(8), --PERSNONUMC  8   PA0003 Personnel number
    Oa_.S3 := 'SUBTY'; --  varchar2(4), --SUBTY CHAR  4   Subtype
    Oa_.S4 := 'OBJPS'; --  varchar2(2), --OBJPS CHAR  2   Object Identification
    Oa_.S5 := 'SPRPS'; --  varchar2(1), --SPRPS CHAR  1   Lock Indicator for HR Master Data Record
    Oa_.S6 := 'ENDDA'; --  varchar2(8), --ENDDA DATS  8   End Date
    Oa_.S7 := 'BEGDA'; --  varchar2(8), --BEGDA DATS  8   Start Date
    Oa_.S8 := 'SEQNR'; --  varchar2(3) --SEQNR NUMC  3   Number of Infotype Record with Same Key
    --.INCLUDE  PSHD1       HR Master Record: Control Field
    Oa_.S9  := 'AEDTM'; --  varchar2(8), -- AEDAT DATS  8       Changed On
    Oa_.S10 := 'UNAME'; --  varchar2(8), -- AENAM CHAR  12      Name of Person Who Changed Object
    Oa_.S11 := 'HISTO'; --  varchar2(8), -- HISTO CHAR  1       Historical Record Flag
    Oa_.S12 := 'ITXEX'; --  varchar2(8), -- ITXEX CHAR  1       Text Exists for Infotype
    Oa_.S13 := 'REFEX'; --  varchar2(8), -- PRFEX CHAR  1       Reference Fields Exist (Primary/Secondary Costs)
    Oa_.S14 := 'ORDEX'; --  varchar2(8), -- ORDEX CHAR  1       Confirmation Fields Exist
    Oa_.S15 := 'ITBLD'; --  varchar2(8), -- ITBLD CHAR  2       Infotype Screen Control
    Oa_.S16 := 'PREAS'; --  varchar2(8), -- PREAS CHAR  2       T530E Reason for Changing Master Data
    Oa_.S17 := 'FLAG1'; --  varchar2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Oa_.S18 := 'FLAG2'; --  varchar2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Oa_.S19 := 'FLAG3'; --  varchar2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Oa_.S20 := 'FLAG4'; --  varchar2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Oa_.S21 := 'RESE1'; --  varchar2(8), -- NUSED2  CHAR  2     Reserved Field/Unused Field of Length 2
    Oa_.S22 := 'RESE2'; --  varchar2(8), -- NUSED2  CHAR  2     Reserved Field/Unused Field of Length 2
    Oa_.S23 := 'GRPVL'; --  varchar2(8) --  PCCE_GPVAL  CHAR  4 Grouping Value for Personnel Assignments
    CASE Infotype
      WHEN '0000' THEN
        --.INCLUDE PS0000 HR Master Record :Infotype 0000(Actions)
        Oa_.S24 := 'MASSN'; --   varchar2(8), -- MASSN CHAR  2 T529A Action Type
        Oa_.S25 := 'MASSG'; --  varchar2(8), -- MASSG CHAR  2 T530  Reason for Action
        Oa_.S26 := 'STAT1'; --   varchar2(8), -- STAT1 CHAR  1 T529U Customer-Specific Status
        Oa_.S27 := 'STAT2'; --   varchar2(8), -- STAT2 CHAR  1 T529U Employment Status
        Oa_.S28 := 'STAT3'; --   varchar2(8) -- STAT3  CHAR  1 T529U Special Payment Status
      WHEN '0001' THEN
        --.INCLUDE  PS0001_SAP        HR Master Record: Infotype 0001 (Org. Assignment)
        Oa_.S24 := 'BUKRS'; --   varchar2(4), --   BUKRS CHAR  4 T001  Company Code
        Oa_.S25 := 'WERKS'; --        varchar2(4), --   PERSA CHAR  4 T500P Personnel Area
        Oa_.S26 := 'PERSG'; --        varchar2(1), --   PERSG CHAR  1 T501  Employee Group
        Oa_.S27 := 'PERSK'; --        varchar2(2), --   PERSK CHAR  2 T503K Employee Subgroup
        Oa_.S28 := 'VDSK1'; --        varchar2(14), --  VDSK1 CHAR  14  T527O Organizational Key
        Oa_.S29 := 'GSBER'; --        varchar2(4), --   GSBER CHAR  4 TGSB  Business Area
        Oa_.S30 := 'BTRTL'; --        varchar2(4), --   BTRTL CHAR  4 T001P Personnel Subarea
        Oa_.S31 := 'JUPER'; --        varchar2(4), --   JUPER CHAR  4   Legal Person
        Oa_.S32 := 'ABKRS'; --        varchar2(2), --   ABKRS CHAR  2 T549A Payroll Area
        Oa_.S33 := 'ANSVH'; --        varchar2(2), --   ANSVH CHAR  2 T542A Work Contract
        Oa_.S34 := 'KOSTL'; --        varchar2(10), --  KOSTL CHAR  10  CSKS  Cost Center ALPHA
        Oa_.S35 := 'ORGEH'; --        varchar2(8), --   ORGEH NUMC  8 T527X Organizational Unit
        Oa_.S36 := 'PLANS'; --        varchar2(8), --   PLANS NUMC  8 T528B Position
        Oa_.S37 := 'STELL'; --        varchar2(8), --   STELL NUMC  8 T513  Job
        Oa_.S38 := 'MSTBR'; --        varchar2(8), --   MSTBR CHAR  8   Supervisor Area
        Oa_.S39 := 'SACHA'; --        varchar2(3), --   SACHA CHAR  3 T526  Payroll Administrator
        Oa_.S40 := 'SACHP'; --        varchar2(3), --   SACHP CHAR  3 T526  Administrator for HR Master Data
        Oa_.S41 := 'SACHZ'; --        varchar2(3), --   SACHZ CHAR  3 T526  Administrator for Time Recording
        Oa_.S42 := 'SNAME'; --        varchar2(30), --  SMNAM CHAR  30    Employees Name (Sortable by LAST NAME FIRST NAME)
        Oa_.S43 := 'ENAME'; --        varchar2(40), --  EMNAM CHAR  40    Formatted Name of Employee or Applicant
        Oa_.S44 := 'OTYPE'; --        varchar2(2), --   OTYPE CHAR  2 T778O Object Type
        Oa_.S45 := 'SBMOD'; --        varchar2(4), --   SBMOD CHAR  4   Administrator Group
        Oa_.S46 := 'KOKRS'; --        varchar2(4), --   KOKRS CHAR  4 TKA01 Controlling Area
        Oa_.S47 := 'FISTL'; --        varchar2(16), --  FISTL CHAR  16
        Oa_.S48 := 'GEBER'; --        varchar2(10), --  BP_GEBER  CHAR  10
        Oa_.S49 := 'FKBER'; --        varchar2(16), --  FKBER CHAR  16  * Functional Area
        Oa_.S50 := 'GRANT_NBR'; --    varchar2(20), --  GM_GRANT_NBR  CHAR  20    Grant ALPHA
        Oa_.S51 := 'SGMNT'; --        varchar2(10), --  FB_SEGMENT  CHAR  10  * Segment for Segmental Reporting ALPHA
        Oa_.S52 := 'BUDGET_PD'; --    varchar2(10) --  FM_BUDGET_PERIOD  CHAR  10  * FM: Budget Period
        Oa_.S91 := 'IFS_POS_CODE';
        Oa_.S92 := 'IFS_POS_NAME';
        Oa_.S93 := 'IFS_POS_NAME_EN';
      WHEN '0002' THEN
        Oa_.S24 := 'INITS'; -- varchar2(10), --    INITS CHAR  10    Initials
        Oa_.S25 := 'NACHN'; -- varchar2(40), --      PAD_NACHN CHAR  40    Last Name
        Oa_.S26 := 'NAME2'; -- varchar2(40), --      PAD_NAME2 CHAR  40    Name at Birth
        Oa_.S27 := 'NACH2'; -- varchar2(40), --      PAD_NACH2 CHAR  40    Second Name
        Oa_.S28 := 'VORNA'; -- varchar2(40), --      PAD_VORNA CHAR  40    First Name
        Oa_.S29 := 'CNAME'; -- varchar2(80), --      PAD_CNAME CHAR  80    Complete Name
        Oa_.S30 := 'TITEL'; -- varchar2(15), --      TITEL CHAR  15  T535N Title
        Oa_.S31 := 'TITL2'; -- varchar2(15), --      TITL2 CHAR  15  T535N Second Title
        Oa_.S32 := 'NAMZU'; -- varchar2(15), --      NAMZU CHAR  15  T535N Other Title
        Oa_.S33 := 'VORSW'; -- varchar2(15), --      VORSW CHAR  15  T535N Name Prefix
        Oa_.S34 := 'VORS2'; -- varchar2(15), --      VORS2 CHAR  15  T535N Second Name Prefix
        Oa_.S35 := 'RUFNM'; -- varchar2(40), --      PAD_RUFNM CHAR  40    Nickname
        Oa_.S36 := 'MIDNM'; -- varchar2(40), --      PAD_MIDNM CHAR  40    Middle Name
        Oa_.S37 := 'KNZNM'; -- varchar2(2), --      KNZNM NUMC  2   Name Format Indicator for Employee in a List
        Oa_.S38 := 'ANRED'; -- varchar2(1), --      ANRDE CHAR  1 T522G Form-of-Address Key
        Oa_.S39 := 'GESCH'; -- varchar2(1), --      GESCH CHAR  1   Gender Key
        Oa_.S40 := 'GBDAT'; -- varchar2(8), --      GBDAT DATS  8   Date of Birth PDATE
        Oa_.S41 := 'GBLND'; -- varchar2(3), --      GBLND CHAR  3 T005  Country of Birth
        Oa_.S42 := 'GBDEP'; -- varchar2(3), --      GBDEP CHAR  3 T005S State
        Oa_.S43 := 'GBORT'; -- varchar2(40), --      PAD_GBORT CHAR  40    Birthplace
        Oa_.S44 := 'NATIO'; -- varchar2(3), --      NATSL CHAR  3 T005  Nationality
        Oa_.S45 := 'NATI2'; -- varchar2(3), --      NATS2 CHAR  3 T005  Second Nationality
        Oa_.S46 := 'NATI3'; -- varchar2(3), --      NATS3 CHAR  3 T005  Third Nationality
        Oa_.S47 := 'SPRSL'; -- varchar2(1), --      PAD_SPRAS LANG  1 T002  Communication Language  ISOLA
        Oa_.S48 := 'KONFE'; -- varchar2(2), --      KONFE CHAR  2 * Religious Denomination Key
        Oa_.S49 := 'FAMST'; -- varchar2(1), --      FAMST CHAR  1 * Marital Status Key
        Oa_.S50 := 'FAMDT'; -- varchar2(8), --      FAMDT DATS  8   Valid From Date of Current Marital Status
        Oa_.S51 := 'ANZKD'; -- varchar2(3), --      ANZKD DEC 3   Number of Children
        Oa_.S52 := 'NACON'; -- varchar2(1), --      NACON CHAR  1   Name Connection
        Oa_.S53 := 'PERMO'; -- varchar2(2), --      PIDMO CHAR  2   Modifier for Personnel Identifier
        Oa_.S54 := 'PERID'; -- varchar2(20), --      PRDNI CHAR  20    Personnel ID Number
        Oa_.S55 := 'GBPAS'; -- varchar2(8), --      GBPAS DATS  8   Date of Birth According to Passport
        Oa_.S56 := 'FNAMK'; -- varchar2(40), --      P22J_PFNMK  CHAR  40    First name (Katakana)
        Oa_.S57 := 'LNAMK'; -- varchar2(40), --      P22J_PLNMK  CHAR  40    Last name (Katakana)
        Oa_.S58 := 'FNAMR'; -- varchar2(40), --      P22J_PFNMR  CHAR  40    First Name (Romaji)
        Oa_.S59 := 'LNAMR'; -- varchar2(40), --      P22J_PLNMR  CHAR  40    Last Name (Romaji)
        Oa_.S60 := 'NABIK'; -- varchar2(40), --      P22J_PNBIK  CHAR  40    Name of Birth (Katakana)
        Oa_.S61 := 'NABIR'; -- varchar2(40), --      P22J_PNBIR  CHAR  40    Name of Birth (Romaji)
        Oa_.S62 := 'NICKK'; -- varchar2(40), --      P22J_PNCKK  CHAR  40    Koseki (Katakana)
        Oa_.S63 := 'NICKR'; -- varchar2(40), --      P22J_PNCKR  CHAR  40    Koseki (Romaji)
        Oa_.S64 := 'GBJHR'; -- varchar2(4), --      GBJHR NUMC  4   Year of Birth GJAHR
        Oa_.S65 := 'GBMON'; -- varchar2(2), --      GBMON NUMC  2   Month of Birth
        Oa_.S66 := 'GBTAG'; -- varchar2(2), --      GBTAG NUMC  2   Birth Date (to Month/Year)
        Oa_.S67 := 'NCHMC'; -- varchar2(25), --      NACHNMC CHAR  25    Last Name (Field for Search Help)
        Oa_.S68 := 'VNAMC'; -- varchar2(25), --      VORNAMC CHAR  25    First Name (Field for Search Help)
        Oa_.S69 := 'NAMZ2'; -- varchar2(15) --     NAMZ2 CHAR  15  T535N Name Affix for Name at Birth
      WHEN '0003' THEN
        Oa_.S24 := 'ABRSP'; -- varchar2(1), --   ABRSP CHAR  1   Indicator: Personnel number locked for payroll
        Oa_.S25 := 'ABRDT'; -- varchar2(8), --   LABRD DATS  8   Accounted to
        Oa_.S26 := 'RRDAT'; -- varchar2(8), --   RRDAT DATS  8   Earliest master data change since last payroll run
        Oa_.S27 := 'RRDAF'; -- varchar2(8), --   RRDAF DATS  8   not in use
        Oa_.S28 := 'KOABR'; -- varchar2(1), --   PAD_INTERN  CHAR  1   Internal Use
        Oa_.S29 := 'PRDAT'; -- varchar2(8), --   PRRDT DATS  8   Earliest personal retroactive accounting date
        Oa_.S30 := 'PKGAB'; -- varchar2(8), --   PKGAB DATS  8   Date as of which personal calendar must be generated
        Oa_.S31 := 'ABWD1'; -- varchar2(8), --   ABWD1 DATS  8   End of processing 1 (run payroll for pers.no. up to)
        Oa_.S32 := 'ABWD2'; -- varchar2(8), --   ABWD2 DATS  8   End of processing (do not run payroll for pers.no. after)
        Oa_.S33 := 'BDERR'; -- varchar2(8), --   BDERR DATS  8   Recalculation date for PDC
        Oa_.S34 := 'BDER1'; -- varchar2(8), --   BDER1 DATS  8   Effective recalculation date for PDC
        Oa_.S35 := 'KOBDE'; -- varchar2(1), --   KOBDE CHAR  1   PDC Error Indicator
        Oa_.S36 := 'TIMRC'; -- varchar2(1), --   TIMRC CHAR  1   Date of initial PDC entry
        Oa_.S37 := 'DAT00'; -- varchar2(8), --   DATP0 DATS  8   Initial input date for a personnel number
        Oa_.S38 := 'UHR00'; -- varchar2(6), --   UHR00 TIMS  6   Time of initial input
        Oa_.S39 := 'INUMK'; -- varchar2(8), --   CHAR8 CHAR  8   Character field, 8 characters long
        Oa_.S40 := 'WERKS'; -- varchar2(4), --   SBMOD CHAR  4   Administrator Group
        Oa_.S41 := 'SACHZ'; -- varchar2(3), --   SACHZ CHAR  3   Administrator for Time Recording
        Oa_.S42 := 'SFELD'; -- varchar2(20), --   SFELD CHAR  20    Sort field for infotype 0003
        Oa_.S43 := 'ADRUN'; -- varchar2(1), --   ADRUN CHAR  1   HR: Special payroll run
        Oa_.S44 := 'VIEKN'; -- varchar2(2), --   VIEKN CHAR  2   Infotype View Indicator
        Oa_.S45 := 'TRVFL'; -- varchar2(1), --   TRVFL CHAR  1   Indicator for recorded trips
        Oa_.S46 := 'RCBON'; -- varchar2(8), --   RCBON DATS  8   Earliest payroll-relevant master data change (bonus)
        Oa_.S47 := 'PRTEV'; -- varchar2(8) --   PRTEV DATS  8   Earliest personal recalculation date for time evaluation
      WHEN '0006' THEN
        Oa_.S24 := 'ANSSA'; -- varchar2(4), --     ANSSA CHAR  4   Address Record Type
        Oa_.S25 := 'NAME2'; -- varchar2(40), -- PAD_CONAM  CHAR  40    Contact Name
        Oa_.S26 := 'STRAS'; -- varchar2(60), -- PAD_STRAS  CHAR  60    Street and House Number
        Oa_.S27 := 'ORT01'; -- varchar2(40), -- PAD_ORT01  CHAR  40    City
        Oa_.S28 := 'ORT02'; -- varchar2(40), -- PAD_ORT02  CHAR  40    District
        Oa_.S29 := 'PSTLZ'; -- varchar2(10), -- PSTLZ_HR CHAR  10    Postal Code
        Oa_.S30 := 'LAND1'; -- varchar2(3), -- LAND1 CHAR  3 T005  Country Key
        Oa_.S31 := 'TELNR'; -- varchar2(14), -- TELNR  CHAR  14    Telephone Number
        Oa_.S32 := 'ENTKM'; -- varchar2(3), -- ENTKM DEC 3   Distance in Kilometers
        Oa_.S33 := 'WKWNG'; -- varchar2(1), -- WKWNG CHAR  1   Company Housing
        Oa_.S34 := 'BUSRT'; -- varchar2(3), -- BUSRT CHAR  3   Bus Route
        Oa_.S35 := 'LOCAT'; -- varchar2(40), -- PAD_LOCAT  CHAR  40    2nd Address Line
        Oa_.S36 := 'ADR03'; -- varchar2(40), --  AD_STRSPP1  CHAR  40    Street 2
        Oa_.S37 := 'ADR04'; -- varchar2(40), -- AD_STRSPP2 CHAR  40    Street 3
        Oa_.S38 := 'HSNMR'; -- varchar2(10), -- PAD_HSNMR  CHAR  10    House Number
        Oa_.S39 := 'POSTA'; -- varchar2(10), -- PAD_POSTA  CHAR  10    Identification of an apartment in a building
        Oa_.S40 := 'BLDNG'; -- varchar2(10), -- AD_BLD_10  CHAR  10    Building (number or code)
        Oa_.S41 := 'FLOOR'; -- varchar2(10), -- AD_FLOOR CHAR  10    Floor in building
        Oa_.S42 := 'STRDS'; -- varchar2(2), -- STRDS CHAR  2 T5EVP Street Abbreviation
        Oa_.S43 := 'ENTK2'; -- varchar2(3), -- ENTKM DEC 3   Distance in Kilometers
        Oa_.S44 := 'COM01'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S45 := 'NUM01'; -- varchar2(20), -- COMNR  CHAR  20    Communication Number
        Oa_.S46 := 'COM02'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S47 := 'NUM02'; -- varchar2(20), --  COMNR CHAR  20    Communication Number
        Oa_.S48 := 'COM03'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S49 := 'NUM03'; -- varchar2(20), -- COMNR  CHAR  20    Communication Number
        Oa_.S50 := 'COM04'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S51 := 'NUM04'; -- varchar2(20), -- COMNR  CHAR  20    Communication Number
        Oa_.S52 := 'COM05'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S53 := 'NUM05'; -- varchar2(20), -- COMNR  CHAR  20    Communication Number
        Oa_.S54 := 'COM06'; -- varchar2(4), -- COMKY CHAR  4 T536B Communication Type
        Oa_.S55 := 'NUM06'; -- varchar2(20), -- COMNR  CHAR  20    Communication Number
        Oa_.S56 := 'INDRL'; -- varchar2(5), -- P22J_INDRL  CHAR  2 T577  Indicator for relationship (specification code)
        Oa_.S57 := 'COUNC'; -- varchar2(3), -- COUNC CHAR  3 T005E County Code
        Oa_.S58 := 'RCTVC'; -- varchar2(6), -- P22J_RCTVC  CHAR  6   Municipal city code
        Oa_.S59 := 'OR2KK'; -- varchar2(40), -- P22J_ORKK2 CHAR  40    Second address line (Katakana)
        Oa_.S60 := 'CONKK'; -- varchar2(40), -- P22J_PCNKK CHAR  40    Contact Person (Katakana) (Japan)
        Oa_.S61 := 'OR1KK'; -- varchar2(40), -- P22J_ORKK1 CHAR  40    First address line (Katakana)
        Oa_.S62 := 'RAILW'; -- varchar2(1) -- RAILW NUMC  1   Social Subscription Railway
        Oa_.S63 := 'IFS_STATE';
        Oa_.S64 := 'IFS_COUNC';
        Oa_.S65 := 'IFS_COUNTY';
      WHEN '0007' THEN
        Oa_.S24 := 'SCHKZ'; -- varchar2(8), --   SCHKN CHAR  8   Work Schedule Rule
        Oa_.S25 := 'ZTERF'; -- varchar2(1), --   PT_ZTERF  NUMC  1 T555U Employee Time Management Status
        Oa_.S26 := 'EMPCT'; -- varchar2(5), --   EMPCT DEC 5(2)    Employment percentage
        Oa_.S27 := 'MOSTD'; -- varchar2(5), --   MOSTD DEC 5(2)    Monthly hours
        Oa_.S28 := 'WOSTD'; -- varchar2(5), --   WOSTD DEC 5(2)    Hours per week
        Oa_.S29 := 'ARBST'; -- varchar2(5), --   STDTG DEC 5(2)    Daily Working Hours
        Oa_.S30 := 'WKWDY'; -- varchar2(4), --   WARST DEC 4(2)    Weekly Workdays
        Oa_.S31 := 'JRSTD'; -- varchar2(7), --   JRSTD DEC 7(2)    Annual working hours
        Oa_.S32 := 'TEILK'; -- varchar2(1), --   TEILK CHAR  1   Indicator Part-Time Employee
        Oa_.S33 := 'MINTA'; -- varchar2(5), --   MINTA DEC 5(2)    Minimum number of work hours per day
        Oa_.S34 := 'MAXTA'; -- varchar2(5), --   MAXTA DEC 5(2)    Maximum number of work hours per day
        Oa_.S35 := 'MINWO'; -- varchar2(5), --   MINWO DEC 5(2)    Minimum weekly working hours
        Oa_.S36 := 'MAXWO'; -- varchar2(5), --   MAXWO DEC 5(2)    Maximum number of work hours per week
        Oa_.S37 := 'MINMO'; -- varchar2(5), --   MINMO DEC 5(2)    Minimum number of work hours per month
        Oa_.S38 := 'MAXMO'; -- varchar2(5), --   MAXMO DEC 5(2)    Maximum number of work hours per month
        Oa_.S39 := 'MINJA'; -- varchar2(7), --   MINJA DEC 7(2)    Minimum annual working hours
        Oa_.S40 := 'MAXJA'; -- varchar2(7), --   MAXJA DEC 7(2)    Maximum Number of Working Hours Per Year
        Oa_.S41 := 'DYSCH'; -- varchar2(1), --   DYSCH CHAR  1   Create Daily Work Schedule Dynamically
        Oa_.S42 := 'KZTIM'; -- varchar2(2), --   KZTIM CHAR  2   Additional indicator for time management
        Oa_.S43 := 'WWEEK'; -- varchar2(2), --   WWEEK CHAR  2 T559A Working week
        Oa_.S44 := 'AWTYP'; -- varchar2(5) --  AWTYP CHAR  5   Reference Transaction
      WHEN '0008' THEN
        Oa_.S24 := 'TRFAR'; -- varchar2(2), --   TRFAR CHAR  2 T510A Pay scale type
        Oa_.S25 := 'TRFGB'; -- varchar2(2), --   TRFGB CHAR  2 T510G Pay Scale Area
        Oa_.S26 := 'TRFGR'; -- varchar2(8), --   TRFGR CHAR  8   Pay Scale Group
        Oa_.S27 := 'TRFST'; -- varchar2(3), --   TRFST CHAR  2   Pay Scale Level
        Oa_.S28 := 'STVOR'; -- varchar2(8), --   STVOR DATS  8   Date of Next Increase
        Oa_.S29 := 'ORZST'; -- varchar2(3), --   ORTZS CHAR  2   Cost of Living Allowance Level
        Oa_.S30 := 'PARTN'; -- varchar2(3), --   PARTN CHAR  2 T577  Partnership
        Oa_.S31 := 'WAERS'; -- varchar2(5), --   WAERS CUKY  5 TCURC Currency Key
        Oa_.S32 := 'VGLTA'; -- varchar2(2), --   VGLTA CHAR  2 T510A Comparison pay scale type
        Oa_.S33 := 'VGLGB'; -- varchar2(2), --   VGLGB CHAR  2 T510G Comparison pay scale area
        Oa_.S34 := 'VGLGR'; -- varchar2(8), --   VGLTG CHAR  8   Comparison pay scale group
        Oa_.S35 := 'VGLST'; -- varchar2(2), --   VGLST CHAR  2   Comparison pay scale level
        Oa_.S36 := 'VGLSV'; -- varchar2(8), --   STVOR DATS  8   Date of Next Increase
        Oa_.S37 := 'BSGRD'; -- varchar2(5), --   BSGRD DEC 5(2)    Capacity Utilization Level
        Oa_.S38 := 'DIVGV'; -- varchar2(5), --   DIVGV DEC 5(2)    Working Hours per Payroll Period
        Oa_.S39 := 'ANSAL'; -- varchar2(15), --   ANSAL_15  CURR  15(2)   Annual salary
        Oa_.S40 := 'FALGK'; -- varchar2(10), --   FALGK CHAR  10    Case group catalog
        Oa_.S41 := 'FALGR'; -- varchar2(6), --   FALGR CHAR  6   Case group
        Oa_.S42 := 'LGA01'; -- varchar2(4), --   LGART CHAR  4 T512Z Wage Type
        Oa_.S43 := 'BET01'; -- varchar2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
        Oa_.S44 := 'ANZ01'; -- varchar2(7), --   ANZHL DEC 7(2)    Number
        Oa_.S45 := 'EIN01'; -- varchar2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
        Oa_.S46 := 'OPK01'; -- varchar2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
        Oa_.S47 := 'LGA02'; -- varchar2(4), --   LGART CHAR  4 T512Z Wage Type
        Oa_.S48 := 'BET02'; -- varchar2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
        Oa_.S49 := 'ANZ02'; -- varchar2(7), --   ANZHL DEC 7(2)    Number
        Oa_.S50 := 'EIN02'; -- varchar2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
        Oa_.S51 := 'OPK02'; -- varchar2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
        Oa_.S52 := 'LGA03'; -- varchar2(4), --   LGART CHAR  4 T512Z Wage Type
        Oa_.S53 := 'BET03'; -- varchar2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
        Oa_.S54 := 'ANZ03'; -- varchar2(7), --   ANZHL DEC 7(2)    Number
        Oa_.S55 := 'EIN03'; -- varchar2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
        Oa_.S56 := 'OPK03'; -- varchar2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
        Oa_.S57 := 'IND01'; -- varchar2(1), --   INDBW CHAR  1   Indicator for indirect valuation
        Oa_.S58 := 'IND02'; -- varchar2(1), --   INDBW CHAR  1   Indicator for indirect valuation
        Oa_.S59 := 'IND03'; -- varchar2(1), --   INDBW CHAR  1   Indicator for indirect valuation
        Oa_.S60 := 'ANCUR'; -- varchar2(5), --   ANCUR CUKY  5 TCURC Currency Key for Annual Salary
        Oa_.S61 := 'CPIND'; -- varchar2(1), --   P_CPIND CHAR  1   Planned compensation type
        Oa_.S62 := 'FLAGA'; -- varchar2(1) --  FLAG  CHAR  1   General Flag
      WHEN '0009' THEN
        --.INCLUDE  PS0009        HR Master Record: Infotype 0009 (Bank Details)
        Oa_.S24 := 'OPKEN'; -- varchar2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
        Oa_.S25 := 'BETRG'; -- varchar2(13), --PAD_VGBTR  CURR  13(2)   Standard value
        Oa_.S26 := 'WAERS'; -- varchar2(5), --PAD_WAERS  CUKY  5 TCURC Payment Currency
        Oa_.S27 := 'ANZHL'; -- varchar2(5), --VGPRO  DEC 5(2)    Standard Percentage
        Oa_.S28 := 'ZEINH'; -- varchar2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
        Oa_.S29 := 'BNKSA'; -- varchar2(4), --BNKSA  CHAR  4 T591A Type of Bank Details Record
        Oa_.S30 := 'ZLSCH'; -- varchar2(1), --PCODE  CHAR  1 T042Z Payment Method
        Oa_.S31 := 'EMFTX'; -- varchar2(40), --EMFTX  CHAR  40    Payee Text
        Oa_.S32 := 'BKPLZ'; -- varchar2(10), --BKPLZ  CHAR  10    Postal Code
        Oa_.S33 := 'BKORT'; -- varchar2(25), --ORT01  CHAR  25    City
        Oa_.S34 := 'BANKS'; -- varchar2(3), --BANKS  CHAR  3 T005  Bank country key
        Oa_.S35 := 'BANKL'; -- varchar2(15), --BANKK  CHAR  15    Bank Keys
        Oa_.S36 := 'BANKN'; -- varchar2(18), --BANKN  CHAR  18    Bank account number
        Oa_.S37 := 'BANKP'; -- varchar2(2), --BANKP  CHAR  2   Check Digit for Bank No./Account
        Oa_.S38 := 'BKONT'; -- varchar2(2), --BKONT  CHAR  2   Bank Control Key
        Oa_.S39 := 'SWIFT'; -- varchar2(11), --SWIFT  CHAR  11    SWIFT/BIC for International Payments
        Oa_.S40 := 'DTAWS'; -- varchar2(2), --DTAWS  CHAR  2 T015W Instruction key for data medium exchange
        Oa_.S41 := 'DTAMS'; -- varchar2(1), --DTAMS  CHAR  1   Indicator for Data Medium Exchange
        Oa_.S42 := 'STCD2'; -- varchar2(11), --STCD2  CHAR  11    Tax Number 2
        Oa_.S43 := 'PSKTO'; -- varchar2(16), --PSKTO  CHAR  16    Account Number of Bank Account At Post Office
        Oa_.S44 := 'ESRNR'; -- varchar2(11), --ESRNR  CHAR  11    ISR Subscriber Number
        Oa_.S45 := 'ESRRE'; -- varchar2(27), --ESRRE  CHAR  27    ISR Reference Number  ALPHA
        Oa_.S46 := 'ESRPZ'; -- varchar2(2), --ESRPZ  CHAR  2   ISR Check Digit
        Oa_.S47 := 'EMFSL'; -- varchar2(8), --EMFSL  CHAR  8   Payee key for bank transfers
        Oa_.S48 := 'ZWECK'; -- varchar2(40), --DZWECK CHAR  40    Purpose of Bank Transfers
        Oa_.S49 := 'BTTYP'; -- varchar2(2), --P09_BTTYP  NUMC  2 T5M3T PBS Transfer Type
        Oa_.S50 := 'PAYTY'; -- varchar2(1), --PAYTY  CHAR  1   Payroll type
        Oa_.S51 := 'PAYID'; -- varchar2(1), --PAYID  CHAR  1   Payroll Identifier
        Oa_.S52 := 'OCRSN'; -- varchar2(4), --PAY_OCRSN  CHAR  4   Reason for Off-Cycle Payroll
        Oa_.S53 := 'BONDT'; -- varchar2(8), --BONDT  DATS  8   Off-cycle payroll payment date
        Oa_.S54 := 'BKREF'; -- varchar2(20), --BKREF  CHAR  20    Reference specifications for bank details
        Oa_.S55 := 'STRAS'; -- varchar2(30), --STRAS  CHAR  30    House number and street
        Oa_.S56 := 'DEBIT'; -- varchar2(1), --P00_XDEBIT_INFTY CHAR  1   Automatic Debit Authorization Indicator
        Oa_.S57 := 'IBAN'; --  varchar2(34) --IBAN CHAR  34    IBAN (International Bank Account Number)
      WHEN '0014' THEN
        --.INCLUDE  PS0014        HR Master Record: Infotype 0014 (Recur. Payments/Deds.)
        Oa_.S24 := 'LGART'; -- varchar2(4), --LGART  CHAR  4 T512Z Wage Type
        Oa_.S25 := 'OPKEN'; -- varchar2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
        Oa_.S26 := 'BETRG'; -- varchar2(13), --PAD_AMT7S  CURR  13(2)   Wage Type Amount for Payments
        Oa_.S27 := 'WAERS'; -- varchar2(5), --WAERS  CUKY  5 TCURC Currency Key
        Oa_.S28 := 'ANZHL'; -- varchar2(7), --ANZHL  DEC 7(2)    Number
        Oa_.S29 := 'ZEINH'; -- varchar2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
        Oa_.S30 := 'INDBW'; -- varchar2(1), --INDBW  CHAR  1   Indicator for indirect valuation
        Oa_.S31 := 'ZDATE'; -- varchar2(8), --DZDATE DATS  8   First payment date
        Oa_.S32 := 'ZFPER'; -- varchar2(2), --DZFPER NUMC  2   First payment period
        Oa_.S33 := 'ZANZL'; -- varchar2(3), --DZANZL DEC 3   Number for determining further payment dates
        Oa_.S34 := 'ZEINZ'; -- varchar2(3), --DZEINZ CHAR  3 T538C Time unit for determining next payment
        Oa_.S35 := 'ZUORD'; -- varchar2(20), --UZORD  CHAR  20    Assignment Number
        Oa_.S36 := 'UWDAT'; -- varchar2(8), --UWDAT  DATS  8   Date of Bank Transfer
        Oa_.S37 := 'MODEL'; -- varchar2(4) --MODE1 CHAR  4 T549W Payment Model
      WHEN '0015' THEN
        Oa_.S24 := 'LGART'; -- varchar2(4), --LGART  CHAR  4 T512Z Wage Type
        Oa_.S25 := 'OPKEN'; -- varchar2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
        Oa_.S26 := 'BETRG'; -- varchar2(13), --PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
        Oa_.S27 := 'WAERS'; -- varchar2(5), --WAERS  CUKY  5 TCURC Currency Key
        Oa_.S28 := 'ANZHL'; -- varchar2(7), --ANZHL  DEC 7(2)    Number
        Oa_.S29 := 'ZEINH'; -- varchar2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
        Oa_.S30 := 'INDBW'; -- varchar2(1), --INDBW  CHAR  1   Indicator for indirect valuation
        Oa_.S31 := 'ZUORD'; -- varchar2(20), --UZORD CHAR  20    Assignment Number
        Oa_.S32 := 'ESTDT'; -- varchar2(8), --ESTDT  DATS  8   Date of origin
        Oa_.S33 := 'PABRJ'; -- varchar2(4), --PABRJ  NUMC  4   Payroll Year  GJAHR
        Oa_.S34 := 'PABRP'; -- varchar2(1), --PABRP  NUMC  2   Payroll Period
        Oa_.S35 := 'UWDAT'; -- varchar2(8), --UWDAT  DATS  8   Date of Bank Transfer
        Oa_.S36 := 'ITFTT'; -- varchar2(2) --P06I_ITFTT  CHAR  2   Processing type
      WHEN '0016' THEN
        --.INCLUDE  PS0016        HR Master Record: Infotype 0016 (Contract Elements)
        Oa_.S24 := 'NBTGK'; -- varchar2(1), --NBTGK  CHAR  1   Sideline Job
        Oa_.S25 := 'WTTKL'; -- varchar2(1), --WTTKL  CHAR  1   Competition Clause
        Oa_.S26 := 'LFZFR'; -- varchar2(3), --LFZFR  DEC 3   Period of Continued Pay (Number)
        Oa_.S27 := 'LFZZH'; -- varchar2(3), --LFZZH  CHAR  3 T538A Period of Continued Pay (Unit)
        Oa_.S28 := 'LFZSO'; -- varchar2(2), --LFZSR  NUMC  2   Special Rule for Continued Pay
        Oa_.S29 := 'KGZFR'; -- varchar2(3), --KGZFR  DEC 3   Sick Pay Supplement Period (Number)
        Oa_.S30 := 'KGZZH'; -- varchar2(3), --KGZZH  CHAR  3 T538A Sick Pay Supplement Period (Unit)
        Oa_.S31 := 'PRBZT'; -- varchar2(3), --PRBZT  DEC 3   Probationary Period (Number)
        Oa_.S32 := 'PRBEH'; -- varchar2(3), --PRBEH  CHAR  3 T538A Probationary Period (Unit)
        Oa_.S33 := 'KDGFR'; -- varchar2(2), --KDGFR  CHAR  2 T547T Dismissals Notice Period for Employer
        Oa_.S34 := 'KDGF2'; -- varchar2(2), --KDGF2  CHAR  2 T547T Dismissals Notice Period for Employee
        Oa_.S35 := 'ARBER'; -- varchar2(8), --ARBER  DATS  8   Expiration Date of Work Permit
        Oa_.S36 := 'EINDT'; -- varchar2(8), --EINTR  DATS  8   Initial Entry
        Oa_.S37 := 'KONDT'; -- varchar2(8), --KONDT  DATS  8   Date of Entry into Group
        Oa_.S38 := 'KONSL'; -- varchar2(2), --KOSL1  CHAR  2 T545T Group Key
        Oa_.S39 := 'CTTYP'; -- varchar2(2), --CTTYP  CHAR  2 T547V Contract Type
        Oa_.S40 := 'CTEDT'; -- varchar2(8), --CTEDT  DATS  8   Contract End Date
        Oa_.S41 := 'PERSG'; -- varchar2(1), --PERSG  CHAR  1 T501  Employee Group
        Oa_.S42 := 'PERSK'; -- varchar2(2), --PERSK  CHAR  2 T503K Employee Subgroup
        Oa_.S43 := 'WRKPL'; -- varchar2(40), -- WRKPL CHAR  40    Work Location (Contract Elements Infotype)
        Oa_.S44 := 'CTBEG'; -- varchar2(8), --CTBEG  DATS  8   Contract Start
        Oa_.S45 := 'CTNUM'; -- varchar2(20), --PCN_CTNUM  CHAR  20    Contract number
        Oa_.S46 := 'OBJNB'; -- varchar2(12) --OBJNB CHAR  12    Object Number (France)
        Oa_.S47 := 'ZZDATZAW';
      WHEN '0019' THEN
        --.INCLUDE  PS0019        HR Master Record: Infotype 0019 (Monitoring of Tasks)
        Oa_.S24 := 'TMART'; -- varchar2(2), --TMART  CHAR  2 T531  Task Type
        Oa_.S25 := 'TERMN'; -- varchar2(8), --TERMN  DATS  8   Date of Task
        Oa_.S26 := 'MNDAT'; -- varchar2(8), --MNDAT  DATS  8   Reminder Date
        Oa_.S27 := 'BVMRK'; -- varchar2(1), --BVMRK  CHAR  1   Processing indicator
        Oa_.S28 := 'TMJHR'; -- varchar2(4), --TMJHR  NUMC  4   Year of date  GJAHR
        Oa_.S29 := 'TMMON'; -- varchar2(2), --TMMON  NUMC  2   Month of date
        Oa_.S30 := 'TMTAG'; -- varchar2(2), --TMTAG  NUMC  2   Day of date
        Oa_.S31 := 'MNJHR'; -- varchar2(4), --MNJHR  NUMC  4   Year of reminder  GJAHR
        Oa_.S32 := 'MNMON'; -- varchar2(2), --MNMON  NUMC  2   Month of reminder
        Oa_.S33 := 'MNTAG'; -- varchar2(2) --MNTAG NUMC  2   Day of reminder
        Oa_.S34 := 'CTEXT'; -- cluster texts
      WHEN '0021' THEN
        --.INCLUDE  PS0021        HR Master Record: Infotype 0021 (Family)
        Oa_.S24 := 'FAMSA'; -- varchar2(4), --FAMSA  CHAR  4   Type of Family Record
        Oa_.S25 := 'FGBDT'; --GBDAT  DATS  8   Date of Birth PDATE
        Oa_.S26 := 'FGBLD'; --GBLND  CHAR  3 T005  Country of Birth
        Oa_.S27 := 'FANAT'; --NATSL  CHAR  3 T005  Nationality
        Oa_.S28 := 'FASEX'; --GESCH  CHAR  1   Gender Key
        Oa_.S29 := 'FAVOR'; --PAD_VORNA  CHAR  40 First Name
        Oa_.S30 := 'FANAM'; --PAD_NACHN  CHAR  40    Last Name
        Oa_.S31 := 'FGBOT'; --PAD_GBORT  CHAR  40    Birthplace
        Oa_.S32 := 'FGDEP'; --GBDEP  CHAR  3 T005S State
        Oa_.S33 := 'ERBNR'; --ERBNR  CHAR  12    Reference Personnel Number for Family Member
        Oa_.S34 := 'FGBNA'; --PAD_NAME2  CHAR  40    Name at Birth
        Oa_.S35 := 'FNAC2'; --PAD_NACH2  CHAR  40    Second Name
        Oa_.S36 := 'FCNAM'; --PAD_CNAME  CHAR  80    Complete Name
        Oa_.S37 := 'FKNZN'; --KNZNM  NUMC  2   Name Format Indicator for Employee in a List
        Oa_.S38 := 'FINIT'; --INITS  CHAR  10    Initials
        Oa_.S39 := 'FVRSW'; --VORSW  CHAR  15  T535N Name Prefix
        Oa_.S40 := 'FVRS2'; --VORSW  CHAR  15  T535N Name Prefix
        Oa_.S41 := 'FNMZU'; --NAMZU  CHAR  15  T535N Other Title
        Oa_.S42 := 'AHVNR'; --AHVNR  CHAR  11    AHV Number  AHVNR
        Oa_.S43 := 'KDSVH'; --KDSVH  CHAR  2 T577  Relationship to Child
        Oa_.S44 := 'KDBSL'; --KDBSL  CHAR  2 T577  Allowance Authorization
        Oa_.S45 := 'KDUTB'; --KDUTB  CHAR  2 T577  Address of Child
        Oa_.S46 := 'KDGBR'; --KDGBR  CHAR  2 T577  Child Allowance Entitlement
        Oa_.S47 := 'KDART'; --KDART  CHAR  2 T577  Child Type
        Oa_.S48 := 'KDZUG'; --KDZUG  CHAR  2 T577  Child Bonuses
        Oa_.S49 := 'KDZUL'; --KDZUL  CHAR  2 T577  Child Allowances
        Oa_.S50 := 'KDVBE'; --KDVBE  CHAR  2 T577  Sickness Certificate Authorization
        Oa_.S51 := 'ERMNR'; --ERMNR  CHAR  8   Authority Number
        Oa_.S52 := 'AUSVL'; --AUSVL  NUMC  4   1st Part of SI Number (Sequential Number)
        Oa_.S53 := 'AUSVG'; --AUSVG  NUMC  8   2nd Part of SI Number (Birth Date)
        Oa_.S54 := 'FASDT'; --FASDT  DATS  8   End of Family Members Education/Training
        Oa_.S55 := 'FASAR'; --FASAR  CHAR  2 T517T School Type of Family Member
        Oa_.S56 := 'FASIN'; --FASIN  CHAR  20    Educational Institute
        Oa_.S57 := 'EGAGA'; --EGAGA  CHAR  8   Employer of Family Member
        Oa_.S58 := 'FANA2'; --NATS2  CHAR  3 T005  Second Nationality
        Oa_.S59 := 'FANA3'; --NATS3  CHAR  3 T005  Third Nationality
        Oa_.S60 := 'BETRG'; --BETRG  CURR  9(2)    Amount
        Oa_.S61 := 'TITEL'; --TITEL  CHAR  15  T535N Title
        Oa_.S62 := 'EMRGN'; --PAD_EMRGN  CHAR  1   Emergency Contact
      WHEN '0022' THEN
        --.INCLUDE  PS0022        HR Master Record: Infotype 0022 (Education)
        Oa_.S24 := 'SLART'; --SLART  CHAR  2 T517T Educational establishment
        Oa_.S25 := 'INSTI'; --INSTI  CHAR  80    Institute/location of training
        Oa_.S26 := 'SLAND'; --LAND1  CHAR  3 T005  Country Key
        Oa_.S27 := 'AUSBI'; --AUSBI  NUMC  8 T518A Education/training
        Oa_.S28 := 'SLABS'; --SLABS  CHAR  2 T519T Certificate
        Oa_.S29 := 'ANZKL'; --ANZKL  DEC 3   Duration of training course
        Oa_.S30 := 'ANZEH'; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
        Oa_.S31 := 'SLTP1'; --FACH1  NUMC  5 T517Y Branch of study
        Oa_.S32 := 'SLTP2'; --FACH2  NUMC  5 T517Y Branch of study
        Oa_.S33 := 'JBEZ1'; --KSGEB  CURR  11(2)   Course fees
        Oa_.S34 := 'WAERS'; --WAERS  CUKY  5 TCURC Currency Key
        Oa_.S35 := 'SLPLN'; --KSPLN  CHAR  1   Planned course (unused)
        Oa_.S36 := 'SLKTR'; --SLKTR  CHAR  2   Cost object (unused)
        Oa_.S37 := 'SLRZG'; --SLRZG  CHAR  1   Repayment obligation
        Oa_.S38 := 'KSBEZ'; --KSBEZ  CHAR  25    Course name
        Oa_.S39 := 'TX122'; --KSBUR  CHAR  40    Course appraisal
        Oa_.S40 := 'SCHCD'; --P22J_SCHCD NUMC  10    Institute/school code
        Oa_.S41 := 'FACCD'; --P22J_FACCD NUMC  3   Faculty code
        Oa_.S42 := 'DPTMT'; -- DPTMT CHAR  40    Department
        Oa_.S43 := 'EMARK'; --EMARK CHAR  4   Final Grade
      WHEN '0023' THEN
        --.INCLUDE  PS0023        HR Master Record: Infotype 0023 (Other/Previous Employers)
        Oa_.S24 := 'ARBGB'; --VORAG  CHAR  60    Name of employer
        Oa_.S25 := 'ORT01'; --ORT01  CHAR  25    City
        Oa_.S26 := 'LAND1'; --LAND1  CHAR  3 T005  Country Key
        Oa_.S27 := 'BRANC'; --BRSCH  CHAR  4 T016  Industry key
        Oa_.S28 := 'TAETE'; --TAETE  NUMC  8 T513C Job at former employer(s)
        Oa_.S29 := 'ANSVX'; --ANSVX  CHAR  2 T542C Work Contract - Other Employers
        Oa_.S30 := 'ORTJ1'; --P22J_ADDR1 CHAR  40    First address line (Kanji)
        Oa_.S31 := 'ORTJ2'; --P22J_ADDR2 CHAR  40    Second address line (Kanji)
        Oa_.S32 := 'ORTJ3'; --P22J_ADDR3  CHAR  40    Third address line (Kanji)
      WHEN '0024' THEN
        --.INCLUDE  PS0024        HR Master Record: Infotype 0024 (Qualifications)
        Oa_.S24 := 'QUALI'; --QUALI_D  NUMC  8 T574A Qualification key
        Oa_.S25 := 'AUSPR'; --CHARA NUMC  4 T778Q Proficiency of a Qualification/Requirement
    --HR Master Record: Infotype 0041 (Date Specifications)
      WHEN '0041' THEN
        --.INCLUDE  PS0041        HR Master Record: Infotype 0041 (Date Specifications)
        Oa_.S24 := 'DAR01'; -- varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S25 := 'DAT01'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S26 := 'DAR02'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S27 := 'DAT02'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S28 := 'DAR03'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S29 := 'DAT03'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S30 := 'DAR04'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S31 := 'DAT04'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S32 := 'DAR05'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S33 := 'DAT05'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S34 := 'DAR06'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S35 := 'DAT06'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S36 := 'DAR07'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S37 := 'DAT07'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S38 := 'DAR08'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S39 := 'DAT08'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S40 := 'DAR09'; --  varchar2(2), -- DATAR CHAR  2 T548Y Date type
        Oa_.S41 := 'DAT09'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S42 := 'DAR10'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S43 := 'DAT10'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S44 := 'DAR11'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S45 := 'DAT11'; --  varchar2(8), --DARDT  DATS  8   Date for date type
        Oa_.S46 := 'DAR12'; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
        Oa_.S47 := 'DAT12'; --  varchar2(8) --DARDT  DATS  8   Date for date type
    --HR Master Record: Infotype 0105 (Komunikacje)
      WHEN '0105' THEN
        --.INCLUDE  PS0185        Personnel Master Record Infotype 0185 (Identification SEA)
        Oa_.S24 := 'USRTY'; --
        Oa_.S25 := 'USRID'; --
        Oa_.S26 := 'USRID_LONG';
        --Personnel Master Record Infotype 0185 (Identification SEA)
      WHEN '0185' THEN
        --.INCLUDE  PS0185        Personnel Master Record Infotype 0185 (Identification SEA)
        Oa_.S24 := 'ICTYP'; -- varchar2(2), -- ICTYP CHAR  2 T5R05 Type of identification (IC type)
        Oa_.S25 := 'ICNUM'; -- varchar2(30), -- PSG_IDNUM CHAR  30    Identity Number
        Oa_.S26 := 'ICOLD'; -- varchar2(20), -- ICOLD CHAR  20    Old IC number
        Oa_.S27 := 'AUTH1'; -- varchar2(30), -- P25_AUTH1 CHAR  30    Issuing authority
        Oa_.S28 := 'DOCN1'; -- varchar2(20), -- ISNUM CHAR  20    Document issuing number
        Oa_.S29 := 'FPDAT'; -- varchar2(8), -- PSG_FPDAT DATS  8   Date of issue for personal ID
        Oa_.S30 := 'EXPID'; -- varchar2(8), -- EXPID DATS  8   ID expiry date
        Oa_.S31 := 'ISSPL'; -- varchar2(30), -- P25_ISSPL CHAR  30    Place of issue of Identification
        Oa_.S32 := 'ISCOT'; -- varchar2(3), -- P25_ISCOT CHAR  3 T005  Country of issue
        Oa_.S33 := 'IDCOT'; -- varchar2(3), -- P25_IDCOT CHAR  3 T005  Country of ID
        Oa_.S34 := 'OVCHK'; -- varchar2(1), -- P25_OVCHK CHAR  1   Indicator for overriding consistency check
        Oa_.S35 := 'ASTAT'; -- varchar2(1), -- PCN_ASTAT CHAR  1   Application status
        Oa_.S36 := 'AKIND'; -- varchar2(1), -- P25_AKIND CHAR  1   Single/multiple
        Oa_.S37 := 'REJEC'; -- varchar2(20), -- P25_REJEC CHAR  20    Reject reason
        Oa_.S38 := 'USEFR'; -- varchar2(8), -- P25_USEFR DATS  8   Used from -date
        Oa_.S39 := 'USETO'; -- varchar2(8), -- P25_USETO DATS  8   Used to -date
        Oa_.S40 := 'DATEN'; -- varchar2(3), -- P25_DATEN DEC 3   Valid length of multiple visa
        Oa_.S41 := 'DATEU'; -- varchar2(3), -- DZEINZ  CHAR  3 T538A Time unit for determining next payment
        Oa_.S42 := 'TIMES'; -- varchar2(8) --  P25_TIMES DATS  8   Application date
      WHEN '0267' THEN
        Oa_.S24 := 'LGART'; -- VARCHAR2(4), -- LGART CHAR  4 T512Z Wage Type
        Oa_.S25 := 'OPKEN'; -- VARCHAR2(1), -- OPKEN CHAR  1   Operation Indicator for Wage Types
        Oa_.S26 := 'BETRG'; -- VARCHAR2(13), --  PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
        Oa_.S27 := 'WAERS'; -- VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
        Oa_.S28 := 'ANZHL'; -- VARCHAR2(7), -- ANZHL DEC 7(2)    Number
        Oa_.S29 := 'ZEINH'; -- VARCHAR2(3), --PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
        Oa_.S30 := 'INDBW'; -- VARCHAR2(1), -- INDBW CHAR  1   Indicator for indirect valuation
        Oa_.S31 := 'ZUORD'; -- VARCHAR2(20), --  UZORD CHAR  20    Assignment Number
        Oa_.S32 := 'ESTDT'; -- VARCHAR2(8), -- ESTDT DATS  8   Date of origin
        Oa_.S33 := 'PABRJ'; -- VARCHAR2(4), -- PABRJ NUMC  4   Payroll Year  GJAHR
        Oa_.S34 := 'PABRP'; -- VARCHAR2(2), -- PABRP NUMC  2   Payroll Period
        Oa_.S35 := 'UWDAT'; -- VARCHAR2(8), -- UWDAT DATS  8   Date of Bank Transfer
        Oa_.S36 := 'PAYTY'; -- VARCHAR2(1), -- PAYTY CHAR  1   Payroll type
        Oa_.S37 := 'PAYID'; -- VARCHAR2(1), -- PAYID CHAR  1   Payroll Identifier
        Oa_.S38 := 'OCRSN'; -- VARCHAR2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
        Oa_.S39 := 'ZZDATZ'; -- VARCHAR2(8),
        Oa_.S40 := 'ZZTEKST1'; -- VARCHAR2(100),
        Oa_.S41 := 'ZZTEKST2'; -- VARCHAR2(100),
        Oa_.S42 := 'ZZTEKST3'; -- VARCHAR2(100),
        Oa_.S43 := 'ZZTEKST4'; --  VARCHAR2(100));
      WHEN '0413' THEN
        --.INCLUDE  PS0413        HR Master Record: Infotype 0413 (Tax Data PL)
        Oa_.S24 := 'TOIDN'; -- varchar2(4), -- PPL_TOIDN CHAR  4 T7PL01  Tax office ID number
        Oa_.S25 := 'COSTR'; -- varchar2(2), -- PPL_COSTR CHAR  2 T7PL20  Cost counting rule
        Oa_.S26 := 'CONTR'; -- varchar2(2), -- PPL_CONTR CHAR  2 T7PL30  Free amount rule
        Oa_.S27 := 'DNIND'; -- varchar2(1) --  PPL_DNIND CHAR  1   Threshold down indicator
      WHEN '0414' THEN
        --.INCLUDE  PS0414        HR Master Record: Infotype 0414
        Oa_.S24 := 'SCD01'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S25 := 'SID01'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S26 := 'SYY01'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S27 := 'SMM01'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S28 := 'SDD01'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S29 := 'SCD02'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S30 := 'SID02'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S31 := 'SYY02'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S32 := 'SMM02'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S33 := 'SDD02'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S34 := 'SCD03'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S35 := 'SID03'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S36 := 'SYY03'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S37 := 'SMM03'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S38 := 'SDD03'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S39 := 'SCD04'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S40 := 'SID04'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S41 := 'SYY04'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S42 := 'SMM04'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S43 := 'SDD04'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S44 := 'SCD05'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S45 := 'SID05'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S46 := 'SYY05'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S47 := 'SMM05'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S48 := 'SDD05'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S49 := 'SCD06'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S50 := 'SID06'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S51 := 'SYY06'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S52 := 'SMM06'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S53 := 'SDD06'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S54 := 'SCD07'; --  varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
        Oa_.S55 := 'SID07'; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
        Oa_.S56 := 'SYY07'; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
        Oa_.S57 := 'SMM07'; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
        Oa_.S58 := 'SDD07'; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
        --
        Oa_.S59 := 'PERTX'; --  varchar2(50), -- PPL_PERTX CHAR  50    Period description
        Oa_.S60 := 'LDPER'; --  varchar2(7), -- PPL_LDPER DEC 7(5)    Leave days at previous employer
        Oa_.S61 := 'EVRP6'; --  varchar2(1), -- PPL_EVRP6 CHAR  1 T7PLA0  Evidence for RP-6 form code
        Oa_.S62 := 'FLFLG'; --  varchar2(1), -- PPL_FLFLG CHAR  1   First leave after 12 months flag
        Oa_.S63 := 'RLDPR'; --  varchar2(6), -- PPL_RLDPR DEC 6(5)    Requested leave days at previous employer
        Oa_.S64 := 'FEFLG'; --  varchar2(1), -- PPL_FEFLG CHAR  1   First employment flag
        Oa_.S65 := 'CHALL'; --  varchar2(7), -- PPL_CHALL DEC 7(5)    Child Care Leave Deduction
        Oa_.S66 := 'FAMAL'; --  varchar2(7), -- PPL_FAMAL DEC 7(5)    Family member care leave
        Oa_.S67 := 'CHL14'; --  varchar2(7), -- PPL_CHL14 DEC 7(5)    Utilized Child Allowance < 14 years old
        Oa_.S68 := 'PTURN'; --  varchar2(1), -- PPL_PTURN CHAR  1   Deduction rehabilitation leave for previous employer
        Oa_.S69 := 'LEAPE'; --  varchar2(7), -- PPL_LEAPE DEC 7(5)    Leave taken over from previous employer
        Oa_.S70 := 'GENLE'; --  varchar2(1) -- PPL_GENLE  CHAR  1   Forcing leave generation
      WHEN '0515' THEN
        --.INCLUDE  PS0515        HR Master Record: Infotype 0515 (SI Add. Data PL)
        Oa_.S24 := 'PODST'; --     varchar2(4), --PPL_PODST CHAR  4 T7PL40  Code of basic subject with extension
        Oa_.S25 := 'ERLRT'; --     varchar2(1), -- PPL_ERLRT CHAR  1   Pension right type
        Oa_.S26 := 'STPNS'; --     varchar2(1), -- PPL_STPNS CHAR  1   Disability level
        Oa_.S27 := 'RUSER'; --    varchar2(1), -- PPL_RUSER CHAR  1   Pension and disability insurance
        Oa_.S28 := 'RUSCH'; --    varchar2(1), -- PPL_RUSCH CHAR  1   Incapability insurance
        Oa_.S29 := 'RUSWP'; --     varchar2(1), -- PPL_RUSWP CHAR  1   Accident insurance
        Oa_.S30 := 'RUSZR'; --     varchar2(1), -- PPL_RUSZR CHAR  1   Health insurance
        Oa_.S31 := 'DZUKC'; --     varchar2(8), -- PPL_DZUKC DATS  8   Date of contract with health fund
        Oa_.S32 := 'NSBEG'; --     varchar2(8), -- PPL_NSBEG DATS  8   Begin date of disability level
        Oa_.S33 := 'KSACH'; --     varchar2(3), --PPL_KSACH CHAR  3   NFZ departament code
        Oa_.S34 := 'NSEND'; -- varchar2(8), --PPL_NSEND DATS  8   End date of disability level
        Oa_.S35 := 'ILLCS'; --     varchar2(3), --PPL_ILLCS NUMC  3   Days of continuous sickness period
        Oa_.S36 := 'ALLPE'; --     varchar2(3), --PPL_ALLPE NUMC  3   Allowance period days
        Oa_.S37 := 'SIBLN'; --     varchar2(1), --PPL_SIBLN CHAR  1   Std./extd. allowance base period lenght
        Oa_.S38 := 'SOELN'; --     varchar2(1), -- PPL_SOELN CHAR  1   Std./extd. allowance base period lenght
        Oa_.S39 := 'WAITP'; --     varchar2(8), -- PPL_WAITP DATS  8   End date of waiting period
        Oa_.S40 := 'LIMTP'; --     varchar2(8), -- PPL_LIMTP DATS  8   End date of limited base period
        Oa_.S41 := 'ILLPR'; --     varchar2(2), -- PPL_ILLPR DEC 2   Sick days at previous employer
        Oa_.S42 := 'ADDIT'; --     varchar2(4), -- PPL_ADDIT CHAR  4 T7PL40  Code of additional subject
        Oa_.S43 := 'ADDBR'; --     varchar2(1), -- PPL_ADDBR CHAR  1   Additional insurance title break code
        Oa_.S44 := 'DIS_LEAVE'; -- varchar2(8), -- PPL_DIS_LEAVE_FROM  DATS  8   Additional leave for disabled first date
        Oa_.S45 := 'MODEL_ID'; --  varchar2(2), --  PPL_MODEL CHAR  2 T7PLZLA_MOD Model ID for PLZLA
        Oa_.S46 := 'NOZDR'; --     varchar2(1) --  PPL_NOZDR CHAR  1   Parental leave without health insurance
        Oa_.S47 := 'TRMCD'; -- PPL_TRMCD CHAR  3 0 Tryb rozw. stosunku pracy
        Oa_.S48 := 'LTMCD'; -- PPL_LTMCD CHAR  3 0 Podstawa prawna - kod
        Oa_.S49 := 'LTMTX'; -- PPL_LTMTX  CHAR  72  0 Podstawa prawna - inna
        Oa_.S50 := 'TRMIN'; -- PPL_TRMIN  CHAR  1 0 Strona inicjatywna
      WHEN '0517' THEN
        Oa_.S24 := 'STRAS'; -- varchar2(3), --PAD_STRAS CHAR  60    Street and House Number
        Oa_.S25 := 'HSNMR'; -- varchar2(3), --PAD_HSNMR CHAR  10    House Number
        Oa_.S26 := 'POSTA'; -- varchar2(3), --PAD_POSTA CHAR  10    Identification of an apartment in a building
        Oa_.S27 := 'PSTLZ'; -- varchar2(3), --PSTLZ_HR  CHAR  10    Postal Code
        Oa_.S28 := 'ORT01'; -- varchar2(3), --PAD_ORT01 CHAR  40    City
        Oa_.S29 := 'ORT02'; -- varchar2(3), --PAD_ORT02 CHAR  40    District
        Oa_.S30 := 'STATE'; -- varchar2(3), --REGIO CHAR  3 Region (State, Province, County)
        Oa_.S31 := 'COUNC'; -- varchar2(3), --COUNC CHAR  3 T005E County Code
        Oa_.S32 := 'LAND1'; -- varchar2(3), --LAND1 CHAR  3 T005  Country Key
        Oa_.S33 := 'TELNR'; -- varchar2(3), --TELNR CHAR  14    Telephone Number
        Oa_.S34 := 'PESEL'; -- varchar2(3), --PPL_PESEL CHAR  11    PESEL number
        Oa_.S35 := 'NIP00'; -- varchar2(3), --PPL_NIP00 CHAR  10    NIP number
        Oa_.S36 := 'RUSZR'; -- varchar2(3), --PPL_UZCZR CHAR  1   Health insurance of family member
        Oa_.S37 := 'CNADR'; -- varchar2(3), --PPL_CNADR CHAR  1   Relevancy of family member address
        Oa_.S38 := 'EXSUP'; -- varchar2(3), --PPL_EXSUP CHAR  1   Exclusive support of family member
        Oa_.S39 := 'CNHLD'; -- varchar2(3), --PPL_CNHLD CHAR  1   Common household with family member
        Oa_.S40 := 'ICTYP'; -- varchar2(3), --ICTYP CHAR  2   Type of identification (IC type)
        Oa_.S41 := 'ICNUM'; -- varchar2(3), --PPL_ICNUM CHAR  20    IC number
        Oa_.S42 := 'STPNS'; -- varchar2(3), --PPL_STPNS CHAR  1   Disability level
        Oa_.S43 := 'TERY2'; -- varchar2(3) --PPL_TERY2 CHAR  3 T7PLE2  Municipality GUS code according to TERYT
        Oa_.S44 := 'ZCNAC'; --
      WHEN '0558' THEN
        --.INCLUDE  PS0558        IT0558 - Additional personal data PL
        Oa_.S24 := 'FATHN'; -- varchar2(40), -- PPL_FATHN CHAR  40    Fathers first name
        Oa_.S25 := 'MOTHN'; -- varchar2(40), -- PPL_MOTHN CHAR  40    Mothers first name
        Oa_.S26 := 'MBNAM'; -- varchar2(40), -- PPL_MBRTN CHAR  40    Mothers birth name
        Oa_.S27 := 'PESEL'; -- varchar2(11), --PPL_PESEL CHAR  11    PESEL number
        Oa_.S28 := 'NIP00'; -- varchar2(10), --PPL_NIP00 CHAR  10    NIP number
        Oa_.S29 := 'ONPIT'; -- varchar2(1) --  PPL_ONPIT CHAR  1   Output NIP instead of PESEL on PIT forms
      WHEN '2001' THEN
        --.INCLUDE  PS2001        Personnel Time Record: Infotype 2001 (Absences)
        Oa_.S24 := 'BEGUZ'; --  varchar2(6), --   BEGTI TIMS  6   Start Time
        Oa_.S25 := 'ENDUZ'; --  varchar2(6), -- ENDTI TIMS  6   End Time
        Oa_.S26 := 'VTKEN'; --  varchar2(1), -- VTKEN CHAR  1   Previous Day Indicator
        Oa_.S27 := 'AWART'; --  varchar2(4), -- AWART CHAR  4 T554S Attendance or Absence Type
        Oa_.S28 := 'ABWTG'; --  varchar2(6), -- ABWTG DEC 6(2)    Attendance and Absence Days
        Oa_.S29 := 'STDAZ'; --  varchar2(7), -- ABSTD DEC 7(2)    Absence hours
        Oa_.S30 := 'ABRTG'; --  varchar2(3), -- ABRTG DEC 6(2)    Payroll days
        Oa_.S31 := 'ABRST'; --  varchar2(7), -- ABRST DEC 7(2)    Payroll hours
        Oa_.S32 := 'ANRTG'; --  varchar2(6), -- ANRTG DEC 6(2)    Days credited for continued pay
        Oa_.S33 := 'LFZED'; --  varchar2(8), -- LFZED DATS  8   End of continued pay
        Oa_.S34 := 'KRGED'; --  varchar2(8), -- KRGED DATS  8   End of sick pay
        Oa_.S35 := 'KBBEG'; --  varchar2(8), -- KBBEG DATS  8   Certified start of sickness
        Oa_.S36 := 'RMDDA'; --  varchar2(8), -- RMDDA DATS  8   Date on which illness was confirmed
        Oa_.S37 := 'KENN1'; --  varchar2(2), -- KENN1 DEC 2   Indicator for Subsequent Illness
        Oa_.S38 := 'KENN2'; --  varchar2(2), -- KENN2 DEC 2   Indicator for repeated illness
        Oa_.S39 := 'KALTG'; --  varchar2(6), -- KALTG DEC 6(2)    Calendar days
        Oa_.S40 := 'URMAN'; --  varchar2(1), -- URMAN CHAR  1   Indicator for manual leave deduction
        Oa_.S41 := 'BEGVA'; --  varchar2(4), -- BEGVA NUMC  4   Start year for leave deduction  GJAHR
        Oa_.S42 := 'BWGRL'; --  varchar2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
        Oa_.S43 := 'AUFKZ'; --  varchar2(1), -- AUFKN CHAR  1   Extra Pay Indicator
        Oa_.S44 := 'TRFGR'; --  varchar2(8), -- TRFGR CHAR  8   Pay Scale Group
        Oa_.S45 := 'TRFST'; --  varchar2(2), -- TRFST CHAR  2   Pay Scale Level
        Oa_.S46 := 'PRAKN'; --  varchar2(2), -- PRAKN CHAR  2 T510P Premium Number
        Oa_.S47 := 'PRAKZ'; --  varchar2(4), -- PRAKZ NUMC  4   Premium Indicator
        Oa_.S48 := 'OTYPE'; --  varchar2(2), -- OTYPE CHAR  2 T778O Object Type
        Oa_.S49 := 'PLANS'; --  varchar2(8), -- PLANS NUMC  8 T528B Position
        Oa_.S50 := 'MLDDA'; --  varchar2(8), -- MLDDA DATS  8   Reported on
        Oa_.S51 := 'MLDUZ'; --  varchar2(6), -- MLDUZ TIMS  6   Reported at
        Oa_.S52 := 'RMDUZ'; --  varchar2(6), -- RMDUZ TIMS  6   Sickness confirmed at
        Oa_.S53 := 'VORGS'; --  varchar2(15), -- VORGS CHAR  15    Superior Out Sick (Illness)
        Oa_.S54 := 'UMSKD'; --  varchar2(6), -- UMSKD CHAR  6   Code for description of illness
        Oa_.S55 := 'UMSCH'; --  varchar2(20), -- UMSCH CHAR  20    Description of illness
        Oa_.S56 := 'REFNR'; --  varchar2(8), -- RFNUM CHAR  8   Reference number
        Oa_.S57 := 'UNFAL'; --  varchar2(1), -- UNFAL CHAR  1   Absent due to accident?
        Oa_.S58 := 'STKRV'; --  varchar2(4), -- STKRV CHAR  4   Subtype for sickness tracking
        Oa_.S59 := 'STUND'; --  varchar2(4), -- STUND CHAR  4   Subtype for accident data
        Oa_.S60 := 'PSARB'; --  varchar2(4), -- PSARB DEC 4(2)    Work capacity percentage
        Oa_.S61 := 'AINFT'; --  varchar2(4), -- AINFT CHAR  4 T582A Infotype that maintains 2001
        Oa_.S62 := 'GENER'; --  varchar2(1), -- PGENER  CHAR  1   Generation flag
        Oa_.S63 := 'HRSIF'; --  varchar2(1), -- HRS_INPFL CHAR  1   Set number of hours
        Oa_.S64 := 'ALLDF'; --  varchar2(1), -- ALLDF CHAR  1   Record is for Full Day
        Oa_.S65 := 'WAERS'; --  varchar2(5), -- WAERS CUKY  5 TCURC Currency Key
        Oa_.S66 := 'LOGSYS'; -- varchar2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
        Oa_.S67 := 'AWTYP'; --  varchar2(5), -- AWTYP CHAR  5   Reference Transaction
        Oa_.S68 := 'AWREF'; --  varchar2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
        Oa_.S69 := 'AWORG'; --  varchar2(10), -- AWORG CHAR  10    Reference Organizational Units
        Oa_.S70 := 'DOCSY'; --  varchar2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
        Oa_.S71 := 'DOCNR'; --  varchar2(20), -- PTM_DOCNR NUMC  20    Document number for time data
        Oa_.S72 := 'PAYTY'; --  varchar2(1), -- PAYTY CHAR  1   Payroll type
        Oa_.S73 := 'PAYID'; --  varchar2(1), -- PAYID CHAR  1   Payroll Identifier
        Oa_.S74 := 'BONDT'; --  varchar2(8), -- BONDT DATS  8   Off-cycle payroll payment date
        Oa_.S75 := 'OCRSN'; --  varchar2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
        Oa_.S76 := 'SPPE1'; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
        Oa_.S77 := 'SPPE2'; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
        Oa_.S78 := 'SPPE3'; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
        Oa_.S79 := 'SPPIN'; --  varchar2(1), -- SPPIN CHAR  1   Indicator for manual modifications
        Oa_.S80 := 'ZKMKT'; --  varchar2(1), -- P05_ZKMKT_EN  CHAR  1   Status of Sickness Notification
        Oa_.S81 := 'FAPRS'; --  varchar2(2), -- FAPRS CHAR  2 T554H Evaluation Type for Attendances/Absences
        --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
        Oa_.S82 := 'TDLANGU'; -- varchar2(10), -- TMW_TDLANGU CHAR  10    Definition Set for IDs
        Oa_.S83 := 'TDSUBLA'; -- varchar2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
        Oa_.S84 := 'TDTYPE'; --  varchar2(4), -- TDTYPE CHAR  4   Time Data ID Type TDTYP
        Oa_.S85 := 'NXDFL'; --   varchar2(1) -- PTM_NXDFL  CHAR  1   Next Day Indicator
        Oa_.S86 := 'IFS_SEQNR'; --ifs_seqno
      WHEN '2003' THEN
        --=Z£¥CZ.TEKSTY("Oa_.S";B1;" := '";LITERY.WIELKIE(FRAGMENT.TEKSTU(A1;5;5));"'; -- ";FRAGMENT.TEKSTU(A1;10;1000);)
        Oa_.S24 := 'BEGUZ'; --  VARCHAR2(6), --BEGUZ  TIMS  6   Start Time
        Oa_.S25 := 'ENDUZ'; --  VARCHAR2(6), --ENDUZ  TIMS  6   End Time
        Oa_.S26 := 'VTKEN'; --  VARCHAR2(1), --VTKEN  CHAR  1   Previous Day Indicator
        Oa_.S27 := 'VTART'; --  VARCHAR2(2), --VTART  CHAR  2 T556  Substitution Type
        Oa_.S28 := 'STDAZ'; --  VARCHAR2(7), --VTSTD  DEC 7(2)    Substitution hours
        Oa_.S29 := 'PAMOD'; --  VARCHAR2(5), --PAMOD  CHAR  4 T550P Work Break Schedule
        Oa_.S30 := 'PBEG1'; --  VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
        Oa_.S31 := 'PEND1'; --  VARCHAR2(6), --PDEND  TIMS  6   End of Break
        Oa_.S32 := 'PBEZ1'; --  VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
        Oa_.S33 := 'PUNB1'; --  VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
        Oa_.S34 := 'PBEG2'; --  VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
        Oa_.S35 := 'PEND2'; --  VARCHAR2(6), --PDEND  TIMS  6   End of Break
        Oa_.S36 := 'PBEZ2'; --  VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
        Oa_.S37 := 'PUNB2'; --  VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
        Oa_.S38 := 'ZEITY'; --  VARCHAR2(1), --DZEITY CHAR  1   Employee Subgroup Grouping for Work Schedules
        Oa_.S39 := 'MOFID'; --  VARCHAR2(2), --HIDENT CHAR  2 THOCI Public Holiday Calendar
        Oa_.S40 := 'MOSID'; --  VARCHAR2(2), --MOSID  NUMC  2 T508Z Personnel Subarea Grouping for Work Schedules
        Oa_.S41 := 'SCHKZ'; --  VARCHAR2(8), --SCHKN  CHAR  8 T508A Work Schedule Rule
        Oa_.S42 := 'MOTPR'; --  VARCHAR2(2), --MOTPR  NUMC  2   Personnel Subarea Grouping for Daily Work Schedules
        Oa_.S43 := 'TPROG'; --  VARCHAR2(4), --TPROG  CHAR  4 T550A Daily Work Schedule
        Oa_.S44 := 'VARIA'; --  VARCHAR2(1), --VARIA  CHAR  1   Daily Work Schedule Variant
        Oa_.S45 := 'TAGTY'; --  VARCHAR2(1), -- TAGTY CHAR  1 T553T Day Type
        Oa_.S46 := 'TPKLA'; --  VARCHAR2(1), --TPKLA  CHAR  1   Daily Work Schedule Class
        Oa_.S47 := 'VPERN'; --  VARCHAR2(8), --VPERN  NUMC  8   Substitute Personnel Number
        Oa_.S48 := 'AUFKZ'; --  VARCHAR2(1), --AUFKN  CHAR  1   Extra Pay Indicator
        Oa_.S49 := 'BWGRL'; --  VARCHAR2(13), --PTM_VBAS7S CURR  13(2)   Valuation Basis for Different Payment
        Oa_.S50 := 'TRFGR'; --  VARCHAR2(8), --TRFGR  CHAR  8   Pay Scale Group
        Oa_.S51 := 'TRFST'; --  VARCHAR2(2), --TRFST  CHAR  2 Pay Scale Level
        Oa_.S52 := 'PRAKN'; --  VARCHAR2(2), --PRAKN  CHAR  2 T510P Premium Number
        Oa_.S53 := 'PRAKZ'; --  VARCHAR2(4), --PRAKZ  NUMC  4   Premium Indicator
        Oa_.S54 := 'OTYPE'; --  VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
        Oa_.S55 := 'PLANS'; --  VARCHAR2(8), --PLANS  NUMC  8   Position
        Oa_.S56 := 'EXBEL'; --  VARCHAR2(8), --EXBEL  CHAR  8   External Document Number
        Oa_.S57 := 'WAERS'; --  VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
        Oa_.S58 := 'WTART'; --  VARCHAR2(4), --WTART  CHAR  4   Work tax area
        Oa_.S59 := 'TDLANGU'; --  VARCHAR2(10), --TMW_TDLANGU  CHAR  10    Definition Set for IDs
        Oa_.S60 := 'TDSUBLA'; --  VARCHAR2(3), --TMW_TDSUBLA  CHAR  3   Definition Subset for IDs
        Oa_.S61 := 'TDTYPE'; --  VARCHAR2(4), --TDTYPE  CHAR  4   Time Data ID Type TDTYP
        Oa_.S62 := 'LOGSYS'; --   VARCHAR2(10), --LOGSYS  CHAR  10  Logical system  ALPHA
        Oa_.S63 := 'AWTYP'; --    VARCHAR2(5), --AWTYP  CHAR  5   Reference Transaction
        Oa_.S64 := 'AWREF'; --    VARCHAR2(10), --AWREF  CHAR  10    Reference Document Number ALPHA
        Oa_.S65 := 'AWORG'; --    VARCHAR2(10), --AWORG  CHAR  10    Reference Organizational Units
        Oa_.S66 := 'NXDFL'; --    VARCHAR2(1), --PTM_NXDFL  CHAR  1   Next Day Indicator
        Oa_.S67 := 'FTKLA'; --    VARCHAR2(1) --FTKLA  CHAR  1   Public holiday class
      WHEN '2006' THEN
        --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
        Oa_.S24 := 'BEGUZ'; -- varchar2(6), -- BEGTI TIMS  6   Start Time
        Oa_.S25 := 'ENDUZ'; -- varchar2(6), -- ENDTI TIMS  6   End Time
        Oa_.S26 := 'VTKEN'; -- varchar2(1), -- VTKEN CHAR  1   Previous Day Indicator
        Oa_.S27 := 'KTART'; -- varchar2(2), -- ABWKO NUMC  2 T556A Absence Quota Type
        Oa_.S28 := 'ANZHL'; -- varchar2(10), -- PTM_QUONUM  DEC 10(5)   Number of Employee Time Quota
        Oa_.S29 := 'KVERB'; -- varchar2(10), -- PTM_QUODED  DEC 10(5)   Deduction of Employee Time Quota
        Oa_.S30 := 'QUONR'; -- varchar2(20), -- PTM_QUONR NUMC  20    Counter for time quotas
        Oa_.S31 := 'DESTA'; -- varchar2(8), -- PTM_DEDSTART  DATS  8   Start Date for Quota Deduction
        Oa_.S32 := 'DEEND'; -- varchar2(8), -- PTM_DEDEND  DATS  8   Quota Deduction to
        Oa_.S33 := 'QUOSY'; -- varchar2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
        --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
        Oa_.S34 := 'TDLANGU'; -- varchar2(10), -- TMW_TDLANGU CHAR  10  Definition Set for IDs
        Oa_.S35 := 'TDSUBLA'; -- varchar2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
        Oa_.S36 := 'TDTYPE'; --  varchar2(4) -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
      WHEN '2010' THEN
        Oa_.S24 := 'BEGUZ'; --  VARCHAR2(6), -- BEGTI TIMS  6   START TIME
        Oa_.S25 := 'ENDUZ'; --  VARCHAR2(6), -- ENDTI TIMS  6   END TIME
        Oa_.S26 := 'VTKEN'; --  VARCHAR2(1), -- VTKEN CHAR  1   PREVIOUS DAY INDICATOR
        Oa_.S27 := 'STDAZ'; --  VARCHAR2(12), -- ENSTD DEC 7(2)    NO.OF HOURS FOR REMUNERATION INFO.
        Oa_.S28 := 'LGART'; --  VARCHAR2(4), -- LGART CHAR  4   WAGE TYPE
        Oa_.S29 := 'ANZHL'; --  VARCHAR2(7), -- ENANZ DEC 7(2)    NUMBER PER TIME UNIT FOR EE REMUNERATION INFO
        Oa_.S30 := 'ZEINH'; --  VARCHAR2(3), -- PT_ZEINH  CHAR  3 T538A TIME/MEASUREMENT UNIT
        Oa_.S31 := 'BWGRL'; --  VARCHAR2(13), -- PTM_VBAS7S  CURR  13(2)   VALUATION BASIS FOR DIFFERENT PAYMENT
        Oa_.S32 := 'AUFKZ'; --  VARCHAR2(1), --   AUFKN CHAR  1   EXTRA PAY INDICATOR
        Oa_.S33 := 'BETRG'; --  VARCHAR2(13), -- PAD_AMT7S CURR  13(2)   WAGE TYPE AMOUNT FOR PAYMENTS
        Oa_.S34 := 'ENDOF'; --  VARCHAR2(1), -- ENDOF CHAR  1   INDICATOR FOR FINAL CONFIRMATION
        Oa_.S35 := 'UFLD1'; --  VARCHAR2(1), -- USFLD CHAR  1   USER FIELD
        Oa_.S36 := 'UFLD2'; --  VARCHAR2(1), -- USFLD CHAR  1   USER FIELD
        Oa_.S37 := 'UFLD3'; --  VARCHAR2(1), --   USFLD CHAR  1   USER FIELD
        Oa_.S38 := 'KEYPR'; --  VARCHAR2(3), -- KEYPR CHAR  3   NUMBER OF INFOTYPE RECORD WITH IDENTICAL KEY
        Oa_.S39 := 'TRFGR'; --  VARCHAR2(8), -- TRFGR CHAR  8   PAY SCALE GROUP
        Oa_.S40 := 'TRFST'; --  VARCHAR2(2), -- TRFST CHAR  2   PAY SCALE LEVEL
        Oa_.S41 := 'PRAKN'; --  VARCHAR2(2), -- PRAKN CHAR  2 T510P PREMIUM NUMBER
        Oa_.S42 := 'PRAKZ'; --  VARCHAR2(4), -- PRAKZ NUMC  4   PREMIUM INDICATOR
        Oa_.S43 := 'OTYPE'; --  VARCHAR2(2), -- OTYPE CHAR  2 T778O OBJECT TYPE
        Oa_.S44 := 'PLANS'; --  VARCHAR2(8), -- PLANS NUMC  8 T528B POSITION
        Oa_.S45 := 'VERSL'; --  VARCHAR2(1), -- VRSCH CHAR  1 T555R OVERTIME COMPENSATION TYPE
        Oa_.S46 := 'EXBEL'; --  VARCHAR2(8), -- EXBEL CHAR  8   EXTERNAL DOCUMENT NUMBER
        Oa_.S47 := 'WAERS'; --  VARCHAR2(5), -- WAERS CUKY  5 TCURC CURRENCY KEY
        Oa_.S48 := 'LOGSYS'; -- VARCHAR2(10), -- LOGSYS CHAR  10    LOGICAL SYSTEM  ALPHA
        Oa_.S49 := 'AWTYP'; --  VARCHAR2(5), -- AWTYP CHAR  5   REFERENCE TRANSACTION
        Oa_.S50 := 'AWREF'; --  VARCHAR2(10), -- AWREF CHAR  10    REFERENCE DOCUMENT NUMBER ALPHA
        Oa_.S51 := 'AWORG'; --  VARCHAR2(10), -- AWORG CHAR  10    REFERENCE ORGANIZATIONAL UNITS
        Oa_.S52 := 'WTART'; --  VARCHAR2(4), -- WTART CHAR  4 T5UTB WORK TAX AREA
        --.INCLUDE  TMW_TDT_FIELDS        INFOTYPE FIELDS RELEVANT FOR SHORT DESCRIPTIONS
        Oa_.S53 := 'TDLANGU'; -- VARCHAR2(10), -- TMW_TDLANGU CHAR  10  DEFINITION SET FOR IDS
        Oa_.S54 := 'TDSUBLA'; -- VARCHAR2(3), -- TMW_TDSUBLA CHAR  3   DEFINITION SUBSET FOR IDS
        Oa_.S55 := 'TDTYPE'; --  VARCHAR2(4) -- TDTYPE  CHAR  4   TIME DATA ID TYPE TDTYP
      WHEN '0866' THEN
        --.INCLUDE  PS0866        Education PL
        Oa_.S24 := 'BEG_SCH'; --varchar2(8), --PPL_BEG_SCH  DATS  8   School start
        Oa_.S25 := 'END_SCH'; --varchar2(8), --PPL_END_SCH DATS  8   School end date
        Oa_.S90 := 'IFS_SUBTY'; --VARCHAR(2) --necessary to map education year
      WHEN '9950' THEN
        Oa_.S24 := 'ZZEMPQUE'; -- varchar2(1), --  Kwestionariusz osobowy
        Oa_.S25 := 'ZZEMPCON'; -- varchar2(1), --  Umowa o pracê
        Oa_.S26 := 'ZZJOBDES'; -- varchar2(1), --  Zakres obowi¹zków
        Oa_.S27 := 'ZZWORPER'; -- varchar2(1), --  Pozwolenie na pracê
        Oa_.S28 := 'ZZWORCER'; -- varchar2(1), --  Œwiadectwo pracy
        Oa_.S29 := 'ZZDIPLOM'; -- varchar2(1), --  Dyplom
        Oa_.S30 := 'ZZMEDEXA'; -- varchar2(1), --  Badania lekarskie
        Oa_.S31 := 'ZZBHPTRA'; -- varchar2(1), --  Szkolenie BHP
        Oa_.S32 := 'ZZCOMWOR'; -- varchar2(1), --  Œwiadectwo pracy firma
        Oa_.S33 := 'ZZREFERE'; -- varchar2(1), --  Referencje
        Oa_.S34 := 'ZZNONSUB'; -- varchar2(1), --  Oœwiadczenie o bezrobociu
        Oa_.S35 := 'ZZCRIREC'; -- varchar2(1), --  Oœwiadczenie o niekaralnoœci
        Oa_.S36 := 'ZZJOBRIS'; -- varchar2(1), --  Ryzyko zawodowe
        Oa_.S37 := 'ZZUNFELI'; --   varchar2(1), --  Licencja UNFE
        Oa_.S38 := 'ZZCURVIT'; --   varchar2(1), --  CV
        Oa_.S39 := 'ZZANNEX'; --   varchar2(1), -- Aneks
        Oa_.S40 := 'ZZINFEMP'; --   varchar2(1), --  Informacja dla pracownika
        Oa_.S41 := 'ZZEQUTRE'; --   varchar2(1), --  Oœwiadczenie o równym traktowaniu
        Oa_.S42 := 'ZZBUSCON'; --   varchar2(1), --Certyfikat firmowy
        Oa_.S43 := 'ZZPPOZCE'; --   varchar2(1), --  Oœwiadczenie PPO¯
        Oa_.S44 := 'ZZINFSW1'; --  varchar2(120), --  Informacja o œwiadectwach 1
        Oa_.S45 := 'ZZINFSW2'; --  varchar2(120), --  Informacja o œwiadectwach 2
        Oa_.S46 := 'ZZDODA01'; --  varchar2(1), --  Dodatkowy dokument 1
        Oa_.S47 := 'ZZDODA02'; --  varchar2(1), --Dodatkowy dokument 2
        Oa_.S48 := 'ZZDODA03'; --  varchar2(1), --  Dodatkowy dokument 3
        Oa_.S49 := 'ZZDODA04'; --  varchar2(1), --  Dodatkowy dokument 4
        Oa_.S50 := 'ZZDODA05'; --  varchar2(1), --  Dodatkowy dokument 5
        Oa_.S51 := 'ZZDODA06'; --  varchar2(1), --  Dodatkowy dokument 6
        Oa_.S52 := 'ZZDODO98'; --  varchar2(120), --  Dodatkowy dokument opis 1
        Oa_.S53 := 'ZZDODO99'; --  varchar2(120) --  Dodatkowy dokument opis 2
      WHEN 'T558A' THEN
        Oa_     := NULL;
        Oa_.S20 := To_Char(0, '000000000');
        --
        Oa_.S1 := 'MANDT'; --   varchar2(3), --MANDT CLNT  3 T000  Client
        Oa_.S2 := 'PERNR'; --   varchar2(8), --PERNR_D NUMC  8   Personnel Number
        Oa_.S3 := 'BEGDA'; --
        Oa_.S4 := 'ENDDA'; --
        Oa_.S5 := 'MOLGA'; --   varchar2(2), --MOLGA CHAR  2 T500L Country Grouping
        Oa_.S6 := 'LGART'; --   varchar2(4), --LGART CHAR  4 T512W Wage Type
        --
        Oa_.S7 := 'BETPE'; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
        Oa_.S8 := 'ANZHL'; -- varchar2(15), --RPANZ DEC 15(2)   Number field
        Oa_.S9 := 'BETRG'; -- varchar2(15) --RPBET  CURR  15(2)   Amount
    --t558b
      WHEN 'T558B' THEN
        Oa_     := NULL;
        Oa_.S20 := To_Char(0, '000000000');
        --
        Oa_.S1 := 'MANDT'; -- varchar2(3), --MANDT  CLNT  3 T000  Client
        Oa_.S2 := 'PERNR'; -- varchar2(8), --PERNR_D  NUMC  8   Personnel Number
        Oa_.S3 := 'SEQNR'; -- varchar2(5), --SEQ_T558B  NUMC  5   Sequential number for payroll period
        --
        Oa_.S4  := 'PAYTY'; --    varchar2(1), --PAYTY CHAR  1   Payroll type
        Oa_.S5  := 'PAYID'; --    varchar2(1), --PAYID CHAR  1   Payroll Identifier
        Oa_.S6  := 'PAYDT'; --    varchar2(8), --PAY_DATE  DATS  8   Pay date for payroll result
        Oa_.S7  := 'PERMO'; --    varchar2(2), --PERMO NUMC  2 T549R Period Parameters
        Oa_.S8  := 'PABRJ'; --    varchar2(4), --PABRJ NUMC  4   Payroll Year  GJAHR
        Oa_.S9  := 'PABRP'; --    varchar2(2), --PABRP NUMC  2   Payroll Period
        Oa_.S10 := 'FPBEG'; --    varchar2(8), --FPBEG DATS  8   Start date of payroll period (FOR period)
        Oa_.S11 := 'FPEND'; --    varchar2(8), --FPEND DATS  8   End of payroll period (for-period)
        Oa_.S12 := 'OCRSN'; --   varchar2(4), --PAY_OCRSN CHAR  4   Reason for Off-Cycle Payroll
        Oa_.S13 := 'SEQNR_CD'; -- varchar2(5) --CDSEQ NUMC  5   Sequence Number
    --t558c
      WHEN 'T558C' THEN
        Oa_     := NULL;
        Oa_.S20 := To_Char(0, '000000000');
        --
        Oa_.S1 := 'MANDT'; --   varchar2(3), --MANDT CLNT  3 T000  Client
        Oa_.S2 := 'PERNR'; --   varchar2(8), --PERNR_D NUMC  8   Personnel Number
        Oa_.S3 := 'SEQNR'; --   varchar2(5), --SEQ_T558B NUMC  5 T558B Sequential number for payroll period
        Oa_.S4 := 'MOLGA'; --   varchar2(2), --MOLGA CHAR  2 T500L Country Grouping
        Oa_.S5 := 'LGART'; --   varchar2(4), --LGART CHAR  4 T512W Wage Type
        Oa_.S6 := 'KEYDATE'; -- varchar2(8), --  DATUM DATS  8   Date
        --
        Oa_.S7 := 'BETPE'; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
        Oa_.S8 := 'ANZHL'; -- varchar2(15), --RPANZ DEC 15(2)   Number field
        Oa_.S9 := 'BETRG'; -- varchar2(15) --RPBET  CURR  15(2)   Amount
      WHEN 'PAYBASE' THEN
        Oa_     := NULL;
        Oa_.S20 := To_Char(0, '000000000');
        --
        Oa_.S1  := 'MANDT'; --
        Oa_.S2  := 'PERNR'; --
        Oa_.S3  := 'PERIOD'; --
        Oa_.S4  := 'h855'; --
        Oa_.S5  := 'h853'; --
        Oa_.S6  := 'h850'; --
        Oa_.S7  := 'w232b'; --
        Oa_.S8  := 'w232n'; --
        Oa_.S9  := 'w3pu'; --
        Oa_.S10 := 'w3p1'; --
        --
        Oa_.S11 := 'w0030b'; --
        Oa_.S12 := 'w0030r'; --
        Oa_.S13 := 'w0030a'; --
      ELSE
        NULL;
    END CASE;
    --
    Oa_.S99 := To_Char(0, '000000000');
    RETURN Oa_;
  END Prepare_Header_Line;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0000) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0000;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0000');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0000_.Massn; -- MASSN CHAR  2 T529A Action Type
      Oa_.S25 := Wa_.Ps0000_.Massg; -- MASSG CHAR  2 T530  Reason for Action
      Oa_.S26 := Wa_.Ps0000_.Stat1; -- STAT1 CHAR  1 T529U Customer-Specific Status
      Oa_.S27 := Wa_.Ps0000_.Stat2; -- STAT2 CHAR  1 T529U Employment Status
      Oa_.S28 := Wa_.Ps0000_.Stat3; -- STAT3  CHAR  1 T529U Special Payment Status
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0000_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0001) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0001;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0001');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0001_.Bukrs; -- BUKRS CHAR  4 T001  Company Code
      Oa_.S25 := Wa_.Ps0001_.Werks; -- PERSA CHAR  4 T500P Personnel Area
      Oa_.S26 := Wa_.Ps0001_.Persg; -- PERSG CHAR  1 T501  Employee Group
      Oa_.S27 := Wa_.Ps0001_.Persk; -- PERSK CHAR  2 T503K Employee Subgroup
      Oa_.S28 := Wa_.Ps0001_.Vdsk1; -- VDSK1 CHAR  14  T527O Organizational Key
      Oa_.S29 := Wa_.Ps0001_.Gsber; -- GSBER CHAR  4 TGSB  Business Area
      Oa_.S30 := Wa_.Ps0001_.Btrtl; -- BTRTL CHAR  4 T001P Personnel Subarea
      Oa_.S31 := Wa_.Ps0001_.Juper; -- JUPER CHAR  4   Legal Person
      Oa_.S32 := Wa_.Ps0001_.Abkrs; -- ABKRS CHAR  2 T549A Payroll Area
      Oa_.S33 := Wa_.Ps0001_.Ansvh; -- ANSVH CHAR  2 T542A Work Contract
      Oa_.S34 := Wa_.Ps0001_.Kostl; -- KOSTL CHAR  10  CSKS  Cost Center ALPHA
      Oa_.S35 := Wa_.Ps0001_.Orgeh; -- ORGEH NUMC  8 T527X Organizational Unit
      Oa_.S36 := Wa_.Ps0001_.Plans; -- PLANS NUMC  8 T528B Position
      Oa_.S37 := Wa_.Ps0001_.Stell; -- STELL NUMC  8 T513  Job
      Oa_.S38 := Wa_.Ps0001_.Mstbr; -- MSTBR CHAR  8   Supervisor Area
      Oa_.S39 := Wa_.Ps0001_.Sacha; -- SACHA CHAR  3 T526  Payroll Administrator
      Oa_.S40 := Wa_.Ps0001_.Sachp; -- SACHP CHAR  3 T526  Administrator for HR Master Data
      Oa_.S41 := Wa_.Ps0001_.Sachz; -- SACHZ CHAR  3 T526  Administrator for Time Recording
      Oa_.S42 := Wa_.Ps0001_.Sname; -- SMNAM CHAR  30    Employees Name (Sortable by LAST NAME FIRST NAME)
      Oa_.S43 := Wa_.Ps0001_.Ename; -- EMNAM CHAR  40    Formatted Name of Employee or Applicant
      Oa_.S44 := Wa_.Ps0001_.Otype; -- OTYPE CHAR  2 T778O Object Type
      Oa_.S45 := Wa_.Ps0001_.Sbmod; -- SBMOD CHAR  4   Administrator Group
      Oa_.S46 := Wa_.Ps0001_.Kokrs; -- KOKRS CHAR  4 TKA01 Controlling Area
      Oa_.S47 := Wa_.Ps0001_.Fistl; -- FISTL CHAR  16
      Oa_.S48 := Wa_.Ps0001_.Geber; -- BP_GEBER  CHAR  10
      Oa_.S49 := Wa_.Ps0001_.Fkber; -- FKBER CHAR  16  * Functional Area
      Oa_.S50 := Wa_.Ps0001_.Grant_Nbr; -- GM_GRANT_NBR  CHAR  20    Grant ALPHA
      Oa_.S51 := Wa_.Ps0001_.Sgmnt; -- FB_SEGMENT  CHAR  10  * Segment for Segmental Reporting ALPHA
      Oa_.S52 := Wa_.Ps0001_.Budget_Pd; -- FM_BUDGET_PERIOD  CHAR  10  * FM: Budget Period
      Oa_.S91 := Wa_.Ps0001_.Ifs_Pose_Code;
      Oa_.S92 := Wa_.Ps0001_.Ifs_Pose_Name;
      Oa_.S93 := Wa_.Ps0001_.Ifs_Pose_Name_En;
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0001_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0002) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0002;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0002');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0002_.Inits; --    INITS CHAR  10    Initials
      Oa_.S25 := Wa_.Ps0002_.Nachn; --      PAD_NACHN CHAR  40    Last Name
      Oa_.S26 := Wa_.Ps0002_.Name2; --      PAD_NAME2 CHAR  40    Name at Birth
      Oa_.S27 := Wa_.Ps0002_.Nach2; --      PAD_NACH2 CHAR  40    Second Name
      Oa_.S28 := Wa_.Ps0002_.Vorna; --      PAD_VORNA CHAR  40    First Name
      Oa_.S29 := Wa_.Ps0002_.Cname; --      PAD_CNAME CHAR  80    Complete Name
      Oa_.S30 := Wa_.Ps0002_.Titel; --      TITEL CHAR  15  T535N Title
      Oa_.S31 := Wa_.Ps0002_.Titl2; --      TITL2 CHAR  15  T535N Second Title
      Oa_.S32 := Wa_.Ps0002_.Namzu; --      NAMZU CHAR  15  T535N Other Title
      Oa_.S33 := Wa_.Ps0002_.Vorsw; --      VORSW CHAR  15  T535N Name Prefix
      Oa_.S34 := Wa_.Ps0002_.Vors2; --      VORS2 CHAR  15  T535N Second Name Prefix
      Oa_.S35 := Wa_.Ps0002_.Rufnm; --      PAD_RUFNM CHAR  40    Nickname
      Oa_.S36 := Wa_.Ps0002_.Midnm; --      PAD_MIDNM CHAR  40    Middle Name
      Oa_.S37 := Wa_.Ps0002_.Knznm; --      KNZNM NUMC  2   Name Format Indicator for Employee in a List
      Oa_.S38 := Wa_.Ps0002_.Anred; --      ANRDE CHAR  1 T522G Form-of-Address Key
      Oa_.S39 := Wa_.Ps0002_.Gesch; --      GESCH CHAR  1   Gender Key
      Oa_.S40 := Wa_.Ps0002_.Gbdat; --      GBDAT DATS  8   Date of Birth PDATE
      Oa_.S41 := Wa_.Ps0002_.Gblnd; --      GBLND CHAR  3 T005  Country of Birth
      Oa_.S42 := Wa_.Ps0002_.Gbdep; --      GBDEP CHAR  3 T005S State
      Oa_.S43 := Wa_.Ps0002_.Gbort; --      PAD_GBORT CHAR  40    Birthplace
      Oa_.S44 := Wa_.Ps0002_.Natio; --      NATSL CHAR  3 T005  Nationality
      Oa_.S45 := Wa_.Ps0002_.Nati2; --      NATS2 CHAR  3 T005  Second Nationality
      Oa_.S46 := Wa_.Ps0002_.Nati3; --      NATS3 CHAR  3 T005  Third Nationality
      Oa_.S47 := Wa_.Ps0002_.Sprsl; --      PAD_SPRAS LANG  1 T002  Communication Language  ISOLA
      Oa_.S48 := Wa_.Ps0002_.Konfe; --      KONFE CHAR  2 * Religious Denomination Key
      Oa_.S49 := Wa_.Ps0002_.Famst; --      FAMST CHAR  1 * Marital Status Key
      Oa_.S50 := Wa_.Ps0002_.Famdt; --      FAMDT DATS  8   Valid From Date of Current Marital Status
      Oa_.S51 := Wa_.Ps0002_.Anzkd; --      ANZKD DEC 3   Number of Children
      Oa_.S52 := Wa_.Ps0002_.Nacon; --      NACON CHAR  1   Name Connection
      Oa_.S53 := Wa_.Ps0002_.Permo; --      PIDMO CHAR  2   Modifier for Personnel Identifier
      Oa_.S54 := Wa_.Ps0002_.Perid; --      PRDNI CHAR  20    Personnel ID Number
      Oa_.S55 := Wa_.Ps0002_.Gbpas; --      GBPAS DATS  8   Date of Birth According to Passport
      Oa_.S56 := Wa_.Ps0002_.Fnamk; --      P22J_PFNMK  CHAR  40    First name (Katakana)
      Oa_.S57 := Wa_.Ps0002_.Lnamk; --      P22J_PLNMK  CHAR  40    Last name (Katakana)
      Oa_.S58 := Wa_.Ps0002_.Fnamr; --      P22J_PFNMR  CHAR  40    First Name (Romaji)
      Oa_.S59 := Wa_.Ps0002_.Lnamr; --      P22J_PLNMR  CHAR  40    Last Name (Romaji)
      Oa_.S60 := Wa_.Ps0002_.Nabik; --      P22J_PNBIK  CHAR  40    Name of Birth (Katakana)
      Oa_.S61 := Wa_.Ps0002_.Nabir; --      P22J_PNBIR  CHAR  40    Name of Birth (Romaji)
      Oa_.S62 := Wa_.Ps0002_.Nickk; --      P22J_PNCKK  CHAR  40    Koseki (Katakana)
      Oa_.S63 := Wa_.Ps0002_.Nickr; --      P22J_PNCKR  CHAR  40    Koseki (Romaji)
      Oa_.S64 := Wa_.Ps0002_.Gbjhr; --      GBJHR NUMC  4   Year of Birth GJAHR
      Oa_.S65 := Wa_.Ps0002_.Gbmon; --      GBMON NUMC  2   Month of Birth
      Oa_.S66 := Wa_.Ps0002_.Gbtag; --      GBTAG NUMC  2   Birth Date (to Month/Year)
      Oa_.S67 := Wa_.Ps0002_.Nchmc; --      NACHNMC CHAR  25    Last Name (Field for Search Help)
      Oa_.S68 := Wa_.Ps0002_.Vnamc; --      VORNAMC CHAR  25    First Name (Field for Search Help)
      Oa_.S69 := Wa_.Ps0002_.Namz2; --     NAMZ2 CHAR  15  T535N Name Affix for Name at Birth
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0002_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0003) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0003;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0003');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0003_.Abrsp; --   ABRSP CHAR  1   Indicator: Personnel number locked for payroll
      Oa_.S25 := Wa_.Ps0003_.Abrdt; --   LABRD DATS  8   Accounted to
      Oa_.S26 := Wa_.Ps0003_.Rrdat; --   RRDAT DATS  8   Earliest master data change since last payroll run
      Oa_.S27 := Wa_.Ps0003_.Rrdaf; --   RRDAF DATS  8   not in use
      Oa_.S28 := Wa_.Ps0003_.Koabr; --   PAD_INTERN  CHAR  1   Internal Use
      Oa_.S29 := Wa_.Ps0003_.Prdat; --   PRRDT DATS  8   Earliest personal retroactive accounting date
      Oa_.S30 := Wa_.Ps0003_.Pkgab; --   PKGAB DATS  8   Date as of which personal calendar must be generated
      Oa_.S31 := Wa_.Ps0003_.Abwd1; --   ABWD1 DATS  8   End of processing 1 (run payroll for pers.no. up to)
      Oa_.S32 := Wa_.Ps0003_.Abwd2; --   ABWD2 DATS  8   End of processing (do not run payroll for pers.no. after)
      Oa_.S33 := Wa_.Ps0003_.Bderr; --   BDERR DATS  8   Recalculation date for PDC
      Oa_.S34 := Wa_.Ps0003_.Bder1; --   BDER1 DATS  8   Effective recalculation date for PDC
      Oa_.S35 := Wa_.Ps0003_.Kobde; --   KOBDE CHAR  1   PDC Error Indicator
      Oa_.S36 := Wa_.Ps0003_.Timrc; --   TIMRC CHAR  1   Date of initial PDC entry
      Oa_.S37 := Wa_.Ps0003_.Dat00; --   DATP0 DATS  8   Initial input date for a personnel number
      Oa_.S38 := Wa_.Ps0003_.Uhr00; --   UHR00 TIMS  6   Time of initial input
      Oa_.S39 := Wa_.Ps0003_.Inumk; --   CHAR8 CHAR  8   Character field, 8 characters long
      Oa_.S40 := Wa_.Ps0003_.Werks; --   SBMOD CHAR  4   Administrator Group
      Oa_.S41 := Wa_.Ps0003_.Sachz; --   SACHZ CHAR  3   Administrator for Time Recording
      Oa_.S42 := Wa_.Ps0003_.Sfeld; --   SFELD CHAR  20    Sort field for infotype 0003
      Oa_.S43 := Wa_.Ps0003_.Adrun; --   ADRUN CHAR  1   HR: Special payroll run
      Oa_.S44 := Wa_.Ps0003_.Viekn; --   VIEKN CHAR  2   Infotype View Indicator
      Oa_.S45 := Wa_.Ps0003_.Trvfl; --   TRVFL CHAR  1   Indicator for recorded trips
      Oa_.S46 := Wa_.Ps0003_.Rcbon; --   RCBON DATS  8   Earliest payroll-relevant master data change (bonus)
      Oa_.S47 := Wa_.Ps0003_.Prtev; --   PRTEV DATS  8   Earliest personal recalculation date for time evaluation
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0003_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0006) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0006;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0006');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0006_.Anssa; --     ANSSA CHAR  4   Address Record Type
      Oa_.S25 := Wa_.Ps0006_.Name2; -- PAD_CONAM  CHAR  40    Contact Name
      Oa_.S26 := Wa_.Ps0006_.Stras; --PAD_STRAS  CHAR  60    Street and House Number
      Oa_.S27 := Wa_.Ps0006_.Ort01; -- PAD_ORT01  CHAR  40    City
      Oa_.S28 := Wa_.Ps0006_.Ort02; -- PAD_ORT02  CHAR  40    District
      Oa_.S29 := Wa_.Ps0006_.Pstlz; -- PSTLZ_HR CHAR  10    Postal Code
      Oa_.S30 := Wa_.Ps0006_.Land1; --LAND1 CHAR  3 T005  Country Key
      Oa_.S31 := Wa_.Ps0006_.Telnr; --TELNR  CHAR  14    Telephone Number
      Oa_.S32 := Wa_.Ps0006_.Entkm; -- ENTKM DEC 3   Distance in Kilometers
      Oa_.S33 := Wa_.Ps0006_.Wkwng; --WKWNG CHAR  1   Company Housing
      Oa_.S34 := Wa_.Ps0006_.Busrt; --BUSRT CHAR  3   Bus Route
      Oa_.S35 := Wa_.Ps0006_.Locat; --PAD_LOCAT  CHAR  40    2nd Address Line
      Oa_.S36 := Wa_.Ps0006_.Adr03; --AD_STRSPP1  CHAR  40    Street 2
      Oa_.S37 := Wa_.Ps0006_.Adr04; --AD_STRSPP2 CHAR  40    Street 3
      Oa_.S38 := Wa_.Ps0006_.Hsnmr; --PAD_HSNMR  CHAR  10    House Number
      Oa_.S39 := Wa_.Ps0006_.Posta; --PAD_POSTA  CHAR  10    Identification of an apartment in a building
      Oa_.S40 := Wa_.Ps0006_.Bldng; -- AD_BLD_10  CHAR  10    Building (number or code)
      Oa_.S41 := Wa_.Ps0006_.Floor; -- AD_FLOOR CHAR  10    Floor in building
      Oa_.S42 := Wa_.Ps0006_.Strds; --STRDS CHAR  2 T5EVP Street Abbreviation
      Oa_.S43 := Wa_.Ps0006_.Entk2; -- ENTKM DEC 3   Distance in Kilometers
      Oa_.S44 := Wa_.Ps0006_.Com01; --COMKY CHAR  4 T536B Communication Type
      Oa_.S45 := Wa_.Ps0006_.Num01; -- COMNR  CHAR  20    Communication Number
      Oa_.S46 := Wa_.Ps0006_.Com02; -- COMKY CHAR  4 T536B Communication Type
      Oa_.S47 := Wa_.Ps0006_.Num02; --  COMNR CHAR  20    Communication Number
      Oa_.S48 := Wa_.Ps0006_.Com03; -- COMKY CHAR  4 T536B Communication Type
      Oa_.S49 := Wa_.Ps0006_.Num03; -- COMNR  CHAR  20    Communication Number
      Oa_.S50 := Wa_.Ps0006_.Com04; -- COMKY CHAR  4 T536B Communication Type
      Oa_.S51 := Wa_.Ps0006_.Num04; -- COMNR  CHAR  20    Communication Number
      Oa_.S52 := Wa_.Ps0006_.Com05; -- COMKY CHAR  4 T536B Communication Type
      Oa_.S53 := Wa_.Ps0006_.Num05; -- COMNR  CHAR  20    Communication Number
      Oa_.S54 := Wa_.Ps0006_.Com06; -- COMKY CHAR  4 T536B Communication Type
      Oa_.S55 := Wa_.Ps0006_.Num06; -- COMNR  CHAR  20    Communication Number
      Oa_.S56 := Wa_.Ps0006_.Indrl; -- P22J_INDRL  CHAR  2 T577  Indicator for relationship (specification code)
      Oa_.S57 := Wa_.Ps0006_.Counc; -- COUNC CHAR  3 T005E County Code
      Oa_.S58 := Wa_.Ps0006_.Rctvc; -- P22J_RCTVC  CHAR  6   Municipal city code
      Oa_.S59 := Wa_.Ps0006_.Or2kk; -- P22J_ORKK2 CHAR  40    Second address line (Katakana)
      Oa_.S60 := Wa_.Ps0006_.Conkk; -- P22J_PCNKK CHAR  40    Contact Person (Katakana) (Japan)
      Oa_.S61 := Wa_.Ps0006_.Or1kk; -- P22J_ORKK1 CHAR  40    First address line (Katakana)
      Oa_.S62 := Wa_.Ps0006_.Railw; --RAILW NUMC  1   Social Subscription Railway
      Oa_.S63 := Wa_.Ps0006_.Ifs_State;
      Oa_.S64 := Wa_.Ps0006_.Ifs_Counc;
      Oa_.S65 := Wa_.Ps0006_.Ifs_County;
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0006_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0007) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0007;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0007');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0007_.Schkz; --       SCHKN CHAR  8   Work Schedule Rule
      Oa_.S25 := Wa_.Ps0007_.Zterf; --       PT_ZTERF  NUMC  1 T555U Employee Time Management Status
      Oa_.S26 := Wa_.Ps0007_.Empct; --      EMPCT DEC 5(2)    Employment percentage
      Oa_.S27 := Wa_.Ps0007_.Mostd; --       MOSTD DEC 5(2)    Monthly hours
      Oa_.S28 := Wa_.Ps0007_.Wostd; --        WOSTD DEC 5(2)    Hours per week
      Oa_.S29 := Wa_.Ps0007_.Arbst; --        STDTG DEC 5(2)    Daily Working Hours
      Oa_.S30 := Wa_.Ps0007_.Wkwdy; --        WARST DEC 4(2)    Weekly Workdays
      Oa_.S31 := Wa_.Ps0007_.Jrstd; --        JRSTD DEC 7(2)    Annual working hours
      Oa_.S32 := Wa_.Ps0007_.Teilk; --        TEILK CHAR  1   Indicator Part-Time Employee
      Oa_.S33 := Wa_.Ps0007_.Minta; --        MINTA DEC 5(2)    Minimum number of work hours per day
      Oa_.S34 := Wa_.Ps0007_.Maxta; --        MAXTA DEC 5(2)    Maximum number of work hours per day
      Oa_.S35 := Wa_.Ps0007_.Minwo; --      MINWO DEC 5(2)    Minimum weekly working hours
      Oa_.S36 := Wa_.Ps0007_.Maxwo; --       MAXWO DEC 5(2)    Maximum number of work hours per week
      Oa_.S37 := Wa_.Ps0007_.Minmo; --        MINMO DEC 5(2)    Minimum number of work hours per month
      Oa_.S38 := Wa_.Ps0007_.Maxmo; --        MAXMO DEC 5(2)    Maximum number of work hours per month
      Oa_.S39 := Wa_.Ps0007_.Minja; --        MINJA DEC 7(2)    Minimum annual working hours
      Oa_.S40 := Wa_.Ps0007_.Maxja; --       MAXJA DEC 7(2)    Maximum Number of Working Hours Per Year
      Oa_.S41 := Wa_.Ps0007_.Dysch; --        DYSCH CHAR  1   Create Daily Work Schedule Dynamically
      Oa_.S42 := Wa_.Ps0007_.Kztim; --       KZTIM CHAR  2   Additional indicator for time management
      Oa_.S43 := Wa_.Ps0007_.Wweek; --        WWEEK CHAR  2 T559A Working week
      Oa_.S44 := Wa_.Ps0007_.Awtyp; --       AWTYP CHAR  5   Reference Transaction
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0007_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0008) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0008;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0008');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0008_.Trfar; --   TRFAR CHAR  2 T510A Pay scale type
      Oa_.S25 := Wa_.Ps0008_.Trfgb; --   TRFGB CHAR  2 T510G Pay Scale Area
      Oa_.S26 := Wa_.Ps0008_.Trfgr; --   TRFGR CHAR  8   Pay Scale Group
      Oa_.S27 := Wa_.Ps0008_.Trfst; --   TRFST CHAR  2   Pay Scale Level
      Oa_.S28 := Wa_.Ps0008_.Stvor; --   STVOR DATS  8   Date of Next Increase
      Oa_.S29 := Wa_.Ps0008_.Orzst; --   ORTZS CHAR  2   Cost of Living Allowance Level
      Oa_.S30 := Wa_.Ps0008_.Partn; --   PARTN CHAR  2 T577  Partnership
      Oa_.S31 := Wa_.Ps0008_.Waers; --   WAERS CUKY  5 TCURC Currency Key
      Oa_.S32 := Wa_.Ps0008_.Vglta; --   VGLTA CHAR  2 T510A Comparison pay scale type
      Oa_.S33 := Wa_.Ps0008_.Vglgb; --   VGLGB CHAR  2 T510G Comparison pay scale area
      Oa_.S34 := Wa_.Ps0008_.Vglgr; --   VGLTG CHAR  8   Comparison pay scale group
      Oa_.S35 := Wa_.Ps0008_.Vglst; --   VGLST CHAR  2   Comparison pay scale level
      Oa_.S36 := Wa_.Ps0008_.Vglsv; --   STVOR DATS  8   Date of Next Increase
      Oa_.S37 := Wa_.Ps0008_.Bsgrd; --   BSGRD DEC 5(2)    Capacity Utilization Level
      Oa_.S38 := Wa_.Ps0008_.Divgv; --   DIVGV DEC 5(2)    Working Hours per Payroll Period
      Oa_.S39 := Wa_.Ps0008_.Ansal; --   ANSAL_15  CURR  15(2)   Annual salary
      Oa_.S40 := Wa_.Ps0008_.Falgk; --   FALGK CHAR  10    Case group catalog
      Oa_.S41 := Wa_.Ps0008_.Falgr; --   FALGR CHAR  6   Case group
      Oa_.S42 := Wa_.Ps0008_.Lga01; --   LGART CHAR  4 T512Z Wage Type
      Oa_.S43 := Wa_.Ps0008_.Bet01; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S44 := Wa_.Ps0008_.Anz01; --   ANZHL DEC 7(2)    Number
      Oa_.S45 := Wa_.Ps0008_.Ein01; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Oa_.S46 := Wa_.Ps0008_.Opk01; --   OPKEN CHAR  1   Operation Indicator for Wage Types
      Oa_.S47 := Wa_.Ps0008_.Lga02; --   LGART CHAR  4 T512Z Wage Type
      Oa_.S48 := Wa_.Ps0008_.Bet02; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S49 := Wa_.Ps0008_.Anz02; --   ANZHL DEC 7(2)    Number
      Oa_.S50 := Wa_.Ps0008_.Ein02; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Oa_.S51 := Wa_.Ps0008_.Opk02; --   OPKEN CHAR  1   Operation Indicator for Wage Types
      Oa_.S52 := Wa_.Ps0008_.Lga03; --   LGART CHAR  4 T512Z Wage Type
      Oa_.S53 := Wa_.Ps0008_.Bet03; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S54 := Wa_.Ps0008_.Anz03; --   ANZHL DEC 7(2)    Number
      Oa_.S55 := Wa_.Ps0008_.Ein03; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Oa_.S56 := Wa_.Ps0008_.Opk03; --   OPKEN CHAR  1   Operation Indicator for Wage Types
      Oa_.S57 := Wa_.Ps0008_.Ind01; --   INDBW CHAR  1   Indicator for indirect valuation
      Oa_.S58 := Wa_.Ps0008_.Ind02; --   INDBW CHAR  1   Indicator for indirect valuation
      Oa_.S59 := Wa_.Ps0008_.Ind03; --   INDBW CHAR  1   Indicator for indirect valuation
      Oa_.S60 := Wa_.Ps0008_.Ancur; --   ANCUR CUKY  5 TCURC Currency Key for Annual Salary
      Oa_.S61 := Wa_.Ps0008_.Cpind; --   P_CPIND CHAR  1   Planned compensation type
      Oa_.S62 := Wa_.Ps0008_.Flaga; --  FLAG  CHAR  1   General Flag
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0008_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0009) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0009;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0009');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0009_.Opken; --OPKEN  CHAR  1   Operation Indicator for Wage Types
      Oa_.S25 := Wa_.Ps0009_.Betrg; --PAD_VGBTR  CURR  13(2)   Standard value
      Oa_.S26 := Wa_.Ps0009_.Waers; --PAD_WAERS  CUKY  5 TCURC Payment Currency
      Oa_.S27 := Wa_.Ps0009_.Anzhl; --VGPRO  DEC 5(2)    Standard Percentage
      Oa_.S28 := Wa_.Ps0009_.Zeinh; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Oa_.S29 := Wa_.Ps0009_.Bnksa; --BNKSA  CHAR  4 T591A Type of Bank Details Record
      Oa_.S30 := Wa_.Ps0009_.Zlsch; --PCODE  CHAR  1 T042Z Payment Method
      Oa_.S31 := Wa_.Ps0009_.Emftx; --EMFTX  CHAR  40    Payee Text
      Oa_.S32 := Wa_.Ps0009_.Bkplz; --BKPLZ  CHAR  10    Postal Code
      Oa_.S33 := Wa_.Ps0009_.Bkort; --ORT01  CHAR  25    City
      Oa_.S34 := Wa_.Ps0009_.Banks; --BANKS  CHAR  3 T005  Bank country key
      Oa_.S35 := Wa_.Ps0009_.Bankl; --BANKK  CHAR  15    Bank Keys
      Oa_.S36 := Wa_.Ps0009_.Bankn; --BANKN  CHAR  18    Bank account number
      Oa_.S37 := Wa_.Ps0009_.Bankp; --BANKP  CHAR  2   Check Digit for Bank No./Account
      Oa_.S38 := Wa_.Ps0009_.Bkont; --BKONT  CHAR  2   Bank Control Key
      Oa_.S39 := Wa_.Ps0009_.Swift; --SWIFT  CHAR  11    SWIFT/BIC for International Payments
      Oa_.S40 := Wa_.Ps0009_.Dtaws; --DTAWS  CHAR  2 T015W Instruction key for data medium exchange
      Oa_.S41 := Wa_.Ps0009_.Dtams; --DTAMS  CHAR  1   Indicator for Data Medium Exchange
      Oa_.S42 := Wa_.Ps0009_.Stcd2; --STCD2  CHAR  11    Tax Number 2
      Oa_.S43 := Wa_.Ps0009_.Pskto; --PSKTO  CHAR  16    Account Number of Bank Account At Post Office
      Oa_.S44 := Wa_.Ps0009_.Esrnr; --ESRNR  CHAR  11    ISR Subscriber Number
      Oa_.S45 := Wa_.Ps0009_.Esrre; --ESRRE  CHAR  27    ISR Reference Number  ALPHA
      Oa_.S46 := Wa_.Ps0009_.Esrpz; --ESRPZ  CHAR  2   ISR Check Digit
      Oa_.S47 := Wa_.Ps0009_.Emfsl; --EMFSL  CHAR  8   Payee key for bank transfers
      Oa_.S48 := Wa_.Ps0009_.Zweck; --DZWECK CHAR  40    Purpose of Bank Transfers
      Oa_.S49 := Wa_.Ps0009_.Bttyp; --P09_BTTYP  NUMC  2 T5M3T PBS Transfer Type
      Oa_.S50 := Wa_.Ps0009_.Payty; --PAYTY  CHAR  1   Payroll type
      Oa_.S51 := Wa_.Ps0009_.Payid; --PAYID  CHAR  1   Payroll Identifier
      Oa_.S52 := Wa_.Ps0009_.Ocrsn; --PAY_OCRSN  CHAR  4   Reason for Off-Cycle Payroll
      Oa_.S53 := Wa_.Ps0009_.Bondt; --BONDT  DATS  8   Off-cycle payroll payment date
      Oa_.S54 := Wa_.Ps0009_.Bkref; --BKREF  CHAR  20    Reference specifications for bank details
      Oa_.S55 := Wa_.Ps0009_.Stras; --STRAS  CHAR  30    House number and street
      Oa_.S56 := Wa_.Ps0009_.Debit; --P00_XDEBIT_INFTY CHAR  1   Automatic Debit Authorization Indicator
      Oa_.S57 := Wa_.Ps0009_.Iban; --IBAN CHAR  34    IBAN (International Bank Account Number)
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0009_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0014) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0014;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0014');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0014_.Lgart; -- LGART  CHAR  4 T512Z Wage Type
      Oa_.S25 := Wa_.Ps0014_.Opken; --OPKEN  CHAR  1   Operation Indicator for Wage Types
      Oa_.S26 := Wa_.Ps0014_.Betrg; --PAD_AMT7S  CURR  13(2)   Wage Type Amount for Payments
      Oa_.S27 := Wa_.Ps0014_.Waers; --WAERS  CUKY  5 TCURC Currency Key
      Oa_.S28 := Wa_.Ps0014_.Anzhl; --ANZHL  DEC 7(2)    Number
      Oa_.S29 := Wa_.Ps0014_.Zeinh; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Oa_.S30 := Wa_.Ps0014_.Indbw; --INDBW  CHAR  1   Indicator for indirect valuation
      Oa_.S31 := Wa_.Ps0014_.Zdate; --DZDATE DATS  8   First payment date
      Oa_.S32 := Wa_.Ps0014_.Zfper; --DZFPER NUMC  2   First payment period
      Oa_.S33 := Wa_.Ps0014_.Zanzl; --DZANZL DEC 3   Number for determining further payment dates
      Oa_.S34 := Wa_.Ps0014_.Zeinz; --DZEINZ CHAR  3 T538C Time unit for determining next payment
      Oa_.S35 := Wa_.Ps0014_.Zuord; --UZORD  CHAR  20    Assignment Number
      Oa_.S36 := Wa_.Ps0014_.Uwdat; --UWDAT  DATS  8   Date of Bank Transfer
      Oa_.S37 := Wa_.Ps0014_.Model; --MODE1 CHAR  4 T549W Payment Model
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0014_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0015) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0015;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0015');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0015_.Lgart; -- LGART  CHAR  4 T512Z Wage Type
      Oa_.S25 := Wa_.Ps0015_.Opken; -- OPKEN  CHAR  1   Operation Indicator for Wage Types
      Oa_.S26 := Wa_.Ps0015_.Betrg; --PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S27 := Wa_.Ps0015_.Waers; --WAERS  CUKY  5 TCURC Currency Key
      Oa_.S28 := Wa_.Ps0015_.Anzhl; --ANZHL  DEC 7(2)    Number
      Oa_.S29 := Wa_.Ps0015_.Zeinh; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Oa_.S30 := Wa_.Ps0015_.Indbw; --INDBW  CHAR  1   Indicator for indirect valuation
      Oa_.S31 := Wa_.Ps0015_.Zuord; --UZORD CHAR  20    Assignment Number
      Oa_.S32 := Wa_.Ps0015_.Estdt; --ESTDT  DATS  8   Date of origin
      Oa_.S33 := Wa_.Ps0015_.Pabrj; --PABRJ  NUMC  4   Payroll Year  GJAHR
      Oa_.S34 := Wa_.Ps0015_.Pabrp; --PABRP  NUMC  2   Payroll Period
      Oa_.S35 := Wa_.Ps0015_.Uwdat; --UWDAT  DATS  8   Date of Bank Transfer
      Oa_.S36 := Wa_.Ps0015_.Itftt; --P06I_ITFTT  CHAR  2   Processing type
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0015_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0015, Chunk_No_ IN NUMBER) IS
    i_         NUMBER;
    Wa_        Zpk_Sap_Exp.P0015;
    Oa_        Ic_Xx_Import_Tab%ROWTYPE;
    St_        Zpk_Sap_Exp.Stab_;
    File_Name_ VARCHAR2(200);
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0015');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0015_.Lgart; -- LGART  CHAR  4 T512Z Wage Type
      Oa_.S25 := Wa_.Ps0015_.Opken; -- OPKEN  CHAR  1   Operation Indicator for Wage Types
      Oa_.S26 := Wa_.Ps0015_.Betrg; --PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S27 := Wa_.Ps0015_.Waers; --WAERS  CUKY  5 TCURC Currency Key
      Oa_.S28 := Wa_.Ps0015_.Anzhl; --ANZHL  DEC 7(2)    Number
      Oa_.S29 := Wa_.Ps0015_.Zeinh; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Oa_.S30 := Wa_.Ps0015_.Indbw; --INDBW  CHAR  1   Indicator for indirect valuation
      Oa_.S31 := Wa_.Ps0015_.Zuord; --UZORD CHAR  20    Assignment Number
      Oa_.S32 := Wa_.Ps0015_.Estdt; --ESTDT  DATS  8   Date of origin
      Oa_.S33 := Wa_.Ps0015_.Pabrj; --PABRJ  NUMC  4   Payroll Year  GJAHR
      Oa_.S34 := Wa_.Ps0015_.Pabrp; --PABRP  NUMC  2   Payroll Period
      Oa_.S35 := Wa_.Ps0015_.Uwdat; --UWDAT  DATS  8   Date of Bank Transfer
      Oa_.S36 := Wa_.Ps0015_.Itftt; --P06I_ITFTT  CHAR  2   Processing type
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    File_Name_ := 'P0015_' || To_Char(Chunk_No_, '000000') || '_' ||
                  To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv';
    File_Name_ := REPLACE(File_Name_, ' ');
    Zpk_Sap_Exp.Dump_Table_To_Csv(File_Name_, 30);
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0016) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0016;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0016');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0016_.Nbtgk; --NBTGK  CHAR  1   Sideline Job
      Oa_.S25 := Wa_.Ps0016_.Wttkl; --WTTKL  CHAR  1   Competition Clause
      Oa_.S26 := Wa_.Ps0016_.Lfzfr; --LFZFR  DEC 3   Period of Continued Pay (Number)
      Oa_.S27 := Wa_.Ps0016_.Lfzzh; --LFZZH  CHAR  3 T538A Period of Continued Pay (Unit)
      Oa_.S28 := Wa_.Ps0016_.Lfzso; --LFZSR  NUMC  2   Special Rule for Continued Pay
      Oa_.S29 := Wa_.Ps0016_.Kgzfr; --KGZFR  DEC 3   Sick Pay Supplement Period (Number)
      Oa_.S30 := Wa_.Ps0016_.Kgzzh; --KGZZH  CHAR  3 T538A Sick Pay Supplement Period (Unit)
      Oa_.S31 := Wa_.Ps0016_.Prbzt; --PRBZT  DEC 3   Probationary Period (Number)
      Oa_.S32 := Wa_.Ps0016_.Prbeh; --PRBEH  CHAR  3 T538A Probationary Period (Unit)
      Oa_.S33 := Wa_.Ps0016_.Kdgfr; --KDGFR  CHAR  2 T547T Dismissals Notice Period for Employer
      Oa_.S34 := Wa_.Ps0016_.Kdgf2; --KDGF2  CHAR  2 T547T Dismissals Notice Period for Employee
      Oa_.S35 := Wa_.Ps0016_.Arber; --ARBER  DATS  8   Expiration Date of Work Permit
      Oa_.S36 := Wa_.Ps0016_.Eindt; --EINTR  DATS  8   Initial Entry
      Oa_.S37 := Wa_.Ps0016_.Kondt; --KONDT  DATS  8   Date of Entry into Group
      Oa_.S38 := Wa_.Ps0016_.Konsl; --KOSL1  CHAR  2 T545T Group Key
      Oa_.S39 := Wa_.Ps0016_.Cttyp; --CTTYP  CHAR  2 T547V Contract Type
      Oa_.S40 := Wa_.Ps0016_.Ctedt; --CTEDT  DATS  8   Contract End Date
      Oa_.S41 := Wa_.Ps0016_.Persg; --PERSG  CHAR  1 T501  Employee Group
      Oa_.S42 := Wa_.Ps0016_.Persk; --PERSK  CHAR  2 T503K Employee Subgroup
      Oa_.S43 := Wa_.Ps0016_.Wrkpl; -- WRKPL CHAR  40    Work Location (Contract Elements Infotype)
      Oa_.S44 := Wa_.Ps0016_.Ctbeg; --CTBEG  DATS  8   Contract Start
      Oa_.S45 := Wa_.Ps0016_.Ctnum; --PCN_CTNUM  CHAR  20    Contract number
      Oa_.S46 := Wa_.Ps0016_.Objnb; --OBJNB CHAR  12    Object Number (France)
      Oa_.S47 := Wa_.Ps0016_.Zzdatzaw;
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0016_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0019) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0019;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0019');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0019_.Tmart; -- varchar2(2), --TMART  CHAR  2 T531  Task Type
      Oa_.S25 := Wa_.Ps0019_.Termn; -- varchar2(8), --TERMN  DATS  8   Date of Task
      Oa_.S26 := Wa_.Ps0019_.Mndat; -- varchar2(8), --MNDAT  DATS  8   Reminder Date
      Oa_.S27 := Wa_.Ps0019_.Bvmrk; -- varchar2(1), --BVMRK  CHAR  1   Processing indicator
      Oa_.S28 := Wa_.Ps0019_.Tmjhr; -- varchar2(4), --TMJHR  NUMC  4   Year of date  GJAHR
      Oa_.S29 := Wa_.Ps0019_.Tmmon; -- varchar2(2), --TMMON  NUMC  2   Month of date
      Oa_.S30 := Wa_.Ps0019_.Tmtag; -- varchar2(2), --TMTAG  NUMC  2   Day of date
      Oa_.S31 := Wa_.Ps0019_.Mnjhr; -- varchar2(4), --MNJHR  NUMC  4   Year of reminder  GJAHR
      Oa_.S32 := Wa_.Ps0019_.Mnmon; -- varchar2(2), --MNMON  NUMC  2   Month of reminder
      Oa_.S33 := Wa_.Ps0019_.Mntag; -- varchar2(2) --MNTAG NUMC  2   Day of reminder
      Oa_.S34 := Wa_.Ps0019_.Ctext; -- cluster texts
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0019_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0021) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0021;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0021');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0021_.Famsa; -- varchar2(4), --FAMSA  CHAR  4   Type of Family Record
      Oa_.S25 := Wa_.Ps0021_.Fgbdt; --GBDAT  DATS  8   Date of Birth PDATE
      Oa_.S26 := Wa_.Ps0021_.Fgbld; --GBLND  CHAR  3 T005  Country of Birth
      Oa_.S27 := Wa_.Ps0021_.Fanat; --NATSL  CHAR  3 T005  Nationality
      Oa_.S28 := Wa_.Ps0021_.Fasex; --GESCH  CHAR  1   Gender Key
      Oa_.S29 := Wa_.Ps0021_.Favor; --PAD_VORNA  CHAR  40 First Name
      Oa_.S30 := Wa_.Ps0021_.Fanam; --PAD_NACHN  CHAR  40    Last Name
      Oa_.S31 := Wa_.Ps0021_.Fgbot; --PAD_GBORT  CHAR  40    Birthplace
      Oa_.S32 := Wa_.Ps0021_.Fgdep; --GBDEP  CHAR  3 T005S State
      Oa_.S33 := Wa_.Ps0021_.Erbnr; --ERBNR  CHAR  12    Reference Personnel Number for Family Member
      Oa_.S34 := Wa_.Ps0021_.Fgbna; --PAD_NAME2  CHAR  40    Name at Birth
      Oa_.S35 := Wa_.Ps0021_.Fnac2; --PAD_NACH2  CHAR  40    Second Name
      Oa_.S36 := Wa_.Ps0021_.Fcnam; --PAD_CNAME  CHAR  80    Complete Name
      Oa_.S37 := Wa_.Ps0021_.Fknzn; --KNZNM  NUMC  2   Name Format Indicator for Employee in a List
      Oa_.S38 := Wa_.Ps0021_.Finit; --INITS  CHAR  10    Initials
      Oa_.S39 := Wa_.Ps0021_.Fvrsw; --VORSW  CHAR  15  T535N Name Prefix
      Oa_.S40 := Wa_.Ps0021_.Fvrs2; --VORSW  CHAR  15  T535N Name Prefix
      Oa_.S41 := Wa_.Ps0021_.Fnmzu; --NAMZU  CHAR  15  T535N Other Title
      Oa_.S42 := Wa_.Ps0021_.Ahvnr; --AHVNR  CHAR  11    AHV Number  AHVNR
      Oa_.S43 := Wa_.Ps0021_.Kdsvh; --KDSVH  CHAR  2 T577  Relationship to Child
      Oa_.S44 := Wa_.Ps0021_.Kdbsl; --KDBSL  CHAR  2 T577  Allowance Authorization
      Oa_.S45 := Wa_.Ps0021_.Kdutb; --KDUTB  CHAR  2 T577  Address of Child
      Oa_.S46 := Wa_.Ps0021_.Kdgbr; --KDGBR  CHAR  2 T577  Child Allowance Entitlement
      Oa_.S47 := Wa_.Ps0021_.Kdart; --KDART  CHAR  2 T577  Child Type
      Oa_.S48 := Wa_.Ps0021_.Kdzug; --KDZUG  CHAR  2 T577  Child Bonuses
      Oa_.S49 := Wa_.Ps0021_.Kdzul; --KDZUL  CHAR  2 T577  Child Allowances
      Oa_.S50 := Wa_.Ps0021_.Kdvbe; --KDVBE  CHAR  2 T577  Sickness Certificate Authorization
      Oa_.S51 := Wa_.Ps0021_.Ermnr; --ERMNR  CHAR  8   Authority Number
      Oa_.S52 := Wa_.Ps0021_.Ausvl; --AUSVL  NUMC  4   1st Part of SI Number (Sequential Number)
      Oa_.S53 := Wa_.Ps0021_.Ausvg; --AUSVG  NUMC  8   2nd Part of SI Number (Birth Date)
      Oa_.S54 := Wa_.Ps0021_.Fasdt; --FASDT  DATS  8   End of Family Members Education/Training
      Oa_.S55 := Wa_.Ps0021_.Fasar; --FASAR  CHAR  2 T517T School Type of Family Member
      Oa_.S56 := Wa_.Ps0021_.Fasin; --FASIN  CHAR  20    Educational Institute
      Oa_.S57 := Wa_.Ps0021_.Egaga; --EGAGA  CHAR  8   Employer of Family Member
      Oa_.S58 := Wa_.Ps0021_.Fana2; --NATS2  CHAR  3 T005  Second Nationality
      Oa_.S59 := Wa_.Ps0021_.Fana3; --NATS3  CHAR  3 T005  Third Nationality
      Oa_.S60 := Wa_.Ps0021_.Betrg; --BETRG  CURR  9(2)    Amount
      Oa_.S61 := Wa_.Ps0021_.Titel; --TITEL  CHAR  15  T535N Title
      Oa_.S62 := Wa_.Ps0021_.Emrgn; --PAD_EMRGN  CHAR  1   Emergency Contact
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0021_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0022) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0022;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0022');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0022_.Slart; --SLART  CHAR  2 T517T Educational establishment
      Oa_.S25 := Wa_.Ps0022_.Insti; --INSTI  CHAR  80    Institute/location of training
      Oa_.S26 := Wa_.Ps0022_.Sland; --LAND1  CHAR  3 T005  Country Key
      Oa_.S27 := Wa_.Ps0022_.Ausbi; --AUSBI  NUMC  8 T518A Education/training
      Oa_.S28 := Wa_.Ps0022_.Slabs; --SLABS  CHAR  2 T519T Certificate
      Oa_.S29 := Wa_.Ps0022_.Anzkl; --ANZKL  DEC 3   Duration of training course
      Oa_.S30 := Wa_.Ps0022_.Anzeh; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Oa_.S31 := Wa_.Ps0022_.Sltp1; --FACH1  NUMC  5 T517Y Branch of study
      Oa_.S32 := Wa_.Ps0022_.Sltp2; --FACH2  NUMC  5 T517Y Branch of study
      Oa_.S33 := Wa_.Ps0022_.Jbez1; --KSGEB  CURR  11(2)   Course fees
      Oa_.S34 := Wa_.Ps0022_.Waers; --WAERS  CUKY  5 TCURC Currency Key
      Oa_.S35 := Wa_.Ps0022_.Slpln; --KSPLN  CHAR  1   Planned course (unused)
      Oa_.S36 := Wa_.Ps0022_.Slktr; --SLKTR  CHAR  2   Cost object (unused)
      Oa_.S37 := Wa_.Ps0022_.Slrzg; --SLRZG  CHAR  1   Repayment obligation
      Oa_.S38 := Wa_.Ps0022_.Ksbez; --KSBEZ  CHAR  25    Course name
      Oa_.S39 := Wa_.Ps0022_.Tx122; --KSBUR  CHAR  40    Course appraisal
      Oa_.S40 := Wa_.Ps0022_.Schcd; --P22J_SCHCD NUMC  10    Institute/school code
      Oa_.S41 := Wa_.Ps0022_.Faccd; --P22J_FACCD NUMC  3   Faculty code
      Oa_.S42 := Wa_.Ps0022_.Dptmt; -- DPTMT CHAR  40    Department
      Oa_.S43 := Wa_.Ps0022_.Emark; --EMARK CHAR  4   Final Grade
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0022_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0023) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0023;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0023');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0023_.Arbgb; --VORAG  CHAR  60    Name of employer
      Oa_.S25 := Wa_.Ps0023_.Ort01; --ORT01  CHAR  25    City
      Oa_.S26 := Wa_.Ps0023_.Land1; --LAND1  CHAR  3 T005  Country Key
      Oa_.S27 := Wa_.Ps0023_.Branc; --BRSCH  CHAR  4 T016  Industry key
      Oa_.S28 := Wa_.Ps0023_.Taete; --TAETE  NUMC  8 T513C Job at former employer(s)
      Oa_.S29 := Wa_.Ps0023_.Ansvx; --ANSVX  CHAR  2 T542C Work Contract - Other Employers
      Oa_.S30 := Wa_.Ps0023_.Ortj1; --P22J_ADDR1 CHAR  40    First address line (Kanji)
      Oa_.S31 := Wa_.Ps0023_.Ortj2; --P22J_ADDR2 CHAR  40    Second address line (Kanji)
      Oa_.S32 := Wa_.Ps0023_.Ortj3; --P22J_ADDR3  CHAR  40    Third address line (Kanji)
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0023_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0024) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0024;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0024');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0024_.Quali; --QUALI_D  NUMC  8 T574A Qualification key
      Oa_.S25 := Wa_.Ps0024_.Auspr; --CHARA NUMC  4 T778Q Proficiency of a Qualification/Requirement
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0024_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0041) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0041;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0041');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0041_.Dar01; -- varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S25 := Wa_.Ps0041_.Dat01; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S26 := Wa_.Ps0041_.Dar02; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S27 := Wa_.Ps0041_.Dat02; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S28 := Wa_.Ps0041_.Dar03; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S29 := Wa_.Ps0041_.Dat03; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S30 := Wa_.Ps0041_.Dar04; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S31 := Wa_.Ps0041_.Dat04; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S32 := Wa_.Ps0041_.Dar05; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S33 := Wa_.Ps0041_.Dat05; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S34 := Wa_.Ps0041_.Dar06; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S35 := Wa_.Ps0041_.Dat06; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S36 := Wa_.Ps0041_.Dar07; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S37 := Wa_.Ps0041_.Dat07; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S38 := Wa_.Ps0041_.Dar08; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S39 := Wa_.Ps0041_.Dat08; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S40 := Wa_.Ps0041_.Dar09; --  varchar2(2), -- DATAR CHAR  2 T548Y Date type
      Oa_.S41 := Wa_.Ps0041_.Dat09; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S42 := Wa_.Ps0041_.Dar10; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S43 := Wa_.Ps0041_.Dat10; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S44 := Wa_.Ps0041_.Dar11; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S45 := Wa_.Ps0041_.Dat11; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Oa_.S46 := Wa_.Ps0041_.Dar12; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Oa_.S47 := Wa_.Ps0041_.Dat12; --  varchar2(8) --DARDT  DATS  8   Date for date type
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0041_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0105) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0105;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0105');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0105_.Usrty;
      Oa_.S25 := Wa_.Ps0105_.Usrid;
      Oa_.S26 := Wa_.Ps0105_.Usrid_Long;
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0105_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0185) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0185;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0185');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0185_.Ictyp; --ICTYP CHAR  2 T5R05 Type of identification (IC type)
      Oa_.S25 := Wa_.Ps0185_.Icnum; -- varchar2(30), -- PSG_IDNUM CHAR  30    Identity Number
      Oa_.S26 := Wa_.Ps0185_.Icold; -- varchar2(20), -- ICOLD CHAR  20    Old IC number
      Oa_.S27 := Wa_.Ps0185_.Auth1; -- varchar2(30), -- P25_AUTH1 CHAR  30    Issuing authority
      Oa_.S28 := Wa_.Ps0185_.Docn1; -- varchar2(20), -- ISNUM CHAR  20    Document issuing number
      Oa_.S29 := Wa_.Ps0185_.Fpdat; -- varchar2(8), -- PSG_FPDAT DATS  8   Date of issue for personal ID
      Oa_.S30 := Wa_.Ps0185_.Expid; -- varchar2(8), -- EXPID DATS  8   ID expiry date
      Oa_.S31 := Wa_.Ps0185_.Isspl; -- varchar2(30), -- P25_ISSPL CHAR  30    Place of issue of Identification
      Oa_.S32 := Wa_.Ps0185_.Iscot; -- varchar2(3), -- P25_ISCOT CHAR  3 T005  Country of issue
      Oa_.S33 := Wa_.Ps0185_.Idcot; -- varchar2(3), -- P25_IDCOT CHAR  3 T005  Country of ID
      Oa_.S34 := Wa_.Ps0185_.Ovchk; -- varchar2(1), -- P25_OVCHK CHAR  1   Indicator for overriding consistency check
      Oa_.S35 := Wa_.Ps0185_.Astat; -- varchar2(1), -- PCN_ASTAT CHAR  1   Application status
      Oa_.S36 := Wa_.Ps0185_.Akind; -- varchar2(1), -- P25_AKIND CHAR  1   Single/multiple
      Oa_.S37 := Wa_.Ps0185_.Rejec; -- varchar2(20), -- P25_REJEC CHAR  20    Reject reason
      Oa_.S38 := Wa_.Ps0185_.Usefr; -- varchar2(8), -- P25_USEFR DATS  8   Used from -date
      Oa_.S39 := Wa_.Ps0185_.Useto; -- varchar2(8), -- P25_USETO DATS  8   Used to -date
      Oa_.S40 := Wa_.Ps0185_.Daten; -- varchar2(3), -- P25_DATEN DEC 3   Valid length of multiple visa
      Oa_.S41 := Wa_.Ps0185_.Dateu; -- varchar2(3), -- DZEINZ  CHAR  3 T538A Time unit for determining next payment
      Oa_.S42 := Wa_.Ps0185_.Times; -- varchar2(8) --  P25_TIMES DATS  8   Application date
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0185_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0267) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0267;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0267');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0267_.Lgart; -- VARCHAR2(4), -- LGART CHAR  4 T512Z Wage Type
      Oa_.S25 := Wa_.Ps0267_.Opken; -- VARCHAR2(1), -- OPKEN CHAR  1   Operation Indicator for Wage Types
      Oa_.S26 := Wa_.Ps0267_.Betrg; -- VARCHAR2(13), --  PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S27 := Wa_.Ps0267_.Waers; -- VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
      Oa_.S28 := Wa_.Ps0267_.Anzhl; -- VARCHAR2(7), -- ANZHL DEC 7(2)    Number
      Oa_.S29 := Wa_.Ps0267_.Zeinh; -- VARCHAR2(3), --PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Oa_.S30 := Wa_.Ps0267_.Indbw; -- VARCHAR2(1), -- INDBW CHAR  1   Indicator for indirect valuation
      Oa_.S31 := Wa_.Ps0267_.Zuord; -- VARCHAR2(20), --  UZORD CHAR  20    Assignment Number
      Oa_.S32 := Wa_.Ps0267_.Estdt; -- VARCHAR2(8), -- ESTDT DATS  8   Date of origin
      Oa_.S33 := Wa_.Ps0267_.Pabrj; -- VARCHAR2(4), -- PABRJ NUMC  4   Payroll Year  GJAHR
      Oa_.S34 := Wa_.Ps0267_.Pabrp; -- VARCHAR2(2), -- PABRP NUMC  2   Payroll Period
      Oa_.S35 := Wa_.Ps0267_.Uwdat; -- VARCHAR2(8), -- UWDAT DATS  8   Date of Bank Transfer
      Oa_.S36 := Wa_.Ps0267_.Payty; -- VARCHAR2(1), -- PAYTY CHAR  1   Payroll type
      Oa_.S37 := Wa_.Ps0267_.Payid; -- VARCHAR2(1), -- PAYID CHAR  1   Payroll Identifier
      Oa_.S38 := Wa_.Ps0267_.Ocrsn; -- VARCHAR2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
      Oa_.S39 := Wa_.Ps0267_.Zzdatz; -- VARCHAR2(8),
      Oa_.S40 := Wa_.Ps0267_.Zztekst1; -- VARCHAR2(100),
      Oa_.S41 := Wa_.Ps0267_.Zztekst2; -- VARCHAR2(100),
      Oa_.S42 := Wa_.Ps0267_.Zztekst3; -- VARCHAR2(100),
      Oa_.S43 := Wa_.Ps0267_.Zztekst4; --  VARCHAR2(100));
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0267_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0413) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0413;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0413');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0413_.Toidn; -- varchar2(4), -- PPL_TOIDN CHAR  4 T7PL01  Tax office ID number
      Oa_.S25 := Wa_.Ps0413_.Costr; --varchar2(2), -- PPL_COSTR CHAR  2 T7PL20  Cost counting rule
      Oa_.S26 := Wa_.Ps0413_.Contr; -- varchar2(2), -- PPL_CONTR CHAR  2 T7PL30  Free amount rule
      Oa_.S27 := Wa_.Ps0413_.Dnind; -- varchar2(1) --  PPL_DNIND CHAR  1   Threshold down indicator
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0413_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0414) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0414;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0414');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0414_.Scd01; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S25 := Wa_.Ps0414_.Sid01; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S26 := Wa_.Ps0414_.Syy01; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S27 := Wa_.Ps0414_.Smm01; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S28 := Wa_.Ps0414_.Sdd01; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S29 := Wa_.Ps0414_.Scd02; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S30 := Wa_.Ps0414_.Sid02; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S31 := Wa_.Ps0414_.Syy02; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S32 := Wa_.Ps0414_.Smm02; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S33 := Wa_.Ps0414_.Sdd02; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S34 := Wa_.Ps0414_.Scd03; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S35 := Wa_.Ps0414_.Sid03; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S36 := Wa_.Ps0414_.Syy03; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S37 := Wa_.Ps0414_.Smm03; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S38 := Wa_.Ps0414_.Sdd03; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S39 := Wa_.Ps0414_.Scd04; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S40 := Wa_.Ps0414_.Sid04; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S41 := Wa_.Ps0414_.Syy04; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S42 := Wa_.Ps0414_.Smm04; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S43 := Wa_.Ps0414_.Sdd04; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S44 := Wa_.Ps0414_.Scd05; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S45 := Wa_.Ps0414_.Sid05; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S46 := Wa_.Ps0414_.Syy05; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S47 := Wa_.Ps0414_.Smm05; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S48 := Wa_.Ps0414_.Sdd05; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S49 := Wa_.Ps0414_.Scd06; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S50 := Wa_.Ps0414_.Sid06; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S51 := Wa_.Ps0414_.Syy06; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S52 := Wa_.Ps0414_.Smm06; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S53 := Wa_.Ps0414_.Sdd06; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S54 := Wa_.Ps0414_.Scd07; -- varchar2(2), -- PPL_SENCD CHAR  2   Seniority code
      Oa_.S55 := Wa_.Ps0414_.Sid07; --  varchar2(1), -- PPL_SENID CHAR  1   Seniority identifier
      Oa_.S56 := Wa_.Ps0414_.Syy07; --  varchar2(2), -- PPL_SENYY NUMC  2   Seniority period - years
      Oa_.S57 := Wa_.Ps0414_.Smm07; --  varchar2(2), -- PPL_SENMM NUMC  2   Seniority period - months
      Oa_.S58 := Wa_.Ps0414_.Sdd07; --  varchar2(3), -- PPL_SENDD NUMC  3   Seniority period - days
      --
      Oa_.S59 := Wa_.Ps0414_.Pertx; --  varchar2(50), -- PPL_PERTX CHAR  50    Period description
      Oa_.S60 := Wa_.Ps0414_.Ldper; --  varchar2(7), -- PPL_LDPER DEC 7(5)    Leave days at previous employer
      Oa_.S61 := Wa_.Ps0414_.Evrp6; -- varchar2(1), -- PPL_EVRP6 CHAR  1 T7PLA0  Evidence for RP-6 form code
      Oa_.S62 := Wa_.Ps0414_.Flflg; --  varchar2(1), -- PPL_FLFLG CHAR  1   First leave after 12 months flag
      Oa_.S63 := Wa_.Ps0414_.Rldpr; --  varchar2(6), -- PPL_RLDPR DEC 6(5)    Requested leave days at previous employer
      Oa_.S64 := Wa_.Ps0414_.Feflg; --  varchar2(1), -- PPL_FEFLG CHAR  1   First employment flag
      Oa_.S65 := Wa_.Ps0414_.Chall; --  varchar2(7), -- PPL_CHALL DEC 7(5)    Child Care Leave Deduction
      Oa_.S66 := Wa_.Ps0414_.Famal; --  varchar2(7), -- PPL_FAMAL DEC 7(5)    Family member care leave
      Oa_.S67 := Wa_.Ps0414_.Chl14; --  varchar2(7), -- PPL_CHL14 DEC 7(5)    Utilized Child Allowance < 14 years old
      Oa_.S68 := Wa_.Ps0414_.Pturn; --  varchar2(1), -- PPL_PTURN CHAR  1   Deduction rehabilitation leave for previous employer
      Oa_.S69 := Wa_.Ps0414_.Leape; --  varchar2(7), -- PPL_LEAPE DEC 7(5)    Leave taken over from previous employer
      Oa_.S70 := Wa_.Ps0414_.Genle; --  varchar2(1) -- PPL_GENLE  CHAR  1   Forcing leave generation
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0414_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0515) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0515;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0515');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0515_.Podst; --     varchar2(4), --PPL_PODST CHAR  4 T7PL40  Code of basic subject with extension
      Oa_.S25 := Wa_.Ps0515_.Erlrt; --     varchar2(1), -- PPL_ERLRT CHAR  1   Pension right type
      Oa_.S26 := Wa_.Ps0515_.Stpns; --      varchar2(1), -- PPL_STPNS CHAR  1   Disability level
      Oa_.S27 := Wa_.Ps0515_.Ruser; --     varchar2(1), -- PPL_RUSER CHAR  1   Pension and disability insurance
      Oa_.S28 := Wa_.Ps0515_.Rusch; --   varchar2(1), -- PPL_RUSCH CHAR  1   Incapability insurance
      Oa_.S29 := Wa_.Ps0515_.Ruswp; --      varchar2(1), -- PPL_RUSWP CHAR  1   Accident insurance
      Oa_.S30 := Wa_.Ps0515_.Ruszr; --      varchar2(1), -- PPL_RUSZR CHAR  1   Health insurance
      Oa_.S31 := Wa_.Ps0515_.Dzukc; --      varchar2(8), -- PPL_DZUKC DATS  8   Date of contract with health fund
      Oa_.S32 := Wa_.Ps0515_.Nsbeg; --      varchar2(8), -- PPL_NSBEG DATS  8   Begin date of disability level
      Oa_.S33 := Wa_.Ps0515_.Ksach; --      varchar2(3), --PPL_KSACH CHAR  3   NFZ departament code
      Oa_.S34 := Wa_.Ps0515_.Nsend; --      varchar2(8), --PPL_NSEND DATS  8   End date of disability level
      Oa_.S35 := Wa_.Ps0515_.Illcs; --      varchar2(3), --PPL_ILLCS NUMC  3   Days of continuous sickness period
      Oa_.S36 := Wa_.Ps0515_.Allpe; --      varchar2(3), --PPL_ALLPE NUMC  3   Allowance period days
      Oa_.S37 := Wa_.Ps0515_.Sibln; --      varchar2(1), --PPL_SIBLN CHAR  1   Std./extd. allowance base period lenght
      Oa_.S38 := Wa_.Ps0515_.Soeln; --      varchar2(1), -- PPL_SOELN CHAR  1   Std./extd. allowance base period lenght
      Oa_.S39 := Wa_.Ps0515_.Waitp; --      varchar2(8), -- PPL_WAITP DATS  8   End date of waiting period
      Oa_.S40 := Wa_.Ps0515_.Limtp; --      varchar2(8), -- PPL_LIMTP DATS  8   End date of limited base period
      Oa_.S41 := Wa_.Ps0515_.Illpr; --      varchar2(2), -- PPL_ILLPR DEC 2   Sick days at previous employer
      Oa_.S42 := Wa_.Ps0515_.Addit; --      varchar2(4), -- PPL_ADDIT CHAR  4 T7PL40  Code of additional subject
      Oa_.S43 := Wa_.Ps0515_.Addbr; --      varchar2(1), -- PPL_ADDBR CHAR  1   Additional insurance title break code
      Oa_.S44 := Wa_.Ps0515_.Dis_Leave; --  varchar2(8), -- PPL_DIS_LEAVE_FROM  DATS  8   Additional leave for disabled first date
      Oa_.S45 := Wa_.Ps0515_.Model_Id; --   varchar2(2), --  PPL_MODEL CHAR  2 T7PLZLA_MOD Model ID for PLZLA
      Oa_.S46 := Wa_.Ps0515_.Nozdr; --      varchar2(1) --  PPL_NOZDR CHAR  1   Parental leave without health insurance
      Oa_.S47 := Wa_.Ps0515_.Trmcd; -- PPL_TRMCD CHAR  3 0 Tryb rozw. stosunku pracy
      Oa_.S48 := Wa_.Ps0515_.Ltmcd; -- PPL_LTMCD CHAR  3 0 Podstawa prawna - kod
      Oa_.S49 := Wa_.Ps0515_.Ltmtx; -- PPL_LTMTX  CHAR  72  0 Podstawa prawna - inna
      Oa_.S50 := Wa_.Ps0515_.Trmin; -- PPL_TRMIN  CHAR  1 0 Strona inicjatywna
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0515_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0517) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0517;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0517');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0517_.Stras; --   varchar2(3), --PAD_STRAS CHAR  60    Street and House Number
      Oa_.S25 := Wa_.Ps0517_.Hsnmr; --   varchar2(3), --PAD_HSNMR CHAR  10    House Number
      Oa_.S26 := Wa_.Ps0517_.Posta; --   varchar2(3), --PAD_POSTA CHAR  10    Identification of an apartment in a building
      Oa_.S27 := Wa_.Ps0517_.Pstlz; --   varchar2(3), --PSTLZ_HR  CHAR  10    Postal Code
      Oa_.S28 := Wa_.Ps0517_.Ort01; --   varchar2(3), --PAD_ORT01 CHAR  40    City
      Oa_.S29 := Wa_.Ps0517_.Ort02; --   varchar2(3), --PAD_ORT02 CHAR  40    District
      Oa_.S30 := Wa_.Ps0517_.State; --   varchar2(3), --REGIO CHAR  3 Region (State, Province, County)
      Oa_.S31 := Wa_.Ps0517_.Counc; --   varchar2(3), --COUNC CHAR  3 T005E County Code
      Oa_.S32 := Wa_.Ps0517_.Land1; --   varchar2(3), --LAND1 CHAR  3 T005  Country Key
      Oa_.S33 := Wa_.Ps0517_.Telnr; --   varchar2(3), --TELNR CHAR  14    Telephone Number
      Oa_.S34 := Wa_.Ps0517_.Pesel; --   varchar2(3), --PPL_PESEL CHAR  11    PESEL number
      Oa_.S35 := Wa_.Ps0517_.Nip00; --   varchar2(3), --PPL_NIP00 CHAR  10    NIP number
      Oa_.S36 := Wa_.Ps0517_.Ruszr; --   varchar2(3), --PPL_UZCZR CHAR  1   Health insurance of family member
      Oa_.S37 := Wa_.Ps0517_.Cnadr; --   varchar2(3), --PPL_CNADR CHAR  1   Relevancy of family member address
      Oa_.S38 := Wa_.Ps0517_.Exsup; --   varchar2(3), --PPL_EXSUP CHAR  1   Exclusive support of family member
      Oa_.S39 := Wa_.Ps0517_.Cnhld; --   varchar2(3), --PPL_CNHLD CHAR  1   Common household with family member
      Oa_.S40 := Wa_.Ps0517_.Ictyp; --   varchar2(3), --ICTYP CHAR  2   Type of identification (IC type)
      Oa_.S41 := Wa_.Ps0517_.Icnum; --   varchar2(3), --PPL_ICNUM CHAR  20    IC number
      Oa_.S42 := Wa_.Ps0517_.Stpns; --   varchar2(3), --PPL_STPNS CHAR  1   Disability level
      Oa_.S43 := Wa_.Ps0517_.Tery2; --   varchar2(3) --PPL_TERY2 CHAR  3 T7PLE2  Municipality GUS code according to TERYT
      Oa_.S44 := Wa_.Ps0517_.Zcnac; -- family type
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0517_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0558) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0558;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0558');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0558_.Fathn; -- varchar2(40), -- PPL_FATHN CHAR  40    Fathers first name
      Oa_.S25 := Wa_.Ps0558_.Mothn; --  varchar2(40), -- PPL_MOTHN CHAR  40    Mothers first name
      Oa_.S26 := Wa_.Ps0558_.Mbnam; --  varchar2(40), -- PPL_MBRTN CHAR  40    Mothers birth name
      Oa_.S27 := Wa_.Ps0558_.Pesel; --  varchar2(11), --PPL_PESEL CHAR  11    PESEL number
      Oa_.S28 := Wa_.Ps0558_.Nip00; --  varchar2(10), --PPL_NIP00 CHAR  10    NIP number
      Oa_.S29 := Wa_.Ps0558_.Onpit; --  varchar2(1) --  PPL_ONPIT CHAR  1   Output NIP instead of PESEL on PIT forms
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0558_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It0866) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P0866;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('0866');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      Oa_.S24 := Wa_.Ps0866_.Beg_Sch; -- PPL_BEG_SCH  DATS  8   School start
      Oa_.S25 := Wa_.Ps0866_.End_Sch; -- PPL_END_SCH DATS  8   School end date
      Oa_.S90 := Wa_.Ps0866_.Ifs_Subty; --necessary to map education year
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P0866_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2001) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P2001;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('2001');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      --.INCLUDE  PS2001        Personnel Time Record: Infotype 2001 (Absences)
      Oa_.S24 := Wa_.Ps2001_.Beguz; --  varchar2(6), --   BEGTI TIMS  6   Start Time
      Oa_.S25 := Wa_.Ps2001_.Enduz; --  varchar2(6), -- ENDTI TIMS  6   End Time
      Oa_.S26 := Wa_.Ps2001_.Vtken; --  varchar2(1), -- VTKEN CHAR  1   Previous Day Indicator
      Oa_.S27 := Wa_.Ps2001_.Awart; --  varchar2(4), -- AWART CHAR  4 T554S Attendance or Absence Type
      Oa_.S28 := Wa_.Ps2001_.Abwtg; --  varchar2(6), -- ABWTG DEC 6(2)    Attendance and Absence Days
      Oa_.S29 := Wa_.Ps2001_.Stdaz; --  varchar2(7), -- ABSTD DEC 7(2)    Absence hours
      Oa_.S30 := Wa_.Ps2001_.Abrtg; --  varchar2(3), -- ABRTG DEC 6(2)    Payroll days
      Oa_.S31 := Wa_.Ps2001_.Abrst; --  varchar2(7), -- ABRST DEC 7(2)    Payroll hours
      Oa_.S32 := Wa_.Ps2001_.Anrtg; --  varchar2(6), -- ANRTG DEC 6(2)    Days credited for continued pay
      Oa_.S33 := Wa_.Ps2001_.Lfzed; --  varchar2(8), -- LFZED DATS  8   End of continued pay
      Oa_.S34 := Wa_.Ps2001_.Krged; --  varchar2(8), -- KRGED DATS  8   End of sick pay
      Oa_.S35 := Wa_.Ps2001_.Kbbeg; --  varchar2(8), -- KBBEG DATS  8   Certified start of sickness
      Oa_.S36 := Wa_.Ps2001_.Rmdda; --  varchar2(8), -- RMDDA DATS  8   Date on which illness was confirmed
      Oa_.S37 := Wa_.Ps2001_.Kenn1; --  varchar2(2), -- KENN1 DEC 2   Indicator for Subsequent Illness
      Oa_.S38 := Wa_.Ps2001_.Kenn2; --  varchar2(2), -- KENN2 DEC 2   Indicator for repeated illness
      Oa_.S39 := Wa_.Ps2001_.Kaltg; --  varchar2(6), -- KALTG DEC 6(2)    Calendar days
      Oa_.S40 := Wa_.Ps2001_.Urman; --  varchar2(1), -- URMAN CHAR  1   Indicator for manual leave deduction
      Oa_.S41 := Wa_.Ps2001_.Begva; --  varchar2(4), -- BEGVA NUMC  4   Start year for leave deduction  GJAHR
      Oa_.S42 := Wa_.Ps2001_.Bwgrl; --  varchar2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
      Oa_.S43 := Wa_.Ps2001_.Aufkz; --  varchar2(1), -- AUFKN CHAR  1   Extra Pay Indicator
      Oa_.S44 := Wa_.Ps2001_.Trfgr; --  varchar2(8), -- TRFGR CHAR  8   Pay Scale Group
      Oa_.S45 := Wa_.Ps2001_.Trfst; --  varchar2(2), -- TRFST CHAR  2   Pay Scale Level
      Oa_.S46 := Wa_.Ps2001_.Prakn; --  varchar2(2), -- PRAKN CHAR  2 T510P Premium Number
      Oa_.S47 := Wa_.Ps2001_.Prakz; --  varchar2(4), -- PRAKZ NUMC  4   Premium Indicator
      Oa_.S48 := Wa_.Ps2001_.Otype; --  varchar2(2), -- OTYPE CHAR  2 T778O Object Type
      Oa_.S49 := Wa_.Ps2001_.Plans; --  varchar2(8), -- PLANS NUMC  8 T528B Position
      Oa_.S50 := Wa_.Ps2001_.Mldda; --  varchar2(8), -- MLDDA DATS  8   Reported on
      Oa_.S51 := Wa_.Ps2001_.Mlduz; --  varchar2(6), -- MLDUZ TIMS  6   Reported at
      Oa_.S52 := Wa_.Ps2001_.Rmduz; --  varchar2(6), -- RMDUZ TIMS  6   Sickness confirmed at
      Oa_.S53 := Wa_.Ps2001_.Vorgs; --  varchar2(15), -- VORGS CHAR  15    Superior Out Sick (Illness)
      Oa_.S54 := Wa_.Ps2001_.Umskd; --  varchar2(6), -- UMSKD CHAR  6   Code for description of illness
      Oa_.S55 := Wa_.Ps2001_.Umsch; --  varchar2(20), -- UMSCH CHAR  20    Description of illness
      Oa_.S56 := Wa_.Ps2001_.Refnr; --  varchar2(8), -- RFNUM CHAR  8   Reference number
      Oa_.S57 := Wa_.Ps2001_.Unfal; --  varchar2(1), -- UNFAL CHAR  1   Absent due to accident?
      Oa_.S58 := Wa_.Ps2001_.Stkrv; --  varchar2(4), -- STKRV CHAR  4   Subtype for sickness tracking
      Oa_.S59 := Wa_.Ps2001_.Stund; --  varchar2(4), -- STUND CHAR  4   Subtype for accident data
      Oa_.S60 := Wa_.Ps2001_.Psarb; --  varchar2(4), -- PSARB DEC 4(2)    Work capacity percentage
      Oa_.S61 := Wa_.Ps2001_.Ainft; --  varchar2(4), -- AINFT CHAR  4 T582A Infotype that maintains 2001
      Oa_.S62 := Wa_.Ps2001_.Gener; --  varchar2(1), -- PGENER  CHAR  1   Generation flag
      Oa_.S63 := Wa_.Ps2001_.Hrsif; --  varchar2(1), -- HRS_INPFL CHAR  1   Set number of hours
      Oa_.S64 := Wa_.Ps2001_.Alldf; --  varchar2(1), -- ALLDF CHAR  1   Record is for Full Day
      Oa_.S65 := Wa_.Ps2001_.Waers; --  varchar2(5), -- WAERS CUKY  5 TCURC Currency Key
      Oa_.S66 := Wa_.Ps2001_.Logsys; -- varchar2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
      Oa_.S67 := Wa_.Ps2001_.Awtyp; --  varchar2(5), -- AWTYP CHAR  5   Reference Transaction
      Oa_.S68 := Wa_.Ps2001_.Awref; --  varchar2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
      Oa_.S69 := Wa_.Ps2001_.Aworg; --  varchar2(10), -- AWORG CHAR  10    Reference Organizational Units
      Oa_.S70 := Wa_.Ps2001_.Docsy; --  varchar2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
      Oa_.S71 := Wa_.Ps2001_.Docnr; --  varchar2(20), -- PTM_DOCNR NUMC  20    Document number for time data
      Oa_.S72 := Wa_.Ps2001_.Payty; --  varchar2(1), -- PAYTY CHAR  1   Payroll type
      Oa_.S73 := Wa_.Ps2001_.Payid; --  varchar2(1), -- PAYID CHAR  1   Payroll Identifier
      Oa_.S74 := Wa_.Ps2001_.Bondt; --  varchar2(8), -- BONDT DATS  8   Off-cycle payroll payment date
      Oa_.S75 := Wa_.Ps2001_.Ocrsn; --  varchar2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
      Oa_.S76 := Wa_.Ps2001_.Sppe1; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Oa_.S77 := Wa_.Ps2001_.Sppe2; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Oa_.S78 := Wa_.Ps2001_.Sppe3; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Oa_.S79 := Wa_.Ps2001_.Sppin; --  varchar2(1), -- SPPIN CHAR  1   Indicator for manual modifications
      Oa_.S80 := Wa_.Ps2001_.Zkmkt; --  varchar2(1), -- P05_ZKMKT_EN  CHAR  1   Status of Sickness Notification
      Oa_.S81 := Wa_.Ps2001_.Faprs; --  varchar2(2), -- FAPRS CHAR  2 T554H Evaluation Type for Attendances/Absences
      --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
      Oa_.S82 := Wa_.Ps2001_.Tdlangu; -- varchar2(10), -- TMW_TDLANGU CHAR  10    Definition Set for IDs
      Oa_.S83 := Wa_.Ps2001_.Tdsubla; -- varchar2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
      Oa_.S84 := Wa_.Ps2001_.Tdtype; --  varchar2(4), -- TDTYPE CHAR  4   Time Data ID Type TDTYP
      Oa_.S85 := Wa_.Ps2001_.Nxdfl; --   varchar2(1) -- PTM_NXDFL  CHAR  1   Next Day Indicator
      --
      Oa_.S86 := Wa_.Ps2001_.Ifs_Seqnr;
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P2001_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2003) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P2003;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --=Z£¥CZ.TEKSTY("Oa_.S";B1;" := Wa_.Ps2003_.";LITERY.MA£E(FRAGMENT.TEKSTU(A1;5;5));"; -- ";FRAGMENT.TEKSTU(A1;10;1000);)
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('2003');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      --.INCLUDE  PS2001        Personnel Time Record: Infotype 2001 (Absences)
      Oa_.S24 := Wa_.Ps2003_.Beguz; --  VARCHAR2(6), --BEGUZ  TIMS  6   Start Time
      Oa_.S25 := Wa_.Ps2003_.Enduz; --  VARCHAR2(6), --ENDUZ  TIMS  6   End Time
      Oa_.S26 := Wa_.Ps2003_.Vtken; --  VARCHAR2(1), --VTKEN  CHAR  1   Previous Day Indicator
      Oa_.S27 := Wa_.Ps2003_.Vtart; --  VARCHAR2(2), --VTART  CHAR  2 T556  Substitution Type
      Oa_.S28 := Wa_.Ps2003_.Stdaz; --  VARCHAR2(7), --VTSTD  DEC 7(2)    Substitution hours
      Oa_.S29 := Wa_.Ps2003_.Pamod; --  VARCHAR2(5), --PAMOD  CHAR  4 T550P Work Break Schedule
      Oa_.S30 := Wa_.Ps2003_.Pbeg1; --  VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
      Oa_.S31 := Wa_.Ps2003_.Pend1; --  VARCHAR2(6), --PDEND  TIMS  6   End of Break
      Oa_.S32 := Wa_.Ps2003_.Pbez1; --  VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
      Oa_.S33 := Wa_.Ps2003_.Punb1; --  VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
      Oa_.S34 := Wa_.Ps2003_.Pbeg2; --  VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
      Oa_.S35 := Wa_.Ps2003_.Pend2; --  VARCHAR2(6), --PDEND  TIMS  6   End of Break
      Oa_.S36 := Wa_.Ps2003_.Pbez2; --  VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
      Oa_.S37 := Wa_.Ps2003_.Punb2; --  VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
      Oa_.S38 := Wa_.Ps2003_.Zeity; --  VARCHAR2(1), --DZEITY CHAR  1   Employee Subgroup Grouping for Work Schedules
      Oa_.S39 := Wa_.Ps2003_.Mofid; --  VARCHAR2(2), --HIDENT CHAR  2 THOCI Public Holiday Calendar
      Oa_.S40 := Wa_.Ps2003_.Mosid; --  VARCHAR2(2), --MOSID  NUMC  2 T508Z Personnel Subarea Grouping for Work Schedules
      Oa_.S41 := Wa_.Ps2003_.Schkz; --  VARCHAR2(8), --SCHKN  CHAR  8 T508A Work Schedule Rule
      Oa_.S42 := Wa_.Ps2003_.Motpr; --  VARCHAR2(2), --MOTPR  NUMC  2   Personnel Subarea Grouping for Daily Work Schedules
      Oa_.S43 := Wa_.Ps2003_.Tprog; --  VARCHAR2(4), --TPROG  CHAR  4 T550A Daily Work Schedule
      Oa_.S44 := Wa_.Ps2003_.Varia; --  VARCHAR2(1), --VARIA  CHAR  1   Daily Work Schedule Variant
      Oa_.S45 := Wa_.Ps2003_.Tagty; --  VARCHAR2(1), -- TAGTY CHAR  1 T553T Day Type
      Oa_.S46 := Wa_.Ps2003_.Tpkla; --  VARCHAR2(1), --TPKLA  CHAR  1   Daily Work Schedule Class
      Oa_.S47 := Wa_.Ps2003_.Vpern; --  VARCHAR2(8), --VPERN  NUMC  8   Substitute Personnel Number
      Oa_.S48 := Wa_.Ps2003_.Aufkz; --  VARCHAR2(1), --AUFKN  CHAR  1   Extra Pay Indicator
      Oa_.S49 := Wa_.Ps2003_.Bwgrl; --  VARCHAR2(13), --PTM_VBAS7S CURR  13(2)   Valuation Basis for Different Payment
      Oa_.S50 := Wa_.Ps2003_.Trfgr; --  VARCHAR2(8), --TRFGR  CHAR  8   Pay Scale Group
      Oa_.S51 := Wa_.Ps2003_.Trfst; --  VARCHAR2(2), --TRFST  CHAR  2 Pay Scale Level
      Oa_.S52 := Wa_.Ps2003_.Prakn; --  VARCHAR2(2), --PRAKN  CHAR  2 T510P Premium Number
      Oa_.S53 := Wa_.Ps2003_.Prakz; --  VARCHAR2(4), --PRAKZ  NUMC  4   Premium Indicator
      Oa_.S54 := Wa_.Ps2003_.Otype; --  VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
      Oa_.S55 := Wa_.Ps2003_.Plans; --  VARCHAR2(8), --PLANS  NUMC  8   Position
      Oa_.S56 := Wa_.Ps2003_.Exbel; --  VARCHAR2(8), --EXBEL  CHAR  8   External Document Number
      Oa_.S57 := Wa_.Ps2003_.Waers; --  VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
      Oa_.S58 := Wa_.Ps2003_.Wtart; --  VARCHAR2(4), --WTART  CHAR  4   Work tax area
      Oa_.S59 := Wa_.Ps2003_.Tdlangu; --  VARCHAR2(10), --TMW_TDLANGU  CHAR  10    Definition Set for IDs
      Oa_.S60 := Wa_.Ps2003_.Tdsubla; --  VARCHAR2(3), --TMW_TDSUBLA  CHAR  3   Definition Subset for IDs
      Oa_.S61 := Wa_.Ps2003_.Tdtype; --  VARCHAR2(4), --TDTYPE  CHAR  4   Time Data ID Type TDTYP
      Oa_.S62 := Wa_.Ps2003_.Logsys; --   VARCHAR2(10), --LOGSYS  CHAR  10  Logical system  ALPHA
      Oa_.S63 := Wa_.Ps2003_.Awtyp; --    VARCHAR2(5), --AWTYP  CHAR  5   Reference Transaction
      Oa_.S64 := Wa_.Ps2003_.Awref; --    VARCHAR2(10), --AWREF  CHAR  10    Reference Document Number ALPHA
      Oa_.S65 := Wa_.Ps2003_.Aworg; --    VARCHAR2(10), --AWORG  CHAR  10    Reference Organizational Units
      Oa_.S66 := Wa_.Ps2003_.Nxdfl; --    VARCHAR2(1), --PTM_NXDFL  CHAR  1   Next Day Indicator
      Oa_.S67 := Wa_.Ps2003_.Ftkla; --    VARCHAR2(1) --FTKLA  CHAR  1   Public holiday class
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P2003_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2006) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P2006;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('2006');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
      Oa_.S24 := Wa_.Ps2006_.Beguz; -- varchar2(6), -- BEGTI TIMS  6   Start Time
      Oa_.S25 := Wa_.Ps2006_.Enduz; -- varchar2(6), -- ENDTI TIMS  6   End Time
      Oa_.S26 := Wa_.Ps2006_.Vtken; -- varchar2(1), -- VTKEN CHAR  1   Previous Day Indicator
      Oa_.S27 := Wa_.Ps2006_.Ktart; -- varchar2(2), -- ABWKO NUMC  2 T556A Absence Quota Type
      Oa_.S28 := Wa_.Ps2006_.Anzhl; -- varchar2(10), -- PTM_QUONUM  DEC 10(5)   Number of Employee Time Quota
      Oa_.S29 := Wa_.Ps2006_.Kverb; -- varchar2(10), -- PTM_QUODED  DEC 10(5)   Deduction of Employee Time Quota
      Oa_.S30 := Wa_.Ps2006_.Quonr; -- varchar2(20), -- PTM_QUONR NUMC  20    Counter for time quotas
      Oa_.S31 := Wa_.Ps2006_.Desta; -- varchar2(8), -- PTM_DEDSTART  DATS  8   Start Date for Quota Deduction
      Oa_.S32 := Wa_.Ps2006_.Deend; -- varchar2(8), -- PTM_DEDEND  DATS  8   Quota Deduction to
      Oa_.S33 := Wa_.Ps2006_.Quosy; -- varchar2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
      --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
      Oa_.S34 := Wa_.Ps2006_.Tdlangu; -- varchar2(10), -- TMW_TDLANGU CHAR  10  Definition Set for IDs
      Oa_.S35 := Wa_.Ps2006_.Tdsubla; -- varchar2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
      Oa_.S36 := Wa_.Ps2006_.Tdtype; --  varchar2(4) -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P2006_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It2010) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P2010;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('2010');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
      Oa_.S24 := Wa_.Ps2010_.Beguz; --  VARCHAR2(6), -- BEGTI TIMS  6   Start Time
      Oa_.S25 := Wa_.Ps2010_.Enduz; --    VARCHAR2(6), -- ENDTI TIMS  6   End Time
      Oa_.S26 := Wa_.Ps2010_.Vtken; --    VARCHAR2(1), -- VTKEN CHAR  1   Previous Day Indicator
      Oa_.S27 := Wa_.Ps2010_.Stdaz; --    VARCHAR2(12), -- ENSTD DEC 7(2)    No.of hours for remuneration info.
      Oa_.S28 := Wa_.Ps2010_.Lgart; --    VARCHAR2(4), -- LGART CHAR  4   Wage Type
      Oa_.S29 := Wa_.Ps2010_.Anzhl; --    VARCHAR2(7), -- ENANZ DEC 7(2)    Number per Time Unit for EE Remuneration Info
      Oa_.S30 := Wa_.Ps2010_.Zeinh; --    VARCHAR2(3), -- PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Oa_.S31 := Wa_.Ps2010_.Bwgrl; --    VARCHAR2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
      Oa_.S32 := Wa_.Ps2010_.Aufkz; --    VARCHAR2(1), --   AUFKN CHAR  1   Extra Pay Indicator
      Oa_.S33 := Wa_.Ps2010_.Betrg; --    VARCHAR2(13), -- PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Oa_.S34 := Wa_.Ps2010_.Endof; --    VARCHAR2(1), -- ENDOF CHAR  1   Indicator for final confirmation
      Oa_.S35 := Wa_.Ps2010_.Ufld1; --    VARCHAR2(1), -- USFLD CHAR  1   User field
      Oa_.S36 := Wa_.Ps2010_.Ufld2; --    VARCHAR2(1), -- USFLD CHAR  1   User field
      Oa_.S37 := Wa_.Ps2010_.Ufld3; --    VARCHAR2(1), --   USFLD CHAR  1   User field
      Oa_.S38 := Wa_.Ps2010_.Keypr; --    VARCHAR2(3), -- KEYPR CHAR  3   Number of Infotype Record with Identical Key
      Oa_.S39 := Wa_.Ps2010_.Trfgr; --    VARCHAR2(8), -- TRFGR CHAR  8   Pay Scale Group
      Oa_.S40 := Wa_.Ps2010_.Trfst; --    VARCHAR2(2), -- TRFST CHAR  2   Pay Scale Level
      Oa_.S41 := Wa_.Ps2010_.Prakn; --    VARCHAR2(2), -- PRAKN CHAR  2 T510P Premium Number
      Oa_.S42 := Wa_.Ps2010_.Prakz; --    VARCHAR2(4), -- PRAKZ NUMC  4   Premium Indicator
      Oa_.S43 := Wa_.Ps2010_.Otype; --    VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
      Oa_.S44 := Wa_.Ps2010_.Plans; --    VARCHAR2(8), -- PLANS NUMC  8 T528B Position
      Oa_.S45 := Wa_.Ps2010_.Versl; --    VARCHAR2(1), -- VRSCH CHAR  1 T555R Overtime Compensation Type
      Oa_.S46 := Wa_.Ps2010_.Exbel; --    VARCHAR2(8), -- EXBEL CHAR  8   External Document Number
      Oa_.S47 := Wa_.Ps2010_.Waers; --    VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
      Oa_.S48 := Wa_.Ps2010_.Logsys; --   VARCHAR2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
      Oa_.S49 := Wa_.Ps2010_.Awtyp; --    VARCHAR2(5), -- AWTYP CHAR  5   Reference Transaction
      Oa_.S50 := Wa_.Ps2010_.Awref; --    VARCHAR2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
      Oa_.S51 := Wa_.Ps2010_.Aworg; --    VARCHAR2(10), -- AWORG CHAR  10    Reference Organizational Units
      Oa_.S52 := Wa_.Ps2010_.Wtart; --    VARCHAR2(4), -- WTART CHAR  4 T5UTB Work tax area
      --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
      Oa_.S53 := Wa_.Ps2010_.Tdlangu; --   VARCHAR2(10), -- TMW_TDLANGU CHAR  10  Definition Set for IDs
      Oa_.S54 := Wa_.Ps2010_.Tdsubla; --   VARCHAR2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
      Oa_.S55 := Wa_.Ps2010_.Tdtype; --    VARCHAR2(4) -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P2010_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.It9950) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.P9950;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('9950');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_ := Init_Head_Store___(Wa_.Pakey_, Wa_.Pshd1_, Wa_.Meta_);
      -- next free 24
      --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
      Oa_.S24 := Wa_.Ps9950_.Zzempque; -- varchar2(1), --  Kwestionariusz osobowy
      Oa_.S25 := Wa_.Ps9950_.Zzempcon; -- varchar2(1), --  Umowa o pracê
      Oa_.S26 := Wa_.Ps9950_.Zzjobdes; -- varchar2(1), --  Zakres obowi¹zków
      Oa_.S27 := Wa_.Ps9950_.Zzworper; -- varchar2(1), --  Pozwolenie na pracê
      Oa_.S28 := Wa_.Ps9950_.Zzworcer; -- varchar2(1), --  Œwiadectwo pracy
      Oa_.S29 := Wa_.Ps9950_.Zzdiplom; -- varchar2(1), --  Dyplom
      Oa_.S30 := Wa_.Ps9950_.Zzmedexa; -- varchar2(1), --  Badania lekarskie
      Oa_.S31 := Wa_.Ps9950_.Zzbhptra; -- varchar2(1), --  Szkolenie BHP
      Oa_.S32 := Wa_.Ps9950_.Zzcomwor; -- varchar2(1), --  Œwiadectwo pracy firma
      Oa_.S33 := Wa_.Ps9950_.Zzrefere; -- varchar2(1), --  Referencje
      Oa_.S34 := Wa_.Ps9950_.Zznonsub; -- varchar2(1), --  Oœwiadczenie o bezrobociu
      Oa_.S35 := Wa_.Ps9950_.Zzcrirec; -- varchar2(1), --  Oœwiadczenie o niekaralnoœci
      Oa_.S36 := Wa_.Ps9950_.Zzjobris; -- varchar2(1), --  Ryzyko zawodowe
      Oa_.S37 := Wa_.Ps9950_.Zzunfeli; --  varchar2(1), --  Licencja UNFE
      Oa_.S38 := Wa_.Ps9950_.Zzcurvit; --   varchar2(1), --  CV
      Oa_.S39 := Wa_.Ps9950_.Zzannex; --   varchar2(1), -- Aneks
      Oa_.S40 := Wa_.Ps9950_.Zzinfemp; --   varchar2(1), --  Informacja dla pracownika
      Oa_.S41 := Wa_.Ps9950_.Zzequtre; --   varchar2(1), --  Oœwiadczenie o równym traktowaniu
      Oa_.S42 := Wa_.Ps9950_.Zzbuscon; --   varchar2(1), --Certyfikat firmowy
      Oa_.S43 := Wa_.Ps9950_.Zzppozce; --   varchar2(1), --  Oœwiadczenie PPO¯
      Oa_.S44 := Wa_.Ps9950_.Zzinfsw1; --  varchar2(120), --  Informacja o œwiadectwach 1
      Oa_.S45 := Wa_.Ps9950_.Zzinfsw2; --varchar2(120), --  Informacja o œwiadectwach 2
      Oa_.S46 := Wa_.Ps9950_.Zzdoda01; --  varchar2(1), --  Dodatkowy dokument 1
      Oa_.S47 := Wa_.Ps9950_.Zzdoda02; --  varchar2(1), --Dodatkowy dokument 2
      Oa_.S48 := Wa_.Ps9950_.Zzdoda03; --  varchar2(1), --  Dodatkowy dokument 3
      Oa_.S49 := Wa_.Ps9950_.Zzdoda04; --  varchar2(1), --  Dodatkowy dokument 4
      Oa_.S50 := Wa_.Ps9950_.Zzdoda05; --  varchar2(1), --  Dodatkowy dokument 5
      Oa_.S51 := Wa_.Ps9950_.Zzdoda06; --  varchar2(1), --  Dodatkowy dokument 6
      Oa_.S52 := Wa_.Ps9950_.Zzdodo98; --  varchar2(120), --  Dodatkowy dokument opis 1
      Oa_.S53 := Wa_.Ps9950_.Zzdodo99; --  varchar2(120) --  Dodatkowy dokument opis
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('P9950_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
  --
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558a,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1) IS
    i_         NUMBER;
    Wa_        Zpk_Sap_Exp.Payt558a;
    Oa_        Ic_Xx_Import_Tab%ROWTYPE;
    St_        Zpk_Sap_Exp.Stab_;
    File_Name_ VARCHAR2(200);
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('T558A');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_.S1 := Wa_.T558a_.Mandt; -- varchar2(3), --MANDT  CLNT  3 T000  Client
      Oa_.S2 := Wa_.T558a_.Pernr; -- varchar2(8), --PERNR_D  NUMC  8   Personnel Number
      Oa_.S3 := Wa_.T558a_.Begda; -- varchar2(5), --BEGDA
      Oa_.S4 := Wa_.T558a_.Endda; -- varchar2(5), --ENDDA
      Oa_.S5 := Wa_.T558a_.Molga; -- varchar2(2), --MOLGA CHAR  2 T500L Country Grouping
      Oa_.S6 := Wa_.T558a_.Lgart; -- varchar2(4), --LGART CHAR  4 T512W Wage Type
      --
      Oa_.S7 := Wa_.T558a_.Betpe; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
      Oa_.S8 := Wa_.T558a_.Anzhl; -- varchar2(15), --RPANZ DEC 15(2)   Number field
      Oa_.S9 := Wa_.T558a_.Betrg; -- varchar2(15) --RPBET  CURR  15(2)   Amount
      --
      Oa_.S20 := To_Char(Wa_.Meta_.Lineno, '000000000');
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    File_Name_ := To_Char(Box_No_, '00') || '_PAY558A_' || To_Char(Chunk_No_, '000000') || '_' ||
                  To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv';
    File_Name_ := REPLACE(File_Name_, ' ');
    Zpk_Sap_Exp.Dump_Table_To_Csv(File_Name_, 20);
  END Store___;
  --
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558b,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1) IS
    i_         NUMBER;
    Wa_        Zpk_Sap_Exp.Payt558b;
    Oa_        Ic_Xx_Import_Tab%ROWTYPE;
    St_        Zpk_Sap_Exp.Stab_;
    File_Name_ VARCHAR2(200);
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('T558B');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_.S1 := Wa_.T558b_.Mandt; -- varchar2(3), --MANDT  CLNT  3 T000  Client
      Oa_.S2 := Wa_.T558b_.Pernr; -- varchar2(8), --PERNR_D  NUMC  8   Personnel Number
      Oa_.S3 := Wa_.T558b_.Seqnr; -- varchar2(5), --SEQ_T558B  NUMC  5   Sequential number for payroll period
      --
      Oa_.S4  := Wa_.T558b_.Payty; --    varchar2(1), --PAYTY CHAR  1   Payroll type
      Oa_.S5  := Wa_.T558b_.Payid; --    varchar2(1), --PAYID CHAR  1   Payroll Identifier
      Oa_.S6  := Wa_.T558b_.Paydt; --    varchar2(8), --PAY_DATE  DATS  8   Pay date for payroll result
      Oa_.S7  := Wa_.T558b_.Permo; --    varchar2(2), --PERMO NUMC  2 T549R Period Parameters
      Oa_.S8  := Wa_.T558b_.Pabrj; --    varchar2(4), --PABRJ NUMC  4   Payroll Year  GJAHR
      Oa_.S9  := Wa_.T558b_.Pabrp; --    varchar2(2), --PABRP NUMC  2   Payroll Period
      Oa_.S10 := Wa_.T558b_.Fpbeg; --    varchar2(8), --FPBEG DATS  8   Start date of payroll period (FOR period)
      Oa_.S11 := Wa_.T558b_.Fpend; --    varchar2(8), --FPEND DATS  8   End of payroll period (for-period)
      Oa_.S12 := Wa_.T558b_.Ocrsn; --   varchar2(4), --PAY_OCRSN CHAR  4   Reason for Off-Cycle Payroll
      Oa_.S13 := Wa_.T558b_.Seqnr_Cd; -- varchar2(5) --CDSEQ NUMC  5   Sequence Number
      --
      Oa_.S20 := To_Char(Wa_.Meta_.Lineno, '000000000');
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    File_Name_ := To_Char(Box_No_, '00') || '_PAY558B_' || To_Char(Chunk_No_, '000000') || '_' ||
                  To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv';
    File_Name_ := REPLACE(File_Name_, ' ');
    Zpk_Sap_Exp.Dump_Table_To_Csv(File_Name_, 20);
  END Store___;
  --
  PROCEDURE Store___(It_       IN Zpk_Sap_Exp.Pay558c,
                     Chunk_No_ NUMBER DEFAULT 0,
                     Box_No_   NUMBER DEFAULT 1) IS
    i_         NUMBER;
    Wa_        Zpk_Sap_Exp.Payt558c;
    Oa_        Ic_Xx_Import_Tab%ROWTYPE;
    St_        Zpk_Sap_Exp.Stab_;
    File_Name_ VARCHAR2(200);
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('T558C');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_.S1 := Wa_.T558c_.Mandt; -- varchar2(3), --MANDT  CLNT  3 T000  Client
      Oa_.S2 := Wa_.T558c_.Pernr; -- varchar2(8), --PERNR_D  NUMC  8   Personnel Number
      Oa_.S3 := Wa_.T558c_.Seqnr; -- varchar2(5), --SEQ_T558B  NUMC  5   Sequential number for payroll period
      Oa_.S4 := Wa_.T558c_.Molga; -- varchar2(2), --MOLGA CHAR  2 T500L Country Grouping
      Oa_.S5 := Wa_.T558c_.Lgart; -- varchar2(4), --LGART CHAR  4 T512W Wage Type
      Oa_.S6 := Wa_.T558c_.Keydate; -- varchar2(8), --  DATUM DATS  8   Date
      --
      Oa_.S7 := Wa_.T558c_.Betpe; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
      Oa_.S8 := Wa_.T558c_.Anzhl; -- varchar2(15), --RPANZ DEC 15(2)   Number field
      Oa_.S9 := Wa_.T558c_.Betrg; -- varchar2(15) --RPBET  CURR  15(2)   Amount
      --
      Oa_.S20 := To_Char(Wa_.Meta_.Lineno, '000000000');
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    File_Name_ := To_Char(Box_No_, '00') || '_PAY558C_' || To_Char(Chunk_No_, '000000') || '_' ||
                  To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv';
    File_Name_ := REPLACE(File_Name_, ' ');
    Zpk_Sap_Exp.Dump_Table_To_Csv(File_Name_, 20);
  END Store___;
  --
  PROCEDURE Store___(It_ IN Zpk_Sap_Exp.Paybase) IS
    i_  NUMBER;
    Wa_ Zpk_Sap_Exp.Paytbase;
    Oa_ Ic_Xx_Import_Tab%ROWTYPE;
    St_ Zpk_Sap_Exp.Stab_;
  BEGIN
    --
    Prepare_Store_Tab;
    Oa_ := Prepare_Header_Line('PAYBASE');
    St_(0) := Oa_;
    --
    i_ := It_.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := It_(i_);
      Oa_ := NULL;
      --
      Oa_.S1  := Wa_.Tbase_.Mandt; --MANDT CLNT  3 T000  Client
      Oa_.S2  := Wa_.Tbase_.Pernr; -- varchar2(8), --PERNR_D NUMC  8   Personnel Number
      Oa_.S3  := Wa_.Tbase_.Period; -- varchar2(8), --PERNR_D NUMC  8   Personnel Number
      Oa_.S4  := Wa_.Tbase_.H855; --  varchar2(5), --planed hours
      Oa_.S5  := Wa_.Tbase_.H853; --  varchar2(5), --worked hours
      Oa_.S6  := Wa_.Tbase_.H850; --  varchar2(5), --zus worked hours
      Oa_.S7  := Wa_.Tbase_.W232b; -- varchar2(15), -- monthly base gross
      Oa_.S8  := Wa_.Tbase_.W232n; -- varchar2(15) -- monthly base net
      Oa_.S9  := Wa_.Tbase_.W3pu; -- varchar2(15), -- monthly base gross
      Oa_.S10 := Wa_.Tbase_.W3p1; -- varchar2(15) -- monthly base net
      --
      Oa_.S11 := Wa_.Tbase_.W0030b; -- yearly
      Oa_.S12 := Wa_.Tbase_.W0030r; --
      Oa_.S13 := Wa_.Tbase_.W0030a; --
      --
      St_(St_.Last + 1) := Oa_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    --
    Save_Store_Tab(St_);
    --
    Zpk_Sap_Exp.Dump_Table_To_Csv('PAYBASE_' || To_Char(SYSDATE, 'YYYYMMDDHH24MISS') || '.csv');
  END Store___;
END Zpk_Sap_Exp_Dic_Api;
/
set define on
