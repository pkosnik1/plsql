set define off
CREATE OR REPLACE PACKAGE IFSAPP.ZPK_SAP_EXP IS
  -- Author  : PKOSNIK
  -- Created : 24.09.2018 08:39:47
  -- Purpose : Export data to sap
  --
  c_Conv_Group_Out_ CONSTANT VARCHAR2(10) := 'EXP_SAP';
  c_Conv_Group_Wc_  CONSTANT VARCHAR2(10) := 'EXP_SAP_WC';
  --
  m_Leaving_Cause_Id CONSTANT VARCHAR2(30) := 'M_LEAVING_CAUSE_ID';
  m_Bukrs_Id         CONSTANT VARCHAR2(30) := 'M_BUKRS_ID';
  m_Werks_Id         CONSTANT VARCHAR2(30) := 'M_WERKS_ID';
  m_Btrtl_Id         CONSTANT VARCHAR2(30) := 'M_BTRTL_ID';
  m_Sex_Id           CONSTANT VARCHAR2(30) := 'M_SEX_ID';
  m_Schedule_Id      CONSTANT VARCHAR2(30) := 'M_SCHEDULE_ID';
  m_Country_Iso_Id   CONSTANT VARCHAR2(30) := 'M_COUNTRY_ISO_ID';
  m_State_Id         CONSTANT VARCHAR2(30) := 'M_STATE_ID';
  m_Address_Type_Id  CONSTANT VARCHAR2(30) := 'M_ADDRESS_TYPE_ID';
  m_Comm_Type_Id     CONSTANT VARCHAR2(30) := 'M_COMM_TYPE_ID';
  m_Param_Id         CONSTANT VARCHAR2(30) := 'M_PARAM_ID';
  m_Param_Time_Id    CONSTANT VARCHAR2(30) := 'M_PARAM_TIME_ID';
  m_Time_Id          CONSTANT VARCHAR2(30) := 'M_TIME_ID';
  m_Relative_Id      CONSTANT VARCHAR2(30) := 'M_RELATIVE_ID';
  m_Relative_Zus_Id  CONSTANT VARCHAR2(30) := 'M_RELATIVE_ZUS_ID';
  m_Edu_Type_Id      CONSTANT VARCHAR2(30) := 'M_EDU_TYPE_ID';
  m_Edu_Level_Id     CONSTANT VARCHAR2(30) := 'M_EDU_LEVEL_ID';
  m_Edu_Title_Id     CONSTANT VARCHAR2(30) := 'M_EDU_TITLE_ID';
  m_Quali_Type       CONSTANT VARCHAR2(30) := 'M_QUALI_TYPE';
  m_Doc_Type         CONSTANT VARCHAR2(30) := 'M_DOC_TYPE';
  m_Param_Costr      CONSTANT VARCHAR2(30) := 'M_PARAM_COSTR';
  m_Param_Contr      CONSTANT VARCHAR2(30) := 'M_PARAM_CONTR';
  m_Param_Dnind      CONSTANT VARCHAR2(30) := 'M_PARAM_DNIND';
  m_Abs_Type         CONSTANT VARCHAR2(30) := 'M_ABS_TYPE';
  m_Lim_Type         CONSTANT VARCHAR2(30) := 'M_LIM_TYPE';
  m_Wagecode_Type    CONSTANT VARCHAR2(30) := 'M_WAGECODE_TYPE';
  m_Lack_Doc_Type    CONSTANT VARCHAR2(30) := 'M_LACK_DOC_TYPE';
  m_Agree_Type       CONSTANT VARCHAR2(30) := 'M_AGREE_TYPE';
  --
  g_Param_Costr_ CONSTANT VARCHAR2(10) := '56040P';
  g_Param_Contr_ CONSTANT VARCHAR2(10) := '56030';
  g_Param_Dnind_ CONSTANT VARCHAR2(10) := '56020';
  --
  c_Dir           CONSTANT VARCHAR2(20) := 'TRANS';
  c_Payroll_Chunk CONSTANT NUMBER := 299999;
  c_Pay_Mode      CONSTANT NUMBER := 2;
  c_Add_List_     CONSTANT VARCHAR2(5) := 'FALSE';
  c_Only_Former   CONSTANT VARCHAR2(5) := 'TRUE';
  c_Curr_Of_Lim   CONSTANT DATE := Trunc(SYSDATE, 'YEAR');
  c_Form_Of_Lim   CONSTANT DATE := Trunc(c_Curr_Of_Lim - 1, 'YEAR'); --get the previous year limit
  -- Defines the date in the payroll past up to which master and time data changes are allowed
  -- as well as the date up to which the system carries out retroactive accounting.
  c_Period_Start CONSTANT DATE := To_Date('20190401', 'YYYYMMDD'); -- 0003 infotype
  c_Var_Mig      CONSTANT DATE := To_Date('20100101', 'YYYYMMDD');
  --------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------
  -- Public constant declarations
  --------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------
  c_Company_Id        VARCHAR2(4) := '148';
  c_Mandt             VARCHAR2(3) := '348';
  c_Period_Calc       DATE := To_Date('20190401', 'YYYYMMDD'); -- first period to calc
  c_Period_Calc_Floor DATE := To_Date('18000101', 'YYYYMMDD'); -- temp period cut
  c_Caclulated_To     NUMBER := To_Number(To_Char(c_Period_Calc - 1, 'YYYYMM')); -- 201812;
  c_Caclulated_From   NUMBER := To_Number(To_Char(c_Period_Calc_Floor, 'YYYYMM')); -- 201812;
  c_Tax_Move          VARCHAR2(5) := 'TRUE';
  --------------------------------------------------------------------------------------------------------
  c_Emp_No     VARCHAR2(8) := '%';
  c_Emp_No_Add VARCHAR2(5) := 'FALSE'; --'FALSE'; --'TRUE'; --'TRUE';
  --------------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------
  -- variable param
  TYPE Meta IS RECORD(
    Lineno NUMBER);
  TYPE Error IS RECORD(
    Empno   VARCHAR2(8),
    Errtype VARCHAR2(30),
    Errno   NUMBER,
    Errmsg  VARCHAR2(2000));
  -- working area temp
  TYPE Emp_Tmp_ IS RECORD(
    Date_From DATE,
    Date_To   DATE,
    Set_Name  VARCHAR2(20),
    S1        VARCHAR2(200),
    S2        VARCHAR2(200),
    S3        VARCHAR2(200),
    S4        VARCHAR2(200),
    S5        VARCHAR2(200),
    S6        VARCHAR2(200),
    S7        VARCHAR2(200),
    S8        VARCHAR2(200),
    S9        VARCHAR2(200),
    S10       VARCHAR2(200),
    S11       VARCHAR2(200),
    S12       VARCHAR2(200),
    S13       VARCHAR2(200),
    S14       VARCHAR2(200),
    S15       VARCHAR2(200),
    S16       VARCHAR2(200),
    S17       VARCHAR2(200),
    S18       VARCHAR2(200),
    S19       VARCHAR2(200),
    S20       VARCHAR2(200),
    S21       VARCHAR2(200),
    S22       VARCHAR2(200),
    S23       VARCHAR2(200),
    S24       VARCHAR2(200),
    S25       VARCHAR2(200),
    S26       VARCHAR2(200),
    S27       VARCHAR2(200),
    S28       VARCHAR2(200),
    S29       VARCHAR2(200),
    S30       VARCHAR2(200));
  --  Key for HR Master Data
  TYPE Pakey IS RECORD(
    Mandt VARCHAR2(4), --MANDT CLNT  3  T000  Client
    --.INCLUDE  PAKEY        Key for HR Master Data
    Pernr VARCHAR2(8), --PERSNONUMC  8   PA0003 Personnel number
    Subty VARCHAR2(4), --SUBTY CHAR  4   Subtype
    Objps VARCHAR2(2), --OBJPS CHAR  2   Object Identification
    Sprps VARCHAR2(1), --SPRPS CHAR  1   Lock Indicator for HR Master Data Record
    Endda VARCHAR2(8), --ENDDA DATS  8   End Date
    Begda VARCHAR2(8), --BEGDA DATS  8   Start Date
    Seqnr VARCHAR2(3) --SEQNR NUMC  3   Number of Infotype Record with Same Key
    );
  -- HR Master Record: Control Field
  TYPE Pshd1 IS RECORD(
    --.INCLUDE  PSHD1       HR Master Record: Control Field
    Aedtm VARCHAR2(8), -- AEDAT DATS  8       Changed On
    Uname VARCHAR2(8), -- AENAM CHAR  12      Name of Person Who Changed Object
    Histo VARCHAR2(8), -- HISTO CHAR  1       Historical Record Flag
    Itxex VARCHAR2(8), -- ITXEX CHAR  1       Text Exists for Infotype
    Refex VARCHAR2(8), -- PRFEX CHAR  1       Reference Fields Exist (Primary/Secondary Costs)
    Ordex VARCHAR2(8), -- ORDEX CHAR  1       Confirmation Fields Exist
    Itbld VARCHAR2(8), -- ITBLD CHAR  2       Infotype Screen Control
    Preas VARCHAR2(8), -- PREAS CHAR  2       T530E Reason for Changing Master Data
    Flag1 VARCHAR2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Flag2 VARCHAR2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Flag3 VARCHAR2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Flag4 VARCHAR2(8), -- NUSED CHAR  1       Reserved Field/Unused Field
    Rese1 VARCHAR2(8), -- NUSED2  CHAR  2     Reserved Field/Unused Field of Length 2
    Rese2 VARCHAR2(8), -- NUSED2  CHAR  2     Reserved Field/Unused Field of Length 2
    Grpvl VARCHAR2(8) --  PCCE_GPVAL  CHAR  4 Grouping Value for Personnel Assignments
    );
  -- HR Master Record: Infotype 0000 (Actions)
  TYPE Ps0000 IS RECORD(
    --.INCLUDE PS0000 HR Master Record :Infotype 0000(Actions)
    Massn VARCHAR2(8), -- MASSN CHAR  2 T529A Action Type
    Massg VARCHAR2(8), -- MASSG CHAR  2 T530  Reason for Action
    Stat1 VARCHAR2(8), -- STAT1 CHAR  1 T529U Customer-Specific Status
    Stat2 VARCHAR2(8), -- STAT2 CHAR  1 T529U Employment Status
    Stat3 VARCHAR2(8) -- STAT3  CHAR  1 T529U Special Payment Status
    );
  -- HR Master Record: Infotype 0001 (Org. Assignment)
  TYPE Ps0001 IS RECORD(
    --      .INCLUDE  PS0001_SAP        HR Master Record: Infotype 0001 (Org. Assignment)
    Bukrs            VARCHAR2(4), --   BUKRS CHAR  4 T001  Company Code
    Werks            VARCHAR2(4), --   PERSA CHAR  4 T500P Personnel Area
    Persg            VARCHAR2(1), --   PERSG CHAR  1 T501  Employee Group
    Persk            VARCHAR2(2), --   PERSK CHAR  2 T503K Employee Subgroup
    Vdsk1            VARCHAR2(14), --  VDSK1 CHAR  14  T527O Organizational Key
    Gsber            VARCHAR2(4), --   GSBER CHAR  4 TGSB  Business Area
    Btrtl            VARCHAR2(4), --   BTRTL CHAR  4 T001P Personnel Subarea
    Juper            VARCHAR2(4), --   JUPER CHAR  4   Legal Person
    Abkrs            VARCHAR2(2), --   ABKRS CHAR  2 T549A Payroll Area
    Ansvh            VARCHAR2(2), --   ANSVH CHAR  2 T542A Work Contract
    Kostl            VARCHAR2(10), --  KOSTL CHAR  10  CSKS  Cost Center ALPHA
    Orgeh            VARCHAR2(8), --   ORGEH NUMC  8 T527X Organizational Unit
    Plans            VARCHAR2(8), --   PLANS NUMC  8 T528B Position
    Stell            VARCHAR2(8), --   STELL NUMC  8 T513  Job
    Mstbr            VARCHAR2(8), --   MSTBR CHAR  8   Supervisor Area
    Sacha            VARCHAR2(3), --   SACHA CHAR  3 T526  Payroll Administrator
    Sachp            VARCHAR2(3), --   SACHP CHAR  3 T526  Administrator for HR Master Data
    Sachz            VARCHAR2(3), --   SACHZ CHAR  3 T526  Administrator for Time Recording
    Sname            VARCHAR2(30), --  SMNAM CHAR  30    Employees Name (Sortable by LAST NAME FIRST NAME)
    Ename            VARCHAR2(40), --  EMNAM CHAR  40    Formatted Name of Employee or Applicant
    Otype            VARCHAR2(2), --   OTYPE CHAR  2 T778O Object Type
    Sbmod            VARCHAR2(4), --   SBMOD CHAR  4   Administrator Group
    Kokrs            VARCHAR2(4), --   KOKRS CHAR  4 TKA01 Controlling Area
    Fistl            VARCHAR2(16), --  FISTL CHAR  16
    Geber            VARCHAR2(10), --  BP_GEBER  CHAR  10
    Fkber            VARCHAR2(16), --  FKBER CHAR  16  * Functional Area
    Grant_Nbr        VARCHAR2(20), --  GM_GRANT_NBR  CHAR  20    Grant ALPHA
    Sgmnt            VARCHAR2(10), --  FB_SEGMENT  CHAR  10  * Segment for Segmental Reporting ALPHA
    Budget_Pd        VARCHAR2(10), --  FM_BUDGET_PERIOD  CHAR  10  * FM: Budget Period
    Ifs_Pose_Code    VARCHAR2(10),
    Ifs_Pose_Name    VARCHAR2(200),
    Ifs_Pose_Name_En VARCHAR2(200));
  -- HR Master Record: Infotype 0002 (Personal Data)
  TYPE Ps0002 IS RECORD(
    -- .INCLUDE PS0002        HR Master Record: Infotype 0002 (Personal Data)
    Inits VARCHAR2(10), --    INITS CHAR  10    Initials
    Nachn VARCHAR2(40), --      PAD_NACHN CHAR  40    Last Name
    Name2 VARCHAR2(40), --      PAD_NAME2 CHAR  40    Name at Birth
    Nach2 VARCHAR2(40), --      PAD_NACH2 CHAR  40    Second Name
    Vorna VARCHAR2(40), --      PAD_VORNA CHAR  40    First Name
    Cname VARCHAR2(80), --      PAD_CNAME CHAR  80    Complete Name
    Titel VARCHAR2(15), --      TITEL CHAR  15  T535N Title
    Titl2 VARCHAR2(15), --      TITL2 CHAR  15  T535N Second Title
    Namzu VARCHAR2(15), --      NAMZU CHAR  15  T535N Other Title
    Vorsw VARCHAR2(15), --      VORSW CHAR  15  T535N Name Prefix
    Vors2 VARCHAR2(15), --      VORS2 CHAR  15  T535N Second Name Prefix
    Rufnm VARCHAR2(40), --      PAD_RUFNM CHAR  40    Nickname
    Midnm VARCHAR2(40), --      PAD_MIDNM CHAR  40    Middle Name
    Knznm VARCHAR2(2), --      KNZNM NUMC  2   Name Format Indicator for Employee in a List
    Anred VARCHAR2(1), --      ANRDE CHAR  1 T522G Form-of-Address Key
    Gesch VARCHAR2(1), --      GESCH CHAR  1   Gender Key
    Gbdat VARCHAR2(8), --      GBDAT DATS  8   Date of Birth PDATE
    Gblnd VARCHAR2(3), --      GBLND CHAR  3 T005  Country of Birth
    Gbdep VARCHAR2(3), --      GBDEP CHAR  3 T005S State
    Gbort VARCHAR2(40), --      PAD_GBORT CHAR  40    Birthplace
    Natio VARCHAR2(3), --      NATSL CHAR  3 T005  Nationality
    Nati2 VARCHAR2(3), --      NATS2 CHAR  3 T005  Second Nationality
    Nati3 VARCHAR2(3), --      NATS3 CHAR  3 T005  Third Nationality
    Sprsl VARCHAR2(1), --      PAD_SPRAS LANG  1 T002  Communication Language  ISOLA
    Konfe VARCHAR2(2), --      KONFE CHAR  2 * Religious Denomination Key
    Famst VARCHAR2(1), --      FAMST CHAR  1 * Marital Status Key
    Famdt VARCHAR2(8), --      FAMDT DATS  8   Valid From Date of Current Marital Status
    Anzkd VARCHAR2(3), --      ANZKD DEC 3   Number of Children
    Nacon VARCHAR2(1), --      NACON CHAR  1   Name Connection
    Permo VARCHAR2(2), --      PIDMO CHAR  2   Modifier for Personnel Identifier
    Perid VARCHAR2(20), --      PRDNI CHAR  20    Personnel ID Number
    Gbpas VARCHAR2(8), --      GBPAS DATS  8   Date of Birth According to Passport
    Fnamk VARCHAR2(40), --      P22J_PFNMK  CHAR  40    First name (Katakana)
    Lnamk VARCHAR2(40), --      P22J_PLNMK  CHAR  40    Last name (Katakana)
    Fnamr VARCHAR2(40), --      P22J_PFNMR  CHAR  40    First Name (Romaji)
    Lnamr VARCHAR2(40), --      P22J_PLNMR  CHAR  40    Last Name (Romaji)
    Nabik VARCHAR2(40), --      P22J_PNBIK  CHAR  40    Name of Birth (Katakana)
    Nabir VARCHAR2(40), --      P22J_PNBIR  CHAR  40    Name of Birth (Romaji)
    Nickk VARCHAR2(40), --      P22J_PNCKK  CHAR  40    Koseki (Katakana)
    Nickr VARCHAR2(40), --      P22J_PNCKR  CHAR  40    Koseki (Romaji)
    Gbjhr VARCHAR2(4), --      GBJHR NUMC  4   Year of Birth GJAHR
    Gbmon VARCHAR2(2), --      GBMON NUMC  2   Month of Birth
    Gbtag VARCHAR2(2), --      GBTAG NUMC  2   Birth Date (to Month/Year)
    Nchmc VARCHAR2(25), --      NACHNMC CHAR  25    Last Name (Field for Search Help)
    Vnamc VARCHAR2(25), --      VORNAMC CHAR  25    First Name (Field for Search Help)
    Namz2 VARCHAR2(15) --     NAMZ2 CHAR  15  T535N Name Affix for Name at Birth
    );
  -- HR Master Record: Infotype 0003 (Payroll Status)
  TYPE Ps0003 IS RECORD(
    -- .INCLUDE PS0003        HR Master Record: Infotype 0003 (Payroll Status)
    Abrsp VARCHAR2(1), --   ABRSP CHAR  1   Indicator: Personnel number locked for payroll
    Abrdt VARCHAR2(8), --   LABRD DATS  8   Accounted to
    Rrdat VARCHAR2(8), --   RRDAT DATS  8   Earliest master data change since last payroll run
    Rrdaf VARCHAR2(8), --   RRDAF DATS  8   not in use
    Koabr VARCHAR2(1), --   PAD_INTERN  CHAR  1   Internal Use
    Prdat VARCHAR2(8), --   PRRDT DATS  8   Earliest personal retroactive accounting date
    Pkgab VARCHAR2(8), --   PKGAB DATS  8   Date as of which personal calendar must be generated
    Abwd1 VARCHAR2(8), --   ABWD1 DATS  8   End of processing 1 (run payroll for pers.no. up to)
    Abwd2 VARCHAR2(8), --   ABWD2 DATS  8   End of processing (do not run payroll for pers.no. after)
    Bderr VARCHAR2(8), --   BDERR DATS  8   Recalculation date for PDC
    Bder1 VARCHAR2(8), --   BDER1 DATS  8   Effective recalculation date for PDC
    Kobde VARCHAR2(1), --   KOBDE CHAR  1   PDC Error Indicator
    Timrc VARCHAR2(1), --   TIMRC CHAR  1   Date of initial PDC entry
    Dat00 VARCHAR2(8), --   DATP0 DATS  8   Initial input date for a personnel number
    Uhr00 VARCHAR2(6), --   UHR00 TIMS  6   Time of initial input
    Inumk VARCHAR2(8), --   CHAR8 CHAR  8   Character field, 8 characters long
    Werks VARCHAR2(4), --   SBMOD CHAR  4   Administrator Group
    Sachz VARCHAR2(3), --   SACHZ CHAR  3   Administrator for Time Recording
    Sfeld VARCHAR2(20), --   SFELD CHAR  20    Sort field for infotype 0003
    Adrun VARCHAR2(1), --   ADRUN CHAR  1   HR: Special payroll run
    Viekn VARCHAR2(2), --   VIEKN CHAR  2   Infotype View Indicator
    Trvfl VARCHAR2(1), --   TRVFL CHAR  1   Indicator for recorded trips
    Rcbon VARCHAR2(8), --   RCBON DATS  8   Earliest payroll-relevant master data change (bonus)
    Prtev VARCHAR2(8) --   PRTEV DATS  8   Earliest personal recalculation date for time evaluation
    );
  --HR Master Record: Infotype 0006 (Addresses)
  TYPE Ps0006 IS RECORD(
    -- .INCLUDE PS0006        HR Master Record: Infotype 0006 (Addresses)
    Anssa      VARCHAR2(4), --     ANSSA CHAR  4   Address Record Type
    Name2      VARCHAR2(40), -- PAD_CONAM  CHAR  40    Contact Name
    Stras      VARCHAR2(60), -- PAD_STRAS  CHAR  60    Street and House Number
    Ort01      VARCHAR2(40), -- PAD_ORT01  CHAR  40    City
    Ort02      VARCHAR2(40), -- PAD_ORT02  CHAR  40    District
    Pstlz      VARCHAR2(10), -- PSTLZ_HR CHAR  10    Postal Code
    Land1      VARCHAR2(3), -- LAND1 CHAR  3 T005  Country Key
    Telnr      VARCHAR2(14), -- TELNR  CHAR  14    Telephone Number
    Entkm      VARCHAR2(3), -- ENTKM DEC 3   Distance in Kilometers
    Wkwng      VARCHAR2(1), -- WKWNG CHAR  1   Company Housing
    Busrt      VARCHAR2(3), -- BUSRT CHAR  3   Bus Route
    Locat      VARCHAR2(40), -- PAD_LOCAT  CHAR  40    2nd Address Line
    Adr03      VARCHAR2(40), --  AD_STRSPP1  CHAR  40    Street 2
    Adr04      VARCHAR2(40), -- AD_STRSPP2 CHAR  40    Street 3
    Hsnmr      VARCHAR2(10), -- PAD_HSNMR  CHAR  10    House Number
    Posta      VARCHAR2(10), -- PAD_POSTA  CHAR  10    Identification of an apartment in a building
    Bldng      VARCHAR2(10), -- AD_BLD_10  CHAR  10    Building (number or code)
    Floor      VARCHAR2(10), -- AD_FLOOR CHAR  10    Floor in building
    Strds      VARCHAR2(2), -- STRDS CHAR  2 T5EVP Street Abbreviation
    Entk2      VARCHAR2(3), -- ENTKM DEC 3   Distance in Kilometers
    Com01      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num01      VARCHAR2(20), -- COMNR  CHAR  20    Communication Number
    Com02      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num02      VARCHAR2(20), --  COMNR CHAR  20    Communication Number
    Com03      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num03      VARCHAR2(20), -- COMNR  CHAR  20    Communication Number
    Com04      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num04      VARCHAR2(20), -- COMNR  CHAR  20    Communication Number
    Com05      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num05      VARCHAR2(20), -- COMNR  CHAR  20    Communication Number
    Com06      VARCHAR2(4), -- COMKY CHAR  4 T536B Communication Type
    Num06      VARCHAR2(20), -- COMNR  CHAR  20    Communication Number
    Indrl      VARCHAR2(5), -- P22J_INDRL  CHAR  2 T577  Indicator for relationship (specification code)
    Counc      VARCHAR2(3), -- COUNC CHAR  3 T005E County Code
    Rctvc      VARCHAR2(6), -- P22J_RCTVC  CHAR  6   Municipal city code
    Or2kk      VARCHAR2(40), -- P22J_ORKK2 CHAR  40    Second address line (Katakana)
    Conkk      VARCHAR2(40), -- P22J_PCNKK CHAR  40    Contact Person (Katakana) (Japan)
    Or1kk      VARCHAR2(40), -- P22J_ORKK1 CHAR  40    First address line (Katakana)
    Railw      VARCHAR2(1), -- RAILW NUMC  1   Social Subscription Railway
    Ifs_State  VARCHAR2(200),
    Ifs_Counc  VARCHAR2(200),
    Ifs_County VARCHAR2(200)
    );
  --HR Master Record: Infotype 0007 (Planned Working Time)
  TYPE Ps0007 IS RECORD(
    -- .INCLUDE  PS0007        HR Master Record: Infotype 0007 (Planned Working Time)
    Schkz VARCHAR2(8), --   SCHKN CHAR  8   Work Schedule Rule
    Zterf VARCHAR2(1), --   PT_ZTERF  NUMC  1 T555U Employee Time Management Status
    Empct VARCHAR2(5), --   EMPCT DEC 5(2)    Employment percentage
    Mostd VARCHAR2(5), --   MOSTD DEC 5(2)    Monthly hours
    Wostd VARCHAR2(5), --   WOSTD DEC 5(2)    Hours per week
    Arbst VARCHAR2(5), --   STDTG DEC 5(2)    Daily Working Hours
    Wkwdy VARCHAR2(4), --   WARST DEC 4(2)    Weekly Workdays
    Jrstd VARCHAR2(7), --   JRSTD DEC 7(2)    Annual working hours
    Teilk VARCHAR2(1), --   TEILK CHAR  1   Indicator Part-Time Employee
    Minta VARCHAR2(5), --   MINTA DEC 5(2)    Minimum number of work hours per day
    Maxta VARCHAR2(5), --   MAXTA DEC 5(2)    Maximum number of work hours per day
    Minwo VARCHAR2(5), --   MINWO DEC 5(2)    Minimum weekly working hours
    Maxwo VARCHAR2(5), --   MAXWO DEC 5(2)    Maximum number of work hours per week
    Minmo VARCHAR2(5), --   MINMO DEC 5(2)    Minimum number of work hours per month
    Maxmo VARCHAR2(5), --   MAXMO DEC 5(2)    Maximum number of work hours per month
    Minja VARCHAR2(7), --   MINJA DEC 7(2)    Minimum annual working hours
    Maxja VARCHAR2(7), --   MAXJA DEC 7(2)    Maximum Number of Working Hours Per Year
    Dysch VARCHAR2(1), --   DYSCH CHAR  1   Create Daily Work Schedule Dynamically
    Kztim VARCHAR2(2), --   KZTIM CHAR  2   Additional indicator for time management
    Wweek VARCHAR2(2), --   WWEEK CHAR  2 T559A Working week
    Awtyp VARCHAR2(5) --  AWTYP CHAR  5   Reference Transaction
    );
  --
  --HR Master Record: Infotype 0008 (Basic Pay)
  TYPE Ps0008 IS RECORD(
    --
    --.INCLUDE  PS0008        HR Master Record: Infotype 0008 (Basic Pay)
    Trfar VARCHAR2(2), --   TRFAR CHAR  2 T510A Pay scale type
    Trfgb VARCHAR2(2), --   TRFGB CHAR  2 T510G Pay Scale Area
    Trfgr VARCHAR2(8), --   TRFGR CHAR  8   Pay Scale Group
    Trfst VARCHAR2(3), --   TRFST CHAR  2   Pay Scale Level
    Stvor VARCHAR2(8), --   STVOR DATS  8   Date of Next Increase
    Orzst VARCHAR2(3), --   ORTZS CHAR  2   Cost of Living Allowance Level
    Partn VARCHAR2(3), --   PARTN CHAR  2 T577  Partnership
    Waers VARCHAR2(5), --   WAERS CUKY  5 TCURC Currency Key
    Vglta VARCHAR2(2), --   VGLTA CHAR  2 T510A Comparison pay scale type
    Vglgb VARCHAR2(2), --   VGLGB CHAR  2 T510G Comparison pay scale area
    Vglgr VARCHAR2(8), --   VGLTG CHAR  8   Comparison pay scale group
    Vglst VARCHAR2(2), --   VGLST CHAR  2   Comparison pay scale level
    Vglsv VARCHAR2(8), --   STVOR DATS  8   Date of Next Increase
    Bsgrd VARCHAR2(5), --   BSGRD DEC 5(2)    Capacity Utilization Level
    Divgv VARCHAR2(5), --   DIVGV DEC 5(2)    Working Hours per Payroll Period
    Ansal VARCHAR2(15), --   ANSAL_15  CURR  15(2)   Annual salary
    Falgk VARCHAR2(10), --   FALGK CHAR  10    Case group catalog
    Falgr VARCHAR2(6), --   FALGR CHAR  6   Case group
    Lga01 VARCHAR2(4), --   LGART CHAR  4 T512Z Wage Type
    Bet01 VARCHAR2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Anz01 VARCHAR2(7), --   ANZHL DEC 7(2)    Number
    Ein01 VARCHAR2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
    Opk01 VARCHAR2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
    Lga02 VARCHAR2(4), --   LGART CHAR  4 T512Z Wage Type
    Bet02 VARCHAR2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Anz02 VARCHAR2(7), --   ANZHL DEC 7(2)    Number
    Ein02 VARCHAR2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
    Opk02 VARCHAR2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
    Lga03 VARCHAR2(4), --   LGART CHAR  4 T512Z Wage Type
    Bet03 VARCHAR2(13), --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Anz03 VARCHAR2(7), --   ANZHL DEC 7(2)    Number
    Ein03 VARCHAR2(3), --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
    Opk03 VARCHAR2(1), --   OPKEN CHAR  1   Operation Indicator for Wage Types
    Ind01 VARCHAR2(1), --   INDBW CHAR  1   Indicator for indirect valuation
    Ind02 VARCHAR2(1), --   INDBW CHAR  1   Indicator for indirect valuation
    Ind03 VARCHAR2(1), --   INDBW CHAR  1   Indicator for indirect valuation
    Ancur VARCHAR2(5), --   ANCUR CUKY  5 TCURC Currency Key for Annual Salary
    Cpind VARCHAR2(1), --   P_CPIND CHAR  1   Planned compensation type
    Flaga VARCHAR2(1) --  FLAG  CHAR  1   General Flag
    );
  --HR Master Record: Infotype 0009 (Bank Details)
  TYPE Ps0009 IS RECORD(
    --.INCLUDE  PS0009        HR Master Record: Infotype 0009 (Bank Details)
    Opken VARCHAR2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
    Betrg VARCHAR2(13), --PAD_VGBTR  CURR  13(2)   Standard value
    Waers VARCHAR2(5), --PAD_WAERS  CUKY  5 TCURC Payment Currency
    Anzhl VARCHAR2(5), --VGPRO  DEC 5(2)    Standard Percentage
    Zeinh VARCHAR2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
    Bnksa VARCHAR2(4), --BNKSA  CHAR  4 T591A Type of Bank Details Record
    Zlsch VARCHAR2(1), --PCODE  CHAR  1 T042Z Payment Method
    Emftx VARCHAR2(40), --EMFTX  CHAR  40    Payee Text
    Bkplz VARCHAR2(10), --BKPLZ  CHAR  10    Postal Code
    Bkort VARCHAR2(25), --ORT01  CHAR  25    City
    Banks VARCHAR2(3), --BANKS  CHAR  3 T005  Bank country key
    Bankl VARCHAR2(15), --BANKK  CHAR  15    Bank Keys
    Bankn VARCHAR2(18), --BANKN  CHAR  18    Bank account number
    Bankp VARCHAR2(2), --BANKP  CHAR  2   Check Digit for Bank No./Account
    Bkont VARCHAR2(2), --BKONT  CHAR  2   Bank Control Key
    Swift VARCHAR2(11), --SWIFT  CHAR  11    SWIFT/BIC for International Payments
    Dtaws VARCHAR2(2), --DTAWS  CHAR  2 T015W Instruction key for data medium exchange
    Dtams VARCHAR2(1), --DTAMS  CHAR  1   Indicator for Data Medium Exchange
    Stcd2 VARCHAR2(11), --STCD2  CHAR  11    Tax Number 2
    Pskto VARCHAR2(16), --PSKTO  CHAR  16    Account Number of Bank Account At Post Office
    Esrnr VARCHAR2(11), --ESRNR  CHAR  11    ISR Subscriber Number
    Esrre VARCHAR2(27), --ESRRE  CHAR  27    ISR Reference Number  ALPHA
    Esrpz VARCHAR2(2), --ESRPZ  CHAR  2   ISR Check Digit
    Emfsl VARCHAR2(8), --EMFSL  CHAR  8   Payee key for bank transfers
    Zweck VARCHAR2(40), --DZWECK CHAR  40    Purpose of Bank Transfers
    Bttyp VARCHAR2(2), --P09_BTTYP  NUMC  2 T5M3T PBS Transfer Type
    Payty VARCHAR2(1), --PAYTY  CHAR  1   Payroll type
    Payid VARCHAR2(1), --PAYID  CHAR  1   Payroll Identifier
    Ocrsn VARCHAR2(4), --PAY_OCRSN  CHAR  4   Reason for Off-Cycle Payroll
    Bondt VARCHAR2(8), --BONDT  DATS  8   Off-cycle payroll payment date
    Bkref VARCHAR2(20), --BKREF  CHAR  20    Reference specifications for bank details
    Stras VARCHAR2(30), --STRAS  CHAR  30    House number and street
    Debit VARCHAR2(1), --P00_XDEBIT_INFTY CHAR  1   Automatic Debit Authorization Indicator
    Iban  VARCHAR2(34) --IBAN CHAR  34    IBAN (International Bank Account Number)
    );
  --HR Master Record: Infotype 0014 (Recur. Payments/Deds.)
  TYPE Ps0014 IS RECORD(
    --.INCLUDE  PS0014        HR Master Record: Infotype 0014 (Recur. Payments/Deds.)
    Lgart VARCHAR2(4), --LGART  CHAR  4 T512Z Wage Type
    Opken VARCHAR2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
    Betrg VARCHAR2(13), --PAD_AMT7S  CURR  13(2)   Wage Type Amount for Payments
    Waers VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
    Anzhl VARCHAR2(7), --ANZHL  DEC 7(2)    Number
    Zeinh VARCHAR2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
    Indbw VARCHAR2(1), --INDBW  CHAR  1   Indicator for indirect valuation
    Zdate VARCHAR2(8), --DZDATE DATS  8   First payment date
    Zfper VARCHAR2(2), --DZFPER NUMC  2   First payment period
    Zanzl VARCHAR2(3), --DZANZL DEC 3   Number for determining further payment dates
    Zeinz VARCHAR2(3), --DZEINZ CHAR  3 T538C Time unit for determining next payment
    Zuord VARCHAR2(20), --UZORD  CHAR  20    Assignment Number
    Uwdat VARCHAR2(8), --UWDAT  DATS  8   Date of Bank Transfer
    Model VARCHAR2(4) --MODE1 CHAR  4 T549W Payment Model
    );
  --HR Master Record: Infotype 0015 (Additional Payments)
  TYPE Ps0015 IS RECORD(
    --.INCLUDE  PS0015        HR Master Record: Infotype 0015 (Additional Payments)
    Lgart VARCHAR2(4), --LGART  CHAR  4 T512Z Wage Type
    Opken VARCHAR2(1), --OPKEN  CHAR  1   Operation Indicator for Wage Types
    Betrg VARCHAR2(13), --PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Waers VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
    Anzhl VARCHAR2(7), --ANZHL  DEC 7(2)    Number
    Zeinh VARCHAR2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
    Indbw VARCHAR2(1), --INDBW  CHAR  1   Indicator for indirect valuation
    Zuord VARCHAR2(20), --UZORD CHAR  20    Assignment Number
    Estdt VARCHAR2(8), --ESTDT  DATS  8   Date of origin
    Pabrj VARCHAR2(4), --PABRJ  NUMC  4   Payroll Year  GJAHR
    Pabrp VARCHAR2(1), --PABRP  NUMC  2   Payroll Period
    Uwdat VARCHAR2(8), --UWDAT  DATS  8   Date of Bank Transfer
    Itftt VARCHAR2(2) --P06I_ITFTT  CHAR  2   Processing type
    );
  --HR Master Record: Infotype 0016 (Contract Elements)
  TYPE Ps0016 IS RECORD(
    --.INCLUDE  PS0016        HR Master Record: Infotype 0016 (Contract Elements)
    Nbtgk    VARCHAR2(1), --NBTGK  CHAR  1   Sideline Job
    Wttkl    VARCHAR2(1), --WTTKL  CHAR  1   Competition Clause
    Lfzfr    VARCHAR2(3), --LFZFR  DEC 3   Period of Continued Pay (Number)
    Lfzzh    VARCHAR2(3), --LFZZH  CHAR  3 T538A Period of Continued Pay (Unit)
    Lfzso    VARCHAR2(2), --LFZSR  NUMC  2   Special Rule for Continued Pay
    Kgzfr    VARCHAR2(3), --KGZFR  DEC 3   Sick Pay Supplement Period (Number)
    Kgzzh    VARCHAR2(3), --KGZZH  CHAR  3 T538A Sick Pay Supplement Period (Unit)
    Prbzt    VARCHAR2(3), --PRBZT  DEC 3   Probationary Period (Number)
    Prbeh    VARCHAR2(3), --PRBEH  CHAR  3 T538A Probationary Period (Unit)
    Kdgfr    VARCHAR2(2), --KDGFR  CHAR  2 T547T Dismissals Notice Period for Employer
    Kdgf2    VARCHAR2(2), --KDGF2  CHAR  2 T547T Dismissals Notice Period for Employee
    Arber    VARCHAR2(8), --ARBER  DATS  8   Expiration Date of Work Permit
    Eindt    VARCHAR2(8), --EINTR  DATS  8   Initial Entry
    Kondt    VARCHAR2(8), --KONDT  DATS  8   Date of Entry into Group
    Konsl    VARCHAR2(2), --KOSL1  CHAR  2 T545T Group Key
    Cttyp    VARCHAR2(2), --CTTYP  CHAR  2 T547V Contract Type
    Ctedt    VARCHAR2(8), --CTEDT  DATS  8   Contract End Date
    Persg    VARCHAR2(1), --PERSG  CHAR  1 T501  Employee Group
    Persk    VARCHAR2(2), --PERSK  CHAR  2 T503K Employee Subgroup
    Wrkpl    VARCHAR2(40), -- WRKPL CHAR  40    Work Location (Contract Elements Infotype)
    Ctbeg    VARCHAR2(8), --CTBEG  DATS  8   Contract Start
    Ctnum    VARCHAR2(20), --PCN_CTNUM  CHAR  20    Contract number
    Objnb    VARCHAR2(12), --OBJNB CHAR  12    Object Number (France)
    Zzdatzaw VARCHAR2(8) --ZZDATZAW
    );
  --HR Master Record: Infotype 0019 (Monitoring of Tasks)
  TYPE Ps0019 IS RECORD(
    --.INCLUDE  PS0019        HR Master Record: Infotype 0019 (Monitoring of Tasks)
    Tmart VARCHAR2(2), --TMART  CHAR  2 T531  Task Type
    Termn VARCHAR2(8), --TERMN  DATS  8   Date of Task
    Mndat VARCHAR2(8), --MNDAT  DATS  8   Reminder Date
    Bvmrk VARCHAR2(1), --BVMRK  CHAR  1   Processing indicator
    Tmjhr VARCHAR2(4), --TMJHR  NUMC  4   Year of date  GJAHR
    Tmmon VARCHAR2(2), --TMMON  NUMC  2   Month of date
    Tmtag VARCHAR2(2), --TMTAG  NUMC  2   Day of date
    Mnjhr VARCHAR2(4), --MNJHR  NUMC  4   Year of reminder  GJAHR
    Mnmon VARCHAR2(2), --MNMON  NUMC  2   Month of reminder
    Mntag VARCHAR2(2), --MNTAG NUMC  2   Day of reminder
    Ctext VARCHAR2(200) -- cluster texts
    );
  --HR Master Record: Infotype 0021 (Family)
  TYPE Ps0021 IS RECORD(
    --.INCLUDE  PS0021        HR Master Record: Infotype 0021 (Family)
    Famsa VARCHAR2(4), --FAMSA  CHAR  4   Type of Family Record
    Fgbdt VARCHAR2(8), --GBDAT  DATS  8   Date of Birth PDATE
    Fgbld VARCHAR2(3), --GBLND  CHAR  3 T005  Country of Birth
    Fanat VARCHAR2(3), --NATSL  CHAR  3 T005  Nationality
    Fasex VARCHAR2(1), --GESCH  CHAR  1   Gender Key
    Favor VARCHAR2(40), --PAD_VORNA  CHAR  40    First Name
    Fanam VARCHAR2(40), --PAD_NACHN  CHAR  40    Last Name
    Fgbot VARCHAR2(40), --PAD_GBORT  CHAR  40    Birthplace
    Fgdep VARCHAR2(3), --GBDEP  CHAR  3 T005S State
    Erbnr VARCHAR2(12), --ERBNR  CHAR  12    Reference Personnel Number for Family Member
    Fgbna VARCHAR2(40), --PAD_NAME2  CHAR  40    Name at Birth
    Fnac2 VARCHAR2(40), --PAD_NACH2  CHAR  40    Second Name
    Fcnam VARCHAR2(80), --PAD_CNAME  CHAR  80    Complete Name
    Fknzn VARCHAR2(2), --KNZNM  NUMC  2   Name Format Indicator for Employee in a List
    Finit VARCHAR2(10), --INITS  CHAR  10    Initials
    Fvrsw VARCHAR2(15), --VORSW  CHAR  15  T535N Name Prefix
    Fvrs2 VARCHAR2(15), --VORSW  CHAR  15  T535N Name Prefix
    Fnmzu VARCHAR2(15), --NAMZU  CHAR  15  T535N Other Title
    Ahvnr VARCHAR2(11), --AHVNR  CHAR  11    AHV Number  AHVNR
    Kdsvh VARCHAR2(2), --KDSVH  CHAR  2 T577  Relationship to Child
    Kdbsl VARCHAR2(2), --KDBSL  CHAR  2 T577  Allowance Authorization
    Kdutb VARCHAR2(2), --KDUTB  CHAR  2 T577  Address of Child
    Kdgbr VARCHAR2(2), --KDGBR  CHAR  2 T577  Child Allowance Entitlement
    Kdart VARCHAR2(2), --KDART  CHAR  2 T577  Child Type
    Kdzug VARCHAR2(2), --KDZUG  CHAR  2 T577  Child Bonuses
    Kdzul VARCHAR2(2), --KDZUL  CHAR  2 T577  Child Allowances
    Kdvbe VARCHAR2(2), --KDVBE  CHAR  2 T577  Sickness Certificate Authorization
    Ermnr VARCHAR2(8), --ERMNR  CHAR  8   Authority Number
    Ausvl VARCHAR2(4), --AUSVL  NUMC  4   1st Part of SI Number (Sequential Number)
    Ausvg VARCHAR2(8), --AUSVG  NUMC  8   2nd Part of SI Number (Birth Date)
    Fasdt VARCHAR2(8), --FASDT  DATS  8   End of Family Members Education/Training
    Fasar VARCHAR2(2), --FASAR  CHAR  2 T517T School Type of Family Member
    Fasin VARCHAR2(20), --FASIN  CHAR  20    Educational Institute
    Egaga VARCHAR2(8), --EGAGA  CHAR  8   Employer of Family Member
    Fana2 VARCHAR2(3), --NATS2  CHAR  3 T005  Second Nationality
    Fana3 VARCHAR2(3), --NATS3  CHAR  3 T005  Third Nationality
    Betrg VARCHAR2(9), --BETRG  CURR  9(2)    Amount
    Titel VARCHAR2(15), --TITEL  CHAR  15  T535N Title
    Emrgn VARCHAR2(1) --PAD_EMRGN  CHAR  1   Emergency Contact
    );
  --HR Master Record: Infotype 0022 (Education)
  TYPE Ps0022 IS RECORD(
    --.INCLUDE  PS0022        HR Master Record: Infotype 0022 (Education)
    Slart VARCHAR2(2), --SLART  CHAR  2 T517T Educational establishment
    Insti VARCHAR2(80), --INSTI  CHAR  80    Institute/location of training
    Sland VARCHAR2(3), --LAND1  CHAR  3 T005  Country Key
    Ausbi VARCHAR2(8), --AUSBI  NUMC  8 T518A Education/training
    Slabs VARCHAR2(2), --SLABS  CHAR  2 T519T Certificate
    Anzkl VARCHAR2(3), --ANZKL  DEC 3   Duration of training course
    Anzeh VARCHAR2(3), --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
    Sltp1 VARCHAR2(5), --FACH1  NUMC  5 T517Y Branch of study
    Sltp2 VARCHAR2(5), --FACH2  NUMC  5 T517Y Branch of study
    Jbez1 VARCHAR2(11), --KSGEB  CURR  11(2)   Course fees
    Waers VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
    Slpln VARCHAR2(1), --KSPLN  CHAR  1   Planned course (unused)
    Slktr VARCHAR2(2), --SLKTR  CHAR  2   Cost object (unused)
    Slrzg VARCHAR2(1), --SLRZG  CHAR  1   Repayment obligation
    Ksbez VARCHAR2(25), --KSBEZ  CHAR  25    Course name
    Tx122 VARCHAR2(40), --KSBUR  CHAR  40    Course appraisal
    Schcd VARCHAR2(10), --P22J_SCHCD NUMC  10    Institute/school code
    Faccd VARCHAR2(3), --P22J_FACCD NUMC  3   Faculty code
    Dptmt VARCHAR2(40), -- DPTMT CHAR  40    Department
    Emark VARCHAR2(4) --EMARK CHAR  4   Final Grade
    );
  --HR Master Record: Infotype 0023 (Other/Previous Employers)
  TYPE Ps0023 IS RECORD(
    --.INCLUDE  PS0023        HR Master Record: Infotype 0023 (Other/Previous Employers)
    Arbgb   VARCHAR2(60), --VORAG  CHAR  60    Name of employer
    Ort01   VARCHAR2(25), --ORT01  CHAR  25    City
    Land1   VARCHAR2(3), --LAND1  CHAR  3 T005  Country Key
    Branc   VARCHAR2(4), --BRSCH  CHAR  4 T016  Industry key
    Taete   VARCHAR2(8), --TAETE  NUMC  8 T513C Job at former employer(s)
    Ansvx   VARCHAR2(2), --ANSVX  CHAR  2 T542C Work Contract - Other Employers
    Ortj1   VARCHAR2(40), --P22J_ADDR1 CHAR  40    First address line (Kanji)
    Ortj2   VARCHAR2(40), --P22J_ADDR2 CHAR  40    Second address line (Kanji)
    Ortj3   VARCHAR2(40), --P22J_ADDR3  CHAR  40    Third address line (Kanji)
    Ifs_Sen VARCHAR2(200) -- ifs seniority type
    );
  --HR Master Record: Infotype 0024 (Qualifications)
  TYPE Ps0024 IS RECORD(
    --.INCLUDE  PS0024        HR Master Record: Infotype 0024 (Qualifications)
    Quali VARCHAR2(8), --QUALI_D  NUMC  8 T574A Qualification key
    Auspr VARCHAR2(4) --CHARA NUMC  4 T778Q Proficiency of a Qualification/Requirement
    );
  --HR Master Record: Infotype 0105 (Komunikacje)
  TYPE Ps0105 IS RECORD(
    --.INCLUDE  PS0105        Rekord danych podst. HR: Typ informacji 0105 (Komunikacje)
    Usrty      VARCHAR2(4), --USRTY  CHAR  4 0 Rodzaj komunikacji
    Usrid      VARCHAR2(30), --SYSID  CHAR  30  0 Komunikacja - ID/numer
    Usrid_Long VARCHAR2(241) --COMM_ID_LONG  CHAR  241 0 Komunikacja - d³uga identyfikacja/numer
    );
  --Personnel Master Record Infotype 0185 (Identification SEA)
  TYPE Ps0185 IS RECORD(
    --.INCLUDE  PS0185        Personnel Master Record Infotype 0185 (Identification SEA)
    Ictyp VARCHAR2(2), -- ICTYP CHAR  2 T5R05 Type of identification (IC type)
    Icnum VARCHAR2(30), -- PSG_IDNUM CHAR  30    Identity Number
    Icold VARCHAR2(20), -- ICOLD CHAR  20    Old IC number
    Auth1 VARCHAR2(30), -- P25_AUTH1 CHAR  30    Issuing authority
    Docn1 VARCHAR2(20), -- ISNUM CHAR  20    Document issuing number
    Fpdat VARCHAR2(8), -- PSG_FPDAT DATS  8   Date of issue for personal ID
    Expid VARCHAR2(8), -- EXPID DATS  8   ID expiry date
    Isspl VARCHAR2(30), -- P25_ISSPL CHAR  30    Place of issue of Identification
    Iscot VARCHAR2(3), -- P25_ISCOT CHAR  3 T005  Country of issue
    Idcot VARCHAR2(3), -- P25_IDCOT CHAR  3 T005  Country of ID
    Ovchk VARCHAR2(1), -- P25_OVCHK CHAR  1   Indicator for overriding consistency check
    Astat VARCHAR2(1), -- PCN_ASTAT CHAR  1   Application status
    Akind VARCHAR2(1), -- P25_AKIND CHAR  1   Single/multiple
    Rejec VARCHAR2(20), -- P25_REJEC CHAR  20    Reject reason
    Usefr VARCHAR2(8), -- P25_USEFR DATS  8   Used from -date
    Useto VARCHAR2(8), -- P25_USETO DATS  8   Used to -date
    Daten VARCHAR2(3), -- P25_DATEN DEC 3   Valid length of multiple visa
    Dateu VARCHAR2(3), -- DZEINZ  CHAR  3 T538A Time unit for determining next payment
    Times VARCHAR2(8) --  P25_TIMES DATS  8   Application date
    );
  --HR Master Record: Infotype 0041 (Date Specifications)
  TYPE Ps0041 IS RECORD(
    --.INCLUDE  PS0041        HR Master Record: Infotype 0041 (Date Specifications)
    Dar01 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat01 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar02 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat02 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar03 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat03 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar04 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat04 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar05 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat05 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar06 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat06 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar07 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat07 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar08 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat08 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar09 VARCHAR2(2), -- DATAR CHAR  2 T548Y Date type
    Dat09 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar10 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat10 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar11 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat11 VARCHAR2(8), --DARDT  DATS  8   Date for date type
    Dar12 VARCHAR2(2), --DATAR  CHAR  2 T548Y Date type
    Dat12 VARCHAR2(8) --DARDT  DATS  8   Date for date type
    );
  --PA0267 SAP HR Master Record: Infotype 0267 (One time Payment off-cycle)
  TYPE Ps0267 IS RECORD(
    --INCLUDE PS0267        HR Master Record: Infotype 0267 (One time payment off-cycle)
    Lgart VARCHAR2(4), -- LGART CHAR  4 T512Z Wage Type
    Opken VARCHAR2(1), -- OPKEN CHAR  1   Operation Indicator for Wage Types
    Betrg VARCHAR2(13), --  PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Waers VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
    Anzhl VARCHAR2(7), -- ANZHL DEC 7(2)    Number
    Zeinh VARCHAR2(3), --PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
    Indbw VARCHAR2(1), -- INDBW CHAR  1   Indicator for indirect valuation
    Zuord VARCHAR2(20), --  UZORD CHAR  20    Assignment Number
    Estdt VARCHAR2(8), -- ESTDT DATS  8   Date of origin
    Pabrj VARCHAR2(4), -- PABRJ NUMC  4   Payroll Year  GJAHR
    Pabrp VARCHAR2(2), -- PABRP NUMC  2   Payroll Period
    Uwdat VARCHAR2(8), -- UWDAT DATS  8   Date of Bank Transfer
    Payty VARCHAR2(1), -- PAYTY CHAR  1   Payroll type
    Payid VARCHAR2(1), -- PAYID CHAR  1   Payroll Identifier
    Ocrsn VARCHAR2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
    --
    Zzdatz   VARCHAR2(8),
    Zztekst1 VARCHAR2(100),
    Zztekst2 VARCHAR2(100),
    Zztekst3 VARCHAR2(100),
    Zztekst4 VARCHAR2(100));
  --HR Master Record: Infotype 0413 (Tax Data PL)
  TYPE Ps0413 IS RECORD(
    --.INCLUDE  PS0413        HR Master Record: Infotype 0413 (Tax Data PL)
    Toidn VARCHAR2(4), -- PPL_TOIDN CHAR  4 T7PL01  Tax office ID number
    Costr VARCHAR2(2), -- PPL_COSTR CHAR  2 T7PL20  Cost counting rule
    Contr VARCHAR2(2), -- PPL_CONTR CHAR  2 T7PL30  Free amount rule
    Dnind VARCHAR2(1) --  PPL_DNIND CHAR  1   Threshold down indicator
    );
  --HR Master Record: Infotype 0414
  TYPE Ps0414 IS RECORD(
    --.INCLUDE  PS0414        HR Master Record: Infotype 0414
    Scd01 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid01 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy01 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm01 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd01 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd02 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid02 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy02 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm02 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd02 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd03 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid03 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy03 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm03 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd03 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd04 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid04 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy04 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm04 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd04 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd05 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid05 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy05 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm05 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd05 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd06 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid06 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy06 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm06 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd06 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Scd07 VARCHAR2(2), -- PPL_SENCD CHAR  2   Seniority code
    Sid07 VARCHAR2(1), -- PPL_SENID CHAR  1   Seniority identifier
    Syy07 VARCHAR2(2), -- PPL_SENYY NUMC  2   Seniority period - years
    Smm07 VARCHAR2(2), -- PPL_SENMM NUMC  2   Seniority period - months
    Sdd07 VARCHAR2(3), -- PPL_SENDD NUMC  3   Seniority period - days
    --
    Pertx VARCHAR2(50), -- PPL_PERTX CHAR  50    Period description
    Ldper VARCHAR2(7), -- PPL_LDPER DEC 7(5)    Leave days at previous employer
    Evrp6 VARCHAR2(1), -- PPL_EVRP6 CHAR  1 T7PLA0  Evidence for RP-6 form code
    Flflg VARCHAR2(1), -- PPL_FLFLG CHAR  1   First leave after 12 months flag
    Rldpr VARCHAR2(6), -- PPL_RLDPR DEC 6(5)    Requested leave days at previous employer
    Feflg VARCHAR2(1), -- PPL_FEFLG CHAR  1   First employment flag
    Chall VARCHAR2(7), -- PPL_CHALL DEC 7(5)    Child Care Leave Deduction
    Famal VARCHAR2(7), -- PPL_FAMAL DEC 7(5)    Family member care leave
    Chl14 VARCHAR2(7), -- PPL_CHL14 DEC 7(5)    Utilized Child Allowance < 14 years old
    Pturn VARCHAR2(1), -- PPL_PTURN CHAR  1   Deduction rehabilitation leave for previous employer
    Leape VARCHAR2(7), -- PPL_LEAPE DEC 7(5)    Leave taken over from previous employer
    Genle VARCHAR2(1) -- PPL_GENLE  CHAR  1   Forcing leave generation
    );
  --HR Master Record: Infotype 0515 (SI Add. Data PL)
  TYPE Ps0515 IS RECORD(
    --.INCLUDE  PS0515        HR Master Record: Infotype 0515 (SI Add. Data PL)
    Podst     VARCHAR2(4), --PPL_PODST CHAR  4 T7PL40  Code of basic subject with extension
    Erlrt     VARCHAR2(1), -- PPL_ERLRT CHAR  1   Pension right type
    Stpns     VARCHAR2(1), -- PPL_STPNS CHAR  1   Disability level
    Ruser     VARCHAR2(1), -- PPL_RUSER CHAR  1   Pension and disability insurance
    Rusch     VARCHAR2(1), -- PPL_RUSCH CHAR  1   Incapability insurance
    Ruswp     VARCHAR2(1), -- PPL_RUSWP CHAR  1   Accident insurance
    Ruszr     VARCHAR2(1), -- PPL_RUSZR CHAR  1   Health insurance
    Dzukc     VARCHAR2(8), -- PPL_DZUKC DATS  8   Date of contract with health fund
    Nsbeg     VARCHAR2(8), -- PPL_NSBEG DATS  8   Begin date of disability level
    Ksach     VARCHAR2(3), --PPL_KSACH CHAR  3   NFZ departament code
    Nsend     VARCHAR2(8), --PPL_NSEND DATS  8   End date of disability level
    Illcs     VARCHAR2(3), --PPL_ILLCS NUMC  3   Days of continuous sickness period
    Allpe     VARCHAR2(3), --PPL_ALLPE NUMC  3   Allowance period days
    Sibln     VARCHAR2(1), --PPL_SIBLN CHAR  1   Std./extd. allowance base period lenght
    Soeln     VARCHAR2(1), -- PPL_SOELN CHAR  1   Std./extd. allowance base period lenght
    Waitp     VARCHAR2(8), -- PPL_WAITP DATS  8   End date of waiting period
    Limtp     VARCHAR2(8), -- PPL_LIMTP DATS  8   End date of limited base period
    Illpr     VARCHAR2(2), -- PPL_ILLPR DEC 2   Sick days at previous employer
    Addit     VARCHAR2(4), -- PPL_ADDIT CHAR  4 T7PL40  Code of additional subject
    Addbr     VARCHAR2(1), -- PPL_ADDBR CHAR  1   Additional insurance title break code
    Dis_Leave VARCHAR2(8), -- PPL_DIS_LEAVE_FROM  DATS  8   Additional leave for disabled first date
    Model_Id  VARCHAR2(2), --  PPL_MODEL CHAR  2 T7PLZLA_MOD Model ID for PLZLA
    Nozdr     VARCHAR2(1) --  PPL_NOZDR CHAR  1   Parental leave without health insurance
    );
  TYPE Ps0517 IS RECORD(
    --.INCLUDE  PS0517        HR Master Record: Infotype 0517
    Stras VARCHAR2(60), --PAD_STRAS CHAR  60    Street and House Number
    Hsnmr VARCHAR2(10), --PAD_HSNMR CHAR  10    House Number
    Posta VARCHAR2(10), --PAD_POSTA CHAR  10    Identification of an apartment in a building
    Pstlz VARCHAR2(10), --PSTLZ_HR  CHAR  10    Postal Code
    Ort01 VARCHAR2(40), --PAD_ORT01 CHAR  40    City
    Ort02 VARCHAR2(40), --PAD_ORT02 CHAR  40    District
    State VARCHAR2(3), --REGIO CHAR  3 Region (State, Province, County)
    Counc VARCHAR2(3), --COUNC CHAR  3 T005E County Code
    Land1 VARCHAR2(3), --LAND1 CHAR  3 T005  Country Key
    Telnr VARCHAR2(14), --TELNR CHAR  14    Telephone Number
    Pesel VARCHAR2(11), --PPL_PESEL CHAR  11    PESEL number
    Nip00 VARCHAR2(10), --PPL_NIP00 CHAR  10    NIP number
    Ruszr VARCHAR2(1), --PPL_UZCZR CHAR  1   Health insurance of family member
    Cnadr VARCHAR2(1), --PPL_CNADR CHAR  1   Relevancy of family member address
    Exsup VARCHAR2(1), --PPL_EXSUP CHAR  1   Exclusive support of family member
    Cnhld VARCHAR2(1), --PPL_CNHLD CHAR  1   Common household with family member
    Ictyp VARCHAR2(2), --ICTYP CHAR  2   Type of identification (IC type)
    Icnum VARCHAR2(20), --PPL_ICNUM CHAR  20    IC number
    Stpns VARCHAR2(1), --PPL_STPNS CHAR  1   Disability level
    Tery2 VARCHAR2(3), --PPL_TERY2 CHAR  3 T7PLE2  Municipality GUS code according to TERYT
    Zcnac VARCHAR2(2) -- family type
    );
  --IT0558 - Additional personal data PL
  TYPE Ps0558 IS RECORD(
    --.INCLUDE  PS0558        IT0558 - Additional personal data PL
    Fathn VARCHAR2(40), -- PPL_FATHN CHAR  40    Fathers first name
    Mothn VARCHAR2(40), -- PPL_MOTHN CHAR  40    Mothers first name
    Mbnam VARCHAR2(40), -- PPL_MBRTN CHAR  40    Mothers birth name
    Pesel VARCHAR2(11), --PPL_PESEL CHAR  11    PESEL number
    Nip00 VARCHAR2(10), --PPL_NIP00 CHAR  10    NIP number
    Onpit VARCHAR2(1) --  PPL_ONPIT CHAR  1   Output NIP instead of PESEL on PIT forms
    );
  --PS0866        Education PL
  TYPE Ps0866 IS RECORD(
    --.INCLUDE  PS0866        Education PL
    Beg_Sch   VARCHAR2(8), --PPL_BEG_SCH  DATS  8   School start
    End_Sch   VARCHAR2(8), --PPL_END_SCH DATS  8   School end date
    Ifs_Subty VARCHAR(2) --necessary to map education year
    );
  --PS2001        Personnel Time Record: Infotype 2001 (Absences)
  TYPE Ps2001 IS RECORD(
    --.INCLUDE  PS2001        Personnel Time Record: Infotype 2001 (Absences)
    Beguz  VARCHAR2(6), --   BEGTI TIMS  6   Start Time
    Enduz  VARCHAR2(6), -- ENDTI TIMS  6   End Time
    Vtken  VARCHAR2(1), -- VTKEN CHAR  1   Previous Day Indicator
    Awart  VARCHAR2(4), -- AWART CHAR  4 T554S Attendance or Absence Type
    Abwtg  VARCHAR2(6), -- ABWTG DEC 6(2)    Attendance and Absence Days
    Stdaz  VARCHAR2(7), -- ABSTD DEC 7(2)    Absence hours
    Abrtg  VARCHAR2(6), -- ABRTG DEC 6(2)    Payroll days
    Abrst  VARCHAR2(7), -- ABRST DEC 7(2)    Payroll hours
    Anrtg  VARCHAR2(6), -- ANRTG DEC 6(2)    Days credited for continued pay
    Lfzed  VARCHAR2(8), -- LFZED DATS  8   End of continued pay
    Krged  VARCHAR2(8), -- KRGED DATS  8   End of sick pay
    Kbbeg  VARCHAR2(8), -- KBBEG DATS  8   Certified start of sickness
    Rmdda  VARCHAR2(8), -- RMDDA DATS  8   Date on which illness was confirmed
    Kenn1  VARCHAR2(2), -- KENN1 DEC 2   Indicator for Subsequent Illness
    Kenn2  VARCHAR2(2), -- KENN2 DEC 2   Indicator for repeated illness
    Kaltg  VARCHAR2(6), -- KALTG DEC 6(2)    Calendar days
    Urman  VARCHAR2(1), -- URMAN CHAR  1   Indicator for manual leave deduction
    Begva  VARCHAR2(4), -- BEGVA NUMC  4   Start year for leave deduction  GJAHR
    Bwgrl  VARCHAR2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
    Aufkz  VARCHAR2(1), -- AUFKN CHAR  1   Extra Pay Indicator
    Trfgr  VARCHAR2(8), -- TRFGR CHAR  8   Pay Scale Group
    Trfst  VARCHAR2(2), -- TRFST CHAR  2   Pay Scale Level
    Prakn  VARCHAR2(2), -- PRAKN CHAR  2 T510P Premium Number
    Prakz  VARCHAR2(4), -- PRAKZ NUMC  4   Premium Indicator
    Otype  VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
    Plans  VARCHAR2(8), -- PLANS NUMC  8 T528B Position
    Mldda  VARCHAR2(8), -- MLDDA DATS  8   Reported on
    Mlduz  VARCHAR2(6), -- MLDUZ TIMS  6   Reported at
    Rmduz  VARCHAR2(6), -- RMDUZ TIMS  6   Sickness confirmed at
    Vorgs  VARCHAR2(15), -- VORGS CHAR  15    Superior Out Sick (Illness)
    Umskd  VARCHAR2(6), -- UMSKD CHAR  6   Code for description of illness
    Umsch  VARCHAR2(20), -- UMSCH CHAR  20    Description of illness
    Refnr  VARCHAR2(8), -- RFNUM CHAR  8   Reference number
    Unfal  VARCHAR2(1), -- UNFAL CHAR  1   Absent due to accident?
    Stkrv  VARCHAR2(4), -- STKRV CHAR  4   Subtype for sickness tracking
    Stund  VARCHAR2(4), -- STUND CHAR  4   Subtype for accident data
    Psarb  VARCHAR2(4), -- PSARB DEC 4(2)    Work capacity percentage
    Ainft  VARCHAR2(4), -- AINFT CHAR  4 T582A Infotype that maintains 2001
    Gener  VARCHAR2(1), -- PGENER  CHAR  1   Generation flag
    Hrsif  VARCHAR2(1), -- HRS_INPFL CHAR  1   Set number of hours
    Alldf  VARCHAR2(1), -- ALLDF CHAR  1   Record is for Full Day
    Waers  VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
    Logsys VARCHAR2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
    Awtyp  VARCHAR2(5), -- AWTYP CHAR  5   Reference Transaction
    Awref  VARCHAR2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
    Aworg  VARCHAR2(10), -- AWORG CHAR  10    Reference Organizational Units
    Docsy  VARCHAR2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
    Docnr  VARCHAR2(20), -- PTM_DOCNR NUMC  20    Document number for time data
    Payty  VARCHAR2(1), -- PAYTY CHAR  1   Payroll type
    Payid  VARCHAR2(1), -- PAYID CHAR  1   Payroll Identifier
    Bondt  VARCHAR2(8), -- BONDT DATS  8   Off-cycle payroll payment date
    Ocrsn  VARCHAR2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
    Sppe1  VARCHAR2(8), -- SPPEG DATS  8   End date for continued pay
    Sppe2  VARCHAR2(8), -- SPPEG DATS  8   End date for continued pay
    Sppe3  VARCHAR2(8), -- SPPEG DATS  8   End date for continued pay
    Sppin  VARCHAR2(1), -- SPPIN CHAR  1   Indicator for manual modifications
    Zkmkt  VARCHAR2(1), -- P05_ZKMKT_EN  CHAR  1   Status of Sickness Notification
    Faprs  VARCHAR2(2), -- FAPRS CHAR  2 T554H Evaluation Type for Attendances/Absences
    --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
    Tdlangu VARCHAR2(10), -- TMW_TDLANGU CHAR  10    Definition Set for IDs
    Tdsubla VARCHAR2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
    Tdtype  VARCHAR2(4), -- TDTYPE CHAR  4   Time Data ID Type TDTYP
    Nxdfl   VARCHAR2(1), -- PTM_NXDFL  CHAR  1   Next Day Indicator
    --
    Ifs_Seqnr NUMBER);
  -- .INCLUDE PS2003        HR Time Record: Infotype 2003 (Substitutions)
  TYPE Ps2003 IS RECORD(
    Beguz VARCHAR2(6), --BEGUZ  TIMS  6   Start Time
    Enduz VARCHAR2(6), --ENDUZ  TIMS  6   End Time
    Vtken VARCHAR2(1), --VTKEN  CHAR  1   Previous Day Indicator
    Vtart VARCHAR2(2), --VTART  CHAR  2 T556  Substitution Type
    Stdaz VARCHAR2(7), --VTSTD  DEC 7(2)    Substitution hours
    Pamod VARCHAR2(5), --PAMOD  CHAR  4 T550P Work Break Schedule
    Pbeg1 VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
    Pend1 VARCHAR2(6), --PDEND  TIMS  6   End of Break
    Pbez1 VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
    Punb1 VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
    Pbeg2 VARCHAR2(6), --PDBEG  TIMS  6   Start of Break
    Pend2 VARCHAR2(6), --PDEND  TIMS  6   End of Break
    Pbez2 VARCHAR2(4), --PDBEZ  DEC 4(2)    Paid Break Period
    Punb2 VARCHAR2(4), --PDUNB  DEC 4(2)    Unpaid Break Period
    Zeity VARCHAR2(1), --DZEITY CHAR  1   Employee Subgroup Grouping for Work Schedules
    Mofid VARCHAR2(2), --HIDENT CHAR  2 THOCI Public Holiday Calendar
    Mosid VARCHAR2(2), --MOSID  NUMC  2 T508Z Personnel Subarea Grouping for Work Schedules
    Schkz VARCHAR2(8), --SCHKN  CHAR  8 T508A Work Schedule Rule
    Motpr VARCHAR2(2), --MOTPR  NUMC  2   Personnel Subarea Grouping for Daily Work Schedules
    Tprog VARCHAR2(4), --TPROG  CHAR  4 T550A Daily Work Schedule
    Varia VARCHAR2(1), --VARIA  CHAR  1   Daily Work Schedule Variant
    Tagty VARCHAR2(1), -- TAGTY CHAR  1 T553T Day Type
    Tpkla VARCHAR2(1), --TPKLA  CHAR  1   Daily Work Schedule Class
    Vpern VARCHAR2(8), --VPERN  NUMC  8   Substitute Personnel Number
    Aufkz VARCHAR2(1), --AUFKN  CHAR  1   Extra Pay Indicator
    Bwgrl VARCHAR2(13), --PTM_VBAS7S CURR  13(2)   Valuation Basis for Different Payment
    Trfgr VARCHAR2(8), --TRFGR  CHAR  8   Pay Scale Group
    Trfst VARCHAR2(2), --TRFST  CHAR  2 Pay Scale Level
    Prakn VARCHAR2(2), --PRAKN  CHAR  2 T510P Premium Number
    Prakz VARCHAR2(4), --PRAKZ  NUMC  4   Premium Indicator
    Otype VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
    Plans VARCHAR2(8), --PLANS  NUMC  8   Position
    Exbel VARCHAR2(8), --EXBEL  CHAR  8   External Document Number
    Waers VARCHAR2(5), --WAERS  CUKY  5 TCURC Currency Key
    Wtart VARCHAR2(4), --WTART  CHAR  4   Work tax area
    --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
    Tdlangu VARCHAR2(10), --TMW_TDLANGU  CHAR  10    Definition Set for IDs
    Tdsubla VARCHAR2(3), --TMW_TDSUBLA  CHAR  3   Definition Subset for IDs
    Tdtype  VARCHAR2(4), --TDTYPE  CHAR  4   Time Data ID Type TDTYP
    Logsys  VARCHAR2(10), --LOGSYS  CHAR  10  Logical system  ALPHA
    Awtyp   VARCHAR2(5), --AWTYP  CHAR  5   Reference Transaction
    Awref   VARCHAR2(10), --AWREF  CHAR  10    Reference Document Number ALPHA
    Aworg   VARCHAR2(10), --AWORG  CHAR  10    Reference Organizational Units
    Nxdfl   VARCHAR2(1), --PTM_NXDFL  CHAR  1   Next Day Indicator
    Ftkla   VARCHAR2(1) --FTKLA  CHAR  1   Public holiday class
    );
  --PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
  TYPE Ps2006 IS RECORD(
    --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
    Beguz VARCHAR2(6), -- BEGTI TIMS  6   Start Time
    Enduz VARCHAR2(6), -- ENDTI TIMS  6   End Time
    Vtken VARCHAR2(1), -- VTKEN CHAR  1   Previous Day Indicator
    Ktart VARCHAR2(2), -- ABWKO NUMC  2 T556A Absence Quota Type
    Anzhl VARCHAR2(10), -- PTM_QUONUM  DEC 10(5)   Number of Employee Time Quota
    Kverb VARCHAR2(10), -- PTM_QUODED  DEC 10(5)   Deduction of Employee Time Quota
    Quonr VARCHAR2(20), -- PTM_QUONR NUMC  20    Counter for time quotas
    Desta VARCHAR2(8), -- PTM_DEDSTART  DATS  8   Start Date for Quota Deduction
    Deend VARCHAR2(8), -- PTM_DEDEND  DATS  8   Quota Deduction to
    Quosy VARCHAR2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
    --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
    Tdlangu VARCHAR2(10), -- TMW_TDLANGU CHAR  10  Definition Set for IDs
    Tdsubla VARCHAR2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
    Tdtype  VARCHAR2(4) -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
    );
  --INCLUDE PS2010        HR Time Record: Infotype 2010 (Employee Remuneration Info.)
  TYPE Ps2010 IS RECORD(
    --.INCLUDE  PS2010        HR Time Record: Infotype 2010 (Employee Remuneration Info.)
    Beguz  VARCHAR2(6), -- BEGTI TIMS  6   Start Time
    Enduz  VARCHAR2(6), -- ENDTI TIMS  6   End Time
    Vtken  VARCHAR2(1), -- VTKEN CHAR  1   Previous Day Indicator
    Stdaz  VARCHAR2(12), -- ENSTD DEC 7(2)    No.of hours for remuneration info.
    Lgart  VARCHAR2(4), -- LGART CHAR  4   Wage Type
    Anzhl  VARCHAR2(7), -- ENANZ DEC 7(2)    Number per Time Unit for EE Remuneration Info
    Zeinh  VARCHAR2(3), -- PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
    Bwgrl  VARCHAR2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
    Aufkz  VARCHAR2(1), --   AUFKN CHAR  1   Extra Pay Indicator
    Betrg  VARCHAR2(13), -- PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
    Endof  VARCHAR2(1), -- ENDOF CHAR  1   Indicator for final confirmation
    Ufld1  VARCHAR2(1), -- USFLD CHAR  1   User field
    Ufld2  VARCHAR2(1), -- USFLD CHAR  1   User field
    Ufld3  VARCHAR2(1), --   USFLD CHAR  1   User field
    Keypr  VARCHAR2(3), -- KEYPR CHAR  3   Number of Infotype Record with Identical Key
    Trfgr  VARCHAR2(8), -- TRFGR CHAR  8   Pay Scale Group
    Trfst  VARCHAR2(2), -- TRFST CHAR  2   Pay Scale Level
    Prakn  VARCHAR2(2), -- PRAKN CHAR  2 T510P Premium Number
    Prakz  VARCHAR2(4), -- PRAKZ NUMC  4   Premium Indicator
    Otype  VARCHAR2(2), -- OTYPE CHAR  2 T778O Object Type
    Plans  VARCHAR2(8), -- PLANS NUMC  8 T528B Position
    Versl  VARCHAR2(1), -- VRSCH CHAR  1 T555R Overtime Compensation Type
    Exbel  VARCHAR2(8), -- EXBEL CHAR  8   External Document Number
    Waers  VARCHAR2(5), -- WAERS CUKY  5 TCURC Currency Key
    Logsys VARCHAR2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
    Awtyp  VARCHAR2(5), -- AWTYP CHAR  5   Reference Transaction
    Awref  VARCHAR2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
    Aworg  VARCHAR2(10), -- AWORG CHAR  10    Reference Organizational Units
    Wtart  VARCHAR2(4), -- WTART CHAR  4 T5UTB Work tax area
    --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
    Tdlangu VARCHAR2(10), -- TMW_TDLANGU CHAR  10  Definition Set for IDs
    Tdsubla VARCHAR2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
    Tdtype  VARCHAR2(4) -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
    );
  --PS9950       Brakuj¹ce dokumenty
  TYPE Ps9950 IS RECORD(
    --.INCLUDE    PS9950       Brakuj¹ce dokumenty
    Zzempque VARCHAR2(1), --+  Kwestionariusz osobowy 1 +
    Zzempcon VARCHAR2(1), --+  Umowa o pracê 2
    Zzjobdes VARCHAR2(1), --+  Zakres obowi¹zków 3
    Zzworper VARCHAR2(1), --+  Pozwolenie na pracê 4
    Zzworcer VARCHAR2(1), --+  Œwiadectwo pracy 5
    Zzdiplom VARCHAR2(1), --+  Dyplom 6
    Zzmedexa VARCHAR2(1), --+  Badania lekarskie 7
    Zzbhptra VARCHAR2(1), --  Szkolenie BHP 8
    Zzcomwor VARCHAR2(1), --  Œwiadectwo pracy firma 9
    Zzrefere VARCHAR2(1), --  Referencje 10
    Zznonsub VARCHAR2(1), --  Oœwiadczenie o bezrobociu
    Zzcrirec VARCHAR2(1), --  Oœwiadczenie o niekaralnoœci
    Zzjobris VARCHAR2(1), --  Ryzyko zawodowe
    Zzunfeli VARCHAR2(1), --  Licencja UNFE
    Zzcurvit VARCHAR2(1), --+ CV
    Zzannex  VARCHAR2(1), --  Aneks
    Zzinfemp VARCHAR2(1), --  Informacja dla pracownika
    Zzequtre VARCHAR2(1), --+  Oœwiadczenie o równym traktowaniu
    Zzbuscon VARCHAR2(1), --Certyfikat firmowy
    Zzppozce VARCHAR2(1), --+  Oœwiadczenie PPO¯ #20
    Zzinfsw1 VARCHAR2(120), --  Informacja o œwiadectwach 1
    Zzinfsw2 VARCHAR2(120), --  Informacja o œwiadectwach 2
    Zzdoda01 VARCHAR2(1), --+  Dodatkowy dokument 1 #23
    Zzdoda02 VARCHAR2(1), --+  Dodatkowy dokument 2
    Zzdoda03 VARCHAR2(1), --+  Dodatkowy dokument 3
    Zzdoda04 VARCHAR2(1), --+  Dodatkowy dokument 4
    Zzdoda05 VARCHAR2(1), --+  Dodatkowy dokument 5
    Zzdoda06 VARCHAR2(1), --+  Dodatkowy dokument 6
    Zzdodo98 VARCHAR2(120), --  Dodatkowy dokument opis 1
    Zzdodo99 VARCHAR2(120) --  Dodatkowy dokument opis 2
    );
  ------------------------------------------------------------------
  -- PAYROLL -------------------------------------------------------
  ------------------------------------------------------------------
  --t558a
  TYPE T558a IS RECORD(
    Mandt VARCHAR2(3), --MANDT  CLNT  3 T000  Client
    Pernr VARCHAR2(8), --PERNR_D  NUMC  8   Personnel Number
    Begda VARCHAR2(8), --BEGDA  DATS  8   Start Date
    Endda VARCHAR2(8), --ENDDA  DATS  8   End Date
    Molga VARCHAR2(2), --MOLGA  CHAR  2 T500L Country Grouping
    Lgart VARCHAR2(4), --LGART  CHAR  4 T512W Wage Type
    --
    Betpe VARCHAR2(15), --BETPE CURR  15(2)   Payroll: Amount per unit
    Anzhl VARCHAR2(15), --RPANZ DEC 15(2)   Number field
    Betrg VARCHAR2(15), --RPBET CURR  15(2)   Amount
    --
    Lgart_Tmp VARCHAR2(200) -- temp lgart
    );
  --t558b
  TYPE T558b IS RECORD(
    Mandt VARCHAR2(3), --MANDT  CLNT  3 T000  Client
    Pernr VARCHAR2(8), --PERNR_D  NUMC  8   Personnel Number
    Seqnr VARCHAR2(5), --SEQ_T558B  NUMC  5   Sequential number for payroll period
    --
    Payty    VARCHAR2(1), --PAYTY CHAR  1   Payroll type
    Payid    VARCHAR2(1), --PAYID CHAR  1   Payroll Identifier
    Paydt    VARCHAR2(8), --PAY_DATE  DATS  8   Pay date for payroll result
    Permo    VARCHAR2(2), --PERMO NUMC  2 T549R Period Parameters
    Pabrj    VARCHAR2(4), --PABRJ NUMC  4   Payroll Year  GJAHR
    Pabrp    VARCHAR2(2), --PABRP NUMC  2   Payroll Period
    Fpbeg    VARCHAR2(8), --FPBEG DATS  8   Start date of payroll period (FOR period)
    Fpend    VARCHAR2(8), --FPEND DATS  8   End of payroll period (for-period)
    Ocrsn    VARCHAR2(4), --PAY_OCRSN CHAR  4   Reason for Off-Cycle Payroll
    Seqnr_Cd VARCHAR2(5) --CDSEQ NUMC  5   Sequence Number
    );
  --t558c
  TYPE T558c IS RECORD(
    Mandt   VARCHAR2(3), --MANDT CLNT  3 T000  Client
    Pernr   VARCHAR2(8), --PERNR_D NUMC  8   Personnel Number
    Seqnr   VARCHAR2(5), --SEQ_T558B NUMC  5 T558B Sequential number for payroll period
    Molga   VARCHAR2(2), --MOLGA CHAR  2 T500L Country Grouping
    Lgart   VARCHAR2(4), --LGART CHAR  4 T512W Wage Type
    Keydate VARCHAR2(8), --  DATUM DATS  8   Date
    --
    Betpe VARCHAR2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
    Anzhl VARCHAR2(15), --RPANZ DEC 15(2)   Number field
    Betrg VARCHAR2(15), --RPBET  CURR  15(2)   Amount
    --
    Lgart_Tmp VARCHAR2(200), -- temp lgart
    Betrg_Cum VARCHAR2(15));
  --base
  TYPE Tbase IS RECORD(
    Mandt  VARCHAR2(3), --MANDT CLNT  3 T000  Client
    Pernr  VARCHAR2(8), --PERNR_D NUMC  8   Personnel Number
    Period VARCHAR2(6), --PERIOD
    H855   VARCHAR2(15), --planed hours
    H853   VARCHAR2(15), --worked hours
    H850   VARCHAR2(15), --zus worked hours
    W232b  VARCHAR2(15), -- monthly base gross
    W232n  VARCHAR2(15), -- monthly base net
    W3pu   VARCHAR2(15), -- base continuation flag
    W3p1   VARCHAR2(15), -- base value flag
    W0030b VARCHAR2(15), -- Yearly
    W0030a VARCHAR2(15),
    W0030r VARCHAR2(15));
  --
  -- Public type declarations
  --
  -- With the Actions infotype (0000) the user can request an overview of all of the important changes related to a person.
  -- The Actions infotype (0000) documents the most important stages of a person’s development within the enterpris
  TYPE P0000 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0000_ Ps0000,
    Meta_   Meta);
  --
  -- The Organizational Assignment infotype (0001) deals with the incorporation of the associate into the organizational structure and the personnel structure.
  -- This data is very important for security authorizations and control of Payroll.
  TYPE P0001 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0001_ Ps0001,
    Meta_   Meta);
  --The infotype Personal Data (0002) stores data for identifying a person, such as name, birth date, SSN, gender, etc.
  -- Please note that, unlike PeopleSoft, you cannot store multiple personal ID's on this infotype.
  TYPE P0002 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0002_ Ps0002,
    Meta_   Meta);
  -- Infotype in which data on the Payroll status and Time Management status is stored.
  --The system automatically creates this infotype when a person is hired. In general, the system updates the infotype and writes the changes to the payroll past.
  -- We should not maintain this infotype directly. Let payroll handle it automatically.
  TYPE P0003 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0003_ Ps0003,
    Meta_   Meta);
  TYPE P0006 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0006_ Ps0006,
    Meta_   Meta);
  TYPE P0007 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0007_ Ps0007,
    Meta_   Meta);
  TYPE P0008 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0008_ Ps0008,
    Meta_   Meta);
  TYPE P0009 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0009_ Ps0009,
    Meta_   Meta);
  TYPE P0014 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0014_ Ps0014,
    Meta_   Meta);
  TYPE P0015 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0015_ Ps0015,
    Meta_   Meta);
  TYPE P0016 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0016_ Ps0016,
    Meta_   Meta);
  TYPE P0019 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0019_ Ps0019,
    Meta_   Meta);
  TYPE P0021 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0021_ Ps0021,
    Meta_   Meta);
  TYPE P0022 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0022_ Ps0022,
    Meta_   Meta);
  TYPE P0023 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0023_ Ps0023,
    Meta_   Meta);
  TYPE P0024 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0024_ Ps0024,
    Meta_   Meta);
  --
  TYPE P0041 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0041_ Ps0041,
    Meta_   Meta);
  --
  TYPE P0105 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0105_ Ps0105,
    Meta_   Meta);
  --
  TYPE P0185 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0185_ Ps0185,
    Meta_   Meta);
  --
  TYPE P0267 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0267_ Ps0267,
    Meta_   Meta);
  --
  TYPE P0413 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0413_ Ps0413,
    Meta_   Meta);
  --
  TYPE P0414 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0414_ Ps0414,
    Meta_   Meta);
  --
  TYPE P0515 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0515_ Ps0515,
    Meta_   Meta);
  --
  TYPE P0517 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0517_ Ps0517,
    Meta_   Meta);
  --
  TYPE P0558 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0558_ Ps0558,
    Meta_   Meta);
  --
  TYPE P0866 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps0866_ Ps0866,
    Meta_   Meta);
  --
  TYPE P2001 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps2001_ Ps2001,
    Meta_   Meta);
  --
  TYPE P2003 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps2003_ Ps2003,
    Meta_   Meta);
  --
  TYPE P2006 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps2006_ Ps2006,
    Meta_   Meta);
  --
  TYPE P2010 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps2010_ Ps2010,
    Meta_   Meta);
  --
  TYPE P9950 IS RECORD(
    Pakey_  Pakey,
    Pshd1_  Pshd1,
    Ps9950_ Ps9950,
    Meta_   Meta);
  --
  TYPE Payt558a IS RECORD(
    T558a_ T558a,
    Meta_  Meta);
  --
  TYPE Payt558b IS RECORD(
    T558b_ T558b,
    Meta_  Meta);
  --
  TYPE Payt558c IS RECORD(
    T558c_ T558c,
    Meta_  Meta);
  --
  TYPE Paytbase IS RECORD(
    Tbase_ Tbase,
    Meta_  Meta);
  -- tables
  TYPE It0000 IS TABLE OF P0000 INDEX BY BINARY_INTEGER;
  TYPE It0001 IS TABLE OF P0001 INDEX BY BINARY_INTEGER;
  TYPE It0002 IS TABLE OF P0002 INDEX BY BINARY_INTEGER;
  TYPE It0003 IS TABLE OF P0003 INDEX BY BINARY_INTEGER;
  TYPE It0006 IS TABLE OF P0006 INDEX BY BINARY_INTEGER;
  TYPE It0007 IS TABLE OF P0007 INDEX BY BINARY_INTEGER;
  TYPE It0008 IS TABLE OF P0008 INDEX BY BINARY_INTEGER;
  TYPE It0009 IS TABLE OF P0009 INDEX BY BINARY_INTEGER;
  TYPE It0014 IS TABLE OF P0014 INDEX BY BINARY_INTEGER;
  TYPE It0015 IS TABLE OF P0015 INDEX BY BINARY_INTEGER;
  TYPE It0016 IS TABLE OF P0016 INDEX BY BINARY_INTEGER;
  TYPE It0019 IS TABLE OF P0019 INDEX BY BINARY_INTEGER;
  TYPE It0021 IS TABLE OF P0021 INDEX BY BINARY_INTEGER;
  TYPE It0022 IS TABLE OF P0022 INDEX BY BINARY_INTEGER;
  TYPE It0023 IS TABLE OF P0023 INDEX BY BINARY_INTEGER;
  TYPE It0024 IS TABLE OF P0024 INDEX BY BINARY_INTEGER;
  TYPE It0041 IS TABLE OF P0041 INDEX BY BINARY_INTEGER;
  TYPE It0105 IS TABLE OF P0105 INDEX BY BINARY_INTEGER;
  TYPE It0185 IS TABLE OF P0185 INDEX BY BINARY_INTEGER;
  TYPE It0267 IS TABLE OF P0267 INDEX BY BINARY_INTEGER;
  TYPE It0413 IS TABLE OF P0413 INDEX BY BINARY_INTEGER;
  TYPE It0414 IS TABLE OF P0414 INDEX BY BINARY_INTEGER;
  TYPE It0515 IS TABLE OF P0515 INDEX BY BINARY_INTEGER;
  TYPE It0517 IS TABLE OF P0517 INDEX BY BINARY_INTEGER;
  TYPE It0558 IS TABLE OF P0558 INDEX BY BINARY_INTEGER;
  TYPE It2001 IS TABLE OF P2001 INDEX BY BINARY_INTEGER;
  TYPE It2003 IS TABLE OF P2003 INDEX BY BINARY_INTEGER;
  TYPE It2006 IS TABLE OF P2006 INDEX BY BINARY_INTEGER;
  TYPE It2010 IS TABLE OF P2010 INDEX BY BINARY_INTEGER;
  TYPE It0866 IS TABLE OF P0866 INDEX BY BINARY_INTEGER;
  TYPE It9950 IS TABLE OF P9950 INDEX BY BINARY_INTEGER;
  TYPE Pay558a IS TABLE OF Payt558a INDEX BY BINARY_INTEGER;
  TYPE Pay558b IS TABLE OF Payt558b INDEX BY BINARY_INTEGER;
  TYPE Pay558c IS TABLE OF Payt558c INDEX BY BINARY_INTEGER;
  TYPE Paybase IS TABLE OF Paytbase INDEX BY BINARY_INTEGER;
  --
  TYPE Iterror IS TABLE OF Error INDEX BY BINARY_INTEGER;
  Errortab Iterror;
  --
  TYPE Stab_ IS TABLE OF Ic_Xx_Import_Tab%ROWTYPE INDEX BY BINARY_INTEGER;
  --
  PROCEDURE Print_Error;
  --PROCEDURE Prepare_Store_Tab;
  PROCEDURE Dump_Table_To_Csv(File_Name_ IN VARCHAR2, Col_Max_ NUMBER DEFAULT 99);
  --
  PROCEDURE Get_All_Pa_Bg;
  PROCEDURE Get_All_Py_Bg;
  PROCEDURE Get_All_Base_Bg;
  --
  PROCEDURE Get_All_Pa;
  --
  PROCEDURE Get_P0000;
  PROCEDURE Get_P0001;
  PROCEDURE Get_P0002;
  PROCEDURE Get_P0003;
  PROCEDURE Get_P0006;
  PROCEDURE Get_P0007;
  PROCEDURE Get_P0008;
  PROCEDURE Get_P0009;
  PROCEDURE Get_P0014;
  PROCEDURE Get_P0015;
  PROCEDURE Get_P0016;
  PROCEDURE Get_P0019;
  PROCEDURE Get_P0021;
  PROCEDURE Get_P0022;
  PROCEDURE Get_P0023;
  PROCEDURE Get_P0024;
  PROCEDURE Get_P0041;
  PROCEDURE Get_P0105;
  PROCEDURE Get_P0185;
  PROCEDURE Get_P0267;
  PROCEDURE Get_P0413;
  PROCEDURE Get_P0515;
  --procedure get_p0517;
  PROCEDURE Get_P0558;
  PROCEDURE Get_P2001;
  PROCEDURE Get_P2003;
  PROCEDURE Get_P2010;
  PROCEDURE Get_P2006;
  PROCEDURE Get_P9950;
  --
  PROCEDURE Get_Payroll(Box_No_ IN NUMBER DEFAULT 1, Boxes_ IN NUMBER DEFAULT 1);
  PROCEDURE Get_Base;
END Zpk_Sap_Exp;
/
CREATE OR REPLACE PACKAGE BODY IFSAPP.ZPK_SAP_EXP IS

  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------
  --
  --PROCEDURE Dump_Table_To_Csv(File_Name_ IN VARCHAR2, Col_Max_ NUMBER DEFAULT 99);
  FUNCTION Get_Mapping(Typ_         IN VARCHAR2,
                       Value_       IN VARCHAR2,
                       Err_         IN BOOLEAN DEFAULT TRUE,
                       Mapping_Set_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
  FUNCTION Get_Emp_First_Employement(Emp_No_ VARCHAR2) RETURN DATE;
  FUNCTION Get_Emp_Last_Employement(Emp_No_ VARCHAR2) RETURN DATE;
  FUNCTION Get_Emp_Last_Termination(Emp_No_ VARCHAR2) RETURN DATE;
  FUNCTION Get_Emp_Continuation_Mode(Emp_No_ VARCHAR2, Account_Date_ DATE) RETURN VARCHAR2;
  FUNCTION Get_Emp_Matrix(Emp_No_ IN VARCHAR2, Infotype_ IN VARCHAR2)
    RETURN Zpk_Emp_No_Provide_Api.Emp_Ttab_;
  --
  TYPE Emp_Watermark_ IS RECORD(
    Emp          VARCHAR2(8),
    Account_Date DATE,
    Flush        BOOLEAN);
  CURSOR c_Employee_Time_ IS
    SELECT *
      FROM Emp_Employed_Time_Tab t
     WHERE t.Company_Id = c_Company_Id
       AND t.Emp_No LIKE c_Emp_No
     ORDER BY t.Emp_No, t.Date_Of_Employment;
  --
  CURSOR c_Employee_Company_ IS
    SELECT *
      FROM Company_Emp_Tab t
     WHERE t.Company = c_Company_Id
       AND (t.Employee_Id LIKE c_Emp_No OR
           (EXISTS (SELECT 1
                       FROM Zpk_Sap_Exp_Emp_Tab e
                      WHERE e.Company_Id = t.Company
                        AND e.Emp_No = t.Employee_Id)) AND c_Emp_No_Add = 'TRUE')
       AND EXISTS (SELECT 1
              FROM Emp_Employed_Time_Tab p
             WHERE p.Company_Id = t.Company
               AND p.Emp_No = t.Employee_Id)
     ORDER BY t.Employee_Id;
  --
  PROCEDURE Add_Error___(Emp_No_   IN VARCHAR2,
                         Err_Type_ IN VARCHAR2,
                         Err_No_   IN NUMBER,
                         Err_Msg_  IN VARCHAR2) IS
    Wa_ Error;
  BEGIN
    Wa_.Empno := Emp_No_;
    Wa_.Errtype := Err_Type_;
    Wa_.Errno := Err_No_;
    Wa_.Errmsg := Err_Msg_;
    Errortab(Nvl(Errortab.Last, 0) + 1) := Wa_;
  END Add_Error___;
  PROCEDURE Print_Error IS
    Wa_ Error;
    i_  NUMBER;
  BEGIN
    i_ := Errortab.First;
    WHILE (i_ IS NOT NULL) LOOP
      Wa_ := Errortab(i_);
      Dbms_Output.Put_Line(Lpad(Wa_.Empno, 10, Chr(32)) || ' ' || Lpad(Wa_.Errtype, 20, Chr(32)) || ' ' ||
                           Lpad(Wa_.Errno, 10, Chr(32)) || ' ' || Wa_.Errmsg);
      i_ := Errortab.Next(i_);
    END LOOP;
  END Print_Error;
  FUNCTION My_Number___(Number_ IN VARCHAR2, Prec_ IN NUMBER DEFAULT 2) RETURN VARCHAR2 IS
  BEGIN
    IF Number_ IS NULL THEN
      RETURN '';
    END IF;
    RETURN REPLACE(Round(To_Number(REPLACE(Number_, ',', '.')), Prec_), ',', '.');
  EXCEPTION
    WHEN Value_Error THEN
      --Dbms_Output.Put_Line('Parssing error  as varchar2 ' || Number_);
      RETURN - 1;
  END My_Number___;
  FUNCTION My_Number___(Number_ IN NUMBER, Prec_ IN NUMBER DEFAULT 2) RETURN VARCHAR2 IS
    Temp_ VARCHAR2(200);
  BEGIN
    IF Number_ IS NULL THEN
      RETURN '';
    END IF;
    Temp_ := Number_;
    RETURN REPLACE(Round(Temp_, Prec_), ',', '.');
  EXCEPTION
    WHEN Value_Error THEN
      Dbms_Output.Put_Line('Parssing error  as number ' || Number_);
      Raise_Application_Error(-20001, 'value_error');
  END My_Number___;
  FUNCTION My_Date___(Date_ IN DATE) RETURN VARCHAR2 IS
  BEGIN
    RETURN To_Char(Date_, 'YYYYMMDD');
  END My_Date___;
  FUNCTION My_Time___(Date_ IN DATE) RETURN VARCHAR2 IS
  BEGIN
    RETURN To_Char(Date_, 'HH24MISS');
  END My_Time___;
  FUNCTION My_Upper___(Text_ IN VARCHAR2, Len_ IN NUMBER DEFAULT 2000) RETURN VARCHAR2 IS
    Return_ VARCHAR2(200);
  BEGIN
    Return_ := Upper(Text_);
    Return_ := Ltrim(Return_);
    Return_ := Rtrim(Return_);
    Return_ := REPLACE(Return_, Chr(9));
    Return_ := Substr(Return_, 1, Len_);
    RETURN Return_;
  END My_Upper___;
  FUNCTION My_Substr___(Emp_No_ IN VARCHAR2, In_ IN VARCHAR2, Len_ IN NUMBER) RETURN VARCHAR2 IS
    Temp_ VARCHAR2(200);
  BEGIN
    IF Length(In_) > Len_ THEN
      Add_Error___(Emp_No_, 'TechStringLen', 90,
                   'Length of its structure is longer than sap one ' || In_);
      RETURN Substr(In_, Len_);
    END IF;
    RETURN In_;
  END My_Substr___;
  --
  PROCEDURE Fetch_Error___(Emp_No_ VARCHAR2, Err_Type_ VARCHAR2, Err_No_ NUMBER, Err_Msg_ VARCHAR2) IS
    Wa_ Error;
  BEGIN
    Wa_.Empno := Emp_No_;
    Wa_.Errtype := Err_Type_;
    Wa_.Errno := Err_No_;
    Wa_.Errmsg := Err_Msg_;
    Errortab(Nvl(Errortab.Last, 0) + 1) := Wa_;
  END Fetch_Error___;
  --
  PROCEDURE Set_Wm___(Wm_ IN OUT Emp_Watermark_, Emp_No_ IN VARCHAR2, Account_Date_ IN DATE) IS
  BEGIN
    IF Wm_.Account_Date IS NOT NULL THEN
      IF Account_Date_ < Wm_.Account_Date THEN
        Raise_Application_Error(-20002, 'Water mark error date order');
      END IF;
    END IF;
    Wm_.Emp := Emp_No_;
    IF Wm_.Account_Date IS NULL THEN
      Wm_.Account_Date := Account_Date_;
    END IF;
    Wm_.Flush := FALSE;
    --
    -- TODO exception handling
  END Set_Wm___;
  --
  FUNCTION Flush_Wm___ RETURN Emp_Watermark_ IS
    Wm_ Emp_Watermark_;
  BEGIN
    Wm_.Emp          := NULL;
    Wm_.Account_Date := NULL;
    Wm_.Flush        := TRUE;
    --
    RETURN Wm_;
    --
    -- TODO exception handling
  END Flush_Wm___;
  --
  PROCEDURE Get_All_Pa IS
  BEGIN
    IF Transaction_Sys.Is_Session_Deferred THEN
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0000', NULL, 'Migration PA ' || 'Get_P0000');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0001', NULL, 'Migration PA ' || 'Get_P0001');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0002', NULL, 'Migration PA ' || 'Get_P0002');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0003', NULL, 'Migration PA ' || 'Get_P0003');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0006', NULL, 'Migration PA ' || 'Get_P0006');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0007', NULL, 'Migration PA ' || 'Get_P0007');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0008', NULL, 'Migration PA ' || 'Get_P0008');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0009', NULL, 'Migration PA ' || 'Get_P0009');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0014', NULL, 'Migration PA ' || 'Get_P0014');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0015', NULL, 'Migration PA ' || 'Get_P0015');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0016', NULL, 'Migration PA ' || 'Get_P0016');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0019', NULL, 'Migration PA ' || 'Get_P0019');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0021', NULL, 'Migration PA ' || 'Get_P0021');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0022', NULL, 'Migration PA ' || 'Get_P0022');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0023', NULL, 'Migration PA ' || 'Get_P0023');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0024', NULL, 'Migration PA ' || 'Get_P0024');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0041', NULL, 'Migration PA ' || 'Get_P0041');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0105', NULL, 'Migration PA ' || 'Get_P0105');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0185', NULL, 'Migration PA ' || 'Get_P0185');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0267', NULL, 'Migration PA ' || 'Get_P0267');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0413', NULL, 'Migration PA ' || 'Get_P0413');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0515', NULL, 'Migration PA ' || 'Get_P0515');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P0558', NULL, 'Migration PA ' || 'Get_P0558');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P2001', NULL, 'Migration PA ' || 'Get_P2001');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P2003', NULL, 'Migration PA ' || 'Get_P2003');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P2006', NULL, 'Migration PA ' || 'Get_P2006');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P2010', NULL, 'Migration PA ' || 'Get_P2010');
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_P9950', NULL, 'Migration PA ' || 'Get_P9950');
    ELSE
      Get_P0000;
      Get_P0001;
      Get_P0002;
      Get_P0003;
      Get_P0006;
      Get_P0007;
      Get_P0008;
      Get_P0009;
      Get_P0014;
      Get_P0015;
      Get_P0016;
      Get_P0019;
      Get_P0021;
      Get_P0022;
      Get_P0023;
      Get_P0024;
      Get_P0041;
      Get_P0105;
      Get_P0185;
      Get_P0267;
      Get_P0413;
      Get_P0515;
      Get_P0558;
      Get_P2001;
      Get_P2003;
      Get_P2006;
      Get_P2010;
      Get_P9950;
    END IF;
    --
    COMMIT;
    --
    Print_Error;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Dbms_Output.Put_Line('Short info:');
      Dbms_Output.Put_Line(SQLERRM);
      Dbms_Output.Put_Line('Stack info:');
      Dbms_Output.Put_Line(Dbms_Utility.Format_Error_Backtrace);
      --
      Raise_Application_Error(-20001, SQLERRM);
  END Get_All_Pa;
  PROCEDURE Get_All_Pa_Bg IS
  BEGIN
    Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_All_Pa', NULL, 'Migration PA Preparation');
    COMMIT;
  END Get_All_Pa_Bg;
  PROCEDURE Get_All_Py_Bg IS
    Dereffert_Attr_ VARCHAR2(32000);
    Boxes_          NUMBER := 20;
  BEGIN
    FOR i IN 1 .. Boxes_ LOOP
      Client_Sys.Clear_Attr(Dereffert_Attr_);
      Client_Sys.Add_To_Attr('BOX_NO_', i, Dereffert_Attr_);
      Client_Sys.Add_To_Attr('BOXES_', Boxes_, Dereffert_Attr_);
      Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_Payroll', 'PARAMETER', Dereffert_Attr_,
                                    'Migration PY ' || i);
    END LOOP;
    COMMIT;
  END Get_All_Py_Bg;
  PROCEDURE Get_All_Base_Bg IS
  BEGIN
    Transaction_Sys.Deferred_Call('Zpk_Sap_Exp.Get_Base', NULL, 'Migration BASE');
    COMMIT;
  END Get_All_Base_Bg;
  PROCEDURE Log_Err(Shrot_ IN VARCHAR2, Trace_ IN VARCHAR2, o_Rec_ IN Emp_Tmp_, n_Rec_ IN Emp_Tmp_) IS
  BEGIN
    IF Transaction_Sys.Is_Session_Deferred THEN
      Transaction_Sys.Log_Status_Info('Short info:');
      Transaction_Sys.Log_Status_Info(Shrot_);
      Transaction_Sys.Log_Status_Info('Stack info:');
      Transaction_Sys.Log_Status_Info(Trace_);
    ELSE
      Dbms_Output.Put_Line('Old:' || o_Rec_.S1 || '^' || o_Rec_.S2 || '^' || o_Rec_.S3 || '^' ||
                           o_Rec_.S4 || '^' || o_Rec_.S5 || '^' || o_Rec_.S6 || '^' || o_Rec_.S7 || '^' ||
                           o_Rec_.S8 || '^' || o_Rec_.S9 || '^' || o_Rec_.S10 || '^' || o_Rec_.S11 || '^' ||
                           o_Rec_.S12);
      Dbms_Output.Put_Line('New:' || n_Rec_.S1 || '^' || n_Rec_.S2 || '^' || n_Rec_.S3 || '^' ||
                           n_Rec_.S4 || '^' || n_Rec_.S5 || '^' || n_Rec_.S6 || '^' || n_Rec_.S7 || '^' ||
                           n_Rec_.S8 || '^' || n_Rec_.S9 || '^' || n_Rec_.S10 || '^' || n_Rec_.S11 || '^' ||
                           n_Rec_.S12);
      --
      Dbms_Output.Put_Line('Short info:');
      Dbms_Output.Put_Line(Shrot_);
      Dbms_Output.Put_Line('Stack info:');
      Dbms_Output.Put_Line(Trace_);
    END IF;
    --
    IF c_Employee_Company_%ISOPEN THEN
      CLOSE c_Employee_Company_;
    END IF;
    --
  END Log_Err;
  --
  PROCEDURE Get_P0000 IS
    It_         It0000;
    Wa_         P0000;
    n_Employee_ c_Employee_Time_%ROWTYPE;
    o_Employee_ c_Employee_Time_%ROWTYPE;
    Wm_         Emp_Watermark_;
    --
    Rec_No_   NUMBER := 0;
    Is_First_ BOOLEAN := TRUE;
    --
    PROCEDURE Add_Rec_(n_Emp_ IN c_Employee_Time_%ROWTYPE, o_Emp_ IN c_Employee_Time_%ROWTYPE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (o_Emp_.Emp_No IS NULL) THEN
        -- first
        Wa_.Pakey_.Pernr := n_Emp_.Emp_No;
        Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_Of_Employment);
        Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_Of_Leaving);
        Set_Wm___(Wm_, n_Emp_.Emp_No, n_Emp_.Date_Of_Employment);
        /*elsif (n_emp_.emp_no is null) then
        -- last
        wa_.pakey_.pernr := o_emp_.emp_no;
        wa_.pakey_.begda := my_date___(o_emp_.date_of_employment);
        wa_.pakey_.endda := my_date___(o_emp_.date_of_leaving);*/
      ELSE
        -- normal
        IF (o_Emp_.Emp_No = n_Emp_.Emp_No AND
           o_Emp_.Date_Of_Leaving = n_Emp_.Date_Of_Employment - 1 AND n_Emp_.Emp_No IS NOT NULL /* it is not last performing step*/
           AND Employment_Type_Api.Decode(o_Emp_.Employment_Id) not in ('ZLC','UCP') AND
           Employment_Type_Api.Decode(n_Emp_.Employment_Id) not in ('ZLC','UCP')) THEN
          Set_Wm___(Wm_, n_Emp_.Emp_No, n_Emp_.Date_Of_Employment);
        ELSE
          -- flush data
          -- case: new employee
          -- case: re-employement
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := o_Emp_.Emp_No;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_Of_Leaving);
          --
          IF Employment_Type_Api.Decode(o_Emp_.Employment_Id) in ('ZLC','UCP') THEN
            Wa_.Ps0000_.Massn := '30'; -- T529A Action Type
            Wa_.Ps0000_.Massg := NULL; -- Reason for Action
            Wa_.Ps0000_.Stat1 := 5; -- Customer-Specific Status
            Wa_.Ps0000_.Stat2 := 3; -- T529U Employment Status
            Wa_.Ps0000_.Stat3 := 1; -- T529U Special Payment Status
          ELSE
            Wa_.Ps0000_.Massn := '10'; -- T529A Action Type
            Wa_.Ps0000_.Massg := NULL; -- Reason for Action
            Wa_.Ps0000_.Stat1 := 0; -- Customer-Specific Status
            Wa_.Ps0000_.Stat2 := 3; -- T529U Employment Status
            Wa_.Ps0000_.Stat3 := 1; -- T529U Special Payment Status
          END IF;
          --
          Save_;
          --
          IF (o_Emp_.Emp_No = n_Emp_.Emp_No) THEN
            -- reemployement
            Wa_.Pakey_.Mandt := c_Mandt;
            Wa_.Pakey_.Pernr := o_Emp_.Emp_No;
            Wa_.Pakey_.Begda := My_Date___(o_Emp_.Date_Of_Leaving + 1);
            Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_Of_Employment - 1);
            --
            Wa_.Ps0000_.Massn := '29'; -- T529A Action Type
            IF Employment_Type_Api.Decode(o_Emp_.Employment_Id) in ('ZLC','UCP') THEN
              Wa_.Ps0000_.Massg := '09'; -- reason "with the time ..."
            ELSE
              Wa_.Ps0000_.Massg := Get_Mapping(m_Leaving_Cause_Id, To_Char(o_Emp_.Leaving_Cause_Id),
                                               FALSE); -- Reason for Action
            END IF;
            Wa_.Ps0000_.Stat1 := 4; -- Customer-Specific Status
            Wa_.Ps0000_.Stat2 := 0; -- T529U Employment Status
            Wa_.Ps0000_.Stat3 := 1; -- T529U Special Payment Status
            --
            Save_;
          ELSE
            -- permanent terminated
            IF o_Emp_.Date_Of_Leaving < Database_Sys.Get_Last_Calendar_Date THEN
              IF Get_Emp_Continuation_Mode(o_Emp_.Emp_No, o_Emp_.Date_Of_Leaving) <> 'HOLD' THEN
                Wa_.Pakey_.Mandt := c_Mandt;
                Wa_.Pakey_.Pernr := o_Emp_.Emp_No;
                Wa_.Pakey_.Begda := My_Date___(o_Emp_.Date_Of_Leaving + 1);
                Wa_.Pakey_.Endda := My_Date___(Database_Sys.Get_Last_Calendar_Date);
                --
                Wa_.Ps0000_.Massn := '29'; -- T529A Action Type
                IF Employment_Type_Api.Decode(o_Emp_.Employment_Id) in ('ZLC','UCP') THEN
                  Wa_.Ps0000_.Massg := '09'; -- reason "with the time ..."
                ELSE
                  Wa_.Ps0000_.Massg := Get_Mapping(m_Leaving_Cause_Id,
                                                   To_Char(o_Emp_.Leaving_Cause_Id), FALSE); -- Reason for Action
                END IF;
                Wa_.Ps0000_.Stat1 := 4; -- Customer-Specific Status
                Wa_.Ps0000_.Stat2 := 0; -- T529U Employment Status
                Wa_.Ps0000_.Stat3 := 1; -- T529U Special Payment Status
                --
                Save_;
              ELSE
                Add_Error___(o_Emp_.Emp_No, 'TermHoldAction', 50,
                             'There is no decision of termination employee at day ' || --
                              To_Char(o_Emp_.Date_Of_Leaving));
              END IF;
            END IF;
          END IF;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, n_Emp_.Emp_No, n_Emp_.Date_Of_Employment);
        END IF;
      END IF;
    END Add_Rec_;
    --
  BEGIN
    OPEN c_Employee_Time_;
    LOOP
      FETCH c_Employee_Time_
        INTO n_Employee_;
      EXIT WHEN c_Employee_Time_%NOTFOUND;
      --
      IF Is_First_ THEN
        Is_First_ := FALSE;
        Add_Rec_(n_Employee_, NULL);
      ELSE
        Add_Rec_(n_Employee_, o_Employee_);
      END IF;
      --
      o_Employee_ := n_Employee_;
    END LOOP;
    CLOSE c_Employee_Time_;
    -- perform last rec
    Add_Rec_(NULL, o_Employee_);
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, NULL);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0000;
  PROCEDURE Get_P0001 IS
    It_              It0001;
    Wa_              P0001;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Emp_Time_Matrix_ Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Main_Lu_         VARCHAR2(30) := 'EmpEmployedTime';
    i_               NUMBER;
    Is_First_        BOOLEAN;
    Is_Outer_        VARCHAR2(5);
    --
    Rec_No_ NUMBER := 0;
    --
    TYPE Pos_Convert_Tab IS TABLE OF NUMBER INDEX BY VARCHAR2(60);
    Position_Tab Pos_Convert_Tab;
    --
    FUNCTION Get_Postion(Pos_Name_ IN VARCHAR2) RETURN VARCHAR2 IS
      Name_ VARCHAR2(60);
    BEGIN
      Name_ := Nvl(Pos_Name_, 'DUMMY');
      IF NOT (Position_Tab.Exists(Name_)) THEN
        Position_Tab(Name_) := Position_Tab.Count + 1;
      END IF;
      RETURN Position_Tab(Name_);
    END Get_Postion;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: position change
          -- case: cost center change
          -- case: terminated
          -- case: employement break
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
          --
          Wa_.Ps0001_.Bukrs            := o_Emp_.S1; --   BUKRS CHAR  4 T001  Company Code
          Wa_.Ps0001_.Werks            := o_Emp_.S2; --   PERSA CHAR  4 T500P Personnel Area
          Wa_.Ps0001_.Persg            := o_Emp_.S3; --   PERSG CHAR  1 T501  Employee Group
          Wa_.Ps0001_.Persk            := o_Emp_.S4; --   PERSK CHAR  2 T503K Employee Subgroup
          Wa_.Ps0001_.Vdsk1            := o_Emp_.S5; --  VDSK1 CHAR  14  T527O Organizational Key
          Wa_.Ps0001_.Gsber            := o_Emp_.S11; --   GSBER CHAR  4 TGSB  Business Area
          Wa_.Ps0001_.Btrtl            := o_Emp_.S6; --   BTRTL CHAR  4 T001P Personnel Subarea
          Wa_.Ps0001_.Juper            := NULL; --   JUPER CHAR  4   Legal Person
          Wa_.Ps0001_.Abkrs            := o_Emp_.S7; --   ABKRS CHAR  2 T549A Payroll Area
          Wa_.Ps0001_.Ansvh            := NULL; --   ANSVH CHAR  2 T542A Work Contract
          Wa_.Ps0001_.Kostl            := o_Emp_.S8; --  KOSTL CHAR  10  CSKS  Cost Center ALPHA
          Wa_.Ps0001_.Orgeh            := NULL; --   ORGEH NUMC  8 T527X Organizational Unit
          Wa_.Ps0001_.Plans            := o_Emp_.S9; --   PLANS NUMC  8 T528B Position
          Wa_.Ps0001_.Stell            := NULL; --   STELL NUMC  8 T513  Job
          Wa_.Ps0001_.Mstbr            := NULL; --   MSTBR CHAR  8   Supervisor Area
          Wa_.Ps0001_.Sacha            := NULL; --   SACHA CHAR  3 T526  Payroll Administrator
          Wa_.Ps0001_.Sachp            := NULL; --   SACHP CHAR  3 T526  Administrator for HR Master Data
          Wa_.Ps0001_.Sachz            := NULL; --   SACHZ CHAR  3 T526  Administrator for Time Recording
          Wa_.Ps0001_.Sname            := o_Emp_.S10; --  SMNAM CHAR  30    Employees Name (Sortable by LAST NAME FIRST NAME)
          Wa_.Ps0001_.Ename            := o_Emp_.S10; --  EMNAM CHAR  40    Formatted Name of Employee or Applicant
          Wa_.Ps0001_.Otype            := 'S'; --   OTYPE CHAR  2 T778O Object Type
          Wa_.Ps0001_.Sbmod            := Wa_.Ps0001_.Werks; --   SBMOD CHAR  4   Administrator Group
          Wa_.Ps0001_.Kokrs            := Wa_.Ps0001_.Bukrs; --   KOKRS CHAR  4 TKA01 Controlling Area
          Wa_.Ps0001_.Fistl            := NULL; --  FISTL CHAR  16
          Wa_.Ps0001_.Geber            := NULL; --  BP_GEBER  CHAR  10
          Wa_.Ps0001_.Fkber            := NULL; --  FKBER CHAR  16  * Functional Area
          Wa_.Ps0001_.Grant_Nbr        := NULL; --  GM_GRANT_NBR  CHAR  20    Grant ALPHA
          Wa_.Ps0001_.Sgmnt            := NULL; --  FB_SEGMENT  CHAR  10  * Segment for Segmental Reporting ALPHA
          Wa_.Ps0001_.Budget_Pd        := NULL; --  FM_BUDGET_PERIOD  CHAR  10  * FM: Budget Period
          Wa_.Ps0001_.Ifs_Pose_Code    := o_Emp_.S19;
          Wa_.Ps0001_.Ifs_Pose_Name    := o_Emp_.S20;
          Wa_.Ps0001_.Ifs_Pose_Name_En := o_Emp_.S21;
          --
          IF Wa_.Ps0001_.Abkrs = 'ZW' THEN
            IF n_Emp_.Date_From IS NULL THEN
              Wa_.Pakey_.Endda := My_Date___(Database_Sys.Get_Last_Calendar_Date);
            END IF;
            -- store record
            Save_;
          ELSIF n_Emp_.Date_From IS NULL THEN
            -- store record
            Save_;
            -- if there is no period
            IF o_Emp_.Date_To < Database_Sys.Get_Last_Calendar_Date THEN
              IF Get_Emp_Continuation_Mode(Emp_No_, o_Emp_.Date_To) <> 'HOLD' THEN
                IF o_Emp_.Date_To <> Last_Day(o_Emp_.Date_To) THEN
                  Wa_.Pakey_.Begda  := My_Date___(o_Emp_.Date_To + 1); -- fix 20190213
                  Wa_.Pakey_.Endda  := My_Date___(Last_Day(o_Emp_.Date_To));
                  Wa_.Ps0001_.Abkrs := 'PU';
                  -- store record
                  Save_;
                  --
                  Wa_.Pakey_.Begda  := My_Date___(Last_Day(o_Emp_.Date_To) + 1);
                  Wa_.Pakey_.Endda  := My_Date___(Database_Sys.Get_Last_Calendar_Date);
                  Wa_.Ps0001_.Abkrs := 'ZW';
                  -- store record
                  Save_;
                  --
                ELSE
                  Wa_.Pakey_.Begda  := My_Date___(o_Emp_.Date_To + 1);
                  Wa_.Pakey_.Endda  := My_Date___(Database_Sys.Get_Last_Calendar_Date);
                  Wa_.Ps0001_.Abkrs := 'ZW';
                  -- store record
                  Save_;
                END IF;
              ELSE
                Add_Error___(Emp_No_, 'TermHoldAssign', 50,
                             'There is no decision of termination employee at day ' || --
                              To_Char(o_Emp_.Date_To));
              END IF;
            END IF;
          ELSE
            Save_;
          END IF;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_, Is_Outer_ IN VARCHAR2) IS
      -- local vairable
      Org_Code_     VARCHAR2(200);
      Pos_Name_     VARCHAR2(200);
      Pos_Name_En_  VARCHAR2(200);
      Out_Pos_Code_ VARCHAR2(200);
      Pos_Code_     VARCHAR2(200);
      Lname_        VARCHAR2(200);
      Fname_        VARCHAR2(200);
      -- loacal function
      FUNCTION Get_Code_Part_Value(Company_Id_ IN VARCHAR2,
                                   Emp_No_     IN VARCHAR2,
                                   Code_Part_  IN VARCHAR2,
                                   Valid_From_ IN DATE) RETURN VARCHAR2 IS
        Temp_ Emp_Con_Type_Tab.Code_Part_Value%TYPE;
        CURSOR Get_Attr IS
          SELECT Code_Part_Value
            FROM Emp_Con_Type_Tab
           WHERE Company_Id = Company_Id_
             AND Emp_No = Emp_No_
             AND Code_Part = Code_Part_
             AND Valid_From_ BETWEEN Valid_From AND Valid_To;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Temp_;
        CLOSE Get_Attr;
        RETURN Temp_;
      END Get_Code_Part_Value;
      --
      FUNCTION Get_Position_Title(Company_Id_ IN VARCHAR2,
                                  Pos_Code_   IN VARCHAR2,
                                  Language_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
        Module_  CONSTANT VARCHAR2(25) := 'PERSON';
        Lu_Name_ CONSTANT VARCHAR2(25) := 'CompanyPosition';
        Temp_ Company_Position_Tab.Position_Title%TYPE;
        CURSOR Get_Attr IS
          SELECT Position_Title
            FROM Company_Position_Tab
           WHERE Company_Id = Company_Id_
             AND Pos_Code = Pos_Code_;
      BEGIN
        Temp_ := Employee_Translation_Api.Get_Basic_Data_Translation('PERSON', 'CompanyPosition',
                                                                     Company_Id_ || '^' || Pos_Code_,
                                                                     Nvl(Language_,
                                                                          Fnd_Session_Api.Get_Language()));
        IF (Temp_ IS NULL) THEN
          OPEN Get_Attr;
          FETCH Get_Attr
            INTO Temp_;
          CLOSE Get_Attr;
        END IF;
        RETURN Temp_;
      END Get_Position_Title;
    BEGIN
      --BUKRS CHAR  4 T001  Company Code
      Rec_.S1 := Get_Mapping(m_Bukrs_Id, c_Company_Id, FALSE);
      IF Is_Outer_ = 'FALSE' THEN
        --PERSA CHAR  4 T500P Personnel Area
        Org_Code_ := Company_Pers_Assign_Api.Get_Org_Code(c_Company_Id, Emp_No_, Rec_.Date_From);
        IF c_Company_Id = '148' THEN
          Rec_.S2  := Get_Mapping(m_Werks_Id, Substr(Org_Code_, 1, 2), FALSE);
          Rec_.S6  := Get_Mapping(m_Btrtl_Id, Substr(Org_Code_, 4, 4), FALSE); --  Personnel Subarea
          Rec_.S11 := Company_Employee_Property_Api.Get_Property_Value(c_Company_Id, Emp_No_,
                                                                       'DZIAL', Rec_.Date_From);
        ELSIF c_Company_Id IN ('111', '171') THEN
          Rec_.S2 := Get_Mapping(m_Werks_Id, Substr(Org_Code_, 1, 10), FALSE);
          Rec_.S6 := Get_Mapping(m_Btrtl_Id, Substr(Org_Code_, 1, 10), FALSE); --  Personnel Subarea
        ELSE
          Rec_.S2 := Get_Mapping(m_Werks_Id, c_Company_Id, FALSE);
          Rec_.S6 := Get_Mapping(m_Btrtl_Id, c_Company_Id, FALSE);
        END IF;
        --   PERSG CHAR  1 T501  Employee Group
        Rec_.S3 := 'N';
        --   PERSK CHAR  2 T503K Employee Subgroup
        Rec_.S4 := 'NA';
        --  VDSK1 CHAR  14  T527O Organizational Key
        Rec_.S5 := 'CA';
        --   ABKRS CHAR  2 T549A Payroll Area
        IF Emp_Employed_Time_Api.Is_Employed(c_Company_Id, Emp_No_, Rec_.Date_From) = 1 THEN
          Rec_.S7 := 'PU';
        ELSE
          Rec_.S7 := 'ZW';
        END IF;
      ELSE
        Rec_.S2 := 'ZLEC';
        Rec_.S6 := 'ZLEC';
        Rec_.S3 := 'Z';
        Rec_.S4 := 'ZO';
        Rec_.S5 := 'CA';
        Rec_.S7 := 'ZE';
      END IF;
      --  KOSTL CHAR  10  CSKS  Cost Center ALPHA
      Rec_.S8 := Lpad(Get_Code_Part_Value(c_Company_Id, Emp_No_, 'B', Rec_.Date_From), 10, '0');
      --   PLANS NUMC  8 T528B Position
      Pos_Code_     := Company_Pers_Assign_Api.Get_Pos_Code(c_Company_Id, Emp_No_, Rec_.Date_From);
      Pos_Name_     := Get_Position_Title(c_Company_Id, Pos_Code_, 'pl');
      Pos_Name_En_  := Get_Position_Title(c_Company_Id, Pos_Code_, 'en');
      Out_Pos_Code_ := Get_Postion(Pos_Name_);
      Rec_.S9  := Get_Postion(Out_Pos_Code_);
      Rec_.S19 := Pos_Code_;
      Rec_.S20 := Pos_Name_;
      -- add en position info
      IF Pos_Name_ != Pos_Name_En_ THEN
        Rec_.S21 := Pos_Name_En_;
      END IF;
      --  SMNAM CHAR  30    Employees Name (Sortable by LAST NAME FIRST NAME)
      Lname_   := Upper(Company_Pers_Api.Get_Lname(c_Company_Id, Emp_No_));
      Fname_   := Upper(Company_Pers_Api.Get_Fname(c_Company_Id, Emp_No_));
      Rec_.S10 := Substr(Lname_ || ' ' || Fname_, 1, 30);
    END Fill_Rec;
    --
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      -- prepare employee time matrix
      Emp_Time_Matrix_ := Get_Emp_Matrix(Emp_Company_Rec_.Employee_Id, '0001');
      Is_First_        := TRUE;
      -- perform employee matrix
      i_ := Emp_Time_Matrix_.First;
      WHILE (i_ IS NOT NULL) LOOP
        -- initialize local temp rec
        n_Rec_           := NULL;
        n_Rec_.Date_From := Emp_Time_Matrix_(i_).Date_From;
        n_Rec_.Date_To   := Emp_Time_Matrix_(i_).Date_To;
        n_Rec_.Set_Name  := Emp_Time_Matrix_(i_).Set_Name;
        -- perform only main time vector
        IF (n_Rec_.Set_Name != Main_Lu_) THEN
          i_ := Emp_Time_Matrix_.Next(i_);
          Continue;
        END IF;
        -- set outer status
        Is_Outer_ := 'FALSE';
        IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_Company_Rec_.Employee_Id,
                                                     n_Rec_.Date_From) in ('ZLC','UCP') THEN
          Is_Outer_ := 'TRUE';
        END IF;
        -- validate breaks in the months
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Is_Outer_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        i_     := Emp_Time_Matrix_.Next(i_);
      END LOOP;
      -- perform last rec for each employee
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0001;
  --
  PROCEDURE Get_P0002 IS
    It_              It0002;
    Wa_              P0002;
    n_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add master data of employee
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0002_.Inits := NULL; --    INITS CHAR  10    Initials
      Wa_.Ps0002_.Nachn := n_Emp_.S3; --      PAD_NACHN CHAR  40    Last Name
      Wa_.Ps0002_.Name2 := n_Emp_.S4; --      PAD_NAME2 CHAR  40    Name at Birth
      Wa_.Ps0002_.Nach2 := NULL; --      PAD_NACH2 CHAR  40    Second Name
      Wa_.Ps0002_.Vorna := n_Emp_.S1; --      PAD_VORNA CHAR  40    First Name
      Wa_.Ps0002_.Cname := NULL; --      PAD_CNAME CHAR  80    Complete Name
      Wa_.Ps0002_.Titel := NULL; --      TITEL CHAR  15  T535N Title
      Wa_.Ps0002_.Titl2 := NULL; --      TITL2 CHAR  15  T535N Second Title
      Wa_.Ps0002_.Namzu := NULL; --      NAMZU CHAR  15  T535N Other Title
      Wa_.Ps0002_.Vorsw := NULL; --      VORSW CHAR  15  T535N Name Prefix
      Wa_.Ps0002_.Vors2 := NULL; --      VORS2 CHAR  15  T535N Second Name Prefix
      Wa_.Ps0002_.Rufnm := NULL; --      PAD_RUFNM CHAR  40    Nickname
      Wa_.Ps0002_.Midnm := n_Emp_.S2; --      PAD_MIDNM CHAR  40    Middle Name
      Wa_.Ps0002_.Knznm := NULL; --      KNZNM NUMC  2   Name Format Indicator for Employee in a List
      Wa_.Ps0002_.Anred := n_Emp_.S5; --      ANRDE CHAR  1 T522G Form-of-Address Key
      Wa_.Ps0002_.Gesch := n_Emp_.S5; --      GESCH CHAR  1   Gender Key
      Wa_.Ps0002_.Gbdat := n_Emp_.S6; --      GBDAT DATS  8   Date of Birth PDATE
      Wa_.Ps0002_.Gblnd := NULL; -- n_Emp_.S8; --      GBLND CHAR  3 T005  Country of Birth
      Wa_.Ps0002_.Gbdep := NULL; --      GBDEP CHAR  3 T005S State
      Wa_.Ps0002_.Gbort := n_Emp_.S7; --      PAD_GBORT CHAR  40    Birthplace
      Wa_.Ps0002_.Natio := n_Emp_.S9; --      NATSL CHAR  3 T005  Nationality
      Wa_.Ps0002_.Nati2 := NULL; --      NATS2 CHAR  3 T005  Second Nationality
      Wa_.Ps0002_.Nati3 := NULL; --      NATS3 CHAR  3 T005  Third Nationality
      Wa_.Ps0002_.Sprsl := NULL; --n_emp_.s10; --      PAD_SPRAS LANG  1 T002  Communication Language  ISOLA
      Wa_.Ps0002_.Konfe := NULL; --      KONFE CHAR  2 * Religious Denomination Key
      Wa_.Ps0002_.Famst := NULL; --      FAMST CHAR  1 * Marital Status Key
      Wa_.Ps0002_.Famdt := NULL; --      FAMDT DATS  8   Valid From Date of Current Marital Status
      Wa_.Ps0002_.Anzkd := NULL; --      ANZKD DEC 3   Number of Children
      Wa_.Ps0002_.Nacon := NULL; --      NACON CHAR  1   Name Connection
      Wa_.Ps0002_.Permo := NULL; --      PIDMO CHAR  2   Modifier for Personnel Identifier
      Wa_.Ps0002_.Perid := NULL; --      PRDNI CHAR  20    Personnel ID Number
      Wa_.Ps0002_.Gbpas := NULL; --      GBPAS DATS  8   Date of Birth According to Passport
      Wa_.Ps0002_.Fnamk := NULL; --      P22J_PFNMK  CHAR  40    First name (Katakana)
      Wa_.Ps0002_.Lnamk := NULL; --      P22J_PLNMK  CHAR  40    Last name (Katakana)
      Wa_.Ps0002_.Fnamr := NULL; --      P22J_PFNMR  CHAR  40    First Name (Romaji)
      Wa_.Ps0002_.Lnamr := NULL; --      P22J_PLNMR  CHAR  40    Last Name (Romaji)
      Wa_.Ps0002_.Nabik := NULL; --      P22J_PNBIK  CHAR  40    Name of Birth (Katakana)
      Wa_.Ps0002_.Nabir := NULL; --      P22J_PNBIR  CHAR  40    Name of Birth (Romaji)
      Wa_.Ps0002_.Nickk := NULL; --      P22J_PNCKK  CHAR  40    Koseki (Katakana)
      Wa_.Ps0002_.Nickr := NULL; --      P22J_PNCKR  CHAR  40    Koseki (Romaji)
      Wa_.Ps0002_.Gbjhr := n_Emp_.S11; --      GBJHR NUMC  4   Year of Birth GJAHR
      Wa_.Ps0002_.Gbmon := n_Emp_.S12; --      GBMON NUMC  2   Month of Birth
      Wa_.Ps0002_.Gbtag := n_Emp_.S13; --      GBTAG NUMC  2   Birth Date (to Month/Year)
      Wa_.Ps0002_.Nchmc := n_Emp_.S14; --      NACHNMC CHAR  25    Last Name (Field for Search Help)
      Wa_.Ps0002_.Vnamc := n_Emp_.S15; --      VORNAMC CHAR  25    First Name (Field for Search Help)
      Wa_.Ps0002_.Namz2 := NULL; --     NAMZ2 CHAR  15  T535N Name Affix for Name at Birth
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
      -- local vairable
      Cp_ Company_Person%ROWTYPE;
      --
      FUNCTION Get_Rec RETURN Company_Person%ROWTYPE IS
        Cp_ Company_Person%ROWTYPE;
        CURSOR Get_Attr IS
          SELECT *
            FROM Company_Person
           WHERE Company_Id = c_Company_Id
             AND Emp_No = Emp_No_;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Cp_;
        CLOSE Get_Attr;
        RETURN Cp_;
      END Get_Rec;
    BEGIN
      Cp_ := Get_Rec;
      --
      Rec_.Date_From := Get_Emp_First_Employement(Emp_No_);
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      Rec_.S1  := Upper(My_Substr___(Emp_No_, Cp_.Fname, 40)); --VORNA
      Rec_.S15 := Upper(My_Substr___(Emp_No_, Cp_.Fname, 25)); --VORNAMC
      Rec_.S2  := Upper(My_Substr___(Emp_No_, Cp_.Name2, 40)); --MIDNM
      Rec_.S3  := Upper(My_Substr___(Emp_No_, Cp_.Lname, 40)); --NACHN
      Rec_.S14 := Upper(My_Substr___(Emp_No_, Cp_.Lname, 25)); --NACHNC
      Rec_.S4  := Upper(My_Substr___(Emp_No_, Cp_.Name5, 40)); -- Free_Field3); --NAME2
      Rec_.S5  := Get_Mapping(m_Sex_Id, Cp_.Sex, FALSE);
      Rec_.S6  := My_Date___(Cp_.Date_Of_Birth);
      Rec_.S7  := Cp_.Place_Of_Birth;
      Rec_.S8  := Get_Mapping(m_Country_Iso_Id, Iso_Country_Api.Encode(Cp_.Citizenship), FALSE);
      Rec_.S9  := Get_Mapping(m_Country_Iso_Id, Iso_Country_Api.Encode(Cp_.Citizenship), FALSE);
      Rec_.S10 := Get_Mapping(m_Country_Iso_Id, Iso_Country_Api.Encode(Cp_.Citizenship), FALSE);
      Rec_.S11 := To_Char(Cp_.Date_Of_Birth, 'YYYY');
      Rec_.S12 := To_Char(Cp_.Date_Of_Birth, 'MM');
      Rec_.S13 := To_Char(Cp_.Date_Of_Birth, 'DD');
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
        Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id);
      END IF;
      -- fill work area with master data value
      Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
      -- apply storage logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0002;
  --
  PROCEDURE Get_P0003 IS
    It_              It0003;
    Wa_              P0003;
    n_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add master data of employee
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0003_.Abrsp := NULL; --    ABRSP CHAR  1   Indicator: Personnel number locked for payroll
      Wa_.Ps0003_.Abrdt := n_Emp_.S1; -- LABRD DATS  8   Accounted to
      Wa_.Ps0003_.Rrdat := NULL; -- RRDAT DATS  8   Earliest master data change since last payroll run
      Wa_.Ps0003_.Rrdaf := NULL; -- RRDAF DATS  8   not in use
      Wa_.Ps0003_.Koabr := NULL; -- PAD_INTERN  CHAR  1   Internal Use
      Wa_.Ps0003_.Prdat := n_Emp_.S2; -- PRRDT DATS  8   Earliest personal retroactive accounting date
      Wa_.Ps0003_.Pkgab := n_Emp_.S3; -- PKGAB DATS  8   Date as of which personal calendar must be generated
      Wa_.Ps0003_.Abwd1 := n_Emp_.S4; -- ABWD1 DATS  8   End of processing 1 (run payroll for pers.no. up to)
      Wa_.Ps0003_.Abwd2 := NULL; -- ABWD2 DATS  8   End of processing (do not run payroll for pers.no. after)
      Wa_.Ps0003_.Bderr := n_Emp_.S5; -- BDERR DATS  8   Recalculation date for PDC
      Wa_.Ps0003_.Bder1 := NULL; -- BDER1 DATS  8   Effective recalculation date for PDC
      Wa_.Ps0003_.Kobde := NULL; -- KOBDE CHAR  1   PDC Error Indicator
      Wa_.Ps0003_.Timrc := NULL; -- TIMRC CHAR  1   Date of initial PDC entry
      Wa_.Ps0003_.Dat00 := n_Emp_.S6; -- DATP0 DATS  8   Initial input date for a personnel number
      Wa_.Ps0003_.Uhr00 := n_Emp_.S7; -- UHR00 TIMS  6   Time of initial input
      Wa_.Ps0003_.Inumk := NULL; -- CHAR8 CHAR  8   Character field, 8 characters long
      Wa_.Ps0003_.Werks := NULL; -- SBMOD CHAR  4   Administrator Group
      Wa_.Ps0003_.Sachz := NULL; -- SACHZ CHAR  3   Administrator for Time Recording
      Wa_.Ps0003_.Sfeld := NULL; -- SFELD CHAR  20    Sort field for infotype 0003
      Wa_.Ps0003_.Adrun := NULL; -- ADRUN CHAR  1   HR: Special payroll run
      Wa_.Ps0003_.Viekn := n_Emp_.S8; -- VIEKN CHAR  2   Infotype View Indicator
      Wa_.Ps0003_.Trvfl := NULL; -- TRVFL CHAR  1   Indicator for recorded trips
      Wa_.Ps0003_.Rcbon := NULL; -- RCBON DATS  8   Earliest payroll-relevant master data change (bonus)
      Wa_.Ps0003_.Prtev := NULL; -- PRTEV DATS  8   Earliest personal recalculation date for time evaluation
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
    BEGIN
      --
      Rec_.Date_From := Get_Emp_First_Employement(Emp_No_);
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      Rec_.S1 := My_Date___(c_Period_Start - 1); -- LABRD DATS  8   Accounted to
      Rec_.S2 := My_Date___(c_Period_Start); -- PRRDT DATS  8   Earliest personal retroactive accounting date
      Rec_.S3 := My_Date___(Add_Months(Trunc(c_Period_Calc, 'YEAR'), -12)); -- PKGAB DATS  8   Date as of which personal calendar must be generated
      Rec_.S4 := NULL; --My_Date___(Database_Sys.Get_Last_Calendar_Date);
      --My_Date___(Get_Emp_Last_Termination(Emp_No_)); -- ABWD1 DATS  8   End of processing 1 (run payroll for pers.no. up to)
      Rec_.S5 := My_Date___(Add_Months(Trunc(c_Period_Calc, 'YEAR'), -12)); -- BDERR DATS  8   Recalculation date for PDC
      Rec_.S6 := My_Date___(c_Period_Calc); -- DATP0 DATS  8   Initial input date for a personnel number
      Rec_.S7 := My_Time___(c_Period_Calc); -- UHR00 TIMS  6   Time of initial input
      Rec_.S8 := '46'; -- VIEKN CHAR  2   Infotype View Indicator
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
        Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id);
      END IF;
      -- fill work area with master data value
      Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
      -- apply storage logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0003;
  PROCEDURE Get_P0006 IS
    It_              It0006;
    Wa_              P0006;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Address_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, a.*, t.Address_Type_Code, t.Def_Address
        FROM Company_Emp_Tab e, Person_Info_Address_Tab a, Person_Info_Address_Type_Tab t
       WHERE e.Company = c_Company_Id
         AND a.Person_Id = e.Person_Id
         AND a.Person_Id = t.Person_Id
         AND a.Address_Id = t.Address_Id
         AND e.Employee_Id = Emmployee_Id_
         AND t.Address_Type_Code NOT IN ('VISIT', 'WORK')
         AND t.Def_Address = 'TRUE'
       ORDER BY a.Address_Id, t.Address_Type_Code;
    Emp_Address_Rec_ c_Employee_Address_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0006_.Anssa      := n_Emp_.S1; --    ANSSA CHAR  4   Address Record Type
      Wa_.Ps0006_.Name2      := NULL; --PAD_CONAM  CHAR  40    Contact Name
      Wa_.Ps0006_.Stras      := n_Emp_.S2; --- PAD_STRAS  CHAR  60    Street and House Number
      Wa_.Ps0006_.Ort01      := n_Emp_.S3; -- PAD_ORT01  CHAR  40    City
      Wa_.Ps0006_.Ort02      := n_Emp_.S4; -- PAD_ORT02  CHAR  40    District
      Wa_.Ps0006_.Pstlz      := n_Emp_.S5; -- PSTLZ_HR CHAR  10    Postal Code
      Wa_.Ps0006_.Land1      := n_Emp_.S6; -- LAND1 CHAR  3 T005  Country Key
      Wa_.Ps0006_.Telnr      := NULL; -- TELNR  CHAR  14    Telephone Number
      Wa_.Ps0006_.Entkm      := n_Emp_.S7; -- ENTKM DEC 3   Distance in Kilometers
      Wa_.Ps0006_.Wkwng      := NULL; -- WKWNG CHAR  1   Company Housing
      Wa_.Ps0006_.Busrt      := NULL; -- BUSRT CHAR  3   Bus Route
      Wa_.Ps0006_.Locat      := NULL; -- PAD_LOCAT  CHAR  40    2nd Address Line
      Wa_.Ps0006_.Adr03      := NULL; --  AD_STRSPP1  CHAR  40    Street 2
      Wa_.Ps0006_.Adr04      := NULL; -- AD_STRSPP2 CHAR  40    Street 3
      Wa_.Ps0006_.Hsnmr      := n_Emp_.S9; -- PAD_HSNMR  CHAR  10    House Number
      Wa_.Ps0006_.Posta      := n_Emp_.S10; -- PAD_POSTA  CHAR  10    Identification of an apartment in a building
      Wa_.Ps0006_.Bldng      := NULL; --AD_BLD_10  CHAR  10    Building (number or code)
      Wa_.Ps0006_.Floor      := NULL; -- AD_FLOOR CHAR  10    Floor in building
      Wa_.Ps0006_.Strds      := NULL; -- STRDS CHAR  2 T5EVP Street Abbreviation
      Wa_.Ps0006_.Entk2      := n_Emp_.S11; -- ENTKM DEC 3   Distance in Kilometers
      Wa_.Ps0006_.Com01      := NULL; -- COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num01      := NULL; -- COMNR  CHAR  20    Communication Number
      Wa_.Ps0006_.Com02      := NULL; -- COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num02      := NULL; -- COMNR CHAR  20    Communication Number
      Wa_.Ps0006_.Com03      := NULL; -- COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num03      := NULL; -- COMNR  CHAR  20    Communication Number
      Wa_.Ps0006_.Com04      := NULL; --COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num04      := NULL; -- COMNR  CHAR  20    Communication Number
      Wa_.Ps0006_.Com05      := NULL; -- COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num05      := NULL; -- COMNR  CHAR  20    Communication Number
      Wa_.Ps0006_.Com06      := NULL; --COMKY CHAR  4 T536B Communication Type
      Wa_.Ps0006_.Num06      := NULL; -- COMNR  CHAR  20    Communication Number
      Wa_.Ps0006_.Indrl      := NULL; -- P22J_INDRL  CHAR  2 T577  Indicator for relationship (specification code)
      Wa_.Ps0006_.Counc      := NULL; -- COUNC CHAR  3 T005E County Code
      Wa_.Ps0006_.Rctvc      := NULL; --P22J_RCTVC  CHAR  6   Municipal city code
      Wa_.Ps0006_.Or2kk      := n_Emp_.S13; --P22J_ORKK2 CHAR  40    Second address line (Katakana)
      Wa_.Ps0006_.Conkk      := NULL; -- P22J_PCNKK CHAR  40    Contact Person (Katakana) (Japan)
      Wa_.Ps0006_.Or1kk      := NULL; -- P22J_ORKK1 CHAR  40    First address line (Katakana)
      Wa_.Ps0006_.Railw      := NULL; -- RAILW NUMC  1   Social Subscription Railway
      Wa_.Ps0006_.Ifs_State  := n_Emp_.S8;
      Wa_.Ps0006_.Ifs_Counc  := n_Emp_.S12;
      Wa_.Ps0006_.Ifs_County := n_Emp_.S13;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Address_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Valid_From;
      Rec_.Date_To   := Inrec_.Valid_To;
      --
      Rec_.S1  := Get_Mapping(m_Address_Type_Id, Inrec_.Address_Type_Code, FALSE); -- ANSSA
      Rec_.S2  := Inrec_.Street; -- STRAS
      Rec_.S3  := Inrec_.City; --ORTO1
      Rec_.S4  := ''; --ORTO2
      Rec_.S5  := Inrec_.Zip_Code; -- PSTLZ
      Rec_.S6  := Get_Mapping(m_Country_Iso_Id, Inrec_.Country, FALSE); -- ANSSA
      Rec_.S7  := '0'; --ENTKM
      Rec_.S8  := Get_Mapping(m_State_Id, Inrec_.State, FALSE); --STATE
      Rec_.S9  := Inrec_.House_No; --HSNMR
      Rec_.S10 := Inrec_.Flat_No; --POSTA
      Rec_.S11 := '0'; --ENTK2
      Rec_.S12 := My_Upper___(Inrec_.Community); -- COUNC
      Rec_.S13 := My_Upper___(Nvl(Inrec_.County, Inrec_.City)); -- OR2KK
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Address_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Address_
          INTO Emp_Address_Rec_;
        EXIT WHEN c_Employee_Address_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Address_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Address_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0006;
  PROCEDURE Get_P0007 IS
    It_              It0007;
    Wa_              P0007;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Emp_Time_Matrix_ Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Main_Lu_         VARCHAR2(30) := 'EmpEmployedTime';
    i_               NUMBER;
    Is_First_        BOOLEAN;
    Is_Outer_        VARCHAR2(5);
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: ...
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
          --
          Wa_.Ps0007_.Schkz := o_Emp_.S1; --    SCHKN CHAR  8   Work Schedule Rule
          Wa_.Ps0007_.Zterf := NULL; --    PT_ZTERF  NUMC  1 T555U Employee Time Management Status
          Wa_.Ps0007_.Empct := o_Emp_.S2; --    EMPCT DEC 5(2)    Employment percentage
          Wa_.Ps0007_.Mostd := o_Emp_.S6; --    MOSTD DEC 5(2)    Monthly hours
          Wa_.Ps0007_.Wostd := o_Emp_.S5; --    WOSTD DEC 5(2)    Hours per week
          Wa_.Ps0007_.Arbst := o_Emp_.S3; --   STDTG DEC 5(2)    Daily Working Hours
          Wa_.Ps0007_.Wkwdy := o_Emp_.S4; --    WARST DEC 4(2)    Weekly Workdays
          Wa_.Ps0007_.Jrstd := o_Emp_.S7; --  JRSTD DEC 7(2)    Annual working hours
          Wa_.Ps0007_.Teilk := o_Emp_.S8; --    TEILK CHAR  1   Indicator Part-Time Employee
          Wa_.Ps0007_.Minta := NULL; --   MINTA DEC 5(2)    Minimum number of work hours per day
          Wa_.Ps0007_.Maxta := NULL; --    MAXTA DEC 5(2)    Maximum number of work hours per day
          Wa_.Ps0007_.Minwo := NULL; --   MINWO DEC 5(2)    Minimum weekly working hours
          Wa_.Ps0007_.Maxwo := NULL; --    MAXWO DEC 5(2)    Maximum number of work hours per week
          Wa_.Ps0007_.Minmo := NULL; --    MINMO DEC 5(2)    Minimum number of work hours per month
          Wa_.Ps0007_.Maxmo := NULL; --    MAXMO DEC 5(2)    Maximum number of work hours per month
          Wa_.Ps0007_.Minja := NULL; --    MINJA DEC 7(2)    Minimum annual working hours
          Wa_.Ps0007_.Maxja := NULL; --   MAXJA DEC 7(2)    Maximum Number of Working Hours Per Year
          Wa_.Ps0007_.Dysch := NULL; --    DYSCH CHAR  1   Create Daily Work Schedule Dynamically
          Wa_.Ps0007_.Kztim := NULL; --    KZTIM CHAR  2   Additional indicator for time management
          Wa_.Ps0007_.Wweek := NULL; --    WWEEK CHAR  2 T559A Working week
          Wa_.Ps0007_.Awtyp := NULL; --  AWTYP CHAR  5   Reference Transaction
          --
          Save_;
          --
          IF o_Emp_.Date_To < Database_Sys.Get_Last_Calendar_Date THEN
            IF NOT Emp_Employed_Time_Api.Is_Employed(c_Company_Id, Emp_No_, o_Emp_.Date_To + 1) = 1 THEN
              Wa_.Pakey_.Begda := My_Date___(o_Emp_.Date_To + 1);
              Wa_.Pakey_.Endda := My_Date___(Database_Sys.Get_Last_Calendar_Date);
              --Wa_.Ps0007_.Schkz := 'NORM'; leave the same schedule
              --
              Save_;
            END IF;
          END IF;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_, Is_Outer_ IN VARCHAR2) IS
      -- local vairable
      Cp_       Work_Sched_Assign_Tab%ROWTYPE;
      Emp_Time_ NUMBER;
      Day_Hour_ NUMBER := 8;
      Week_Day_ NUMBER := 5;
      --
      --
      CURSOR c_Get_Sched_Info_(Schedule_ VARCHAR2) IS
        SELECT *
          FROM Day_Sched_Type_Tab t
         WHERE t.Company_Id = c_Company_Id
           AND t.Wage_Class = 'MIES'
           AND t.Day_Sched_Code = Schedule_;
      Sched_Info_Rec_ c_Get_Sched_Info_%ROWTYPE;
      --
      FUNCTION Get_Rec RETURN Work_Sched_Assign_Tab%ROWTYPE IS
        Cp_ Work_Sched_Assign_Tab%ROWTYPE;
        CURSOR Get_Attr IS
          SELECT *
            FROM Work_Sched_Assign_Tab t
           WHERE Company_Id = c_Company_Id
             AND Emp_No = Emp_No_
             AND Rec_.Date_From BETWEEN t.Valid_From AND t.Valid_To;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Cp_;
        CLOSE Get_Attr;
        RETURN Cp_;
      END Get_Rec;
    BEGIN
      Cp_       := Get_Rec;
      Emp_Time_ := Additional_Data_Api.Get_Work_Time(c_Company_Id, Emp_No_, Rec_.Date_From);
      --
      Rec_.Date_From := Rec_.Date_From;
      Rec_.Date_To   := Rec_.Date_To;
      --
      -- seting before time calculation
      IF Emp_Time_ != 1 THEN
        Rec_.S8 := 'X';
      END IF;
      --
      IF Is_Outer_ = 'FALSE' THEN
        Rec_.S1 := Get_Mapping(m_Schedule_Id, Cp_.Day_Sched_Code, FALSE); -- SCHKZ
      ELSE
        Rec_.S1   := 'NORM';
        Emp_Time_ := 1;
      END IF;
      --
      IF Cp_.Day_Sched_Code != 'NORM'
         AND Day_Sched_Type_Api.Get_Schedule_Type_Db(c_Company_Id, 'MIES', Cp_.Day_Sched_Code) !=
         'DAY-BY-DAY' THEN
        OPEN c_Get_Sched_Info_(Cp_.Day_Sched_Code);
        FETCH c_Get_Sched_Info_
          INTO Sched_Info_Rec_;
        CLOSE c_Get_Sched_Info_;
        -- new emp time
        Emp_Time_ := Sched_Info_Rec_.Work_Hours_Week / (Day_Hour_ * Week_Day_);
        --
      END IF;
      --
      Emp_Time_ := Round(Emp_Time_, 2);
      --
      Rec_.S2 := My_Number___(Emp_Time_ * 100); --EMPCT
      Rec_.S3 := My_Number___(Day_Hour_ * Emp_Time_); --ARBST
      Rec_.S4 := My_Number___(Week_Day_); --WKWDY
      Rec_.S5 := My_Number___(Week_Day_ * Day_Hour_ * Emp_Time_); --WOSTD
      Rec_.S6 := My_Number___(Week_Day_ * Day_Hour_ * Emp_Time_ * 4); --MOSTD
      Rec_.S7 := My_Number___(Week_Day_ * Day_Hour_ * Emp_Time_ * 4 * 12); --JRSTD
    END Fill_Rec;
    --
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      -- prepare employee time matrix
      Emp_Time_Matrix_ := Get_Emp_Matrix(Emp_Company_Rec_.Employee_Id, '0007');
      Is_First_        := TRUE;
      -- perform employee matrix
      i_ := Emp_Time_Matrix_.First;
      WHILE (i_ IS NOT NULL) LOOP
        -- initialize local temp rec
        n_Rec_           := NULL;
        n_Rec_.Date_From := Emp_Time_Matrix_(i_).Date_From;
        n_Rec_.Date_To   := Emp_Time_Matrix_(i_).Date_To;
        n_Rec_.Set_Name  := Emp_Time_Matrix_(i_).Set_Name;
        -- perform only main time vector
        IF (n_Rec_.Set_Name != Main_Lu_) THEN
          i_ := Emp_Time_Matrix_.Next(i_);
          Continue;
        END IF;
        -- outer status
        Is_Outer_ := 'FALSE';
        IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_Company_Rec_.Employee_Id,
                                                     n_Rec_.Date_From) in ('ZLC','UCP') THEN
          Is_Outer_ := 'TRUE';
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Is_Outer_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        i_     := Emp_Time_Matrix_.Next(i_);
      END LOOP;
      -- perform last rec for each employee
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0007;
  PROCEDURE Get_P0008 IS
    It_              It0008;
    Wa_              P0008;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Emp_Time_Matrix_ Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Main_Lu_         VARCHAR2(30) := 'EmpEmployedTime';
    i_               NUMBER;
    Is_First_        BOOLEAN;
    Is_Outer_        VARCHAR2(5);
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        IF Wa_.Ps0008_.Bet01 != My_Number___(0) THEN
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: ...
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
          --
          --
          Wa_.Ps0008_.Trfar := o_Emp_.S1; --   TRFAR CHAR  2 T510A Pay scale type
          Wa_.Ps0008_.Trfgb := o_Emp_.S2; --   TRFGB CHAR  2 T510G Pay Scale Area
          Wa_.Ps0008_.Trfgr := NULL; --   TRFGR CHAR  8   Pay Scale Group
          Wa_.Ps0008_.Trfst := NULL; --   TRFST CHAR  2   Pay Scale Level
          Wa_.Ps0008_.Stvor := NULL; --   STVOR DATS  8   Date of Next Increase
          Wa_.Ps0008_.Orzst := NULL; --   ORTZS CHAR  2   Cost of Living Allowance Level
          Wa_.Ps0008_.Partn := NULL; --   PARTN CHAR  2 T577  Partnership
          Wa_.Ps0008_.Waers := o_Emp_.S3; --   WAERS CUKY  5 TCURC Currency Key
          Wa_.Ps0008_.Vglta := NULL; --   VGLTA CHAR  2 T510A Comparison pay scale type
          Wa_.Ps0008_.Vglgb := NULL; --   VGLGB CHAR  2 T510G Comparison pay scale area
          Wa_.Ps0008_.Vglgr := NULL; --   VGLTG CHAR  8   Comparison pay scale group
          Wa_.Ps0008_.Vglst := NULL; --   VGLST CHAR  2   Comparison pay scale level
          Wa_.Ps0008_.Vglsv := NULL; --   STVOR DATS  8   Date of Next Increase
          Wa_.Ps0008_.Bsgrd := o_Emp_.S4; --   BSGRD DEC 5(2)    Capacity Utilization Level
          Wa_.Ps0008_.Divgv := o_Emp_.S5; --   DIVGV DEC 5(2)    Working Hours per Payroll Period
          Wa_.Ps0008_.Ansal := o_Emp_.S6; --   ANSAL_15  CURR  15(2)   Annual salary
          Wa_.Ps0008_.Falgk := NULL; --   FALGK CHAR  10    Case group catalog
          Wa_.Ps0008_.Falgr := NULL; --   FALGR CHAR  6   Case group
          Wa_.Ps0008_.Lga01 := o_Emp_.S7; --   LGART CHAR  4 T512Z Wage Type
          Wa_.Ps0008_.Bet01 := o_Emp_.S8; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
          Wa_.Ps0008_.Anz01 := o_Emp_.S9; --   ANZHL DEC 7(2)    Number
          Wa_.Ps0008_.Ein01 := NULL; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
          Wa_.Ps0008_.Opk01 := NULL; --   OPKEN CHAR  1   Operation Indicator for Wage Types
          Wa_.Ps0008_.Lga02 := NULL; --   LGART CHAR  4 T512Z Wage Type
          Wa_.Ps0008_.Bet02 := NULL; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
          Wa_.Ps0008_.Anz02 := NULL; --   ANZHL DEC 7(2)    Number
          Wa_.Ps0008_.Ein02 := NULL; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
          Wa_.Ps0008_.Opk02 := NULL; --   OPKEN CHAR  1   Operation Indicator for Wage Types
          Wa_.Ps0008_.Lga03 := NULL; --   LGART CHAR  4 T512Z Wage Type
          Wa_.Ps0008_.Bet03 := NULL; --   PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
          Wa_.Ps0008_.Anz03 := NULL; --   ANZHL DEC 7(2)    Number
          Wa_.Ps0008_.Ein03 := NULL; --   PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
          Wa_.Ps0008_.Opk03 := NULL; --   OPKEN CHAR  1   Operation Indicator for Wage Types
          Wa_.Ps0008_.Ind01 := NULL; --   INDBW CHAR  1   Indicator for indirect valuation
          Wa_.Ps0008_.Ind02 := NULL; --   INDBW CHAR  1   Indicator for indirect valuation
          Wa_.Ps0008_.Ind03 := NULL; --   INDBW CHAR  1   Indicator for indirect valuation
          Wa_.Ps0008_.Ancur := o_Emp_.S10; -- ANCUR CUKY  5 TCURC Currency Key for Annual Salary
          Wa_.Ps0008_.Cpind := o_Emp_.S11; --   P_CPIND CHAR  1   Planned compensation type
          Wa_.Ps0008_.Flaga := NULL; --  FLAG  CHAR  1   General Flag
          --
          Save_;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
      -- local vairable
      Cp_ Employee_Salary_Tab%ROWTYPE;
      --
      FUNCTION Get_Rec RETURN Employee_Salary_Tab%ROWTYPE IS
        Cp_ Employee_Salary_Tab%ROWTYPE;
        CURSOR Get_Attr IS
          SELECT *
            FROM Employee_Salary_Tab t
           WHERE Company_Id = c_Company_Id
             AND Emp_No = Emp_No_
             AND Rec_.Date_From BETWEEN t.Valid_From AND t.Valid_To;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Cp_;
        CLOSE Get_Attr;
        RETURN Cp_;
      END Get_Rec;
    BEGIN
      Cp_ := Get_Rec;
      --
      Rec_.Date_From := Rec_.Date_From;
      Rec_.Date_To   := Rec_.Date_To;
      --
      Rec_.S1  := '01'; -- TRFAR
      Rec_.S2  := '01'; -- TRFGB
      Rec_.S3  := 'PLN'; -- WAERS
      Rec_.S4  := My_Number___(Additional_Data_Api.Get_Work_Time(c_Company_Id, Emp_No_,
                                                                 Rec_.Date_From) * 100); --BSGRD
      Rec_.S5  := '160'; --DIVGV
      Rec_.S6  := '0'; --ANSAL
      Rec_.S7  := '0001'; -- LGA01
      Rec_.S8  := My_Number___(Nvl(Cp_.Full_Time_Amount, 0)); -- BET01
      Rec_.S9  := '0'; -- ANZ01
      Rec_.S10 := 'PLN'; -- ANCUR
      Rec_.S11 := 'T'; -- CPIND
    END Fill_Rec;
    --
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      -- prepare employee time matrix
      Emp_Time_Matrix_ := Get_Emp_Matrix(Emp_Company_Rec_.Employee_Id, '0008');
      Is_First_        := TRUE;
      -- perform employee matrix
      i_ := Emp_Time_Matrix_.First;
      WHILE (i_ IS NOT NULL) LOOP
        -- initialize local temp rec
        n_Rec_           := NULL;
        n_Rec_.Date_From := Emp_Time_Matrix_(i_).Date_From;
        n_Rec_.Date_To   := Emp_Time_Matrix_(i_).Date_To;
        n_Rec_.Set_Name  := Emp_Time_Matrix_(i_).Set_Name;
        -- perform only main time vector
        IF (n_Rec_.Set_Name != Main_Lu_) THEN
          i_ := Emp_Time_Matrix_.Next(i_);
          Continue;
        END IF;
        -- outer status
        Is_Outer_ := 'FALSE';
        IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_Company_Rec_.Employee_Id,
                                                     n_Rec_.Date_From) in ('ZLC','UCP') THEN
          Is_Outer_ := 'TRUE';
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        i_     := Emp_Time_Matrix_.Next(i_);
      END LOOP;
      -- perform last rec for each employee
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0008;
  PROCEDURE Get_P0009 IS
    It_              It0009;
    Wa_              P0009;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Disp_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*, h.Is_Active
        FROM Company_Emp_Tab e, Employee_Disposal_Head_Tab h, Employee_Disposal_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = h.Company_Id
         AND h.Company_Id = b.Company_Id
         AND h.Emp_No = b.Emp_No
         AND e.Employee_Id = h.Emp_No
         AND h.Valid_From = b.Valid_From
         AND h.Payment_Type_Id = b.Payment_Type_Id
         AND e.Employee_Id = Emmployee_Id_
         AND h.Is_Active = 'TRUE'
            -- additional singleton requirements
         AND h.Valid_From < SYSDATE
         AND h.Valid_From = (SELECT MAX(Valid_From)
                               FROM Employee_Disposal_Head_Tab b
                              WHERE b.Company_Id = h.Company_Id
                                AND b.Emp_No = h.Emp_No
                                AND b.Payment_Type_Id = h.Payment_Type_Id)
       ORDER BY b.Valid_From;
    Emp_Disp_Rec_ c_Employee_Disp_%ROWTYPE;
    --
    CURSOR Get_Addr_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id,
             Person_Info_Api.Get_External_Display_Name(a.Person_Id) Name_,
             a.Street,
             a.House_No,
             a.Flat_No,
             a.Zip_Code,
             a.City,
             a.County
        FROM Company_Emp_Tab e, Person_Info_Address_Tab a, Person_Info_Address_Type_Tab t
       WHERE e.Company = c_Company_Id
         AND a.Person_Id = e.Person_Id
         AND a.Person_Id = t.Person_Id
         AND a.Address_Id = t.Address_Id
         AND e.Employee_Id = Emmployee_Id_
         AND t.Address_Type_Code NOT IN ('VISIT', 'WORK')
         AND t.Def_Address = 'TRUE'
       ORDER BY Decode(t.Address_Type_Code, 'HOME', 'A', 'RESIDENCE', 'B', 'CORRESPONDENCE', 'C',
                       'TAX', 'D');
    Emp_Address_Rec_ Get_Addr_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0009_.Opken := NULL; --OPKEN  CHAR  1   Operation Indicator for Wage Types
      Wa_.Ps0009_.Betrg := n_Emp_.S1; --PAD_VGBTR  CURR  13(2)   Standard value
      Wa_.Ps0009_.Waers := n_Emp_.S2; --PAD_WAERS  CUKY  5 TCURC Payment Currency
      Wa_.Ps0009_.Anzhl := n_Emp_.S3; --VGPRO  DEC 5(2)    Standard Percentage
      Wa_.Ps0009_.Zeinh := NULL; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Wa_.Ps0009_.Bnksa := n_Emp_.S4; --BNKSA  CHAR  4 T591A Type of Bank Details Record
      Wa_.Ps0009_.Zlsch := n_Emp_.S5; --PCODE  CHAR  1 T042Z Payment Method
      Wa_.Ps0009_.Emftx := n_Emp_.S6; --EMFTX  CHAR  40    Payee Text
      Wa_.Ps0009_.Bkplz := n_Emp_.S7; --BKPLZ  CHAR  10    Postal Code
      Wa_.Ps0009_.Bkort := n_Emp_.S8; --ORT01  CHAR  25    City
      Wa_.Ps0009_.Banks := n_Emp_.S9; --BANKS  CHAR  3 T005  Bank country key
      Wa_.Ps0009_.Bankl := n_Emp_.S10; --BANKK  CHAR  15    Bank Keys
      Wa_.Ps0009_.Bankn := n_Emp_.S11; --BANKN  CHAR  18    Bank account number
      Wa_.Ps0009_.Bankp := NULL; --BANKP  CHAR  2   Check Digit for Bank No./Account
      Wa_.Ps0009_.Bkont := n_Emp_.S12; --BKONT  CHAR  2   Bank Control Key
      Wa_.Ps0009_.Swift := NULL; --SWIFT  CHAR  11    SWIFT/BIC for International Payments
      Wa_.Ps0009_.Dtaws := NULL; --DTAWS  CHAR  2 T015W Instruction key for data medium exchange
      Wa_.Ps0009_.Dtams := NULL; --DTAMS  CHAR  1   Indicator for Data Medium Exchange
      Wa_.Ps0009_.Stcd2 := NULL; --STCD2  CHAR  11    Tax Number 2
      Wa_.Ps0009_.Pskto := NULL; --PSKTO  CHAR  16    Account Number of Bank Account At Post Office
      Wa_.Ps0009_.Esrnr := NULL; --ESRNR  CHAR  11    ISR Subscriber Number
      Wa_.Ps0009_.Esrre := NULL; --ESRRE  CHAR  27    ISR Reference Number  ALPHA
      Wa_.Ps0009_.Esrpz := NULL; --ESRPZ  CHAR  2   ISR Check Digit
      Wa_.Ps0009_.Emfsl := NULL; --EMFSL  CHAR  8   Payee key for bank transfers
      Wa_.Ps0009_.Zweck := NULL; --DZWECK CHAR  40    Purpose of Bank Transfers
      Wa_.Ps0009_.Bttyp := NULL; --P09_BTTYP  NUMC  2 T5M3T PBS Transfer Type
      Wa_.Ps0009_.Payty := NULL; --PAYTY  CHAR  1   Payroll type
      Wa_.Ps0009_.Payid := NULL; --PAYID  CHAR  1   Payroll Identifier
      Wa_.Ps0009_.Ocrsn := NULL; --PAY_OCRSN  CHAR  4   Reason for Off-Cycle Payroll
      Wa_.Ps0009_.Bondt := NULL; --BONDT  DATS  8   Off-cycle payroll payment date
      Wa_.Ps0009_.Bkref := NULL; --BKREF  CHAR  20    Reference specifications for bank details
      Wa_.Ps0009_.Stras := NULL; --STRAS  CHAR  30    House number and street
      Wa_.Ps0009_.Debit := NULL; --P00_XDEBIT_INFTY CHAR  1   Automatic Debit Authorization Indicator
      Wa_.Ps0009_.Iban  := NULL; --IBAN CHAR  34    IBAN (International Bank Account Number)
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Disp_%ROWTYPE) IS
      Emftx_        VARCHAR2(200);
      Bank_Account_ VARCHAR2(200);
    BEGIN
      --
      Rec_.Date_From := Greatest(Inrec_.Valid_From, Get_Emp_First_Employement(Emp_No_));
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      OPEN Get_Addr_(Emp_No_);
      FETCH Get_Addr_
        INTO Emp_Address_Rec_;
      CLOSE Get_Addr_;
      --
      Emftx_ := Emp_Address_Rec_.Name_;
      --Emftx_ := Emftx_ || ' ' || Emp_Address_Rec_.Street;
      --Emftx_ := Emftx_ || ' ' || Emp_Address_Rec_.House_No;
      --IF Emp_Address_Rec_.Flat_No IS NOT NULL THEN
      -- Emftx_ := Emftx_ || ' / ' || Emp_Address_Rec_.Flat_No;
      --END IF;
      --
      Bank_Account_ := Inrec_.Bank_Account;
      Bank_Account_ := REPLACE(Bank_Account_, Chr(31));
      Bank_Account_ := REPLACE(Bank_Account_, Chr(32));
      Bank_Account_ := REPLACE(Bank_Account_, Chr(45));
      --
      Rec_.S1  := '0'; --BETRG
      Rec_.S2  := 'PLN'; --WAERS
      Rec_.S3  := '0'; --ANZHL
      Rec_.S4  := '0'; --BANKSA
      Rec_.S5  := 'E'; --ZLSCH
      Rec_.S6  := Substr(Emftx_, 1, 40); --EMFTX
      Rec_.S7  := Substr(Emp_Address_Rec_.Zip_Code, 1, 10); --BKPLZ
      Rec_.S8  := Substr(Nvl(Emp_Address_Rec_.County, Emp_Address_Rec_.City), 1, 25); --BKORT
      Rec_.S9  := 'PL'; --BANKS
      Rec_.S10 := Inrec_.Bank_Id; --BANKL
      Rec_.S11 := Substr(Bank_Account_, 11); --BANKN
      Rec_.S12 := Substr(Bank_Account_, 1, 2); --BKONT
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Disp_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Disp_
          INTO Emp_Disp_Rec_;
        EXIT WHEN c_Employee_Disp_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Disp_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Disp_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0009;
  --
  PROCEDURE Get_P0014 IS
    It_              It0014;
    Wa_              P0014;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Cons_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Reg_Const_Data_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Param_Id, b.Date_From;
    Emp_Cons_Rec_ c_Employee_Cons_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        IF Substr(Wa_.Ps0014_.Lgart, 1, 3) NOT IN ('N/A', '?') THEN
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0014_.Lgart := n_Emp_.S1; --LGART  CHAR  4 T512Z Wage Type
      Wa_.Ps0014_.Opken := NULL; --OPKEN  CHAR  1   Operation Indicator for Wage Types
      Wa_.Ps0014_.Betrg := n_Emp_.S2; --PAD_AMT7S  CURR  13(2)   Wage Type Amount for Payments
      Wa_.Ps0014_.Waers := n_Emp_.S3; --WAERS  CUKY  5 TCURC Currency Key
      Wa_.Ps0014_.Anzhl := n_Emp_.S4; --ANZHL  DEC 7(2)    Number
      Wa_.Ps0014_.Zeinh := n_Emp_.S5; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Wa_.Ps0014_.Indbw := NULL; --INDBW  CHAR  1   Indicator for indirect valuation
      Wa_.Ps0014_.Zdate := NULL; --DZDATE DATS  8   First payment date
      Wa_.Ps0014_.Zfper := NULL; --DZFPER NUMC  2   First payment period
      Wa_.Ps0014_.Zanzl := n_Emp_.S6; --DZANZL DEC 3   Number for determining further payment dates
      Wa_.Ps0014_.Zeinz := NULL; --DZEINZ CHAR  3 T538C Time unit for determining next payment
      Wa_.Ps0014_.Zuord := NULL; --UZORD  CHAR  20    Assignment Number
      Wa_.Ps0014_.Uwdat := NULL; --UWDAT  DATS  8   Date of Bank Transfer
      Wa_.Ps0014_.Model := NULL; --MODE1 CHAR  4 T549W Payment Model
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Cons_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Date_From;
      Rec_.Date_To   := Nvl(Inrec_.Date_To, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Get_Mapping(m_Param_Id, Inrec_.Param_Id, FALSE); -- LGART
      Rec_.S2 := My_Number___(Inrec_.Value); -- BETRG
      Rec_.S3 := 'PLN'; -- WAERS
      Rec_.S4 := '0'; -- ANZHL
      Rec_.S5 := ''; -- ZEINH
      Rec_.S6 := '0'; -- ZANZL
      IF Substr(Rec_.S1, 5, 1) = 'N' THEN
        Rec_.S1 := Substr(Rec_.S1, 1, 4);
        Rec_.S2 := '0';
        Rec_.S4 := My_Number___(Inrec_.Value);
      END IF;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Cons_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Cons_
          INTO Emp_Cons_Rec_;
        EXIT WHEN c_Employee_Cons_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Cons_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Cons_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0014;
  --
  PROCEDURE Get_P0015 IS
    It_              It0015;
    Wa_              P0015;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    Chunk_No_ NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Change_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Reg_Change_Data_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.Payroll_List_Id IS NOT NULL
         AND b.Data_Deriv_Day > c_Var_Mig
         AND EXISTS (SELECT 1
                FROM Intface_Conv_List_Cols_Tab m
               WHERE m.Conv_List_Id = 'EXP_SAP'
                 AND m.Old_Value IN
                     ('****^M_PARAM_ID^' || b.Param_Id,
                      Lpad(b.Company_Id, 4, '0') || '^M_PARAM_ID^' || b.Param_Id)
                 AND NOT (Substr(Upper(m.New_Value), 1, 3) IN ('?$$', 'N/A') OR
                      Substr(m.New_Value, 1, 1) IN ('?')))
       ORDER BY b.Param_Id, b.Data_Deriv_Day;
    Emp_Change_Rec_ c_Employee_Change_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        IF Substr(Wa_.Ps0015_.Lgart, 1, 3) NOT IN ('N/A', '?') THEN
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0015_.Lgart := n_Emp_.S1; --LGART  CHAR  4 T512Z Wage Type
      Wa_.Ps0015_.Opken := NULL; --OPKEN  CHAR  1   Operation Indicator for Wage Types
      Wa_.Ps0015_.Betrg := n_Emp_.S2; --PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Wa_.Ps0015_.Waers := n_Emp_.S3; --WAERS  CUKY  5 TCURC Currency Key
      Wa_.Ps0015_.Anzhl := n_Emp_.S4; --ANZHL  DEC 7(2)    Number
      Wa_.Ps0015_.Zeinh := n_Emp_.S5; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Wa_.Ps0015_.Indbw := NULL; --INDBW  CHAR  1   Indicator for indirect valuation
      Wa_.Ps0015_.Zuord := NULL; --UZORD CHAR  20    Assignment Number
      Wa_.Ps0015_.Estdt := NULL; --ESTDT  DATS  8   Date of origin
      Wa_.Ps0015_.Pabrj := NULL; --PABRJ  NUMC  4   Payroll Year  GJAHR
      Wa_.Ps0015_.Pabrp := NULL; --PABRP  NUMC  2   Payroll Period
      Wa_.Ps0015_.Uwdat := NULL; --UWDAT  DATS  8   Date of Bank Transfer
      Wa_.Ps0015_.Itftt := NULL; --P06I_ITFTT  CHAR  2   Processing type
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Change_%ROWTYPE) IS
      Period_Date_ DATE;
    BEGIN
      --
      Rec_.Date_From := Inrec_.Data_Deriv_Day;
      Rec_.Date_To   := Inrec_.Data_Deriv_Day;
      --
      Rec_.S1 := Get_Mapping(m_Param_Id, Inrec_.Param_Id, FALSE); -- LGART
      Rec_.S2 := My_Number___(Inrec_.Value); -- BETRG
      Rec_.S3 := 'PLN'; -- WAERS
      Rec_.S4 := '0'; -- ANZHL
      Rec_.S5 := ''; -- ZEINH
      Rec_.S6 := '0'; -- ZANZL
      -- special periodical bonuses
      IF Rec_.S1 = '0030' THEN
        Rec_.S4 := My_Number___(To_Char(Rec_.Date_From, 'YYYY') || ',01');
        Rec_.S5 := '013'; -- ZEINH -> LATA
        --
        Period_Date_   := Hrp_Pay_List_Api.Get_Date_To(c_Company_Id, Inrec_.Payroll_List_Id);
        Rec_.Date_From := Period_Date_;
        Rec_.Date_To   := Period_Date_;
      END IF;
      IF Substr(Rec_.S1, 5, 1) = 'N' THEN
        Rec_.S1 := Substr(Rec_.S1, 1, 4);
        Rec_.S2 := '0';
        Rec_.S4 := My_Number___(Inrec_.Value);
      END IF;
      --
      -- trim to 4
      Rec_.S1 := Substr(Rec_.S1, 1, 4);
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Change_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Change_
          INTO Emp_Change_Rec_;
        EXIT WHEN c_Employee_Change_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Change_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        --
        -- chunk of file
        IF Rec_No_ > c_Payroll_Chunk THEN
          Rec_No_   := 0;
          Chunk_No_ := Nvl(Chunk_No_, 0) + 1;
          -- flush
          Zpk_Sap_Exp_Dic_Api.Store___(It_, Chunk_No_);
          -- clear
          It_.Delete;
        END IF;
      END LOOP;
      CLOSE c_Employee_Change_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    IF Chunk_No_ IS NOT NULL THEN
      Chunk_No_ := Chunk_No_ + 1;
    END IF;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_, Chunk_No_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0015;
  --
  PROCEDURE Get_P0016 IS
    It_              It0016;
    Wa_              P0016;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Time_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Emp_Employed_Time_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.Employment_Id != 4 -- UCP - cywilno prawna
         AND b.Employment_Id != 7 -- ZLC
       ORDER BY b.Date_Of_Employment;
    Emp_Time_Rec_ c_Employee_Time_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: ...
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
          --
          Wa_.Ps0016_.Nbtgk    := NULL; --NBTGK  CHAR  1   Sideline Job
          Wa_.Ps0016_.Wttkl    := NULL; --WTTKL  CHAR  1   Competition Clause
          Wa_.Ps0016_.Lfzfr    := o_Emp_.S1; --LFZFR  DEC 3   Period of Continued Pay (Number)
          Wa_.Ps0016_.Lfzzh    := o_Emp_.S2; --LFZZH  CHAR  3 T538A Period of Continued Pay (Unit)
          Wa_.Ps0016_.Lfzso    := NULL; --LFZSR  NUMC  2   Special Rule for Continued Pay
          Wa_.Ps0016_.Kgzfr    := o_Emp_.S3; --KGZFR  DEC 3   Sick Pay Supplement Period (Number)
          Wa_.Ps0016_.Kgzzh    := o_Emp_.S4; --KGZZH  CHAR  3 T538A Sick Pay Supplement Period (Unit)
          Wa_.Ps0016_.Prbzt    := o_Emp_.S5; --PRBZT  DEC 3   Probationary Period (Number)
          Wa_.Ps0016_.Prbeh    := o_Emp_.S6; --PRBEH  CHAR  3 T538A Probationary Period (Unit)
          Wa_.Ps0016_.Kdgfr    := o_Emp_.S7; --KDGFR  CHAR  2 T547T Dismissals Notice Period for Employer
          Wa_.Ps0016_.Kdgf2    := o_Emp_.S8; --KDGF2  CHAR  2 T547T Dismissals Notice Period for Employee
          Wa_.Ps0016_.Arber    := NULL; --ARBER  DATS  8   Expiration Date of Work Permit
          Wa_.Ps0016_.Eindt    := NULL; --EINTR  DATS  8   Initial Entry
          Wa_.Ps0016_.Kondt    := NULL; --KONDT  DATS  8   Date of Entry into Group
          Wa_.Ps0016_.Konsl    := NULL; --KOSL1  CHAR  2 T545T Group Key
          Wa_.Ps0016_.Cttyp    := o_Emp_.S9; --CTTYP  CHAR  2 T547V Contract Type
          Wa_.Ps0016_.Ctedt    := o_Emp_.S10; --CTEDT  DATS  8   Contract End Date
          Wa_.Ps0016_.Persg    := NULL; --PERSG  CHAR  1 T501  Employee Group
          Wa_.Ps0016_.Persk    := NULL; --PERSK  CHAR  2 T503K Employee Subgroup
          Wa_.Ps0016_.Wrkpl    := NULL; -- WRKPL CHAR  40    Work Location (Contract Elements Infotype)
          Wa_.Ps0016_.Ctbeg    := NULL; --CTBEG  DATS  8   Contract Start
          Wa_.Ps0016_.Ctnum    := NULL; --PCN_CTNUM  CHAR  20    Contract number
          Wa_.Ps0016_.Objnb    := NULL; --OBJNB CHAR  12    Object Number (France)
          Wa_.Ps0016_.Zzdatzaw := o_Emp_.S11;
          --
          Save_;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Time_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Date_Of_Employment;
      Rec_.Date_To   := Inrec_.Date_Of_Leaving;
      --
      Rec_.S1  := '42'; --LFZFR
      Rec_.S2  := '010'; --LFZZH
      Rec_.S3  := '6'; --KGZFR
      Rec_.S4  := '012'; --KGZZH
      Rec_.S5  := '3'; --PRBZT
      Rec_.S6  := '012'; --PRBEH
      Rec_.S7  := '13'; --KDGFR
      Rec_.S8  := '13'; --KDGF2
      Rec_.S9  := Get_Mapping(m_Time_Id, Inrec_.Employment_Id, FALSE); -- CTTYP
      Rec_.S10 := My_Date___(Inrec_.Date_Of_Leaving); --CTEDT -- combine issue
      Rec_.S11 := My_Date___(Inrec_.Leaving_Notification_Date); --ZZDATZAW
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Time_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Time_
          INTO Emp_Time_Rec_;
        EXIT WHEN c_Employee_Time_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        -- validate breaks in the months
        IF o_Rec_.Date_To IS NOT NULL THEN
          IF Trunc(o_Rec_.Date_To, 'MONTH') = Trunc(n_Rec_.Date_From, 'MONTH') THEN
            IF o_Rec_.Date_To + 1 != n_Rec_.Date_From THEN
              Add_Error___(Emp_Company_Rec_.Employee_Id, 'CriticalDataGap', 10,
                           'There is a gap of employement in the month ' || --
                            To_Char(o_Rec_.Date_To) || ' - ' || To_Char(n_Rec_.Date_From));
            END IF;
          END IF;
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Time_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Time_;
      -- perform last rec for each employee
      -- not clear logic
      -- if its filled
      IF o_Rec_.Date_From IS NOT NULL THEN
        Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
      END IF;
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0016;
  --
  PROCEDURE Get_P0019 IS
    It_              It0019;
    Wa_              P0019;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Licence_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.Valid_From, b.Valid_To, b.License_Name, b.License_Info Ctext_
        FROM Company_Emp_Tab e, Pers_License_Profile b
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = b.Person_Id
         AND e.Employee_Id = Emmployee_Id_
      UNION ALL
      SELECT e.Employee_Id, h.Issue_Date, h.Valid_Till, h.Health_Check_Type_Id, h.Note Ctext_
        FROM Company_Emp_Tab e, Health_Check h
       WHERE e.Company = c_Company_Id
         AND e.Company = h.Company_Id
         AND e.Employee_Id = h.Emp_No
         AND e.Employee_Id = Emmployee_Id_
      UNION ALL
      SELECT e.Employee_Id, p.Date_From, p.Date_To, p.Penality_Id, p.Note Ctext_
        FROM Company_Emp_Tab e, Disciplinary_Penalities_Tab p
       WHERE e.Company = c_Company_Id
         AND e.Company = p.Company_Id
         AND e.Employee_Id = p.Emp_No
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY 1, 2;
    Emp_Licence_Rec_ c_Employee_Licence_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        IF Upper(Wa_.Ps0019_.Tmart) = 'NA' THEN
          RETURN;
        END IF;
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Pshd1_.Itxex := n_Emp_.S11;
      --
      Wa_.Ps0019_.Tmart := n_Emp_.S1; -- varchar2(2), --TMART  CHAR  2 T531  Task Type
      Wa_.Ps0019_.Termn := n_Emp_.S2; -- varchar2(8), --TERMN  DATS  8   Date of Task
      Wa_.Ps0019_.Mndat := n_Emp_.S3; -- varchar2(8), --MNDAT  DATS  8   Reminder Date
      Wa_.Ps0019_.Bvmrk := NULL; --BVMRK  CHAR  1   Processing indicator
      Wa_.Ps0019_.Tmjhr := n_Emp_.S4; --TMJHR  NUMC  4   Year of date  GJAHR
      Wa_.Ps0019_.Tmmon := n_Emp_.S5; -- varchar2(2), --TMMON  NUMC  2   Month of date
      Wa_.Ps0019_.Tmtag := n_Emp_.S6; -- varchar2(2), --TMTAG  NUMC  2   Day of date
      Wa_.Ps0019_.Mnjhr := n_Emp_.S7; -- varchar2(4), --MNJHR  NUMC  4   Year of reminder  GJAHR
      Wa_.Ps0019_.Mnmon := n_Emp_.S8; -- varchar2(2), --MNMON  NUMC  2   Month of reminder
      Wa_.Ps0019_.Mntag := n_Emp_.S9; -- varchar2(2) --MNTAG NUMC  2   Day of reminder
      Wa_.Ps0019_.Ctext := n_Emp_.S10; -- cluster texts
      --
      Save_;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Licence_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Valid_From;
      Rec_.Date_To   := Nvl(Inrec_.Valid_To, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1  := Get_Mapping(m_Quali_Type, Inrec_.License_Name, FALSE); --
      Rec_.S2  := My_Date___(Rec_.Date_To); --
      Rec_.S3  := My_Date___(Rec_.Date_To - 30); --
      Rec_.S4  := To_Char(Rec_.Date_To, 'YYYY'); --TMJHR
      Rec_.S5  := To_Char(Rec_.Date_To, 'MM');
      Rec_.S6  := To_Char(Rec_.Date_To, 'DD');
      Rec_.S7  := To_Char(Rec_.Date_To - 30, 'YYYY'); --TMJHR
      Rec_.S8  := To_Char(Rec_.Date_To - 30, 'MM');
      Rec_.S9  := To_Char(Rec_.Date_To - 30, 'DD');
      Rec_.S10 := Substr(Inrec_.Ctext_, 1, 200);
      --
      Rec_.S1 := REPLACE(Rec_.S1, 'N/A', 'NA');
      Rec_.S1 := REPLACE(Rec_.S1, 'n/a', 'NA');
      --
      IF Inrec_.Ctext_ IS NOT NULL THEN
        Rec_.S11 := 'X';
      END IF;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Licence_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Licence_
          INTO Emp_Licence_Rec_;
        EXIT WHEN c_Employee_Licence_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill licence area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Licence_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Licence_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0019;
  --
  PROCEDURE Get_P0021 IS
    It_ It0021;
    Wa_ P0021;
    -- extend
    It2_ It0517;
    Wa2_ P0517;
    --
    -- fetch data
    Lv_Person_Id_    VARCHAR2(20);
    Lv_Dependent_Id_ NUMBER;
    Lv_Pesel_        VARCHAR2(20);
    --
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Rec_No_   NUMBER := 0;
    Is_First_ BOOLEAN;
    i_        NUMBER;
    j_        NUMBER;
    --
    -- local cursors
    --
    CURSOR c_Employee_Dependent_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, t.*
        FROM Employee_Dependent_Tab t, Company_Emp_Tab e
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = t.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY t.Dependent_Id;
    Emp_Dep_Rec_ c_Employee_Dependent_%ROWTYPE;
    --
    CURSOR c_Ssi_Dependent_(c_Employee_Id_ VARCHAR2, c_Person_Id_ VARCHAR2, c_Dependent_Id_ NUMBER) IS
      SELECT *
        FROM Ssi_Family_Data_Tab t
       WHERE Company_Id = c_Company_Id
         AND Emp_No = c_Employee_Id_
         AND Person_Id = c_Person_Id_
         AND Dependent_Id = c_Dependent_Id_
         AND Ins_Beg_Exp_Date = (SELECT MAX(b.Ins_Beg_Exp_Date)
                                   FROM Ssi_Family_Data_Tab b
                                  WHERE b.Company_Id = t.Company_Id
                                    AND b.Person_Id = t.Person_Id
                                    AND b.Emp_No = t.Emp_No
                                    AND b.Dependent_Id = t.Dependent_Id);
    Ssi_Dep_Rec_ c_Ssi_Dependent_%ROWTYPE;
    --
    FUNCTION Fix_Map(Dependent_Id_ VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
      CASE Dependent_Id_
        WHEN 0101 THEN
          RETURN 11;
        WHEN 0201 THEN
          RETURN 21;
        WHEN 0202 THEN
          RETURN 22;
        WHEN 0203 THEN
          RETURN 23;
        WHEN 1101 THEN
          RETURN 31;
        WHEN 1201 THEN
          RETURN 41;
        WHEN 1202 THEN
          RETURN 42;
        ELSE
          RETURN 99;
      END CASE;
    END Fix_Map;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add master data of employee
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0021_.Famsa := n_Emp_.S1; --FAMSA  CHAR  4   Type of Family Record
      Wa_.Ps0021_.Fgbdt := n_Emp_.S2; --GBDAT  DATS  8   Date of Birth PDATE
      Wa_.Ps0021_.Fgbld := NULL; --GBLND  CHAR  3 T005  Country of Birth
      Wa_.Ps0021_.Fanat := n_Emp_.S3; --NATSL  CHAR  3 T005  Nationality
      Wa_.Ps0021_.Fasex := n_Emp_.S4; --GESCH  CHAR  1   Gender Key
      Wa_.Ps0021_.Favor := n_Emp_.S5; --PAD_VORNA  CHAR  40    First Name
      Wa_.Ps0021_.Fanam := n_Emp_.S6; --PAD_NACHN  CHAR  40    Last Name
      Wa_.Ps0021_.Fgbot := NULL; --PAD_GBORT  CHAR  40    Birthplace
      Wa_.Ps0021_.Fgdep := NULL; --GBDEP  CHAR  3 T005S State
      Wa_.Ps0021_.Erbnr := n_Emp_.S7; --ERBNR  CHAR  12    Reference Personnel Number for Family Member
      Wa_.Ps0021_.Fgbna := NULL; --PAD_NAME2  CHAR  40    Name at Birth
      Wa_.Ps0021_.Fnac2 := NULL; --PAD_NACH2  CHAR  40    Second Name
      Wa_.Ps0021_.Fcnam := NULL; --PAD_CNAME  CHAR  80    Complete Name
      Wa_.Ps0021_.Fknzn := NULL; --KNZNM  NUMC  2   Name Format Indicator for Employee in a List
      Wa_.Ps0021_.Finit := NULL; --INITS  CHAR  10    Initials
      Wa_.Ps0021_.Fvrsw := NULL; --VORSW  CHAR  15  T535N Name Prefix
      Wa_.Ps0021_.Fvrs2 := NULL; --VORSW  CHAR  15  T535N Name Prefix
      Wa_.Ps0021_.Fnmzu := NULL; --NAMZU  CHAR  15  T535N Other Title
      Wa_.Ps0021_.Ahvnr := NULL; --AHVNR  CHAR  11    AHV Number  AHVNR
      Wa_.Ps0021_.Kdsvh := NULL; --KDSVH  CHAR  2 T577  Relationship to Child
      Wa_.Ps0021_.Kdbsl := NULL; --KDBSL  CHAR  2 T577  Allowance Authorization
      Wa_.Ps0021_.Kdutb := NULL; --KDUTB  CHAR  2 T577  Address of Child
      Wa_.Ps0021_.Kdgbr := NULL; --KDGBR  CHAR  2 T577  Child Allowance Entitlement
      Wa_.Ps0021_.Kdart := NULL; --KDART  CHAR  2 T577  Child Type
      Wa_.Ps0021_.Kdzug := NULL; --KDZUG  CHAR  2 T577  Child Bonuses
      Wa_.Ps0021_.Kdzul := NULL; --KDZUL  CHAR  2 T577  Child Allowances
      Wa_.Ps0021_.Kdvbe := NULL; --KDVBE  CHAR  2 T577  Sickness Certificate Authorization
      Wa_.Ps0021_.Ermnr := NULL; --ERMNR  CHAR  8   Authority Number
      Wa_.Ps0021_.Ausvl := NULL; --AUSVL  NUMC  4   1st Part of SI Number (Sequential Number)
      Wa_.Ps0021_.Ausvg := NULL; --AUSVG  NUMC  8   2nd Part of SI Number (Birth Date)
      Wa_.Ps0021_.Fasdt := NULL; --FASDT  DATS  8   End of Family Members Education/Training
      Wa_.Ps0021_.Fasar := NULL; --FASAR  CHAR  2 T517T School Type of Family Member
      Wa_.Ps0021_.Fasin := NULL; --FASIN  CHAR  20    Educational Institute
      Wa_.Ps0021_.Egaga := NULL; --EGAGA  CHAR  8   Employer of Family Member
      Wa_.Ps0021_.Fana2 := NULL; --NATS2  CHAR  3 T005  Second Nationality
      Wa_.Ps0021_.Fana3 := NULL; --NATS3  CHAR  3 T005  Third Nationality
      Wa_.Ps0021_.Betrg := NULL; --BETRG  CURR  9(2)    Amount
      Wa_.Ps0021_.Titel := NULL; --TITEL  CHAR  15  T535N Title
      Wa_.Ps0021_.Emrgn := NULL; --PAD_EMRGN  CHAR  1   Emergency Contact
      -- additional sequence number
      Wa_.Pakey_.Subty := n_Emp_.S1;
      Wa_.Pakey_.Objps := n_Emp_.S8;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Dependent_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Get_Emp_First_Employement(Emp_No_); --Inrec_.Birthdate; --Get_Emp_First_Employement(Emp_No_);
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      Rec_.S1 := Get_Mapping(m_Relative_Id, Inrec_.Relationship_Type, FALSE); --FAMSA
      Rec_.S2 := My_Date___(Inrec_.Birthdate); --FGBDT
      Rec_.S3 := 'PL'; --FANAT
      Rec_.S4 := Get_Mapping(m_Sex_Id, Inrec_.Gender, FALSE); --FASEX
      Rec_.S5 := Upper(Inrec_.First_Name); --FAVOR
      Rec_.S6 := Upper(Inrec_.Last_Name); --FANAM
      Rec_.S7 := Inrec_.Dependent_Id;
      Rec_.S7 := TRIM(To_Char(Fix_Map(Inrec_.Dependent_Id), '00'));
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Dependent_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Dependent_
          INTO Emp_Dep_Rec_;
        EXIT WHEN c_Employee_Dependent_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Dep_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Dependent_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
    -- extension to infotype 0517
    i_ := It_.First;
    WHILE i_ IS NOT NULL LOOP
      Wa_         := It_(i_);
      Wa2_.Pakey_ := Wa_.Pakey_;
      -- fetch data
      Lv_Person_Id_    := Company_Pers_Api.Get_Person_Id(c_Company_Id, Wa_.Pakey_.Pernr);
      Lv_Dependent_Id_ := To_Number(Wa_.Ps0021_.Erbnr);
      --
      Lv_Pesel_ := Employee_Dependent_Prop_Api.Get_Property_Value(Lv_Person_Id_, Lv_Dependent_Id_,
                                                                  'DEPRELID');
      -- fetch ssi
      OPEN c_Ssi_Dependent_(Wa_.Pakey_.Pernr, Lv_Person_Id_, Lv_Dependent_Id_);
      FETCH c_Ssi_Dependent_
        INTO Ssi_Dep_Rec_;
      CLOSE c_Ssi_Dependent_;
      --
      Wa2_.Ps0517_.Zcnac := Get_Mapping(m_Relative_Zus_Id, Wa_.Ps0021_.Famsa, FALSE);
      Wa2_.Ps0517_.Pesel := Lv_Pesel_;
      Wa2_.Ps0517_.Stpns := Ssi_Dep_Rec_.Disability_Code; --PPL_STPNS CHAR  1   Disability level
      Wa2_.Ps0517_.Ruszr := 'X';
      IF Ssi_Dep_Rec_.One_Household = 'TRUE' THEN
        Wa2_.Ps0517_.Cnhld := 'X';
      END IF;
      Wa2_.Ps0517_.Land1 := 'PL';
      --
      j_ := Nvl(It2_.Last, 0) + 1;
      It2_(j_) := Wa2_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    Zpk_Sap_Exp_Dic_Api.Store___(It2_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0021;
  --
  PROCEDURE Get_P0022 IS
    It_ It0022;
    Wa_ P0022;
    -- extend
    It2_             It0866;
    Wa2_             P0866;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    i_        NUMBER;
    j_        NUMBER;
    --
    -- local cursors
    --
    CURSOR c_Employee_Edu_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Pers_Education_Profile b
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = b.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Pers_Edu_Number;
    Emp_Edu_Rec_ c_Employee_Edu_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0022_.Slart := n_Emp_.S1; --SLART  CHAR  2 T517T Educational establishment
      Wa_.Ps0022_.Insti := n_Emp_.S2; --INSTI  CHAR  80    Institute/location of training
      Wa_.Ps0022_.Sland := n_Emp_.S3; --LAND1  CHAR  3 T005  Country Key
      Wa_.Ps0022_.Ausbi := n_Emp_.S4; --AUSBI  NUMC  8 T518A Education/training
      Wa_.Ps0022_.Slabs := n_Emp_.S5; --SLABS  CHAR  2 T519T Certificate
      Wa_.Ps0022_.Anzkl := n_Emp_.S6; --ANZKL  DEC 3   Duration of training course
      Wa_.Ps0022_.Anzeh := NULL; --PT_ZEINH CHAR  3 T538A Time/Measurement Unit
      Wa_.Ps0022_.Sltp1 := NULL; --FACH1  NUMC  5 T517Y Branch of study
      Wa_.Ps0022_.Sltp2 := NULL; --FACH2  NUMC  5 T517Y Branch of study
      Wa_.Ps0022_.Jbez1 := NULL; --KSGEB  CURR  11(2)   Course fees
      Wa_.Ps0022_.Waers := NULL; --WAERS  CUKY  5 TCURC Currency Key
      Wa_.Ps0022_.Slpln := NULL; --KSPLN  CHAR  1   Planned course (unused)
      Wa_.Ps0022_.Slktr := NULL; --SLKTR  CHAR  2   Cost object (unused)
      Wa_.Ps0022_.Slrzg := NULL; --SLRZG  CHAR  1   Repayment obligation
      Wa_.Ps0022_.Ksbez := NULL; --KSBEZ  CHAR  25    Course name
      Wa_.Ps0022_.Tx122 := NULL; --KSBUR  CHAR  40    Course appraisal
      Wa_.Ps0022_.Schcd := NULL; --P22J_SCHCD NUMC  10    Institute/school code
      Wa_.Ps0022_.Faccd := NULL; --P22J_FACCD NUMC  3   Faculty code
      Wa_.Ps0022_.Dptmt := NULL; -- DPTMT CHAR  40    Department
      Wa_.Ps0022_.Emark := NULL; --EMARK CHAR  4   Final Grade
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Edu_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Start_Year;
      Rec_.Date_To   := Nvl(Inrec_.End_Year, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Get_Mapping(m_Edu_Type_Id, Inrec_.Education_Level_Name, FALSE); -- SLART
      Rec_.S2 := Substr(Inrec_.Location, 1, 80); -- INSTI
      Rec_.S3 := 'PL'; -- SLAND
      Rec_.S4 := Get_Mapping(m_Edu_Level_Id, Inrec_.Education_Level_Name, FALSE); -- AUSBI
      Rec_.S5 := Get_Mapping(m_Edu_Title_Id, Inrec_.Education_Level_Name, FALSE); -- SLABS
      Rec_.S6 := '0'; -- ANZKL
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Edu_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Edu_
          INTO Emp_Edu_Rec_;
        EXIT WHEN c_Employee_Edu_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Edu_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Edu_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
    --
    i_ := It_.First;
    WHILE i_ IS NOT NULL LOOP
      Wa_                    := It_(i_);
      Wa2_.Pakey_            := Wa_.Pakey_;
      Wa2_.Ps0866_.Beg_Sch   := Wa_.Pakey_.Begda;
      Wa2_.Ps0866_.End_Sch   := Wa_.Pakey_.Endda;
      Wa2_.Ps0866_.Ifs_Subty := Wa_.Ps0022_.Slart;
      --
      j_ := Nvl(It2_.Last, 0) + 1;
      It2_(j_) := Wa2_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    Zpk_Sap_Exp_Dic_Api.Store___(It2_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0022;
  --
  --
  PROCEDURE Get_P0023 IS
    It_ It0023;
    Wa_ P0023;
    -- extend
    It2_ It0414;
    Wa2_ P0414;
    --
    Years_  NUMBER;
    Months_ NUMBER;
    Days_   NUMBER;
    i_      NUMBER;
    j_      NUMBER;
    --
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Work_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Pers_Work_Experience b
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = b.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Start_Date;
    Emp_Work_Rec_ c_Employee_Work_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0023_.Arbgb   := Substr(n_Emp_.S1, 1, 60); --VORAG  CHAR  60    Name of employer
      Wa_.Ps0023_.Ort01   := NULL; --ORT01  CHAR  25    City
      Wa_.Ps0023_.Land1   := n_Emp_.S2; --LAND1  CHAR  3 T005  Country Key
      Wa_.Ps0023_.Branc   := NULL; --BRSCH  CHAR  4 T016  Industry key
      Wa_.Ps0023_.Taete   := NULL; --TAETE  NUMC  8 T513C Job at former employer(s)
      Wa_.Ps0023_.Ansvx   := NULL; --ANSVX  CHAR  2 T542C Work Contract - Other Employers
      Wa_.Ps0023_.Ortj1   := NULL; --P22J_ADDR1 CHAR  40    First address line (Kanji)
      Wa_.Ps0023_.Ortj2   := NULL; --P22J_ADDR2 CHAR  40    Second address line (Kanji)
      Wa_.Ps0023_.Ortj3   := NULL; --P22J_ADDR3  CHAR  40    Third address line (Kanji)
      Wa_.Ps0023_.Ifs_Sen := n_Emp_.S3;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Work_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Start_Date;
      Rec_.Date_To   := Nvl(Inrec_.End_Date, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Inrec_.Company; -- ARBGB
      Rec_.S2 := 'PL'; -- LAND1
      Rec_.S3 := Upper(Inrec_.Leaving_Cause_Type);
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Work_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Work_
          INTO Emp_Work_Rec_;
        EXIT WHEN c_Employee_Work_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Work_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Work_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
    -- extension to infotype 0414
    i_ := It_.First;
    WHILE i_ IS NOT NULL LOOP
      Wa_         := It_(i_);
      Wa2_.Pakey_ := Wa_.Pakey_;
      -- fetch data
      --
      BEGIN
        Seniority_Api.Remainder_ := FALSE;
        Years_                   := 0;
        Months_                  := 0;
        Days_                    := 0;
        Seniority_Api.Calculate_Seniority__(Years_, Months_, Days_,
                                            To_Date(Wa_.Pakey_.Begda, 'YYYYMMDD'),
                                            To_Date(Wa_.Pakey_.Endda, 'YYYYMMDD'));
        /*
        01  Sta¿ do wymiaru urlopu
        02  Sta¿ do wys³ugi ³¹cznie
        03  Sta¿ do nagrody jubileuszowej
        04  Sta¿ do wys³ugi obcy
        05  Sta¿ do wys³ugi zak³adowy
        06  Sta¿ do urlopu w pierwszym roku pracy
        07  Sta¿ do emerytury
        */
        --
        Wa2_.Ps0414_.Scd01 := '01';
        Wa2_.Ps0414_.Sid01 := '+';
        Wa2_.Ps0414_.Syy01 := Years_;
        Wa2_.Ps0414_.Smm01 := Months_;
        Wa2_.Ps0414_.Sdd01 := Days_;
        --
        Wa2_.Ps0414_.Scd02 := '02';
        Wa2_.Ps0414_.Sid02 := '+';
        Wa2_.Ps0414_.Syy02 := Years_;
        Wa2_.Ps0414_.Smm02 := Months_;
        Wa2_.Ps0414_.Sdd02 := Days_;
        --
        Wa2_.Ps0414_.Scd03 := '03';
        Wa2_.Ps0414_.Sid03 := '+';
        Wa2_.Ps0414_.Syy03 := 0;
        Wa2_.Ps0414_.Smm03 := 0;
        Wa2_.Ps0414_.Sdd03 := 0;
        --
        Wa2_.Ps0414_.Scd06 := '06';
        Wa2_.Ps0414_.Sid06 := '+';
        Wa2_.Ps0414_.Syy06 := Years_;
        Wa2_.Ps0414_.Smm06 := Months_;
        Wa2_.Ps0414_.Sdd06 := Days_;
        --
        Wa2_.Ps0414_.Scd07 := '07';
        Wa2_.Ps0414_.Sid07 := '+';
        Wa2_.Ps0414_.Syy07 := Years_;
        Wa2_.Ps0414_.Smm07 := Months_;
        Wa2_.Ps0414_.Sdd07 := Days_;
        -- clear if not the same company
        IF Wa_.Ps0023_.Ifs_Sen != 'FIRMA' THEN
          Years_  := 0;
          Months_ := 0;
          Days_   := 0;
        END IF;
        --
        Wa2_.Ps0414_.Scd04 := '04';
        Wa2_.Ps0414_.Sid04 := '+';
        Wa2_.Ps0414_.Syy04 := Years_;
        Wa2_.Ps0414_.Smm04 := Months_;
        Wa2_.Ps0414_.Sdd04 := Days_;
        --
        Wa2_.Ps0414_.Scd05 := '05';
        Wa2_.Ps0414_.Sid05 := '+';
        Wa2_.Ps0414_.Syy05 := Years_;
        Wa2_.Ps0414_.Smm05 := Months_;
        Wa2_.Ps0414_.Sdd05 := Days_;
      EXCEPTION
        WHEN OTHERS THEN
          Add_Error___(Wa2_.Pakey_.Pernr, 'Seniority', 20,
                       'Seniority calculation for period' || --
                        Wa_.Pakey_.Begda || ' and pair ' || Wa_.Pakey_.Endda);
      END;
      --
      j_ := Nvl(It2_.Last, 0) + 1;
      It2_(j_) := Wa2_;
      --
      i_ := It_.Next(i_);
    END LOOP;
    Zpk_Sap_Exp_Dic_Api.Store___(It2_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0023;
  --
  PROCEDURE Get_P0024 IS
    It_              It0024;
    Wa_              P0024;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Licence_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Pers_License_Profile b
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = b.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Valid_From;
    Emp_Licence_Rec_ c_Employee_Licence_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0024_.Quali := n_Emp_.S1; --QUALI_D  NUMC  8 T574A Qualification key
      Wa_.Ps0024_.Auspr := n_Emp_.S2; --AUSPR NUMC  4 T778Q Proficiency of a Qualification/Requirement
      --
      Save_;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Licence_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Valid_From;
      Rec_.Date_To   := Nvl(Inrec_.Valid_To, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Get_Mapping(m_Quali_Type, Inrec_.License_Name, FALSE); --QUALI
      Rec_.S2 := NULL; -- LAND1
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      --IF c_Company_Id IN ('148') THEN
      IF 1 = 1 THEN
        EXIT;
      END IF;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Licence_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Licence_
          INTO Emp_Licence_Rec_;
        EXIT WHEN c_Employee_Licence_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill licence area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Licence_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Licence_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0024;
  --
  --
  PROCEDURE Get_P0041 IS
    It_              It0041;
    Wa_              P0041;
    n_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add master data of employee
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0041_.Dar01 := n_Emp_.S1; -- varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat01 := n_Emp_.S2; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar02 := n_Emp_.S3; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat02 := n_Emp_.S4; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar03 := n_Emp_.S5; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat03 := n_Emp_.S6; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar04 := n_Emp_.S7; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat04 := n_Emp_.S8; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar05 := n_Emp_.S9; --  DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat05 := n_Emp_.S10; -- DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar06 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat06 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar07 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat07 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar08 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat08 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar09 := NULL; --  varchar2(2), -- DATAR CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat09 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar10 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat10 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar11 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat11 := NULL; --  varchar2(8), --DARDT  DATS  8   Date for date type
      Wa_.Ps0041_.Dar12 := NULL; --  varchar2(2), --DATAR  CHAR  2 T548Y Date type
      Wa_.Ps0041_.Dat12 := NULL; --  varchar2(8) --DARDT  DATS  8   Date for date type
      Save_;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
    BEGIN
      Rec_.Date_From := Get_Emp_First_Employement(Emp_No_);
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      Rec_.S1  := '01'; --DAR01
      Rec_.S2  := My_Date___(Get_Emp_First_Employement(Emp_No_));
      Rec_.S3  := '02'; --DAR02
      Rec_.S4  := My_Date___(Get_Emp_Last_Employement(Emp_No_));
      Rec_.S5  := '03'; --DAR03
      Rec_.S6  := My_Date___(Get_Emp_Last_Employement(Emp_No_));
      Rec_.S7  := '26'; --DAR04
      Rec_.S8  := My_Date___(Get_Emp_Last_Employement(Emp_No_));
      Rec_.S9  := '50'; --DAR05
      Rec_.S10 := My_Date___(Get_Emp_Last_Employement(Emp_No_));
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
        Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id);
      END IF;
      -- fill work area with master data value
      Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
      -- apply storage logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0041;
  --
  PROCEDURE Get_P0105 IS
    It_              It0105;
    Wa_              P0105;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Comm_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, c.*
        FROM Company_Emp_Tab e, Pers_Comms2 c
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = c.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY c.Valid_From;
    Emp_Comm_Rec_ c_Employee_Comm_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps0105_.Usrty      := n_Emp_.S1;
      Wa_.Ps0105_.Usrid      := n_Emp_.S2;
      Wa_.Ps0105_.Usrid_Long := n_Emp_.S3;
      --
      Save_;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Comm_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Valid_From;
      Rec_.Date_To   := Nvl(Inrec_.Valid_To, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Get_Mapping(m_Comm_Type_Id, Inrec_.Method_Id_Db, FALSE); --QUALI
      IF Length(Inrec_.Comm_Data) <= 30 THEN
        Rec_.S2 := Inrec_.Comm_Data; -- LAND1
      ELSE
        Rec_.S3 := Inrec_.Comm_Data;
      END IF;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Comm_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Comm_
          INTO Emp_Comm_Rec_;
        EXIT WHEN c_Employee_Comm_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill licence area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Comm_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Comm_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0105;
  --
  PROCEDURE Get_P0185 IS
    It_              It0185;
    Wa_              P0185;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Doc_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Pers_Document b
       WHERE e.Company = c_Company_Id
         AND e.Person_Id = b.Person_Id
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Valid_From;
    Emp_Doc_Rec_ c_Employee_Doc_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      --
      Wa_.Ps0185_.Ictyp := n_Emp_.S1; -- ICTYP CHAR  2 T5R05 Type of identification (IC type)
      Wa_.Ps0185_.Icnum := n_Emp_.S2; -- PSG_IDNUM CHAR  30    Identity Number
      Wa_.Ps0185_.Icold := NULL; -- ICOLD CHAR  20    Old IC number
      Wa_.Ps0185_.Auth1 := n_Emp_.S3; -- P25_AUTH1 CHAR  30    Issuing authority
      Wa_.Ps0185_.Docn1 := NULL; -- ISNUM CHAR  20    Document issuing number
      Wa_.Ps0185_.Fpdat := n_Emp_.S4; -- PSG_FPDAT DATS  8   Date of issue for personal ID
      Wa_.Ps0185_.Expid := n_Emp_.S5; -- EXPID DATS  8   ID expiry date
      Wa_.Ps0185_.Isspl := NULL; -- P25_ISSPL CHAR  30    Place of issue of Identification
      Wa_.Ps0185_.Iscot := n_Emp_.S6; -- P25_ISCOT CHAR  3 T005  Country of issue
      Wa_.Ps0185_.Idcot := NULL; -- P25_IDCOT CHAR  3 T005  Country of ID
      Wa_.Ps0185_.Ovchk := NULL; -- P25_OVCHK CHAR  1   Indicator for overriding consistency check
      Wa_.Ps0185_.Astat := NULL; -- PCN_ASTAT CHAR  1   Application status
      Wa_.Ps0185_.Akind := NULL; -- P25_AKIND CHAR  1   Single/multiple
      Wa_.Ps0185_.Rejec := NULL; -- P25_REJEC CHAR  20    Reject reason
      Wa_.Ps0185_.Usefr := NULL; -- P25_USEFR DATS  8   Used from -date
      Wa_.Ps0185_.Useto := NULL; -- P25_USETO DATS  8   Used to -date
      Wa_.Ps0185_.Daten := n_Emp_.S7; -- P25_DATEN DEC 3   Valid length of multiple visa
      Wa_.Ps0185_.Dateu := NULL; -- DZEINZ  CHAR  3 T538A Time unit for determining next payment
      Wa_.Ps0185_.Times := NULL; --  P25_TIMES DATS  8   Application date
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Doc_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Valid_From;
      Rec_.Date_To   := Nvl(Inrec_.Valid_To, Database_Sys.Get_Last_Calendar_Date);
      --
      Rec_.S1 := Get_Mapping(m_Doc_Type, Inrec_.Pers_Doc_Type, FALSE); --ICTYP
      Rec_.S2 := Inrec_.Pers_Doc_Id; -- OCNUM
      Rec_.S3 := Substr(Inrec_.Issued_By, 1, 30); -- AUTH1
      Rec_.S4 := My_Date___(Inrec_.Valid_From); -- FPDAT
      Rec_.S5 := My_Date___(Inrec_.Valid_To); -- EXPOD
      Rec_.S6 := Inrec_.Country_Db; -- ISCOT
      Rec_.S7 := '0'; -- DATEN
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Doc_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Doc_
          INTO Emp_Doc_Rec_;
        EXIT WHEN c_Employee_Doc_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill doc area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Doc_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Doc_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0185;
  --
  PROCEDURE Get_P0267 IS
    It_              It0267;
    Wa_              P0267;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Is_Outer_ VARCHAR2(5);
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Agreement_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id,
             b.*,
             a.Agreement_Description,
             a.Date_From,
             a.Date_To,
             a.Agreement_Subject
        FROM Company_Emp_Tab e, Hrp_Agreement_Detail_Tab b, Hrp_Agreement_Tab a
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND a.Company_Id = b.Company_Id
         AND a.Agreement_No = b.Agreement_No
         AND e.Employee_Id = Emmployee_Id_
       ORDER BY b.Validation_Date;
    Emp_Agreement_Rec_ c_Employee_Agreement_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      --
      Wa_.Ps0267_.Lgart    := n_Emp_.S1; -- LGART CHAR  4 T512Z Wage Type
      Wa_.Ps0267_.Opken    := NULL; -- OPKEN CHAR  1   Operation Indicator for Wage Types
      Wa_.Ps0267_.Betrg    := n_Emp_.S2; -- PAD_AMT7S CURR  13(2)   Wage Type Amount for Payments
      Wa_.Ps0267_.Waers    := n_Emp_.S3; -- WAERS CUKY  5 TCURC Currency Key
      Wa_.Ps0267_.Anzhl    := n_Emp_.S4; -- ANZHL DEC 7(2)    Number
      Wa_.Ps0267_.Zeinh    := NULL; -- PT_ZEINH  CHAR  3 T538A Time/Measurement Unit
      Wa_.Ps0267_.Indbw    := NULL; -- INDBW CHAR  1   Indicator for indirect valuation
      Wa_.Ps0267_.Zuord    := n_Emp_.S13; -- UZORD CHAR  20    Assignment Number
      Wa_.Ps0267_.Estdt    := n_Emp_.S14; -- ESTDT DATS  8   Date of origin
      Wa_.Ps0267_.Pabrj    := n_Emp_.S6; -- PABRJ NUMC  4   Payroll Year  GJAHR
      Wa_.Ps0267_.Pabrp    := NULL; -- PABRP NUMC  2   Payroll Period
      Wa_.Ps0267_.Uwdat    := NULL; -- UWDAT DATS  8   Date of Bank Transfer
      Wa_.Ps0267_.Payty    := n_Emp_.S7; -- PAYTY CHAR  1   Payroll type
      Wa_.Ps0267_.Payid    := n_Emp_.S8; -- PAYID CHAR  1   Payroll Identifier
      Wa_.Ps0267_.Ocrsn    := NULL; -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
      Wa_.Ps0267_.Zzdatz   := NULL;
      Wa_.Ps0267_.Zztekst1 := n_Emp_.S9;
      Wa_.Ps0267_.Zztekst2 := n_Emp_.S10;
      Wa_.Ps0267_.Zztekst3 := n_Emp_.S11;
      Wa_.Ps0267_.Zztekst4 := n_Emp_.S12;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_   IN VARCHAR2,
                       Rec_      IN OUT Emp_Tmp_,
                       Inrec_    IN c_Employee_Agreement_%ROWTYPE,
                       Is_Outer_ IN VARCHAR2) IS
      CURSOR c_Get_Ssi IS
        SELECT *
          FROM Ssi_Data_Tab t
         WHERE t.Company_Id = c_Company_Id
           AND t.Emp_No = Emp_No_
         ORDER BY t.Date_From DESC;
      Rec_Ssi_ c_Get_Ssi%ROWTYPE;
    BEGIN
      --
      Rec_.Date_From := Inrec_.Validation_Date;
      Rec_.Date_To   := Inrec_.Validation_Date;
      --
      Rec_.S1 := '7001'; -- default wage codes Get_Mapping(m_Agree_Type, Inrec_.Param_Id, FALSE); --LGART
      Rec_.S2 := My_Number___(Inrec_.Value); --Betrg
      Rec_.S3 := 'PLN'; -- WAERS
      Rec_.S4 := My_Number___(0); --anzhl
      -- s5 has been moved
      Rec_.S6  := '0000'; -- PABRJ
      Rec_.S7  := 'A'; -- PAYTY
      Rec_.S8  := '1'; -- PAYID
      Rec_.S9  := Substr('Migracja - AgreeNo: ' || Inrec_.Agreement_No || ' - ' ||
                         Inrec_.Agreement_Description, 1, 100);
      Rec_.S10 := 'Od: ' || To_Char(Inrec_.Date_From, 'YYYY-MM-DD') || ' Do: ' ||
                  To_Char(Inrec_.Date_To, 'YYYY-MM-DD') || ' IFS param: ' || Inrec_.Param_Id;
      Rec_.S11 := Substr('Opis: ' || Inrec_.Agreement_Subject, 1, 100);
      Rec_.S12 := Substr('Uwaga!!! Dane o sk³adkach mog¹ siê ró¿niæ od rzecz. wyp³ac.-szczeg. w arch.,(' ||
                         Inrec_.Payroll_List_Id || ') - ' ||
                         Hrp_Pay_List_Api.Get_Name(c_Company_Id, Inrec_.Payroll_List_Id), 1, 100); --
      --
      IF Is_Outer_ = 'TRUE' THEN
        --
        OPEN c_Get_Ssi;
        FETCH c_Get_Ssi
          INTO Rec_Ssi_;
        CLOSE c_Get_Ssi;
        --
        Rec_.S13 := '041000ECWZ'; -- new mappp will be required
        -- emerytalne^chorobowe^wypadkowe^zdrowotne
        IF Rec_Ssi_.Oblig_Pension_Insur = 'TRUE' THEN
          -- emerytalne
          Rec_.S13 := REPLACE(Rec_.S13, 'E', 'X');
        END IF;
        IF Rec_Ssi_.Oblig_Health_Insur = 'TRUE' THEN
          -- chorobowe
          Rec_.S13 := REPLACE(Rec_.S13, 'C', 'X');
        END IF;
        IF Rec_Ssi_.Oblig_Accident_Insur = 'TRUE' THEN
          -- wypadkowe
          Rec_.S13 := REPLACE(Rec_.S13, 'W', 'X');
        END IF;
        IF Rec_Ssi_.Opt_Health_Insur2 = 'TRUE' THEN
          -- zdrowotne
          Rec_.S13 := REPLACE(Rec_.S13, 'Z', 'X');
        END IF;
        Rec_.S13 := REPLACE(Rec_.S13, 'E', ' ');
        Rec_.S13 := REPLACE(Rec_.S13, 'C', ' ');
        Rec_.S13 := REPLACE(Rec_.S13, 'W', ' ');
        Rec_.S13 := REPLACE(Rec_.S13, 'Z', ' ');
      ELSE
        Rec_.S13 := '011011XXXX';
      END IF;
      Rec_.S14 := My_Date___(Inrec_.Date_From); -- date to
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      /*IF c_Company_Id IN ('148') THEN
        EXIT;
      END IF;*/
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Agreement_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Agreement_
          INTO Emp_Agreement_Rec_;
        EXIT WHEN c_Employee_Agreement_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        -- outer status
        Is_Outer_ := 'FALSE';
        IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_Company_Rec_.Employee_Id,
                                                     Emp_Agreement_Rec_.Validation_Date) IN
           ('ZLC', 'UCP') THEN
          Is_Outer_ := 'TRUE';
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill doc area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Agreement_Rec_, Is_Outer_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Agreement_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0267;
  --
  PROCEDURE Get_P0413 IS
    It_              It0413;
    Wa_              P0413;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Emp_Time_Matrix_ Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Main_Lu_         VARCHAR2(30) := 'EmpEmployedTime';
    i_               NUMBER;
    Is_First_        BOOLEAN;
    Is_Outer_        VARCHAR2(5);
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      Date_ DATE;
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: position change
          -- case: cost center change
          -- case: terminated
          -- case: employement break
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
          --.INCLUDE  PS0413        HR Master Record: Infotype 0413 (Tax Data PL)
          Wa_.Ps0413_.Toidn := o_Emp_.S1; --  -- PPL_TOIDN CHAR  4 T7PL01  Tax office ID number
          Wa_.Ps0413_.Costr := o_Emp_.S2; --  PPL_COSTR CHAR  2 T7PL20  Cost counting rule
          Wa_.Ps0413_.Contr := o_Emp_.S3; --  PPL_CONTR CHAR  2 T7PL30  Free amount rule
          Wa_.Ps0413_.Dnind := o_Emp_.S4; --  PPL_DNIND CHAR  1   Threshold down indicator
          -- if it is last record then do not close data frame
          /*          IF n_Emp_.Date_From IS NULL
             AND n_Emp_.Date_To IS NULL THEN
            Wa_.Pakey_.Endda := My_Date___(Database_Sys.Get_Last_Calendar_Date);
          END IF;*/
          --
          -- this save has been moved -> Save_;
          --
          -- for terminated employee set fix
          --
          IF o_Emp_.Date_To < Database_Sys.Get_Last_Calendar_Date THEN
            IF NOT Emp_Employed_Time_Api.Is_Employed(c_Company_Id, Emp_No_, o_Emp_.Date_To + 1) = 1 THEN
              IF o_Emp_.Date_To = Last_Day(o_Emp_.Date_To) THEN
                Date_ := Add_Months(Trunc(o_Emp_.Date_To, 'MONTH'), 2);
              ELSE
                Date_ := Add_Months(Trunc(o_Emp_.Date_To, 'MONTH'), 1);
              END IF;
              --origin
              Wa_.Pakey_.Endda := My_Date___(Date_ - 1);
              Save_;
              --
              Wa_.Pakey_.Begda := My_Date___(Date_);
              --
              Wa_.Pakey_.Endda  := My_Date___(Database_Sys.Get_Last_Calendar_Date);
              Wa_.Ps0413_.Costr := '03'; -- without Cost
              Wa_.Ps0413_.Contr := '03'; -- without free amount
              --
              Save_; --new
            ELSE
              Save_; --origin
            END IF;
          ELSE
            Save_; --origin
          END IF;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    --
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_, Is_Outer_ IN VARCHAR2) IS
      -- local vairable
      Toidn_ VARCHAR2(200);
      Costr_ VARCHAR2(200);
      Contr_ VARCHAR2(200);
      Dnind_ VARCHAR2(200);
      -- loacal function
      FUNCTION Get_Tax_Off(Emp_No_ IN VARCHAR2, Valid_Date_ IN DATE) RETURN VARCHAR2 IS
        Temp_ Pers_Tax_Off_Tab.Tax_Office_Id%TYPE;
        CURSOR Get_Attr IS
          SELECT Tax_Office_Id
            FROM Pers_Tax_Off_Tab
           WHERE Person_Id = Company_Pers_Api.Get_Person_Id(c_Company_Id, Emp_No_)
             AND Valid_From <= Valid_Date_
             AND Valid_To >= Valid_Date_;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Temp_;
        CLOSE Get_Attr;
        RETURN Temp_;
      END Get_Tax_Off;
    BEGIN
      Toidn_ := Get_Tax_Off(Emp_No_, Rec_.Date_From);
      Costr_ := Reg_Const_Data_Api.Get_Value_On_Day(c_Company_Id, Emp_No_, g_Param_Costr_,
                                                    Rec_.Date_From);
      Contr_ := Reg_Const_Data_Api.Get_Value_On_Day(c_Company_Id, Emp_No_, g_Param_Contr_,
                                                    Rec_.Date_From);
      Dnind_ := Reg_Const_Data_Api.Get_Value_On_Day(c_Company_Id, Emp_No_, g_Param_Dnind_,
                                                    Rec_.Date_From);
      Dnind_ := Nvl(Dnind_, 0);
      --
      Rec_.S1 := Toidn_;
      Rec_.S2 := Get_Mapping(m_Param_Costr, Costr_, FALSE);
      Rec_.S3 := Get_Mapping(m_Param_Contr, Contr_, FALSE);
      Rec_.S4 := Get_Mapping(m_Param_Dnind, Dnind_, FALSE);
      -- for outer employee
      IF Is_Outer_ = 'TRUE' THEN
        Rec_.S2 := '03';
        Rec_.S3 := '03';
      END IF;
    END Fill_Rec;
    --
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      -- prepare employee time matrix
      Emp_Time_Matrix_ := Get_Emp_Matrix(Emp_Company_Rec_.Employee_Id, '0413');
      Is_First_        := TRUE;
      -- perform employee matrix
      i_ := Emp_Time_Matrix_.First;
      WHILE (i_ IS NOT NULL) LOOP
        -- initialize local temp rec
        n_Rec_           := NULL;
        n_Rec_.Date_From := Emp_Time_Matrix_(i_).Date_From;
        n_Rec_.Date_To   := Emp_Time_Matrix_(i_).Date_To;
        n_Rec_.Set_Name  := Emp_Time_Matrix_(i_).Set_Name;
        -- perform only main time vector
        IF (n_Rec_.Set_Name != Main_Lu_) THEN
          i_ := Emp_Time_Matrix_.Next(i_);
          Continue;
        END IF;
        -- outer status
        Is_Outer_ := 'FALSE';
        IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_Company_Rec_.Employee_Id,
                                                     n_Rec_.Date_From) IN ('ZLC', 'UCP') THEN
          Is_Outer_ := 'TRUE';
        END IF;
        --
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Is_Outer_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        i_     := Emp_Time_Matrix_.Next(i_);
      END LOOP;
      -- perform last rec for each employee
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0413;
  --
  --
  PROCEDURE Get_P0515 IS
    It_              It0515;
    Wa_              P0515;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Emp_Time_Matrix_ Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Main_Lu_         VARCHAR2(30) := 'SsiData';
    i_               NUMBER;
    Is_First_        BOOLEAN;
    Rec_No_          NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
      ELSE
        -- normal
        IF (o_Emp_.Date_To = n_Emp_.Date_From - 1 --
           AND (o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND (o_Emp_.S4 = n_Emp_.S4 OR (o_Emp_.S4 IS NULL AND n_Emp_.S4 IS NULL)) --
           AND (o_Emp_.S5 = n_Emp_.S5 OR (o_Emp_.S5 IS NULL AND n_Emp_.S5 IS NULL)) --
           AND (o_Emp_.S6 = n_Emp_.S6 OR (o_Emp_.S6 IS NULL AND n_Emp_.S6 IS NULL)) --
           AND (o_Emp_.S7 = n_Emp_.S7 OR (o_Emp_.S7 IS NULL AND n_Emp_.S7 IS NULL)) --
           AND (o_Emp_.S8 = n_Emp_.S8 OR (o_Emp_.S8 IS NULL AND n_Emp_.S8 IS NULL)) --
           AND (o_Emp_.S9 = n_Emp_.S9 OR (o_Emp_.S9 IS NULL AND n_Emp_.S9 IS NULL)) --
           AND (o_Emp_.S10 = n_Emp_.S10 OR (o_Emp_.S10 IS NULL AND n_Emp_.S10 IS NULL)) --
           AND (o_Emp_.S20 = n_Emp_.S20 OR (o_Emp_.S20 IS NULL AND n_Emp_.S20 IS NULL)) -- Sap control procedure raise error
           AND 1 = 1) THEN
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        ELSE
          -- flush data
          -- case: add each record not
          -- not clear logic is applied
          Wa_.Pakey_.Mandt := c_Mandt;
          Wa_.Pakey_.Pernr := Emp_No_;
          Wa_.Pakey_.Begda := My_Date___(Wm_.Account_Date);
          Wa_.Pakey_.Endda := My_Date___(Nvl(n_Emp_.Date_From - 1, o_Emp_.Date_To));
          --.INCLUDE  PS0515        HR Master Record: Infotype 0515 (SI Add. Data PL)
          Wa_.Ps0515_.Podst     := o_Emp_.S1; --PPL_PODST CHAR  4 T7PL40  Code of basic subject with extension
          Wa_.Ps0515_.Erlrt     := o_Emp_.S2; -- PPL_ERLRT CHAR  1   Pension right type
          Wa_.Ps0515_.Stpns     := o_Emp_.S3; -- PPL_STPNS CHAR  1   Disability level
          Wa_.Ps0515_.Ruser     := o_Emp_.S4; -- PPL_RUSER CHAR  1   Pension and disability insurance
          Wa_.Ps0515_.Rusch     := o_Emp_.S5; -- PPL_RUSCH CHAR  1   Incapability insurance
          Wa_.Ps0515_.Ruswp     := o_Emp_.S6; -- PPL_RUSWP CHAR  1   Accident insurance
          Wa_.Ps0515_.Ruszr     := o_Emp_.S7; -- PPL_RUSZR CHAR  1   Health insurance
          Wa_.Ps0515_.Dzukc     := o_Emp_.S8; -- PPL_DZUKC DATS  8   Date of contract with health fund
          Wa_.Ps0515_.Nsbeg     := NULL; -- PPL_NSBEG DATS  8   Begin date of disability level
          Wa_.Ps0515_.Ksach     := o_Emp_.S9; --PPL_KSACH CHAR  3   NFZ departament code
          Wa_.Ps0515_.Nsend     := NULL; --PPL_NSEND DATS  8   End date of disability level
          Wa_.Ps0515_.Illcs     := NULL; --PPL_ILLCS NUMC  3   Days of continuous sickness period
          Wa_.Ps0515_.Allpe     := NULL; --PPL_ALLPE NUMC  3   Allowance period days
          Wa_.Ps0515_.Sibln     := NULL; --PPL_SIBLN CHAR  1   Std./extd. allowance base period lenght
          Wa_.Ps0515_.Soeln     := NULL; --PPL_SOELN CHAR  1   Std./extd. allowance base period lenght
          Wa_.Ps0515_.Waitp     := NULL; -- PPL_WAITP DATS  8   End date of waiting period
          Wa_.Ps0515_.Limtp     := NULL; -- PPL_LIMTP DATS  8   End date of limited base period
          Wa_.Ps0515_.Illpr     := NULL; -- PPL_ILLPR DEC 2   Sick days at previous employer
          Wa_.Ps0515_.Addit     := o_Emp_.S10; -- PPL_ADDIT CHAR  4 T7PL40  Code of additional subject
          Wa_.Ps0515_.Addbr     := NULL; -- PPL_ADDBR CHAR  1   Additional insurance title break code
          Wa_.Ps0515_.Dis_Leave := NULL; --PPL_DIS_LEAVE_FROM  DATS  8   Additional leave for disabled first date
          Wa_.Ps0515_.Model_Id  := NULL; -- PPL_MODEL CHAR  2 T7PLZLA_MOD Model ID for PLZLA
          Wa_.Ps0515_.Nozdr     := NULL; -- PPL_NOZDR CHAR  1   Parental leave without health insurance
          --
          Save_;
          --
          -- for terminated employee set fix
          --
          IF o_Emp_.Date_To < Database_Sys.Get_Last_Calendar_Date THEN
            IF NOT Emp_Employed_Time_Api.Is_Employed(c_Company_Id, Emp_No_, o_Emp_.Date_To + 1) = 1 THEN
              Wa_.Pakey_.Begda  := My_Date___(o_Emp_.Date_To + 1);
              Wa_.Pakey_.Endda  := My_Date___(Database_Sys.Get_Last_Calendar_Date);
              Wa_.Ps0515_.Podst := '3000';
              --
              Save_;
            END IF;
          END IF;
          --
          Wm_ := Flush_Wm___();
          Set_Wm___(Wm_, Emp_No_, n_Emp_.Date_From);
        END IF;
      END IF;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
      --
      -- local cursors
      --
      CURSOR c_Employee_Ssi_ IS
        SELECT t.*
          FROM Ssi_Data_Tab t
         WHERE t.Company_Id = c_Company_Id
           AND t.Emp_No = Emp_No_
           AND t.Date_From = (SELECT MAX(b.Date_From)
                                FROM Ssi_Data_Tab b
                               WHERE b.Company_Id = t.Company_Id
                                 AND b.Emp_No = t.Emp_No
                                 AND b.Date_From <= Rec_.Date_From);
      Emp_Ssi_Rec_ c_Employee_Ssi_%ROWTYPE;
      --
      CURSOR Get_Abs_ IS
        SELECT Decode(a.Absence_Type_Id,
                      --
                      'U-58', '1240',
                      --
                      'U-57', '1240',
                      --
                      'U-56', '1240',
                      --
                      'U-55', '1240',
                      --
                      'U-54', '1240',
                      --
                      'U-53', '1240',
                      --
                      'U-52', '1240',
                      --
                      'U-51', '1240',
                      --
                      'U-41', '1211',
                      --
                      '0000') Code_,
               a.Absence_Id
          FROM Absence_Registration_Tab a
         WHERE a.Company_Id = c_Company_Id
           AND a.Emp_No = Emp_No_
           AND a.Absence_Type_Id IN
               ('U-58', 'U-57', 'U-56', 'U-55', 'U-54', 'U-53', 'U-52', 'U-51', 'U-41')
           AND a.Rowstate NOT IN ('CalculationCancelled', 'Cancelled')
           AND a.Date_From <= Rec_.Date_From
           AND a.Date_To >= Rec_.Date_From
         ORDER BY a.Date_From;
    BEGIN
      -- TODO check if there is endda of disability
      -- TODO verify ADIDT raporting mode if necessary add absence period logic
      --
      OPEN c_Employee_Ssi_;
      FETCH c_Employee_Ssi_
        INTO Emp_Ssi_Rec_;
      CLOSE c_Employee_Ssi_;
      --
      --Rec_.Date_From := Emp_Ssi_Rec_.Date_From;
      --Rec_.Date_To := Database_Sys.Get_Last_Calendar_Date;
      --get_mapping(M_DOC_TYPE, inrec_.pers_doc_type, false); --ICTYP
      Rec_.S1  := Emp_Ssi_Rec_.Insurance_Code; -- PODST
      Rec_.S2  := Emp_Ssi_Rec_.Pen_Ann_Code; -- ERLRT
      Rec_.S3  := Emp_Ssi_Rec_.Disability_Code; -- STPNS
      Rec_.S4  := 'X'; --RUSER
      Rec_.S5  := 'X'; --RUSCH
      Rec_.S6  := 'X'; --RUSWP
      Rec_.S7  := 'X'; --RUSZR
      Rec_.S8  := My_Date___(Emp_Ssi_Rec_.Insur_Beg_Date); -- DZUKC
      Rec_.S9  := Emp_Ssi_Rec_.Nhs_Code; -- KASACH
      Rec_.S10 := NULL; -- ADIDT Matrix of dates can to be necessary
      FOR Abs_Rec_ IN Get_Abs_ LOOP
        Rec_.S10 := Abs_Rec_.Code_; -- ADIDT Matrix of dates can to be necessary
        Rec_.S20 := Abs_Rec_.Absence_Id;
      END LOOP;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      -- prepare employee time matrix
      Emp_Time_Matrix_ := Get_Emp_Matrix(Emp_Company_Rec_.Employee_Id, '0515');
      Is_First_        := TRUE;
      -- perform employee matrix
      i_ := Emp_Time_Matrix_.First;
      WHILE (i_ IS NOT NULL) LOOP
        -- initialize local temp rec
        n_Rec_           := NULL;
        n_Rec_.Date_From := Emp_Time_Matrix_(i_).Date_From;
        n_Rec_.Date_To   := Emp_Time_Matrix_(i_).Date_To;
        n_Rec_.Set_Name  := Emp_Time_Matrix_(i_).Set_Name;
        -- perform only main time vector
        IF (n_Rec_.Set_Name != Main_Lu_) THEN
          i_ := Emp_Time_Matrix_.Next(i_);
          Continue;
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill ssi area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
        i_     := Emp_Time_Matrix_.Next(i_);
      END LOOP;
      --CLOSE c_Employee_Ssi_;
      -- perform last rec for each employee
      -- not clear logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0515;
  --
  --
  PROCEDURE Get_P0558 IS
    It_              It0558;
    Wa_              P0558;
    n_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Rec_No_ NUMBER := 0;
    --
    PROCEDURE Add_Rec_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add master data of employee
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --.INCLUDE  PS0558        IT0558 - Additional personal data PL
      Wa_.Ps0558_.Fathn := n_Emp_.S1; -- PPL_FATHN CHAR  40    Fathers first name
      Wa_.Ps0558_.Mothn := n_Emp_.S2; -- PPL_MOTHN CHAR  40    Mothers first name
      Wa_.Ps0558_.Mbnam := n_Emp_.S3; -- PPL_MBRTN CHAR  40    Mothers birth name
      Wa_.Ps0558_.Pesel := n_Emp_.S4; --PPL_PESEL CHAR  11    PESEL number
      Wa_.Ps0558_.Nip00 := n_Emp_.S5; --PPL_NIP00 CHAR  10    NIP number
      Wa_.Ps0558_.Onpit := n_Emp_.S6; -- PPL_ONPIT CHAR  1   Output NIP instead of PESEL on PIT forms
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2, Rec_ IN OUT Emp_Tmp_) IS
      -- local vairable
      Cp_ Company_Person%ROWTYPE;
      --
      FUNCTION Get_Rec RETURN Company_Person%ROWTYPE IS
        Cp_ Company_Person%ROWTYPE;
        CURSOR Get_Attr IS
          SELECT *
            FROM Company_Person
           WHERE Company_Id = c_Company_Id
             AND Emp_No = Emp_No_;
      BEGIN
        OPEN Get_Attr;
        FETCH Get_Attr
          INTO Cp_;
        CLOSE Get_Attr;
        RETURN Cp_;
      END Get_Rec;
    BEGIN
      Cp_ := Get_Rec;
      --
      Rec_.Date_From := Get_Emp_First_Employement(Emp_No_);
      Rec_.Date_To   := Database_Sys.Get_Last_Calendar_Date;
      --
      Rec_.S1 := Upper(Cp_.Free_Field1); --FATHN
      Rec_.S2 := Upper(Cp_.Free_Field2); --MOTHN
      Rec_.S3 := Upper(Cp_.Free_Field3); --MBNAM
      Rec_.S4 := Company_Pers_Property_Api.Get_Person_Property_Value(Cp_.Person_Id, 'RELID', SYSDATE); --PESEL
      Rec_.S5 := Company_Pers_Property_Api.Get_Person_Property_Value(Cp_.Person_Id, 'RELTAX',
                                                                     SYSDATE); --NIP00
      Rec_.S5 := REPLACE(Rec_.S5, '-');
      Rec_.S5 := REPLACE(Rec_.S5, ' ');
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
        Dbms_Output.Put_Line('Perf rec_: ' || Emp_Company_Rec_.Employee_Id);
      END IF;
      -- fill work area with master data value
      Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_);
      -- valid
      IF Length(n_Rec_.S4) > 11
         OR Length(n_Rec_.S5) > 10 THEN
        Add_Error___(Emp_Company_Rec_.Employee_Id, 'NipPeseleFormat', 10,
                     'There is a some issue in nip/pesele format Pesel:' || --
                      n_Rec_.S4 || ' Nip:' || n_Rec_.S5);
        Continue;
      END IF;
      -- apply storage logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P0558;
  --
  PROCEDURE Get_P2001 IS
    It_              It2001;
    Wa_              P2001;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Abs_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id,
             b.Absence_Type_Id,
             b.Absence_Id,
             b.Date_From,
             b.Date_To,
             b.Document_No,
             b.Time_From,
             b.Time_To,
             b.Abs_Duration,
             b.Calc_Abs_Duration,
             Absence_Limit_Used_Api.Is_Dependent_Used(b.Company_Id, b.Emp_No, b.Absence_Id) Is_Dependent,
             Absence_Type_Api.Get_Absence_Duration_Unit_Db(Company_Id, Absence_Type_Id) Dur_Unit,
             Absence_Type_Api.Get_Abs_Calc_Period_Unit_Db(Company_Id, Absence_Type_Id) Calc_Unit,
             Rank() Over(PARTITION BY Trunc(b.Date_From) ORDER BY b.Time_From) Rank_
        FROM Company_Emp_Tab e, Absence_Registration b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.State NOT IN ('CalculationCancelled', 'Cancelled')
       ORDER BY b.Date_From;
    Emp_Abs_Rec_ c_Employee_Abs_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
        Work_Hours1_ NUMBER;
        Work_Hours2_ NUMBER;
      BEGIN
        IF n_Emp_.Date_From < c_Curr_Of_Lim
           AND n_Emp_.Date_To >= c_Curr_Of_Lim
           AND Wa_.Ps2001_.Awart = 'UWYP' THEN
          ---
          Add_Error___(Emp_No_, 'AbsDivided', 10,
                       'Absence has been divided in ' || To_Char(c_Curr_Of_Lim, 'YYYY-MM-DD'));
          -- part I
          Work_Hours1_ := Absence_Registration_Api.Get_Absence_Duration(c_Company_Id, Emp_No_,
                                                                        'WORKINGHOURS',
                                                                        n_Emp_.Date_From,
                                                                        c_Curr_Of_Lim - 1, NULL, NULL);
          Work_Hours2_ := Absence_Registration_Api.Get_Absence_Duration(c_Company_Id, Emp_No_,
                                                                        'WORKINGHOURS', c_Curr_Of_Lim,
                                                                        n_Emp_.Date_To, NULL, NULL);
          Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
          Wa_.Pakey_.Endda := My_Date___(c_Curr_Of_Lim - 1);
          Wa_.Ps2001_.Abrtg := My_Number___(Work_Hours1_ / 8);
          Wa_.Ps2001_.Abrst := My_Number___(Work_Hours1_);
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
          -- part II
          Wa_.Pakey_.Begda := My_Date___(c_Curr_Of_Lim);
          Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
          Wa_.Ps2001_.Abrtg := My_Number___(Work_Hours2_ / 8);
          Wa_.Ps2001_.Abrst := My_Number___(Work_Hours2_);
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        ELSE
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps2001_.Beguz  := n_Emp_.S11; --  varchar2(6), --   BEGTI TIMS  6   Start Time
      Wa_.Ps2001_.Enduz  := n_Emp_.S12; --  varchar2(6), -- ENDTI TIMS  6   End Time
      Wa_.Ps2001_.Vtken  := NULL; --  varchar2(1), -- VTKEN CHAR  1   Previous Day Indicator
      Wa_.Ps2001_.Awart  := n_Emp_.S1; --  varchar2(4), -- AWART CHAR  4 T554S Attendance or Absence Type
      Wa_.Ps2001_.Abwtg  := n_Emp_.S2; --  varchar2(6), -- ABWTG DEC 6(2)    Attendance and Absence Days
      Wa_.Ps2001_.Stdaz  := n_Emp_.S3; --  varchar2(7), -- ABSTD DEC 7(2)    Absence hours
      Wa_.Ps2001_.Abrtg  := n_Emp_.S4; --  varchar2(3), -- ABRTG DEC 6(2)    Payroll days
      Wa_.Ps2001_.Abrst  := n_Emp_.S5; --  varchar2(7), -- ABRST DEC 7(2)    Payroll hours
      Wa_.Ps2001_.Anrtg  := n_Emp_.S6; --  varchar2(6), -- ANRTG DEC 6(2)    Days credited for continued pay
      Wa_.Ps2001_.Lfzed  := NULL; --  varchar2(8), -- LFZED DATS  8   End of continued pay
      Wa_.Ps2001_.Krged  := NULL; --  varchar2(8), -- KRGED DATS  8   End of sick pay
      Wa_.Ps2001_.Kbbeg  := NULL; --  varchar2(8), -- KBBEG DATS  8   Certified start of sickness
      Wa_.Ps2001_.Rmdda  := NULL; --  varchar2(8), -- RMDDA DATS  8   Date on which illness was confirmed
      Wa_.Ps2001_.Kenn1  := n_Emp_.S7; --  varchar2(2), -- KENN1 DEC 2   Indicator for Subsequent Illness
      Wa_.Ps2001_.Kenn2  := n_Emp_.S8; --  varchar2(2), -- KENN2 DEC 2   Indicator for repeated illness
      Wa_.Ps2001_.Kaltg  := n_Emp_.S9; --  varchar2(6), -- KALTG DEC 6(2)    Calendar days
      Wa_.Ps2001_.Urman  := NULL; --  varchar2(1), -- URMAN CHAR  1   Indicator for manual leave deduction
      Wa_.Ps2001_.Begva  := n_Emp_.S10; --  varchar2(4), -- BEGVA NUMC  4   Start year for leave deduction  GJAHR
      Wa_.Ps2001_.Bwgrl  := NULL; --  varchar2(13), -- PTM_VBAS7S  CURR  13(2)   Valuation Basis for Different Payment
      Wa_.Ps2001_.Aufkz  := NULL; --  varchar2(1), -- AUFKN CHAR  1   Extra Pay Indicator
      Wa_.Ps2001_.Trfgr  := NULL; --  varchar2(8), -- TRFGR CHAR  8   Pay Scale Group
      Wa_.Ps2001_.Trfst  := NULL; --  varchar2(2), -- TRFST CHAR  2   Pay Scale Level
      Wa_.Ps2001_.Prakn  := NULL; --  varchar2(2), -- PRAKN CHAR  2 T510P Premium Number
      Wa_.Ps2001_.Prakz  := NULL; --  varchar2(4), -- PRAKZ NUMC  4   Premium Indicator
      Wa_.Ps2001_.Otype  := NULL; --  varchar2(2), -- OTYPE CHAR  2 T778O Object Type
      Wa_.Ps2001_.Plans  := NULL; --  varchar2(8), -- PLANS NUMC  8 T528B Position
      Wa_.Ps2001_.Mldda  := NULL; --  varchar2(8), -- MLDDA DATS  8   Reported on
      Wa_.Ps2001_.Mlduz  := NULL; --n_Emp_.S11; --  varchar2(6), -- MLDUZ TIMS  6   Reported at
      Wa_.Ps2001_.Rmduz  := NULL; --n_Emp_.S12; --  varchar2(6), -- RMDUZ TIMS  6   Sickness confirmed at
      Wa_.Ps2001_.Vorgs  := n_Emp_.S13; --  varchar2(15), -- VORGS CHAR  15    Superior Out Sick (Illness)
      Wa_.Ps2001_.Umskd  := n_Emp_.S19; --  varchar2(6), -- UMSKD CHAR  6   Code for description of illness
      Wa_.Ps2001_.Umsch  := NULL; --  varchar2(20), -- UMSCH CHAR  20    Description of illness
      Wa_.Ps2001_.Refnr  := n_Emp_.S14; --  varchar2(8), -- RFNUM CHAR  8   Reference number
      Wa_.Ps2001_.Unfal  := NULL; --  varchar2(1), -- UNFAL CHAR  1   Absent due to accident?
      Wa_.Ps2001_.Stkrv  := NULL; --  varchar2(4), -- STKRV CHAR  4   Subtype for sickness tracking
      Wa_.Ps2001_.Stund  := NULL; --  varchar2(4), -- STUND CHAR  4   Subtype for accident data
      Wa_.Ps2001_.Psarb  := n_Emp_.S15; --  varchar2(4), -- PSARB DEC 4(2)    Work capacity percentage
      Wa_.Ps2001_.Ainft  := NULL; --  varchar2(4), -- AINFT CHAR  4 T582A Infotype that maintains 2001
      Wa_.Ps2001_.Gener  := NULL; --  varchar2(1), -- PGENER  CHAR  1   Generation flag
      Wa_.Ps2001_.Hrsif  := NULL; --  varchar2(1), -- HRS_INPFL CHAR  1   Set number of hours
      Wa_.Ps2001_.Alldf  := n_Emp_.S16; --  varchar2(1), -- ALLDF CHAR  1   Record is for Full Day
      Wa_.Ps2001_.Waers  := NULL; --  varchar2(5), -- WAERS CUKY  5 TCURC Currency Key
      Wa_.Ps2001_.Logsys := NULL; -- varchar2(10), -- LOGSYS CHAR  10    Logical system  ALPHA
      Wa_.Ps2001_.Awtyp  := NULL; --  varchar2(5), -- AWTYP CHAR  5   Reference Transaction
      Wa_.Ps2001_.Awref  := NULL; --  varchar2(10), -- AWREF CHAR  10    Reference Document Number ALPHA
      Wa_.Ps2001_.Aworg  := NULL; --  varchar2(10), -- AWORG CHAR  10    Reference Organizational Units
      Wa_.Ps2001_.Docsy  := n_Emp_.S17; --  varchar2(10), -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
      Wa_.Ps2001_.Docnr  := n_Emp_.S18; --  varchar2(20), -- PTM_DOCNR NUMC  20    Document number for time data
      Wa_.Ps2001_.Payty  := NULL; --  varchar2(1), -- PAYTY CHAR  1   Payroll type
      Wa_.Ps2001_.Payid  := NULL; --  varchar2(1), -- PAYID CHAR  1   Payroll Identifier
      Wa_.Ps2001_.Bondt  := NULL; --  varchar2(8), -- BONDT DATS  8   Off-cycle payroll payment date
      Wa_.Ps2001_.Ocrsn  := NULL; --  varchar2(4), -- PAY_OCRSN CHAR  4 T52OCR  Reason for Off-Cycle Payroll
      Wa_.Ps2001_.Sppe1  := NULL; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Wa_.Ps2001_.Sppe2  := NULL; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Wa_.Ps2001_.Sppe3  := NULL; --  varchar2(8), -- SPPEG DATS  8   End date for continued pay
      Wa_.Ps2001_.Sppin  := NULL; --  varchar2(1), -- SPPIN CHAR  1   Indicator for manual modifications
      Wa_.Ps2001_.Zkmkt  := NULL; --  varchar2(1), -- P05_ZKMKT_EN  CHAR  1   Status of Sickness Notification
      Wa_.Ps2001_.Faprs  := NULL; --  varchar2(2), -- FAPRS CHAR  2 T554H Evaluation Type for Attendances/Absences
      --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
      Wa_.Ps2001_.Tdlangu := NULL; -- varchar2(10), -- TMW_TDLANGU CHAR  10    Definition Set for IDs
      Wa_.Ps2001_.Tdsubla := NULL; -- varchar2(3), -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
      Wa_.Ps2001_.Tdtype  := NULL; --  varchar2(4), -- TDTYPE CHAR  4   Time Data ID Type TDTYP
      Wa_.Ps2001_.Nxdfl   := NULL; --   varchar2(1) -- PTM_NXDFL  CHAR  1   Next Day Indicator
      --
      Wa_.Ps2001_.Ifs_Seqnr := n_Emp_.S20;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Abs_%ROWTYPE) IS
      Abs_Type_Raw_ VARCHAR2(200);
      Awert_        VARCHAR2(4);
      Refnr_        VARCHAR2(20);
      Umskd_        VARCHAR2(6);
      Work_Days_    NUMBER;
      Work_Hours_   NUMBER;
      -- for time
      Fday_  NUMBER;
      Ftime_ VARCHAR2(20);
      Tday_  NUMBER;
      Ttime_ VARCHAR2(20);
    BEGIN
      -- TODO ...
      Abs_Type_Raw_ := Get_Mapping(m_Abs_Type, Inrec_.Absence_Type_Id, FALSE);
      IF Instr(Abs_Type_Raw_, '^') > 0 THEN
        Awert_ := Substr(Abs_Type_Raw_, 1, Instr(Abs_Type_Raw_, '^') - 1);
        Refnr_ := Substr(Abs_Type_Raw_, Instr(Abs_Type_Raw_, '^') + 1);
        IF Length(Refnr_) > 1
           AND Refnr_ NOT IN ('100', '80') THEN
          Umskd_ := Refnr_;
          Refnr_ := NULL;
        END IF;
      ELSE
        Awert_ := Abs_Type_Raw_;
        Refnr_ := NULL;
      END IF;
      --
      Rec_.Date_From := Inrec_.Date_From;
      Rec_.Date_To   := Inrec_.Date_To;
      --get_mapping(M_DOC_TYPE, inrec_.pers_doc_type, false); --ICTYP
      Rec_.S1     := Awert_; --AWART
      Work_Days_  := Work_Sched_Assign_Api.Get_Normal_Day_Count(c_Company_Id, Emp_No_,
                                                                Inrec_.Date_From, Inrec_.Date_To);
      Work_Hours_ := Absence_Registration_Api.Get_Absence_Duration(c_Company_Id, Emp_No_,
                                                                   'WORKINGHOURS', Inrec_.Date_From,
                                                                   Inrec_.Date_To, Inrec_.Time_From,
                                                                   Inrec_.Time_To);
      -- set calculated work days
      Rec_.S2 := My_Number___(Work_Days_); -- ABWTG
      Rec_.S3 := My_Number___(Work_Hours_); -- STDAZ
      --
      /*IF (Inrec_.Dur_Unit IN ('CALENDARDAYS', 'WORKINGDAYS')) THEN
        Rec_.S2 := My_Number___(Inrec_.Abs_Duration); -- ABWTG
        Rec_.S3 := My_Number___(Inrec_.Abs_Duration * 8); -- STDAZ
      ELSE
        Rec_.S2 := My_Number___(Inrec_.Abs_Duration / 8); -- ABWTG
        Rec_.S3 := My_Number___(Inrec_.Abs_Duration); -- STDAZ
      END IF;*/
      IF (Inrec_.Calc_Unit IN ('CALENDARDAYS', 'WORKINGDAYS'))
         OR Awert_ IN ('UWYC') THEN
        Rec_.S4 := My_Number___(Inrec_.Calc_Abs_Duration); --ABRTG
        Rec_.S5 := My_Number___(Inrec_.Calc_Abs_Duration * 8); --ABRST
      ELSE
        Rec_.S4 := My_Number___(Inrec_.Calc_Abs_Duration / 8); --ABRTG
        Rec_.S5 := My_Number___(Inrec_.Calc_Abs_Duration); --ABRST
      END IF;
      Rec_.S6  := '0'; --ANRTG
      Rec_.S7  := '0'; --KENN1
      Rec_.S8  := '0'; --KENN2
      Rec_.S9  := Inrec_.Date_To - Inrec_.Date_From + 1; --KALTG
      Rec_.S10 := '0000'; -- BEGVA
      Rec_.S16 := 'X'; -- ALLDF
      -- my_date___(inrec_.date_from); -- BEGVA
      IF (Inrec_.Time_From IS NOT NULL OR Inrec_.Time_To IS NOT NULL)
         AND (Trunc(Inrec_.Date_From) = Trunc(Inrec_.Date_To)) THEN
        Work_Sched_Assign_Api.Get_Normal_Time(Fday_, Ftime_, Tday_, Ttime_, Work_Hours_,
                                              c_Company_Id, Emp_No_, Inrec_.Date_To);
        Rec_.S16 := NULL;
      END IF;
      Rec_.S11 := Nvl(To_Char(Inrec_.Time_From, 'HH24MISS'), REPLACE(Ftime_, ':') || '00'); --
      Rec_.S12 := Nvl(To_Char(Inrec_.Time_To, 'HH24MISS'), REPLACE(Ttime_, ':') || '00'); --
      Rec_.S13 := 'X'; -- VORGS
      Rec_.S14 := Refnr_; -- REFNR
      Rec_.S15 := '0'; -- PSARB
      Rec_.S17 := 'TH1_' || c_Mandt; --DOCSY
      Rec_.S18 := Inrec_.Absence_Id; --DOCNR
      Rec_.S19 := Umskd_; --UMSKD
      Rec_.S20 := Inrec_.Rank_ - 1;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Abs_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Abs_
          INTO Emp_Abs_Rec_;
        EXIT WHEN c_Employee_Abs_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill abs area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Abs_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Abs_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P2001;
  --
  PROCEDURE Get_P2003 IS
    It_              It2003;
    Wa_              P2003;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Change_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Emp_Pers_Dev_Days_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.Account_Date >= Trunc(SYSDATE, 'YEAR')
       ORDER BY b.Account_Date;
    Emp_Change_Rec_ c_Employee_Change_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps2003_.Stdaz := n_Emp_.S1;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Change_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Account_Date;
      Rec_.Date_To   := Inrec_.Account_Date;
      --
      --Rec_.S1 := My_Number___(0); -- STDAZ
      /* Rec_.S2 := Get_Mapping(m_Param_Time_Id, Inrec_.Param_Id, FALSE); -- LGART
      Rec_.S3 := '001'; -- Zeinh
      Rec_.S4 := My_Number___(Inrec_.Value); -- ANZHL*/
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Change_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Change_
          INTO Emp_Change_Rec_;
        EXIT WHEN c_Employee_Change_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Change_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Change_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P2003;
  --
  PROCEDURE Get_P2010 IS
    It_              It2010;
    Wa_              P2010;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Change_(Emmployee_Id_ VARCHAR2) IS
      SELECT e.Employee_Id, b.*
        FROM Company_Emp_Tab e, Reg_Change_Data_Tab b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.Payroll_List_Id IS NOT NULL
         AND b.Data_Deriv_Day > c_Var_Mig
         AND (b.Param_Id IN ('20630',
                             -- dyzor
                             '22715'
                             -- nadgodziny
                             ) OR b.Param_Id LIKE '00%')
       ORDER BY b.Param_Id, b.Data_Deriv_Day;
    Emp_Change_Rec_ c_Employee_Change_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        IF Substr(Wa_.Ps2010_.Lgart, 1, 3) NOT IN ('N/A', '?') THEN
          Rec_No_ := Rec_No_ + 1;
          Wa_.Meta_.Lineno := Rec_No_;
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      Wa_.Ps2010_.Stdaz := n_Emp_.S1;
      Wa_.Ps2010_.Lgart := n_Emp_.S2;
      Wa_.Ps2010_.Zeinh := n_Emp_.S3;
      Wa_.Ps2010_.Anzhl := n_Emp_.S4;
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Change_%ROWTYPE) IS
    BEGIN
      --
      Rec_.Date_From := Inrec_.Data_Deriv_Day;
      Rec_.Date_To   := Inrec_.Data_Deriv_Day;
      --
      Rec_.S1 := My_Number___(0); -- STDAZ
      Rec_.S2 := Get_Mapping(m_Param_Time_Id, Inrec_.Param_Id, FALSE); -- LGART
      Rec_.S3 := '001'; -- Zeinh
      Rec_.S4 := My_Number___(Inrec_.Value); -- ANZHL
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Change_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Change_
          INTO Emp_Change_Rec_;
        EXIT WHEN c_Employee_Change_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Change_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Change_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P2010;
  --
  PROCEDURE Get_P2006 IS
    It_              It2006;
    Wa_              P2006;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Lim_(Emmployee_Id_ VARCHAR2) IS
      WITH Abs_Tab_ AS
       ( --CREATE OR REPLACE VIEW IFSINFO.ZPK_ABSENCE_LIMIT_WS_IAL AS
        SELECT Company_Id,
                Emp_No,
                'dummy_' Emp_Info_1_,
                'dummy_' Emp_Info_2_,
                Absence_Group_Id,
                REPLACE(Absence_Type_Id, 'U-10', 'U-11') Absence_Type_Id,
                MIN(Abs_Date_From_) Abs_Date_From,
                MAX(Abs_Date_To_) Abs_Date_To,
                MAX(Tab_.Seq_No) Seq_No,
                MAX(Tab_.Abs_Limit_Dimension) Abs_Limit_Dimension,
                SUM(CASE Outstanding_
                      WHEN 0 THEN
                       Greatest(Abs_Prop_Days_Limit, 0)
                      ELSE
                       0
                    END) Abs_Prop_Days_Limit,
                SUM(CASE Outstanding_
                      WHEN 0 THEN
                       Greatest(Abs_Prop_Hours_Limit, 0)
                      ELSE
                       0
                    END) Abs_Prop_Hours_Limit,
                SUM(CASE Outstanding_
                      WHEN 0 THEN
                       Greatest(Least(Day_Used_, Abs_Prop_Days_Limit), 0)
                      ELSE
                       0
                    END) Abs_Prop_Days_Limit_Used,
                SUM(CASE Outstanding_
                      WHEN 0 THEN
                       Greatest(Least(Hours_Used_, Abs_Prop_Hours_Limit), 0)
                      ELSE
                       0
                    END) Abs_Prop_Hours_Limit_Used,
                SUM(CASE Outstanding_
                      WHEN 1 THEN
                       Greatest(Abs_Prop_Days_Limit - Day_Used_, 0)
                      ELSE
                       0
                    END) Abs_Prev_Days_Limit,
                SUM(CASE Outstanding_
                      WHEN 1 THEN
                       Greatest(Abs_Prop_Hours_Limit - Hours_Used_, 0)
                      ELSE
                       0
                    END) Abs_Prev_Hours_Limit,
                SUM(CASE Outstanding_
                      WHEN 1 THEN
                       Greatest(Abs_Prop_Days_Limit - Day_Used_On_Day_, 0)
                      ELSE
                       0
                    END) Abs_Prev_Days_Limit_On_Day,
                SUM(CASE Outstanding_
                      WHEN 1 THEN
                       Greatest(Abs_Prop_Hours_Limit - Hours_Used_On_Day_, 0)
                      ELSE
                       0
                    END) Abs_Prev_Hours_Limit_On_Day,
                SUM(CASE Outstanding_
                      WHEN 2 THEN
                       Greatest(Abs_Prop_Days_Limit, 0)
                      ELSE
                       0
                    END) Abs_Next_Days_Limit,
                SUM(CASE Outstanding_
                      WHEN 2 THEN
                       Greatest(Abs_Prop_Hours_Limit, 0)
                      ELSE
                       0
                    END) Abs_Next_Hours_Limit
          FROM (SELECT Company_Id,
                        Emp_No,
                        Absence_Group_Id,
                        Absence_Type_Id,
                        Seq_No,
                        MIN(Abs_Date_From_) Abs_Date_From_,
                        MAX(Abs_Date_To_) Abs_Date_To_,
                        MAX(Abs_Limit_Dimension) Abs_Limit_Dimension,
                        SUM(Abs_Prop_Days_Limit) Abs_Prop_Days_Limit,
                        SUM(Abs_Prop_Hours_Limit) Abs_Prop_Hours_Limit,
                        MAX(Day_Used_) Day_Used_,
                        MAX(Hours_Used_) Hours_Used_,
                        MAX(Day_Used_On_Day_) Day_Used_On_Day_,
                        MAX(Hours_Used_On_Day_) Hours_Used_On_Day_,
                        MAX(Outstanding_) Outstanding_
                   FROM (SELECT Company_Id,
                                Emp_No,
                                Ifsapp.Absence_Type_Api.Get_Group_Id(Company_Id, Absence_Type_Id) Absence_Group_Id,
                                Absence_Type_Id,
                                Seq_No,
                                Greatest(Abs_Date_From, Trunc(SYSDATE, 'YEAR')) Abs_Date_From_,
                                Least(Abs_Date_To, Add_Months(Trunc(SYSDATE, 'YEAR'), 12) - 1) Abs_Date_To_,
                                Abs_Limit_Dimension,
                                Abs_Prop_Days_Limit,
                                Abs_Prop_Hours_Limit,
                                Ifsapp.Absence_Limit_Used_Api.Get_Days_Used(Company_Id, Absence_Type_Id,
                                                                            Emp_No, Seq_No) Day_Used_,
                                Ifsapp.Absence_Limit_Used_Api.Get_Hours_Used(Company_Id, Absence_Type_Id,
                                                                             Emp_No, Seq_No) Hours_Used_,
                                Ifsapp.Absence_Limit_Used_Api.Get_Days_Used_On_Day(Company_Id,
                                                                                   Absence_Type_Id, Emp_No,
                                                                                   Seq_No,
                                                                                   Trunc(SYSDATE, 'YEAR') - 1) Day_Used_On_Day_,
                                Ifsapp.Absence_Limit_Used_Api.Get_Hours_Used_On_Day(Company_Id,
                                                                                    Absence_Type_Id,
                                                                                    Emp_No, Seq_No,
                                                                                    Trunc(SYSDATE, 'YEAR') - 1) Hours_Used_On_Day_,
                                CASE
                                  WHEN (Trunc(t.Abs_Date_From, 'YEAR') = Trunc(SYSDATE, 'YEAR') AND
                                       t.Absence_Type_Id NOT IN ('U-10')) THEN
                                   0
                                  ELSE
                                   1
                                END Outstanding_
                           FROM Ifsapp.Absence_Limit_Tab t
                          WHERE t.Absence_Type_Id IN ('U-10', 'U-11', 'U-14', 'U-22', 'U-24', 'U-71')
                            AND t.Abs_Date_From >= Add_Months(Trunc(SYSDATE, 'YEAR'), -48)
                            AND t.Abs_Date_From <= Add_Months(Trunc(SYSDATE, 'YEAR'), 12) - 1
                         --AND   t.abs_date_to   >= trunc(sysdate,'YEAR')
                         ) Itab_
                  GROUP BY Company_Id, Emp_No, Absence_Group_Id, Absence_Type_Id, Seq_No
                 HAVING MAX(Abs_Date_To_) >= Trunc(SYSDATE, 'YEAR')) Tab_
         GROUP BY Company_Id, Emp_No, Absence_Group_Id, Absence_Type_Id)
      SELECT e.Employee_Id,
             b.Absence_Type_Id,
             b.Abs_Prev_Days_Limit_On_Day Abs_Prev_Days_Value,
             -- b.Abs_Prev_Days_Limit,
             b.Abs_Date_From,
             b.Abs_Date_To,
             'FORMER' Mode_
        FROM Company_Emp_Tab e, Abs_Tab_ b
       WHERE e.Company = c_Company_Id
         AND e.Company = b.Company_Id
         AND e.Employee_Id = b.Emp_No
         AND e.Employee_Id = Emmployee_Id_
         AND b.Absence_Type_Id = 'U-11'
         AND b.Abs_Prev_Days_Limit != 0
      UNION ALL
      SELECT e.Employee_Id,
             y.Absence_Type_Id,
             y.Abs_Prop_Days_Limit,
             y.Abs_Date_From,
             y.Abs_Date_To,
             'CURRENT' Mode_
        FROM Company_Emp_Tab e, Absence_Limit_Year y
       WHERE e.Company = c_Company_Id
       AND e.Company = y.Company_Id
       AND e.Employee_Id = y.Emp_No
       AND e.Employee_Id = Emmployee_Id_
       AND y.Absence_Type_Id IN ('U-11', 'U-14', 'U-22', 'U-22H', 'C-41', 'C-42')
       AND Trunc(y.Abs_Date_From, 'YEAR') = Trunc(c_Curr_Of_Lim, 'YEAR')
       ORDER BY 1, 2;
    Emp_Lim_Rec_ c_Employee_Lim_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(n_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(n_Emp_.Date_To);
      --
      --.INCLUDE  PS2006        HR Time Record: Infotype 2006 (Absence Quotas)
      Wa_.Ps2006_.Beguz := NULL; --  -- BEGTI TIMS  6   Start Time
      Wa_.Ps2006_.Enduz := NULL; -- ENDTI TIMS  6   End Time
      Wa_.Ps2006_.Vtken := NULL; -- VTKEN CHAR  1   Previous Day Indicator
      Wa_.Ps2006_.Ktart := n_Emp_.S1; -- ABWKO NUMC  2 T556A Absence Quota Type
      Wa_.Ps2006_.Anzhl := n_Emp_.S2; -- PTM_QUONUM  DEC 10(5)   Number of Employee Time Quota
      Wa_.Ps2006_.Kverb := n_Emp_.S3; -- PTM_QUODED  DEC 10(5)   Deduction of Employee Time Quota
      Wa_.Ps2006_.Quonr := n_Emp_.S4; -- PTM_QUONR NUMC  20    Counter for time quotas
      Wa_.Ps2006_.Desta := n_Emp_.S5; -- PTM_DEDSTART  DATS  8   Start Date for Quota Deduction
      Wa_.Ps2006_.Deend := n_Emp_.S6; -- PTM_DEDEND  DATS  8   Quota Deduction to
      Wa_.Ps2006_.Quosy := n_Emp_.S7; -- PTM_DOCSY CHAR  10    Logical system for document (personnel time)  ALPHA
      --.INCLUDE  TMW_TDT_FIELDS        Infotype Fields Relevant for Short Descriptions
      Wa_.Ps2006_.Tdlangu := NULL; -- TMW_TDLANGU CHAR  10  Definition Set for IDs
      Wa_.Ps2006_.Tdsubla := NULL; -- TMW_TDSUBLA CHAR  3   Definition Subset for IDs
      Wa_.Ps2006_.Tdtype  := NULL; -- TDTYPE  CHAR  4   Time Data ID Type TDTYP
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Lim_%ROWTYPE) IS
      Diff_ NUMBER;
      FUNCTION Verify_Threshold_Abs RETURN NUMBER AS
        TYPE Abs_Cur_Typ IS REF CURSOR RETURN Absence_Registration_Tab%ROWTYPE;
        Abs_Cur_ Abs_Cur_Typ;
        Abs_Rec_ Abs_Cur_%ROWTYPE;
        Value_   NUMBER;
      BEGIN
        OPEN Abs_Cur_ FOR
          SELECT *
            FROM Absence_Registration_Tab a
           WHERE a.Company_Id = c_Company_Id
             AND a.Emp_No = Emp_No_
             AND a.Absence_Type_Id IN ('U-11')
             AND a.Date_From < Trunc(SYSDATE, 'YEAR')
             AND a.Date_To >= Trunc(SYSDATE, 'YEAR')
             AND a.Rowstate NOT IN ('Cancelled', 'CalculationCancelled');
        FETCH Abs_Cur_
          INTO Abs_Rec_;
        IF Abs_Cur_%FOUND THEN
          CLOSE Abs_Cur_;
          Value_ := Absence_Registration_Api.Get_Absence_Duration(Abs_Rec_.Company_Id,
                                                                  Abs_Rec_.Emp_No, 'WORKINGDAYS',
                                                                  Trunc(SYSDATE, 'YEAR'),
                                                                  Abs_Rec_.Date_To);
          --
          Add_Error___(Abs_Rec_.Emp_No, 'AbsenceThresholdGap', 10,
                       'There is an absence in the threshold of yera. Balance will be deducted of ' ||
                        To_Char(Value_) || ' days. ');
          --
          RETURN Value_ *(-1);
        END IF;
        CLOSE Abs_Cur_;
        --
        RETURN NULL;
      END Verify_Threshold_Abs;
    BEGIN
      -- TODO ...
      --
      Diff_ := NULL;
      --
      IF Inrec_.Mode_ = 'FORMER' THEN
        Rec_.Date_From := Add_Months(c_Form_Of_Lim, 12) - 1;
        Rec_.Date_To   := Add_Months(c_Form_Of_Lim, 12) - 1;
        --Absence_Registration_API.Get_Absence_Duration(Company_Id_,Emp_No_,abs_type_unit_,cur_date_from_,cur_date_to_,cur_time_from_,cur_time_to_);
        Diff_ := Verify_Threshold_Abs();
      ELSE
        Rec_.Date_From := Greatest(c_Curr_Of_Lim, Inrec_.Abs_Date_From);
        Rec_.Date_To   := Least(Add_Months(c_Curr_Of_Lim, 12) - 1, Inrec_.Abs_Date_To);
      END IF;
      --
      Rec_.S1 := Get_Mapping(m_Lim_Type, Inrec_.Absence_Type_Id, FALSE); --KTART
      Rec_.S2 := My_Number___(Inrec_.Abs_Prev_Days_Value + Nvl(Diff_, 0)); -- ANZHL
      Rec_.S3 := 0; -- KVERB
      Rec_.S4 := '999999999'; --QUONR
      Rec_.S5 := My_Date___(Greatest(c_Curr_Of_Lim, Rec_.Date_From)); --ABRST
      IF Inrec_.Mode_ = 'FORMER' THEN
        Rec_.S6 := My_Date___(Least(Add_Months(c_Curr_Of_Lim, 47) - 1,
                                    Get_Emp_Last_Termination(Emp_No_)));
        Rec_.S6 := Greatest(Rec_.S6, Rec_.S5);
      ELSE
        Rec_.S6 := My_Date___(Least(Add_Months(c_Curr_Of_Lim, 57) - 1,
                                    Get_Emp_Last_Termination(Emp_No_)));
        Rec_.S6 := Greatest(Rec_.S6, Rec_.S5);
      END IF;
      Rec_.S7 := 'TH1_' || c_Mandt; --QUOSY
      --
      IF Rec_.S5 > Rec_.S6
         OR Rec_.Date_To < Rec_.Date_From THEN
        Add_Error___(Emp_No_, 'Absence lim', 200610,
                     '"Date from" is greter than "date to" for ' || --
                      To_Char(Inrec_.Abs_Date_From, 'YYYY-MM-DD') || ' and type ' ||
                      Inrec_.Absence_Type_Id);
      END IF; --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Is_First_ := TRUE;
      -- perform employee matrix
      OPEN c_Employee_Lim_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Lim_
          INTO Emp_Lim_Rec_;
        EXIT WHEN c_Employee_Lim_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_ := NULL;
        --
        IF Emp_Lim_Rec_.Mode_ != 'FORMER'
           AND c_Only_Former = 'TRUE' THEN
          Continue;
        END IF;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill abs area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Lim_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_(Emp_Company_Rec_.Employee_Id, n_Rec_, o_Rec_);
        END IF;
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Lim_;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P2006;
  --
  PROCEDURE Get_P9950 IS
    It_              It9950;
    Wa_              P9950;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Wm_              Emp_Watermark_;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    --
    -- local cursors
    --
    CURSOR c_Employee_Lack_(Emmployee_Id_ VARCHAR2) IS
      SELECT Emp_No, Value_, Desc_
        FROM (SELECT d.*
                FROM Zan_Pers_Lacking_Doc d
               WHERE d.Company_Id = c_Company_Id
                 AND d.Emp_No = Emmployee_Id_) Tab_ --
             Unpivot((Value_, Desc_) FOR Sk IN((Doc1001, Doc1001_Desc) AS 1,
                                               (Doc1002, Doc1002_Desc) AS 2,
                                               (Doc1003, Doc1003_Desc) AS 3,
                                               (Doc1004, Doc1004_Desc) AS 4,
                                               (Doc1005, Doc1005_Desc) AS 5,
                                               (Doc1006, Doc1006_Desc) AS 6,
                                               (Doc1007, Doc1007_Desc) AS 7,
                                               (Doc1008, Doc1008_Desc) AS 8,
                                               (Doc1009, Doc1009_Desc) AS 9,
                                               (Doc1010, Doc1010_Desc) AS 10,
                                               (Doc1011, Doc1011_Desc) AS 11,
                                               (Doc1012, Doc1012_Desc) AS 12,
                                               (Doc1013, Doc1013_Desc) AS 13,
                                               (Doc1014, Doc1014_Desc) AS 14,
                                               (Doc1015, Doc1015_Desc) AS 15,
                                               (Doc1016, Doc1016_Desc) AS 16,
                                               (Doc1017, Doc1017_Desc) AS 17,
                                               (Doc1018, Doc1018_Desc) AS 18,
                                               (Doc1019, Doc1019_Desc) AS 19,
                                               (Doc1020, Doc1020_Desc) AS 20,
                                               (Doc1021, Doc1021_Desc) AS 21,
                                               (Doc1022, Doc1022_Desc) AS 22,
                                               (Doc1023, Doc1023_Desc) AS 23,
                                               (Doc1024, Doc1024_Desc) AS 24,
                                               (Doc1025, Doc1025_Desc) AS 25,
                                               (Doc1026, Doc1026_Desc) AS 26,
                                               (Doc1027, Doc1027_Desc) AS 27,
                                               (Doc1028, Doc1028_Desc) AS 28,
                                               (Doc1029, Doc1029_Desc) AS 29,
                                               (Doc1030, Doc1030_Desc) AS 30,
                                               (Doc1031, Doc1031_Desc) AS 31,
                                               (Doc1032, Doc1032_Desc) AS 32,
                                               (Doc1033, Doc1033_Desc) AS 33,
                                               (Doc1034, Doc1034_Desc) AS 34,
                                               (Doc1035, Doc1035_Desc) AS 35,
                                               (Doc1036, Doc1036_Desc) AS 36,
                                               (Doc1037, Doc1037_Desc) AS 37,
                                               (Doc1038, Doc1038_Desc) AS 38,
                                               (Doc1039, Doc1039_Desc) AS 39,
                                               (Doc1040, Doc1040_Desc) AS 40,
                                               (Doc1041, Doc1041_Desc) AS 41,
                                               (Doc1042, Doc1042_Desc) AS 42,
                                               (Doc1043, Doc1043_Desc) AS 43,
                                               (Doc1044, Doc1044_Desc) AS 44,
                                               (Doc1045, Doc1045_Desc) AS 45,
                                               (Doc1046, Doc1046_Desc) AS 46,
                                               (Doc1047, Doc1047_Desc) AS 47,
                                               (Doc1048, Doc1048_Desc) AS 48,
                                               (Doc1049, Doc1049_Desc) AS 49,
                                               (Doc1050, Doc1050_Desc) AS 50));
    Emp_Lack_Rec_ c_Employee_Lack_%ROWTYPE;
    --
    PROCEDURE Add_Rec_(Emp_No_   IN VARCHAR2,
                       n_Emp_    IN Emp_Tmp_,
                       o_Emp_    IN Emp_Tmp_,
                       Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wa_.Meta_.Lineno := Rec_No_;
        It_(Nvl(It_.Last, 0) + 1) := Wa_;
      END Save_;
    BEGIN
      -- flush data
      -- case: add each record not
      -- not clear logic is applied
      Wa_.Pakey_.Mandt := c_Mandt;
      Wa_.Pakey_.Pernr := Emp_No_;
      Wa_.Pakey_.Begda := My_Date___(o_Emp_.Date_From);
      Wa_.Pakey_.Endda := My_Date___(o_Emp_.Date_To);
      --
      Wa_.Ps9950_.Zzempque := o_Emp_.S1; -- varchar2(1), --  Kwestionariusz osobowy
      Wa_.Ps9950_.Zzempcon := o_Emp_.S2; --  varchar2(1), --  Umowa o pracê
      Wa_.Ps9950_.Zzjobdes := o_Emp_.S3; --  varchar2(1), --  Zakres obowi¹zków
      Wa_.Ps9950_.Zzworper := o_Emp_.S4; --  varchar2(1), --  Pozwolenie na pracê
      Wa_.Ps9950_.Zzworcer := o_Emp_.S5; --  varchar2(1), --  Œwiadectwo pracy
      Wa_.Ps9950_.Zzdiplom := o_Emp_.S6; --  varchar2(1), --  Dyplom
      Wa_.Ps9950_.Zzmedexa := o_Emp_.S7; --  varchar2(1), --  Badania lekarskie
      Wa_.Ps9950_.Zzbhptra := o_Emp_.S8; --  varchar2(1), --  Szkolenie BHP
      Wa_.Ps9950_.Zzcomwor := o_Emp_.S9; --  varchar2(1), --  Œwiadectwo pracy firma
      Wa_.Ps9950_.Zzrefere := o_Emp_.S10; --  varchar2(1), --  Referencje
      Wa_.Ps9950_.Zznonsub := o_Emp_.S11; --  varchar2(1), --  Oœwiadczenie o bezrobociu
      Wa_.Ps9950_.Zzcrirec := o_Emp_.S12; --  varchar2(1), --  Oœwiadczenie o niekaralnoœci
      Wa_.Ps9950_.Zzjobris := o_Emp_.S13; --  varchar2(1), --  Ryzyko zawodowe
      Wa_.Ps9950_.Zzunfeli := o_Emp_.S14; --   varchar2(1), --  Licencja UNFE
      Wa_.Ps9950_.Zzcurvit := o_Emp_.S15; --    varchar2(1), --  CV
      Wa_.Ps9950_.Zzannex  := o_Emp_.S16; --    varchar2(1), -- Aneks
      Wa_.Ps9950_.Zzinfemp := o_Emp_.S17; --    varchar2(1), --  Informacja dla pracownika
      Wa_.Ps9950_.Zzequtre := o_Emp_.S18; --    varchar2(1), --  Oœwiadczenie o równym traktowaniu
      Wa_.Ps9950_.Zzbuscon := o_Emp_.S19; --    varchar2(1), --Certyfikat firmowy
      Wa_.Ps9950_.Zzppozce := o_Emp_.S20; --    varchar2(1), --  Oœwiadczenie PPO¯
      Wa_.Ps9950_.Zzinfsw1 := o_Emp_.S21; --   varchar2(120), --  Informacja o œwiadectwach 1
      Wa_.Ps9950_.Zzinfsw2 := o_Emp_.S22; -- varchar2(120), --  Informacja o œwiadectwach 2
      Wa_.Ps9950_.Zzdoda01 := o_Emp_.S23; --   varchar2(1), --  Dodatkowy dokument 1
      Wa_.Ps9950_.Zzdoda02 := o_Emp_.S24; --   varchar2(1), --Dodatkowy dokument 2
      Wa_.Ps9950_.Zzdoda03 := o_Emp_.S25; --   varchar2(1), --  Dodatkowy dokument 3
      Wa_.Ps9950_.Zzdoda04 := o_Emp_.S26; --   varchar2(1), --  Dodatkowy dokument 4
      Wa_.Ps9950_.Zzdoda05 := o_Emp_.S27; --   varchar2(1), --  Dodatkowy dokument 5
      Wa_.Ps9950_.Zzdoda06 := o_Emp_.S28; --   varchar2(1), --  Dodatkowy dokument 6
      Wa_.Ps9950_.Zzdodo98 := o_Emp_.S29; --   varchar2(120), --  Dodatkowy dokument opis 1
      Wa_.Ps9950_.Zzdodo99 := o_Emp_.S30; --   varchar2(120) --  Dodatkowy dokument opis
      --
      Save_;
    END Add_Rec_;
    PROCEDURE Fill_Rec(Emp_No_ IN VARCHAR2,
                       Rec_    IN OUT Emp_Tmp_,
                       Inrec_  IN c_Employee_Lack_%ROWTYPE) IS
      Key_ VARCHAR2(200); --
    BEGIN
      --
      Rec_.Date_From := Nvl(Rec_.Date_From, Get_Emp_Last_Employement(Emp_No_));
      Rec_.Date_To   := Nvl(Rec_.Date_To, Get_Emp_Last_Termination(Emp_No_));
      --
      IF Inrec_.Value_ = 'TRUE' THEN
        Key_ := Get_Mapping(m_Lack_Doc_Type, Inrec_.Desc_, FALSE); --
        IF Key_ = '?' THEN
          RETURN;
        END IF;
        BEGIN
          IF Substr(Key_, 1, 2) = '##' THEN
            Rec_.S30 := Rec_.S30 || Key_;
          ELSIF Substr(Key_, 1, 1) = '#' THEN
            Rec_.S29 := Rec_.S29 || Key_;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            Add_Error___(Emp_No_, 'LackDoc', 10,
                         'Value to long' || Key_ || ' ' || --
                          Substr(SQLERRM, 1, 200));
        END;
        --
        BEGIN
          IF Substr(Key_, 1, 1) = '#' THEN
            RETURN;
          END IF;
          --
          CASE Key_
            WHEN 1 THEN
              Rec_.S1 := 'X';
            WHEN 2 THEN
              Rec_.S2 := 'X';
            WHEN 3 THEN
              Rec_.S3 := 'X';
            WHEN 4 THEN
              Rec_.S4 := 'X';
            WHEN 5 THEN
              Rec_.S5 := 'X';
            WHEN 6 THEN
              Rec_.S6 := 'X';
            WHEN 7 THEN
              Rec_.S7 := 'X';
            WHEN 8 THEN
              Rec_.S8 := 'X';
            WHEN 9 THEN
              Rec_.S9 := 'X';
            WHEN 10 THEN
              Rec_.S10 := 'X';
            WHEN 11 THEN
              Rec_.S11 := 'X';
            WHEN 12 THEN
              Rec_.S12 := 'X';
            WHEN 13 THEN
              Rec_.S13 := 'X';
            WHEN 14 THEN
              Rec_.S14 := 'X';
            WHEN 15 THEN
              Rec_.S15 := 'X';
            WHEN 16 THEN
              Rec_.S16 := 'X';
            WHEN 17 THEN
              Rec_.S17 := 'X';
            WHEN 18 THEN
              Rec_.S18 := 'X';
            WHEN 19 THEN
              Rec_.S19 := 'X';
            WHEN 20 THEN
              Rec_.S20 := 'X';
            WHEN 21 THEN
              Rec_.S21 := 'X';
            WHEN 22 THEN
              Rec_.S22 := 'X';
            WHEN 23 THEN
              Rec_.S23 := 'X';
            WHEN 24 THEN
              Rec_.S24 := 'X';
            WHEN 25 THEN
              Rec_.S25 := 'X';
            WHEN 26 THEN
              Rec_.S26 := 'X';
            WHEN 27 THEN
              Rec_.S27 := 'X';
            WHEN 28 THEN
              Rec_.S28 := 'X';
            WHEN 29 THEN
              Rec_.S29 := 'X';
            WHEN 30 THEN
              Rec_.S30 := 'X';
            ELSE
              RETURN;
          END CASE;
        EXCEPTION
          WHEN OTHERS THEN
            Add_Error___(Emp_No_, 'LackDoc', 20,
                         'Undefined error for ' || Key_ || ' ' || --
                          Substr(SQLERRM, 1, 200));
        END;
        --
      END IF;
      --
    END Fill_Rec;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      IF c_Company_Id IN ('148') THEN
        EXIT;
      END IF;
      --
      Is_First_ := TRUE;
      -- initialize local temp rec
      n_Rec_ := NULL;
      -- perform employee matrix
      OPEN c_Employee_Lack_(Emp_Company_Rec_.Employee_Id);
      LOOP
        FETCH c_Employee_Lack_
          INTO Emp_Lack_Rec_;
        EXIT WHEN c_Employee_Lack_%NOTFOUND;
        --
        IF (Instr(c_Emp_No, '0000000') > 0 AND c_Emp_No != '%') THEN
          Dbms_Output.Put_Line('Perf rec_: ' || n_Rec_.Set_Name || ' ' ||
                               To_Char(n_Rec_.Date_From) || ' - ' || To_Char(n_Rec_.Date_To));
        END IF;
        -- fill work area with master data value
        Fill_Rec(Emp_Company_Rec_.Employee_Id, n_Rec_, Emp_Lack_Rec_);
        -- apply storage logic
        /*if is_first_ then
          add_rec_(emp_company_rec_.employee_id, n_rec_, null, true);
          is_first_ := false;
        else
          add_rec_(emp_company_rec_.employee_id, n_rec_, o_rec_);
        end if;*/
        --
        o_Rec_ := n_Rec_;
      END LOOP;
      CLOSE c_Employee_Lack_;
      -- perform last rec for each employee
      -- not clear logic
      Add_Rec_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api.Store___(It_);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      --                           --
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, o_Rec_, n_Rec_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_P9950;
  --
  PROCEDURE Get_Payroll(Box_No_ IN NUMBER DEFAULT 1, Boxes_ IN NUMBER DEFAULT 1) IS
    Ita_ Pay558a;
    Itb_ Pay558b;
    Itc_ Pay558c;
    Waa_ Payt558a;
    Wab_ Payt558b;
    Wac_ Payt558c;
    --
    n_Rec_a_         Emp_Tmp_;
    n_Rec_b_         Emp_Tmp_;
    o_Rec_b_         Emp_Tmp_;
    n_Rec_c_         Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    Min_Date_        DATE;
    --
    Is_First_ BOOLEAN;
    Rec_No_   NUMBER := 0;
    Chunk_No_ NUMBER;
    --
    Count_Emp_ NUMBER;
    Box_Count_ NUMBER;
    b_Gather_  BOOLEAN;
    --
    -- local cursors
    --
    CURSOR c_Payroll_Arch_Emp_(Emp_No_ VARCHAR2, Min_Date_ DATE) IS
      WITH Tab_ AS
       (SELECT t.Company_Id,
               t.Tax_Year * 100 + t.Tax_Month Tax_,
               Last_Day(Least(t.Validation_Date,
                              To_Date(t.Tax_Year * 10000 + t.Tax_Month * 100 + 01, 'YYYYMMDD'))) Validation_Date_,
               t.Emp_No,
               Decode(t.Wage_Code_Id, '15050', '15045', Wage_Code_Id) Wage_Code_Id_,
               t.Summarised_Value,
               t.Rowkey Rowkey_,
               Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY Last_Day(t.Validation_Date), t.Tax_Year, t.Tax_Month) AS Period_Main_
          FROM (SELECT t.Company_Id,
                       CASE
                         WHEN c_Tax_Move = 'TRUE'
                              AND Tax_Month = 1
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          t.Tax_Year - 1
                         ELSE
                          t.Tax_Year
                       END Tax_Year,
                       CASE
                         WHEN c_Tax_Move = 'TRUE'
                              AND Tax_Month = 1
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          12
                         WHEN c_Tax_Move = 'TRUE'
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          t.Tax_Month - 1
                         ELSE
                          t.Tax_Month
                       END Tax_Month,
                       CASE
                       --select distinct b.wage_code_id from HRP_ABS_CALC_OTHER_WC_TAb b where b.company_id = t.company_id
                         WHEN Wage_Code_Id IN ('24023', '24026') THEN
                          Greatest(To_Date((t.Accounting_Year * 100 + t.Accounting_Month) || '01',
                                           'YYYYMMDD'), Min_Date_)
                         ELSE
                          Greatest(t.Validation_Date, Min_Date_)
                       END Validation_Date,
                       t.Emp_No,
                       t.Wage_Code_Id,
                       Round(t.Summarised_Value, 2) Summarised_Value,
                       t.Rowkey
                  FROM Hrp_Wc_Archive_Tab t
                 WHERE c_Add_List_ = 'FALSE'
                UNION ALL
                -- tax declaration period
                SELECT t.Company_Id,
                       CASE
                         WHEN c_Tax_Move = 'TRUE'
                              AND Tax_Month = 1
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          Tax_Year - 1
                         ELSE
                          Tax_Year
                       END Tax_Year,
                       CASE
                         WHEN c_Tax_Move = 'TRUE'
                              AND Tax_Month = 1
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          12
                         WHEN c_Tax_Move = 'TRUE'
                         /*AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                         (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1)*/
                          THEN
                          Tax_Month - 1
                         ELSE
                          Tax_Month
                       END Tax_Month,
                       CASE
                         WHEN c_Tax_Move = 'TRUE'
                              AND To_Char(Trunc(Min_Date_, 'MONTH'), 'YYYYMMDD') <
                              (t.Tax_Year * 10000 + t.Tax_Month * 100 + 1) THEN
                          Add_Months(To_Date((t.Tax_Year * 100 + t.Tax_Month) || '01', 'YYYYMMDD'), -1)
                         ELSE
                          To_Date((t.Tax_Year * 100 + t.Tax_Month) || '01', 'YYYYMMDD')
                       END Validation_Date,
                       t.Emp_No,
                       Substr(Pit_.Old_Value, 22, 30) Wage_Code_Id,
                       Round(Hrp_Wc_Archive_Api.Get_Group_Value_By_Month(t.Company_Id, t.Emp_No,
                                                                         Substr(Pit_.Old_Value, 22, 30),
                                                                         0, 2,
                                                                         To_Date((t.Tax_Year * 100 +
                                                                                  t.Tax_Month) || '01',
                                                                                  'YYYYMMDD'),
                                                                         To_Date((t.Tax_Year * 100 +
                                                                                  t.Tax_Month) || '01',
                                                                                  'YYYYMMDD')), 2) Summarised_Value,
                       NULL Rowkey
                  FROM (SELECT Company_Id, Tax_Year, Tax_Month, Emp_No
                          FROM Hrp_Wc_Archive_Tab
                         GROUP BY Company_Id, Tax_Year, Tax_Month, Emp_No) t,
                       Intface_Conv_List_Cols_Tab Pit_
                 WHERE c_Add_List_ = 'FALSE'
                   AND Substr(c_Caclulated_To, 1, 4) < t.Tax_Year + 3 -- for last three year
                   AND Pit_.Conv_List_Id = 'EXP_SAP_WC'
                   AND (Pit_.Old_Value LIKE '%M_WAGECODE_TYPE^PIT%' OR
                       Pit_.Old_Value LIKE '%M_WAGECODE_TYPE^FOR%')
                UNION ALL
                SELECT t.Company_Id,
                       t.Tax_Year,
                       t.Tax_Month,
                       To_Date(c_Caclulated_To || '01', 'YYYYMMDD') Validation_Date, --t.Validation_Date,
                       t.Emp_No,
                       t.Wage_Code_Id,
                       Round(t.Value, 2) VALUE,
                       t.Rowkey
                  FROM Hrp_Wc_Archive_Det_Tab t
                 WHERE c_Add_List_ = 'TRUE'
                   AND t.Payroll_List_Id LIKE 'LD%') t
         WHERE t.Company_Id = c_Company_Id
           AND t.Emp_No = Emp_No_
           AND (((t.Tax_Year * 100 + t.Tax_Month) <= c_Caclulated_To AND c_Add_List_ = 'FALSE') OR
               ((t.Tax_Year * 100 + t.Tax_Month) = c_Caclulated_To AND c_Add_List_ = 'TRUE'))
           AND (t.Tax_Year * 100 + t.Tax_Month) >= c_Caclulated_From
           AND EXISTS (SELECT 1
                  FROM Intface_Conv_List_Cols_Tab b
                 WHERE b.Conv_List_Id = 'EXP_SAP_WC'
                   AND b.Old_Value IN ('****^M_WAGECODE_TYPE^' || t.Wage_Code_Id,
                                       Lpad(t.Company_Id, 4, '0') || '^M_WAGECODE_TYPE^' ||
                                        t.Wage_Code_Id)
                   AND NOT (Substr(b.New_Value, 1, 3) IN ('?$$', 'N/A') OR
                        Substr(b.New_Value, 1, 1) IN ('?')))),
      Itab_Recur_(Company_Id,
      Emp_No,
      Wage_Code_Id_,
      Tax_,
      Validation_Date_,
      Summarised_Value,
      Rowkey_) AS
       (SELECT Company_Id, Emp_No, Wage_Code_Id_, Tax_, Validation_Date_, Summarised_Value, Rowkey_
          FROM Tab_
        UNION ALL
        SELECT Company_Id,
               Emp_No,
               'DUMMY',
               Tax_,
               Last_Day(Add_Months(Validation_Date_, 1)) Validation_Date_,
               0,
               Rowkey_
          FROM Itab_Recur_
         WHERE Validation_Date_ < Last_Day(To_Date((Tax_) || '01', 'YYYYMMDD'))),
      Itab_Recur_Period_ AS
       (SELECT Company_Id,
               Emp_No,
               Wage_Code_Id_,
               Tax_,
               Validation_Date_,
               Summarised_Value,
               Rowkey_,
               Dense_Rank() Over(PARTITION BY Emp_No ORDER BY Validation_Date_, Tax_) AS Period_Main_
          FROM Itab_Recur_),
      Period_ AS
       (SELECT DISTINCT t.Emp_No,
                        t.Validation_Date_,
                        Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY t.Validation_Date_, t.Tax_) AS Period_
          FROM Itab_Recur_Period_ t),
      Wc_ AS
       (SELECT DISTINCT t.Emp_No, t.Validation_Date_, t.Wage_Code_Id_ FROM Itab_Recur_Period_ t),
      Period_Wc_ AS
       (SELECT Period_, p.Emp_No Emp_No_, Wage_Code_Id_ Wage_Code_Id_, p.Validation_Date_
          FROM Period_ p, Wc_ w
         WHERE p.Validation_Date_ = w.Validation_Date_),
      Out_ AS
       (SELECT p.*,
               t.Summarised_Value,
               t.Tax_,
               (SELECT MAX(Tax_)
                  FROM Itab_Recur_Period_ p
                 WHERE p.Period_Main_ = p.Period_
                   AND Tax_ IS NOT NULL) AS Tax_Calc_,
               --MAX(t.Tax_) Over(PARTITION BY t.Emp_No ORDER BY p.Period_ RANGE BETWEEN Unbounded Preceding AND CURRENT ROW) AS Max_Tax_,
               Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY t.Emp_No, t.Validation_Date_, t.Tax_) AS Myrank_,
               SUM(Nvl(t.Summarised_Value, 0)) Over(PARTITION BY p.Emp_No_, p.Wage_Code_Id_, p.Validation_Date_ ORDER BY p.Period_ RANGE BETWEEN Unbounded Preceding AND CURRENT ROW) AS T558c_Sum_,
               Dense_Rank() Over(PARTITION BY t.Emp_No, t.Wage_Code_Id_, p.Period_ ORDER BY t.Rowkey_) AS T558c_Rank_,
               SUM(Nvl(t.Summarised_Value, 0)) Over(PARTITION BY t.Emp_No, t.Wage_Code_Id_, t.Tax_) AS T558a_Sum_,
               Rank() Over(PARTITION BY t.Emp_No, t.Wage_Code_Id_, t.Tax_ ORDER BY t.Rowkey_) AS T558a_Rank_, -- this has to provide not doubling data
               SUM(Nvl(t.Summarised_Value, 0)) Over(PARTITION BY p.Emp_No_, p.Wage_Code_Id_, Substr(t.Tax_, 1, 4) ORDER BY t.Tax_ RANGE BETWEEN Unbounded Preceding AND CURRENT ROW) AS Sum_Year_,
               Decode(Dense_Rank() Over(PARTITION BY t.Emp_No, t.Wage_Code_Id_,
                           t.Validation_Date_ ORDER BY t.Tax_ DESC), '3', 'O', '2', 'P', '1', 'A', 'O') AS List_Sign_
          FROM Itab_Recur_Period_ t, Period_Wc_ p
         WHERE p.Period_ = t.Period_Main_(+)
           AND p.Wage_Code_Id_ = t.Wage_Code_Id_(+))
      SELECT * FROM Out_ o WHERE Wage_Code_Id_ != 'DUMMY' ORDER BY Period_;
    /*
        WITH Tab_ AS
         (SELECT t.Company_Id,
                 t.Accounting_Year,
                 t.Accounting_Month,
                 t.Tax_Year,
                 t.Tax_Month,
                 t.Tax_Year * 100 + t.Tax_Month Tax_,
                 t.Validation_Date,
                 t.Emp_No,
                 CASE t.Wage_Code_Id
                   WHEN '15050' THEN
                    '15045'
                   ELSE
                    Wage_Code_Id
                 END Wage_Code_Id,
                 t.Summarised_Value,
                 t.Period_No,
                 t.Pl_Period_Type,
                 t.Rowversion,
                 t.Rowkey,
                 --last_day(t.validation_date) validation_date_,
                 Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY Last_Day(t.Validation_Date), t.Tax_Year, t.Tax_Month) AS Period_Main_
            FROM Hrp_Wc_Archive_Tab t
           WHERE t.Company_Id = c_Company_Id
             AND t.Emp_No = Emp_No_
             AND (t.Tax_Year * 100 + t.Tax_Month) <= c_Caclulated_To
             AND NOT EXISTS (SELECT 1
                    FROM Intface_Conv_List_Cols_Tab b
                   WHERE b.Conv_List_Id = 'EXP_SAP_WC'
                     AND b.Old_Value IN
                         ('****^M_WAGECODE_TYPE^' || t.Wage_Code_Id,
                          t.Company_Id || '^M_WAGECODE_TYPE^' || t.Wage_Code_Id)
                     AND (Substr(b.New_Value, 1, 3) IN ('?$$', 'N/A') OR
                         Substr(b.New_Value, 1, 1) IN ('?')))),
        Period_ AS
         (SELECT DISTINCT t.Emp_No,
                          Last_Day(t.Validation_Date) Validation_Date_,
                          Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY Last_Day(t.Validation_Date), t.Tax_Year, t.Tax_Month) AS Period_
            FROM Tab_ t),
        Wc_ AS
         (SELECT DISTINCT t.Emp_No, Last_Day(t.Validation_Date) Validation_Date_, t.Wage_Code_Id
            FROM Tab_ t),
        Period_Wc_ AS
         (SELECT Period_, p.Emp_No Emp_No_, Wage_Code_Id Wage_Code_Id_, p.Validation_Date_
            FROM Period_ p, Wc_ w
           WHERE p.Validation_Date_ = w.Validation_Date_)
        SELECT p.*,
               t.*,
               MAX(t.Tax_) Over(PARTITION BY t.Emp_No ORDER BY p.Period_ RANGE BETWEEN Unbounded Preceding AND CURRENT ROW) AS Max_Tax_,
               Dense_Rank() Over(PARTITION BY t.Emp_No ORDER BY t.Emp_No, Last_Day(t.Validation_Date), t.Tax_Year, t.Tax_Month) AS Myrank_,
               SUM(Nvl(t.Summarised_Value, 0)) Over(PARTITION BY p.Emp_No_, p.Wage_Code_Id_, p.Validation_Date_ ORDER BY p.Period_ RANGE BETWEEN Unbounded Preceding AND CURRENT ROW) AS T558c_Sum_,
               Dense_Rank() Over(PARTITION BY t.Emp_No, t.Wage_Code_Id, p.Period_ ORDER BY t.Rowid) AS T558c_Rank_,
               SUM(Nvl(t.Summarised_Value, 0)) Over(PARTITION BY t.Emp_No, t.Wage_Code_Id, t.Tax_Year, t.Tax_Month) AS T558a_Sum_,
               Rank() Over(PARTITION BY t.Emp_No, t.Wage_Code_Id, t.Tax_Year, t.Tax_Month ORDER BY t.Rowid) AS T558a_Rank_, -- this has to provide not doubling data
               Decode(Dense_Rank()
                      Over(PARTITION BY t.Emp_No, t.Wage_Code_Id,
                           Last_Day(t.Validation_Date) ORDER BY t.Tax_Year DESC, t.Tax_Month DESC), '3',
                      'O', '2', 'P', '1', 'A', 'O') AS List_Sign_
          FROM Tab_ t, Period_Wc_ p
         WHERE p.Period_ = t.Period_Main_(+)
           AND p.Wage_Code_Id_ = t.Wage_Code_Id(+)
         ORDER BY t.Emp_No, Myrank_;
    */
    /*with tab_ as
     (select t.* ,
     DENSE_RANK() over(PARTITION BY t.emp_no, last_day(t.validation_date) ORDER BY t.tax_year, t.tax_month) AS period_
     from hrp_wc_archive_tab t
       where t.company_id = c_company_id
         and t.emp_no = emp_no_
         and (t.tax_year * 100 + t.tax_month) <= c_caclulated_to
         and not exists
       (select 1
                from intface_conv_list_cols_tab b
               where b.conv_list_id = c_conv_group_out_
                 and b.old_value in
                     ('****^M_WAGECODE_TYPE^' || t.wage_code_id,
                      t.company_id || '^M_WAGECODE_TYPE^' || t.wage_code_id)
                 and b.new_value in ('?', 'N/A'))),
    period_ as
     (select DENSE_RANK() over(PARTITION BY t.emp_no, last_day(t.validation_date) ORDER BY t.tax_year, t.tax_month) AS period_
        from tab_ t)
    select t.*,
           DENSE_RANK() OVER(PARTITION BY t.emp_no ORDER BY t.emp_no, last_day(t.validation_date), t.tax_year, t.tax_month) AS myrank_,
           sum(t.summarised_value) over(PARTITION BY t.emp_no, t.wage_code_id, last_day(t.validation_date) order by t.tax_year, t.tax_month RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as t558c_sum_,
           DENSE_RANK() over(PARTITION BY t.emp_no, t.wage_code_id, t.tax_year, t.tax_month, last_day(t.validation_date) order by t.rowid) AS t558c_rank_,
           sum(t.summarised_value) over(PARTITION BY t.emp_no, t.wage_code_id, t.tax_year, t.tax_month) as t558a_sum_,
           RANK() OVER(PARTITION BY t.emp_no, t.wage_code_id, t.tax_year, t.tax_month order by t.rowid) AS t558a_rank_,
           decode(DENSE_RANK()
                  OVER(PARTITION BY t.emp_no,
                       t.wage_code_id,
                       last_day(t.validation_date) order by t.tax_year desc,
                       t.tax_month desc),
                  '3',
                  'O',
                  '2',
                  'P',
                  '1',
                  'A',
                  'O') AS list_sign_
      from tab_ t,period_ p
      where t.period_ = p.period_(+)
     order by t.emp_no, myrank_;*/
    Emp_Pay_Rec_ c_Payroll_Arch_Emp_%ROWTYPE;
    --
    TYPE Wc_Convert_Tab IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    Wc_Tab Wc_Convert_Tab;
    --
    FUNCTION Get_Sap_Wc(Wc_Name_ IN VARCHAR2) RETURN VARCHAR2 IS
      Name_ VARCHAR2(200);
    BEGIN
      Name_ := Nvl(Wc_Name_, 'DUMMY');
      IF NOT (Wc_Tab.Exists(Name_)) THEN
        Wc_Tab(Name_) := Get_Mapping(m_Wagecode_Type, Name_, FALSE, Mapping_Set_ => c_Conv_Group_Wc_);
      END IF;
      RETURN Wc_Tab(Name_);
    END Get_Sap_Wc;
    --
    PROCEDURE Add_Rec_a_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
        i_     NUMBER;
        n_     NUMBER;
        r_     NUMBER;
        b_     NUMBER;
        From_  NUMBER;
        To_    NUMBER := 0;
        Lgart_ VARCHAR2(5);
        Value_ VARCHAR2(16);
      BEGIN
        Value_ := Waa_.T558a_.Betrg;
        WHILE (TRUE) LOOP
          -- skip to next
          From_ := To_ + 1;
          -- break
          IF (From_ > Length(Waa_.T558a_.Lgart_Tmp)) THEN
            EXIT;
          END IF;
          --
          To_ := Instr(Waa_.T558a_.Lgart_Tmp, '+', From_ + 1);
          IF (To_ = 0) THEN
            -- in regular mode
            To_    := Length(Waa_.T558a_.Lgart_Tmp);
            Lgart_ := Substr(Waa_.T558a_.Lgart_Tmp, From_, To_ - From_ + 1);
          ELSE
            Lgart_ := Substr(Waa_.T558a_.Lgart_Tmp, From_, To_ - From_);
          END IF;
          -- move to work area
          Waa_.T558a_.Lgart := Substr(Lgart_, 1, 4);
          -- definie dimension
          IF Substr(Lgart_, 5, 1) IN ('N', 'R') THEN
            CASE Substr(Lgart_, 5, 1)
              WHEN 'N' THEN
                Waa_.T558a_.Betpe := 0;
                Waa_.T558a_.Anzhl := Value_;
                Waa_.T558a_.Betrg := 0;
              WHEN 'R' THEN
                Waa_.T558a_.Betpe := Value_;
                Waa_.T558a_.Anzhl := 0;
                Waa_.T558a_.Betrg := 0;
            END CASE;
          ELSIF Length(Lgart_) > 4 THEN
            RETURN;
          END IF; -- move this to as partition prat....
          /* i_ := ita_.first;
          while (i_ is not null) loop
            if (ita_(i_).t558a_.pernr = waa_.t558a_.pernr --
               and ita_(i_).t558a_.begda = waa_.t558a_.begda --
               and ita_(i_).t558a_.endda = waa_.t558a_.endda --
               and ita_(i_).t558a_.lgart = waa_.t558a_.lgart) then
              --
              n_ := to_number(replace(nvl(ita_(i_).t558a_.betpe, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(waa_.t558a_.betpe, 0), '.', ','));
              r_ := to_number(replace(nvl(ita_(i_).t558a_.anzhl, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(waa_.t558a_.anzhl, 0), '.', ','));
              b_ := to_number(replace(nvl(ita_(i_).t558a_.betrg, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(waa_.t558a_.betrg, 0), '.', ','));
              --
              ita_(i_).t558a_.betpe := my_number___(n_);
              ita_(i_).t558a_.anzhl := my_number___(r_);
              ita_(i_).t558a_.betrg := my_number___(b_);
              return;
            end if;
            i_ := ita_.next(i_);
          end loop;*/
          IF Waa_.T558a_.Betpe = '0'
             AND Waa_.T558a_.Anzhl = '0'
             AND Waa_.T558a_.Betrg = '0' THEN
            Continue;
          END IF;
          Rec_No_ := Rec_No_ + 1;
          Waa_.Meta_.Lineno := Rec_No_;
          Ita_(Nvl(Ita_.Last, 0) + 1) := Waa_;
        END LOOP;
      END Save_;
    BEGIN
      -- flush data
      -- case: ...
      Waa_.T558a_.Mandt     := c_Mandt;
      Waa_.T558a_.Pernr     := Emp_No_;
      Waa_.T558a_.Begda     := n_Emp_.S3;
      Waa_.T558a_.Endda     := n_Emp_.S4;
      Waa_.T558a_.Molga     := n_Emp_.S5; --MOLGA CHAR  2 T500L Country Grouping
      Waa_.T558a_.Lgart_Tmp := n_Emp_.S6; --LGART CHAR  4 T512W Wage Type
      --
      Waa_.T558a_.Betpe := n_Emp_.S7; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
      Waa_.T558a_.Anzhl := n_Emp_.S8; -- varchar2(15), --RPANZ DEC 15(2)   Number field
      Waa_.T558a_.Betrg := n_Emp_.S9; -- varchar2(15) --RPBET  CURR  15(2)   Amount
      --
      IF n_Emp_.S20 = 1
         AND n_Emp_.S9 != '0'
         AND c_Add_List_ = 'FALSE' THEN
        Save_;
      END IF;
      --
    END Add_Rec_a_;
    --
    PROCEDURE Add_Rec_b_(Emp_No_   IN VARCHAR2,
                         n_Emp_    IN Emp_Tmp_,
                         o_Emp_    IN Emp_Tmp_,
                         Is_First_ BOOLEAN DEFAULT FALSE) IS
      PROCEDURE Save_ IS
      BEGIN
        Rec_No_ := Rec_No_ + 1;
        Wab_.Meta_.Lineno := Rec_No_;
        Itb_(Nvl(Itb_.Last, 0) + 1) := Wab_;
      END Save_;
    BEGIN
      IF (Is_First_) THEN
        -- first
        NULL;
      ELSE
        -- normal
        IF ((o_Emp_.S1 = n_Emp_.S1 OR (o_Emp_.S1 IS NULL AND n_Emp_.S1 IS NULL)) --
           AND (o_Emp_.S2 = n_Emp_.S2 OR (o_Emp_.S2 IS NULL AND n_Emp_.S2 IS NULL)) --
           AND (o_Emp_.S3 = n_Emp_.S3 OR (o_Emp_.S3 IS NULL AND n_Emp_.S3 IS NULL)) --
           AND 1 = 1) THEN
          NULL;
        ELSE
          -- flush data
          -- case: ...
          Wab_.T558b_.Mandt := c_Mandt;
          Wab_.T558b_.Pernr := Emp_No_;
          Wab_.T558b_.Seqnr := o_Emp_.S3;
          --
          Wab_.T558b_.Payty    := o_Emp_.S4; --    varchar2(1), --PAYTY CHAR  1   Payroll type
          Wab_.T558b_.Payid    := o_Emp_.S5; --    varchar2(1), --PAYID CHAR  1   Payroll Identifier
          Wab_.T558b_.Paydt    := o_Emp_.S6; --    varchar2(8), --PAY_DATE  DATS  8   Pay date for payroll result
          Wab_.T558b_.Permo    := o_Emp_.S7; --    varchar2(2), --PERMO NUMC  2 T549R Period Parameters
          Wab_.T558b_.Pabrj    := o_Emp_.S8; --    varchar2(4), --PABRJ NUMC  4   Payroll Year  GJAHR
          Wab_.T558b_.Pabrp    := o_Emp_.S9; --    varchar2(2), --PABRP NUMC  2   Payroll Period
          Wab_.T558b_.Fpbeg    := o_Emp_.S10; --    varchar2(8), --FPBEG DATS  8   Start date of payroll period (FOR period)
          Wab_.T558b_.Fpend    := o_Emp_.S11; --    varchar2(8), --FPEND DATS  8   End of payroll period (for-period)
          Wab_.T558b_.Ocrsn    := o_Emp_.S12; --   varchar2(4), --PAY_OCRSN CHAR  4   Reason for Off-Cycle Payroll
          Wab_.T558b_.Seqnr_Cd := o_Emp_.S13; -- varchar2(5) --CDSEQ NUMC  5   Sequence Number
          --
          IF c_Add_List_ = 'TRUE' THEN
            Wab_.T558b_.Payty    := 'B';
            Wab_.T558b_.Payid    := '1';
            Wab_.T558b_.Seqnr_Cd := '00000';
          END IF;
          --
          IF o_Emp_.S10 IS NOT NULL THEN
            Save_;
          END IF;
          --
        END IF;
      END IF;
    END Add_Rec_b_;
    --
    PROCEDURE Add_Rec_c_(Emp_No_ IN VARCHAR2, n_Emp_ IN Emp_Tmp_) IS
      PROCEDURE Save_ IS
        i_         NUMBER;
        n_         NUMBER;
        r_         NUMBER;
        b_         NUMBER;
        From_      NUMBER;
        To_        NUMBER := 0;
        Lgart_     VARCHAR2(5);
        Value_     VARCHAR2(16);
        Value_Cum_ VARCHAR2(16);
      BEGIN
        Value_     := Wac_.T558c_.Betrg;
        Value_Cum_ := Wac_.T558c_.Betrg_Cum;
        WHILE (TRUE) LOOP
          -- skip to next
          From_ := To_ + 1;
          -- break
          IF (From_ > Length(Wac_.T558c_.Lgart_Tmp)) THEN
            EXIT;
          END IF;
          --
          To_ := Instr(Wac_.T558c_.Lgart_Tmp, '+', From_ + 1);
          --
          IF (To_ = 0) THEN
            -- in regular mode
            To_    := Length(Wac_.T558c_.Lgart_Tmp);
            Lgart_ := Substr(Wac_.T558c_.Lgart_Tmp, From_, To_ - From_ + 1);
          ELSE
            Lgart_ := Substr(Wac_.T558c_.Lgart_Tmp, From_, To_ - From_);
          END IF;
          -- move to work area
          Wac_.T558c_.Lgart := Substr(Lgart_, 1, 4);
          -- definie dimension
          IF Substr(Lgart_, 5, 1) IN ('N', 'R', 'C', 'O', 'P') THEN
            CASE Substr(Lgart_, 5, 1)
              WHEN 'N' THEN
                Wac_.T558c_.Betpe := 0;
                Wac_.T558c_.Anzhl := Value_;
                Wac_.T558c_.Betrg := 0;
              WHEN 'R' THEN
                Wac_.T558c_.Betpe := Value_;
                Wac_.T558c_.Anzhl := 0;
                Wac_.T558c_.Betrg := 0;
              WHEN 'C' THEN
                Wac_.T558c_.Betpe := 0;
                Wac_.T558c_.Anzhl := 0;
                -- refresh cumm value
                SELECT SUM(t.Summarised_Value)
                  INTO Value_Cum_
                  FROM Hrp_Wc_Archive_Tax t
                 WHERE t.Company_Id = c_Company_Id
                   AND t.Emp_No = Emp_No_
                   AND t.Tax_Year = Substr(c_Caclulated_To, 1, 4)
                   AND t.Wage_Code_Id = n_Emp_.S11;
                Wac_.T558c_.Betrg := My_Number___(Value_Cum_);
              WHEN 'O' THEN
                Wac_.T558c_.Betpe := 0;
                Wac_.T558c_.Anzhl := 0;
                -- refresh cumm value
                SELECT SUM(t.Summarised_Value)
                  INTO Value_Cum_
                  FROM Hrp_Wc_Archive_Tax t
                 WHERE t.Company_Id = c_Company_Id
                   AND t.Emp_No = Emp_No_
                   AND t.Tax_Year * 100 + t.Tax_Month = Substr(n_Emp_.S6, 1, 6)
                   AND t.Wage_Code_Id = n_Emp_.S11;
                --
                Wac_.T558c_.Betrg := My_Number___(Value_ - Value_Cum_);
              WHEN 'P' THEN
                Wac_.T558c_.Molga := '99';
                Wac_.T558c_.Betpe := 0;
                Wac_.T558c_.Anzhl := 0;
                Wac_.T558c_.Betrg := Value_;
            END CASE;
          END IF;
          -- add tax split info for particulara sap wage codes
          IF Wac_.T558c_.Lgart = '/4C1'
             OR Wac_.T558c_.Lgart = '/4C3'
             OR Wac_.T558c_.Lgart = '/4C5'
             OR Wac_.T558c_.Lgart = '/4V9'
             OR Wac_.T558c_.Lgart = '/500'
             OR Wac_.T558c_.Lgart = '/501'
             OR Wac_.T558c_.Lgart = '/511'
             OR Wac_.T558c_.Lgart = '/531'
             OR Wac_.T558c_.Lgart = '/115' THEN
            IF n_Emp_.S11 = '56110' --FB - KOSZTY UZYSKANIA
               OR n_Emp_.S11 = '56190ZZ' --FB - zaliczka na podatek pobrana - um. zlecenie
             THEN
              Wac_.T558c_.Anzhl := 2; -- non-personal
            ELSE
              Wac_.T558c_.Anzhl := 1; -- personal found
            END IF;
          END IF;
          -- move this to as partition ....
          /* i_ := itc_.first;
          while (i_ is not null) loop
            if (itc_(i_).t558c_.pernr = wac_.t558c_.pernr --
               and itc_(i_).t558c_.seqnr = wac_.t558c_.seqnr --
               and itc_(i_).t558c_.molga = wac_.t558c_.molga --
               and itc_(i_).t558c_.keydate = wac_.t558c_.keydate --
               and itc_(i_).t558c_.lgart = wac_.t558c_.lgart) then
              --
              n_ := to_number(replace(nvl(itc_(i_).t558c_.betpe, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(wac_.t558c_.betpe, 0), '.', ','));
              r_ := to_number(replace(nvl(itc_(i_).t558c_.anzhl, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(wac_.t558c_.anzhl, 0), '.', ','));
              b_ := to_number(replace(nvl(itc_(i_).t558c_.betrg, 0),
                                      '.',
                                      ',')) +
                    to_number(replace(nvl(wac_.t558c_.betrg, 0), '.', ','));
              --
              itc_(i_).t558c_.betpe := my_number___(n_);
              itc_(i_).t558c_.anzhl := my_number___(r_);
              itc_(i_).t558c_.betrg := my_number___(b_);
              return;
            end if;
            i_ := itc_.next(i_);
          end loop;*/
          -- skip 0
          IF Wac_.T558c_.Betpe = '0'
             AND Wac_.T558c_.Anzhl = '0'
             AND Wac_.T558c_.Betrg = '0' THEN
            Continue;
          END IF;
          Rec_No_ := Rec_No_ + 1;
          Wac_.Meta_.Lineno := Rec_No_;
          Itc_(Nvl(Itc_.Last, 0) + 1) := Wac_;
        END LOOP;
      END Save_;
    BEGIN
      -- flush data
      -- case: ...
      Wac_.T558c_.Mandt     := c_Mandt;
      Wac_.T558c_.Pernr     := Emp_No_;
      Wac_.T558c_.Seqnr     := n_Emp_.S3;
      Wac_.T558c_.Molga     := n_Emp_.S4; --    MOLGA CHAR  2 T500L Country Grouping
      Wac_.T558c_.Lgart_Tmp := n_Emp_.S5; --    LGART CHAR  4 T512W Wage Type
      Wac_.T558c_.Keydate   := n_Emp_.S6; --  DATUM DATS  8   Date
      --
      Wac_.T558c_.Betpe     := n_Emp_.S7; -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
      Wac_.T558c_.Anzhl     := n_Emp_.S8; -- varchar2(15), --RPANZ DEC 15(2)   Number field
      Wac_.T558c_.Betrg     := n_Emp_.S9; -- varchar2(15) --RPBET  CURR  15(2)   Amount
      Wac_.T558c_.Betrg_Cum := n_Emp_.S10;
      --
      IF c_Add_List_ = 'TRUE' THEN
        Wac_.T558c_.Keydate := My_Date___(c_Caclulated_To || '01');
      END IF;
      --
      IF n_Emp_.S20 = 1 THEN
        Save_;
      END IF;
      --
    END Add_Rec_c_;
    --
    PROCEDURE Fill_Rec_c_(Emp_No_ IN VARCHAR2,
                          Rec_    IN OUT Emp_Tmp_,
                          Inrec_  IN c_Payroll_Arch_Emp_%ROWTYPE) IS
      Wage_Code_Info_  VARCHAR2(200);
      Validation_Date_ DATE;
    BEGIN
      -- TODO ...
      --
      Wage_Code_Info_ := Get_Sap_Wc(Inrec_.Wage_Code_Id_); -- to skip DUMMY
      --  get_mapping(M_WAGECODE_TYPE,inrec_.wage_code_id,false);
      --
      Rec_.S1 := c_Mandt;
      Rec_.S2 := Emp_No_;
      Rec_.S3 := Inrec_.Period_; --SEQ_T558B  NUMC  5   Sequential number for payroll period
      Rec_.S4 := '46'; --    MOLGA CHAR  2 T500L Country Grouping
      Rec_.S5 := Wage_Code_Info_; --AWART  'WC'; --   LGART CHAR  4 T512W Wage Type
      IF c_Add_List_ = 'FALSE' THEN
        Rec_.S6 := My_Date___(Inrec_.Validation_Date_); --   DATUM DATS  8   Date
      ELSE
        Rec_.S6 := My_Date___(Trunc(Inrec_.Validation_Date_, 'MONTH')); --   DATUM DATS  8   Date
      END IF;
      --
      Rec_.S7 := '0'; --    -- varchar2(15), -- BETPE  CURR  15(2)   Payroll: Amount per unit
      Rec_.S8 := '0'; --RPANZ DEC 15(2)   Number field
      IF (c_Pay_Mode = 1) THEN
        Rec_.S9 := My_Number___(Inrec_.T558c_Sum_); --RPBET  CURR  15(2)   Amount
      ELSE
        Rec_.S9  := My_Number___(Inrec_.T558c_Sum_); --RPBET  CURR  15(2)   Amount
        Rec_.S10 := My_Number___(Inrec_.Sum_Year_);
      END IF;
      Rec_.S11 := Inrec_.Wage_Code_Id_;
      --
      Rec_.S20 := Inrec_.T558c_Rank_;
      --
      -- for moved period
      IF Last_Day(Min_Date_) > Last_Day(Inrec_.Validation_Date_)
         AND c_Tax_Move = 'TRUE' THEN
        Validation_Date_ := Add_Months(Inrec_.Validation_Date_, 1);
        Rec_.S6          := My_Date___(Validation_Date_);
      END IF;
    END Fill_Rec_c_;
    --
    PROCEDURE Fill_Rec_b_(Emp_No_ IN VARCHAR2,
                          Rec_    IN OUT Emp_Tmp_,
                          Inrec_  IN c_Payroll_Arch_Emp_%ROWTYPE) IS
      Tax_Date_ DATE;
      Acc_Date_ DATE;
    BEGIN
      /*      -- should exist at last one not null value for tax period
      if Inrec_.tax_calc_ is null then
        return;
      end if;*/
      Tax_Date_ := Last_Day(To_Date(Inrec_.Tax_Calc_ * 100 + 1, 'YYYYMMDD'));
      --Tax_Date_ := Last_Day(To_Date(Inrec_.Tax_Year * 10000 + Inrec_.Tax_Month * 100 + 1, 'YYYYMMDD'));
      --Tax_Date_ := Last_Day(To_Date(Inrec_.Max_Tax_ * 100 + 1, 'YYYYMMDD'));
      IF (c_Pay_Mode = 1) THEN
        NULL;
        --Acc_Date_ := Last_Day(To_Date(Inrec_.Accounting_Year * 10000 +
        --                              Inrec_.Accounting_Month * 100 + 1, 'YYYYMMDD'));
      ELSE
        Acc_Date_ := Last_Day(Inrec_.Validation_Date_);
      END IF;
      -- TODO ...
      --
      Rec_.S1 := c_Mandt;
      Rec_.S2 := Emp_No_;
      Rec_.S3 := Inrec_.Period_; --SEQ_T558B  NUMC  5   Sequential number for payroll period
      --
      Rec_.S4 := 'A'; --    varchar2(1), --PAYTY CHAR  1   Payroll type
      Rec_.S5 := 'A'; --    varchar2(1), --PAYID CHAR  1   Payroll Identifier
      IF c_Add_List_ = 'FALSE' THEN
        Rec_.S6  := My_Date___(Tax_Date_); --    varchar2(8), --PAY_DATE  DATS  8   Pay date for payroll result
        Rec_.S12 := Inrec_.List_Sign_; --   varchar2(4), --PAY_OCRSN CHAR  4   Reason for Off-Cycle Payroll
      ELSE
        Rec_.S6  := My_Date___(Trunc(Tax_Date_, 'MONTH')); --    varchar2(8), --PAY_DATE  DATS  8   Pay date for payroll result
        Rec_.S12 := '0002'; -- additional for previous period
      END IF;
      Rec_.S7  := '01'; --    varchar2(2), --PERMO NUMC  2 T549R Period Parameters
      Rec_.S8  := To_Char(Acc_Date_, 'YYYY'); --    varchar2(4), --PABRJ NUMC  4   Payroll Year  GJAHR
      Rec_.S9  := To_Char(Acc_Date_, 'MM'); --    varchar2(2), --PABRP NUMC  2   Payroll Period
      Rec_.S10 := My_Date___(Trunc(Acc_Date_, 'MONTH')); --    varchar2(8), --FPBEG DATS  8   Start date of payroll period (FOR period)
      Rec_.S11 := My_Date___(Acc_Date_); --    varchar2(8), --FPEND DATS  8   End of payroll period (for-period)
      Rec_.S13 := Inrec_.Myrank_; -- varchar2(5) --CDSEQ NUMC  5   Sequence Number
      -- for moved period
      IF Last_Day(Min_Date_) > Last_Day(Tax_Date_)
         AND c_Tax_Move = 'TRUE' THEN
        Rec_.S5   := '9'; --    varchar2(1), --PAYTY CHAR  1   Payroll type
        Tax_Date_ := Add_Months(Tax_Date_, 1);
        Rec_.S6   := My_Date___(Tax_Date_);
        Rec_.S8   := To_Char(Tax_Date_, 'YYYY');
        Rec_.S9   := To_Char(Tax_Date_, 'MM');
        Rec_.S10  := My_Date___(Tax_Date_);
        Rec_.S11  := My_Date___(Tax_Date_);
        Rec_.S13  := '00000';
      END IF;
      --
    END Fill_Rec_b_;
    --
    PROCEDURE Fill_Rec_a_(Emp_No_ IN VARCHAR2,
                          Rec_    IN OUT Emp_Tmp_,
                          Inrec_  IN c_Payroll_Arch_Emp_%ROWTYPE) IS
      Tax_Date_       DATE;
      Wage_Code_Info_ VARCHAR2(30);
    BEGIN
      Tax_Date_ := Last_Day(To_Date(Inrec_.Tax_Calc_ * 100 + 1, 'YYYYMMDD'));
      -- Tax_Date_       := Last_Day(To_Date(Inrec_.Tax_Year * 10000 + Inrec_.Tax_Month * 100 + 1,'YYYYMMDD'));
      Wage_Code_Info_ := Get_Sap_Wc(Inrec_.Wage_Code_Id_);
      --  get_mapping(M_WAGECODE_TYPE,inrec_.wage_code_id,false);
      -- TODO ...
      --
      Rec_.S1 := c_Mandt;
      Rec_.S2 := Emp_No_;
      Rec_.S3 := My_Date___(Trunc(Tax_Date_, 'MONTH')); --BEGDA
      Rec_.S4 := My_Date___(Tax_Date_); --ENDDA
      Rec_.S5 := '46'; -- MOLGA
      Rec_.S6 := Wage_Code_Info_; -- LGART
      --
      Rec_.S7 := '0'; --BETPE  CURR  15(2)   Payroll: Amount per unit
      Rec_.S8 := '0'; --RPANZ DEC 15(2)   Number field
      Rec_.S9 := My_Number___(Inrec_.Summarised_Value); --RPBET  CURR  15(2)   Amount
      --
      Rec_.S20 := Inrec_.T558a_Rank_;
    END Fill_Rec_a_;
  BEGIN
    --
    Count_Emp_ := 0;
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      Count_Emp_ := Count_Emp_ + 1;
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Box_Count_ := Floor(Count_Emp_ / Boxes_);
    -- clear
    Count_Emp_ := 0;
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Count_Emp_ := Count_Emp_ + 1;
      b_Gather_  := FALSE;
      IF Count_Emp_ > Box_Count_ * (Box_No_ - 1)
         AND Count_Emp_ <= Box_Count_ * Box_No_ THEN
        b_Gather_ := TRUE;
      END IF;
      IF NOT b_Gather_ THEN
        IF Box_No_ >= Boxes_ THEN
          IF Count_Emp_ > Box_Count_ * (Box_No_ - 1)
             AND Count_Emp_ <= 999999999 THEN
            b_Gather_ := TRUE;
          END IF;
        END IF;
      END IF;
      --
      IF NOT b_Gather_ THEN
        Continue;
      END IF;
      --
      --dbms_output.put_line('Emp ' ||Emp_Company_Rec_.Employee_Id);
      --continue;
      --
      Is_First_ := TRUE;
      -- initialize local temp rec
      o_Rec_b_ := NULL;
      -- perform employee matrix
      Min_Date_ := Get_Emp_First_Employement(Emp_Company_Rec_.Employee_Id);
      OPEN c_Payroll_Arch_Emp_(Emp_Company_Rec_.Employee_Id, Min_Date_);
      LOOP
        FETCH c_Payroll_Arch_Emp_
          INTO Emp_Pay_Rec_;
        EXIT WHEN c_Payroll_Arch_Emp_%NOTFOUND;
        -- initialize local temp rec
        n_Rec_a_ := NULL;
        n_Rec_b_ := NULL;
        n_Rec_c_ := NULL;
        --
        IF (c_Emp_No != '%') THEN
          NULL;
        END IF;
        -- fill abs area with master data value
        Fill_Rec_a_(Emp_Company_Rec_.Employee_Id, n_Rec_a_, Emp_Pay_Rec_);
        Fill_Rec_b_(Emp_Company_Rec_.Employee_Id, n_Rec_b_, Emp_Pay_Rec_);
        Fill_Rec_c_(Emp_Company_Rec_.Employee_Id, n_Rec_c_, Emp_Pay_Rec_);
        -- apply storage logic
        IF Is_First_ THEN
          Add_Rec_b_(Emp_Company_Rec_.Employee_Id, n_Rec_b_, NULL, TRUE);
          Is_First_ := FALSE;
        ELSE
          Add_Rec_b_(Emp_Company_Rec_.Employee_Id, n_Rec_b_, o_Rec_b_);
        END IF;
        -- always add rec c
        Add_Rec_a_(Emp_Company_Rec_.Employee_Id, n_Rec_a_);
        Add_Rec_c_(Emp_Company_Rec_.Employee_Id, n_Rec_c_);
        --
        o_Rec_b_ := n_Rec_b_;
      END LOOP;
      CLOSE c_Payroll_Arch_Emp_;
      -- perform last rec for each employee
      Add_Rec_b_(Emp_Company_Rec_.Employee_Id, NULL, o_Rec_b_);
      -- chunk of file
      IF Rec_No_ > c_Payroll_Chunk THEN
        Rec_No_   := 0;
        Chunk_No_ := Nvl(Chunk_No_, 0) + 1;
        -- flush
        Zpk_Sap_Exp_Dic_Api.Store___(Ita_, Chunk_No_, Box_No_);
        Zpk_Sap_Exp_Dic_Api.Store___(Itb_, Chunk_No_, Box_No_);
        Zpk_Sap_Exp_Dic_Api.Store___(Itc_, Chunk_No_, Box_No_);
        -- clear
        Ita_.Delete;
        Itb_.Delete;
        Itc_.Delete;
      END IF;
    END LOOP;
    --
    CLOSE c_Employee_Company_;
    --
    IF Chunk_No_ IS NOT NULL THEN
      Chunk_No_ := Chunk_No_ + 1;
    END IF;
    Zpk_Sap_Exp_Dic_Api.Store___(Ita_, Chunk_No_, Box_No_);
    Zpk_Sap_Exp_Dic_Api.Store___(Itb_, Chunk_No_, Box_No_);
    Zpk_Sap_Exp_Dic_Api.Store___(Itc_, Chunk_No_, Box_No_);
    --
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, n_Rec_a_);
      --
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_Payroll;
  --
  PROCEDURE Get_Base IS
    It_              Paybase;
    Wa_              Paytbase;
    n_Rec_           Emp_Tmp_;
    o_Rec_           Emp_Tmp_;
    Emp_Company_Rec_ c_Employee_Company_%ROWTYPE;
    --
    c_Ground_Months_     NUMBER := 36;
    c_Abs_Type_          VARCHAR2(20) := 'C-11';
    c_Abs_Type_Holi_     VARCHAR2(20) := 'U-11';
    Date_Of_Employment_  DATE;
    Working_Days_        NUMBER;
    Norma_Working_Days_  NUMBER;
    Working_Hours_       NUMBER;
    Working_Hours_Holi_  NUMBER;
    Norma_Working_Hours_ NUMBER;
    -- operating
    Current_Month_ DATE;
    Wc_Value_      NUMBER;
    Net_Factor_    NUMBER;
    Net_Value_     NUMBER;
    Zpk_Nf_Tab_    Zpk_Mig_Abs_Calc_Base_Api.t_Net_Factor_Tab;
    -- yearly
    Wc_0030_Value_   NUMBER;
    Net_0030_Factor_ NUMBER;
    Net_0030_Value_  NUMBER;
    Period_0030_     VARCHAR2(200);
    -- periodicaly
    Base_Rec_ Hrp_Abs_Calc_Base_Tab%ROWTYPE;
    Abs_Rec_  Absence_Registration_Tab%ROWTYPE;
    --
    Pay_Exists_ BOOLEAN;
    W3pu_       NUMBER;
    W3p1_       NUMBER;
    CURSOR Get_Payment(c_Emp_No_ VARCHAR2) IS
      SELECT c.Avg_Rate
        FROM Absence_Period_Cal_Overview c
       WHERE c.Company_Id = c_Company_Id
         AND c.Emp_No = c_Emp_No_
         AND c.Date_From >= Trunc(Add_Months(Trunc(c_Period_Calc, 'MONTH'), -3), 'MONTH')
         AND c.Date_From < Trunc(c_Period_Calc, 'MONTH')
         AND Absence_Registration_Api.Get_Absence_Type_Id(c.Company_Id, c.Emp_No, c.Absence_Id) IN
             ('C-11', 'C-12', 'C-13', 'C-15', 'C-16', 'C-17', 'C-21', 'C-31', 'C-32', 'C-33', 'C-34',
              'C-41', 'C42', 'C-43', 'C-44', 'U-51', 'U-52', 'U-53', 'U-54', 'U-55', 'U-56', 'U-57',
              'U-58')
       ORDER BY c.Date_From DESC;
    Rec_Pay_ Get_Payment%ROWTYPE;
    CURSOR Check_Period(c_Emp_No_ VARCHAR2) IS
      SELECT 1
        FROM Hrp_Wc_Archive_Tab t
       WHERE t.Company_Id = c_Company_Id
         AND t.Emp_No = c_Emp_No_
         AND t.Accounting_Year = To_Number(To_Char(Current_Month_, 'YYYY'))
         AND t.Accounting_Month = To_Number(To_Char(Current_Month_, 'MM'));
    Rec_Period_ Check_Period%ROWTYPE;
  BEGIN
    -- clear
    OPEN c_Employee_Company_;
    LOOP
      FETCH c_Employee_Company_
        INTO Emp_Company_Rec_;
      EXIT WHEN c_Employee_Company_%NOTFOUND;
      --
      Date_Of_Employment_ := Emp_Employed_Time_Api.Get_Date_Of_Employment(Emp_Company_Rec_.Company,
                                                                          Emp_Company_Rec_.Employee_Id,
                                                                          c_Period_Calc);
      -- perform employee matrix
      FOR i_ IN 1 .. c_Ground_Months_ LOOP
        Current_Month_ := Add_Months(c_Period_Calc, i_ * -1);
        IF Date_Of_Employment_ > Trunc(Current_Month_, 'MONTH') THEN
          EXIT;
        ELSE
          -- check
          OPEN Check_Period(Emp_Company_Rec_.Employee_Id);
          FETCH Check_Period
            INTO Rec_Period_;
          IF Check_Period%NOTFOUND THEN
            CLOSE Check_Period;
            Continue;
          END IF;
          CLOSE Check_Period;
          -- get payment
          Pay_Exists_ := FALSE;
          IF i_ = 1 THEN
            OPEN Get_Payment(Emp_Company_Rec_.Employee_Id);
            FETCH Get_Payment
              INTO Rec_Pay_;
            IF Get_Payment%FOUND THEN
              Pay_Exists_ := TRUE;
            END IF;
            CLOSE Get_Payment;
          END IF;
          --
          IF Pay_Exists_ THEN
            W3pu_ := 1;
            W3p1_ := Rec_Pay_.Avg_Rate * 30;
          ELSE
            W3pu_ := 0;
            W3p1_ := 0;
          END IF;
          --
          Hrp_Abs_Calc_Month_Api.Calculate_Days_And_Hours(Emp_Company_Rec_.Company,
                                                          Emp_Company_Rec_.Employee_Id, c_Abs_Type_,
                                                          Trunc(Current_Month_, 'MONTH'),
                                                          Last_Day(Current_Month_), Working_Days_,
                                                          Norma_Working_Days_, Working_Hours_,
                                                          Norma_Working_Hours_);
          -- holi hours
          Working_Hours_Holi_ := Hrp_Abs_Calc_Month_Api.s_Work_Hours(Emp_Company_Rec_.Company,
                                                                     Emp_Company_Rec_.Employee_Id,
                                                                     c_Abs_Type_Holi_,
                                                                     Trunc(Current_Month_, 'MONTH'),
                                                                     Last_Day(Current_Month_));
          -- clear cache array
          Zpk_Nf_Tab_.Delete;
          Wc_Value_   := 0;
          Net_Factor_ := 0;
          --
          Zpk_Mig_Abs_Calc_Base_Api .Insert_Wage_Codes_Adv1(Wc_Value_, Net_Factor_,
                                                            Emp_Company_Rec_.Company,
                                                            Emp_Company_Rec_.Employee_Id,
                                                            Trunc(Current_Month_, 'MONTH'),
                                                            'POD_CH_ST',
                                                            --constant_wc_group_,
                                                            'CONSTANT', 5, Zpk_Nf_Tab_, 'POD_CH_SKL',
                                                            -- contribution_wc_group_,
                                                            'POD_CH_POD'
                                                            --base_wc_group_,
                                                            );
          --
          Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_Adv1(Wc_Value_, Net_Factor_,
                                                           Emp_Company_Rec_.Company,
                                                           Emp_Company_Rec_.Employee_Id,
                                                           Trunc(Current_Month_, 'MONTH'),
                                                           'POD_CH_ZM_NU',
                                                           --constant_wc_group_,
                                                           'NOTUPDATED', 5, Zpk_Nf_Tab_,
                                                           'POD_CH_SKL',
                                                           -- contribution_wc_group_,
                                                           'POD_CH_POD'
                                                           --base_wc_group_,
                                                           );
          --
          Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_Adv1(Wc_Value_, Net_Factor_,
                                                           Emp_Company_Rec_.Company,
                                                           Emp_Company_Rec_.Employee_Id,
                                                           Trunc(Current_Month_, 'MONTH'), NULL,
                                                           --constant_wc_group_,
                                                           'BASEEXCLUDED', 5, Zpk_Nf_Tab_,
                                                           'POD_CH_SKL',
                                                           -- contribution_wc_group_,
                                                           'POD_CH_POD'
                                                           --base_wc_group_,
                                                           );
          -- yearly
          -- clear cache array
          Wc_0030_Value_   := 0;
          Net_0030_Factor_ := 0;
          Period_0030_     := NULL;
          --
          Zpk_Mig_Abs_Calc_Base_Api.Zpk_Insert_Wage_Codes_4_6(Wc_0030_Value_, Net_0030_Factor_,
                                                              Period_0030_, Emp_Company_Rec_.Company,
                                                              Emp_Company_Rec_.Employee_Id,
                                                              Trunc(Current_Month_, 'MONTH'),
                                                              Trunc(Current_Month_, 'MONTH'),
                                                              Wc_Group_ => 'POD_CH_R',
                                                              Paid_Way_ => 'TAX',
                                                              Wc_Type_ => 'CONSTANT',
                                                              Calc_Type_ => 'YEARLY',
                                                              Gr_Contribution_ => 'POD_CH_SKL',
                                                              Gr_Base_ => 'POD_CH_POD');
          -- if not found skip collecting
          IF Wc_Value_ = 0
             AND Wc_0030_Value_ = 0 THEN
            Continue;
          END IF;
          --
          Net_Value_ := Wc_Value_ + Wc_Value_ * Net_Factor_;
          --
          Wa_.Tbase_.Mandt  := c_Mandt;
          Wa_.Tbase_.Pernr  := Emp_Company_Rec_.Employee_Id;
          Wa_.Tbase_.Period := To_Char(Current_Month_, 'YYYYMM');
          Wa_.Tbase_.H855   := My_Number___(Norma_Working_Hours_);
          Wa_.Tbase_.H853   := My_Number___(Working_Hours_Holi_);
          Wa_.Tbase_.H850   := My_Number___(Working_Hours_);
          Wa_.Tbase_.W232b  := My_Number___(Wc_Value_);
          Wa_.Tbase_.W232n  := My_Number___(Round(Net_Value_, 2));
          Wa_.Tbase_.W3pu   := My_Number___(Round(W3pu_, 2));
          Wa_.Tbase_.W3p1   := My_Number___(Round(W3p1_, 2));
          -- yearly
          Net_0030_Value_   := Wc_0030_Value_ + Wc_0030_Value_ * Net_0030_Factor_;
          Wa_.Tbase_.W0030b := My_Number___(Wc_0030_Value_);
          IF Period_0030_ IS NOT NULL THEN
            Period_0030_ := Substr(Period_0030_, 1, 4) || '01';
          END IF;
          Wa_.Tbase_.W0030r := My_Number___(To_Number(Period_0030_) / 100);
          Wa_.Tbase_.W0030a := My_Number___(Round(Net_0030_Value_, 2));
          --
          It_(Nvl(It_.Last, 0) + 1) := Wa_;
        END IF;
        IF c_Emp_No != '%' THEN
          Dbms_Output.Put_Line('Period: ' || To_Char(Current_Month_, 'YYYY-MM-DD') || ' working ' ||
                               Working_Hours_ || '/' || Norma_Working_Hours_ || ' base ' ||
                               Wc_Value_ || ' net ' || Net_Factor_);
          IF Nvl(Net_0030_Value_, 0) <> 0 THEN
            Dbms_Output.Put_Line('Yearly bonuses: ' || To_Char(Wa_.Tbase_.W0030b) || ' netting ' ||
                                 Net_0030_Factor_ || ' period ' || Wa_.Tbase_.W0030r);
          END IF;
        END IF;
      END LOOP;
      -- perform last rec for each employee
      -- not clear logic
      -- add_rec_(emp_company_rec_.employee_id, null, o_rec_);
    END LOOP;
    CLOSE c_Employee_Company_;
    --
    Zpk_Sap_Exp_Dic_Api .Store___(It_);
    --
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Dbms_Output.Put_Line('Last rec_: ' || ' Pernr ' || Wa_.Tbase_.Pernr || ' Period ' ||
                           Wa_.Tbase_.Period);
      Log_Err(SQLERRM, Dbms_Utility.Format_Error_Backtrace, NULL, NULL);
      Raise_Application_Error(-20001, 'detailed issue');
  END Get_Base;
  FUNCTION Get_Emp_First_Employement(Emp_No_ VARCHAR2) RETURN DATE IS
    Date_ DATE;
  BEGIN
    SELECT MIN(p.Date_Of_Employment)
      INTO Date_
      FROM Emp_Employed_Time_Tab p
     WHERE p.Company_Id = c_Company_Id
       AND p.Emp_No = Emp_No_;
    --
    RETURN Date_;
  END Get_Emp_First_Employement;
  --
  --
  FUNCTION Get_Emp_Last_Employement(Emp_No_ VARCHAR2) RETURN DATE IS
    Date_ DATE;
  BEGIN
    SELECT MAX(p.Date_Of_Employment)
      INTO Date_
      FROM Emp_Employed_Time_Tab p
     WHERE p.Company_Id = c_Company_Id
       AND p.Emp_No = Emp_No_;
    --
    RETURN Emp_Employed_Time_Api.Get_Date_Of_Employment(c_Company_Id, Emp_No_, Date_);
    --
  END Get_Emp_Last_Employement;
  --
  FUNCTION Get_Emp_Last_Termination(Emp_No_ VARCHAR2) RETURN DATE IS
    Date_ DATE;
  BEGIN
    SELECT MAX(p.Date_Of_Leaving)
      INTO Date_
      FROM Emp_Employed_Time_Tab p
     WHERE p.Company_Id = c_Company_Id
       AND p.Emp_No = Emp_No_;
    --
    RETURN Date_;
  END Get_Emp_Last_Termination;
  --
  FUNCTION Get_Emp_Continuation_Mode(Emp_No_ VARCHAR2, Account_Date_ DATE) RETURN VARCHAR2 IS
    -- fill logic in term of:
    -- *  finall terminiation
    -- ** not decision of employement continuation
  BEGIN
    IF Emp_Employed_Time_Api.Get_Employment_Name(c_Company_Id, Emp_No_, Account_Date_) IN
       ('UOP', 'UCO') THEN
      IF Account_Date_ <= SYSDATE - 90 THEN
        RETURN 'OBSOLETED'; -- obsoleted
      ELSIF Account_Date_ >= Trunc(SYSDATE, 'MONTH') THEN
        RETURN 'FUTURE'; -- future
      ELSIF Emp_Employed_Time_Api.Get_Leaving_Name(c_Company_Id, Emp_No_, Account_Date_) IS NULL THEN
        RETURN 'HOLD'; -- exists leaving reason, we predict that employee is finally terminated
      END IF;
    END IF;
    RETURN 'FINALLY';
  END Get_Emp_Continuation_Mode;
  FUNCTION Get_Emp_Matrix(Emp_No_ IN VARCHAR2, Infotype_ IN VARCHAR2)
    RETURN Zpk_Emp_No_Provide_Api.Emp_Ttab_ IS
    --
    Str_Itab_          Zpk_Emp_No_Provide_Api.Str_Ttab_;
    Emp_Itab_          Zpk_Emp_No_Provide_Api.Emp_Ttab_;
    Provide_Date_From_ DATE := Get_Emp_First_Employement(Emp_No_);
    Provide_Date_To_   DATE := Get_Emp_Last_Termination(Emp_No_);
    Error_Cnt_         NUMBER;
    i_                 NUMBER;
    j_                 NUMBER;
    CURSOR Get_Abs_ IS
      SELECT a.Absence_Id, a.Date_From, a.Date_To
        FROM Absence_Registration_Tab a
       WHERE a.Company_Id = c_Company_Id
         AND a.Emp_No = Emp_No_
         AND a.Absence_Type_Id IN
             ('U-58', 'U-57', 'U-56', 'U-55', 'U-54', 'U-53', 'U-52', 'U-51', 'U-41')
         AND a.Rowstate NOT IN ('CalculationCancelled', 'Cancelled')
       ORDER BY a.Date_From;
  BEGIN
    Str_Itab_.Delete;
    Emp_Itab_.Delete;
    --
    Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'EmpEmployedTime');
    Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                          'EmpEmployedTime', 'EmpEmployedTime',
                                          'EMP_EMPLOYED_TIME_TAB', Provide_Date_From_,
                                          Provide_Date_To_, 'DATE_OF_EMPLOYMENT', 'DATE_OF_LEAVING');
    IF (Infotype_ IN ('0001', '0007')) THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'CompanyPersAssign');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'CompanyPersAssign', 'CompanyPersAssign',
                                            'COMPANY_PERS_ASSIGN_TAB', Provide_Date_From_,
                                            Provide_Date_To_, 'VALID_FROM', 'VALID_TO');
      -- clear not primary
      i_ := Emp_Itab_.First;
      WHILE (i_ IS NOT NULL) LOOP
        IF Emp_Itab_(i_).Set_Name = 'CompanyPersAssign'
            AND Emp_Itab_(i_).S4 = '0' THEN
          Emp_Itab_.Delete(i_);
        END IF;
        i_ := Emp_Itab_.Next(i_);
      END LOOP;
    END IF;
    --
    IF (Infotype_ = '0001') THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'EmpConType');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'EmpConType', 'EmpConType', 'EMP_CON_TYPE_TAB',
                                            Provide_Date_From_, Provide_Date_To_, 'VALID_FROM',
                                            'VALID_TO');
    ELSIF (Infotype_ = '0007') THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'WorkSchedAssign');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'WorkSchedAssign', 'WorkSchedAssign',
                                            'WORK_SCHED_ASSIGN_TAB', Provide_Date_From_,
                                            Provide_Date_To_, 'VALID_FROM', 'VALID_TO');
    ELSIF (Infotype_ = '0008') THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'EmployeeSalary');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'EmployeeSalary', 'EmployeeSalary',
                                            'EMPLOYEE_SALARY_TAB', Provide_Date_From_,
                                            Provide_Date_To_, 'VALID_FROM', 'VALID_TO');
    ELSIF (Infotype_ = '0413') THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'ZpkPersTaxOff');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'ZpkPersTaxOff', 'ZpkPersTaxOff', 'ZPK_PERS_TAX_OFF',
                                            Provide_Date_From_, Provide_Date_To_, 'VALID_FROM',
                                            'VALID_TO');
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'RegConstData');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_,
                                            'RegConstData', 'RegConstData', 'REG_CONST_DATA_TAB',
                                            Provide_Date_From_, Provide_Date_To_, 'DATE_FROM',
                                            'DATE_TO');
      -- clear unnecesary information
      j_ := Emp_Itab_.First;
      WHILE (j_ IS NOT NULL) LOOP
        IF Emp_Itab_(j_).Set_Name = 'RegConstData' --
            AND Emp_Itab_(j_).S3 IN (g_Param_Costr_) THEN
          Emp_Itab_(j_).Set_Name := 'RegConstDataCostr'; --56040P
        ELSIF Emp_Itab_(j_).Set_Name = 'RegConstData' --
               AND Emp_Itab_(j_).S3 IN (g_Param_Contr_) THEN
          Emp_Itab_(j_).Set_Name := 'RegConstDataContr'; --56030
        ELSIF Emp_Itab_(j_).Set_Name = 'RegConstData' --
               AND Emp_Itab_(j_).S3 IN (g_Param_Dnind_) THEN
          Emp_Itab_(j_).Set_Name := 'RegConstDataDnind'; -- 56020
        ELSIF Emp_Itab_(j_).Set_Name = 'RegConstData' THEN
          Emp_Itab_.Delete(j_);
        END IF;
        j_ := Emp_Itab_.Next(j_);
      END LOOP;
    ELSIF (Infotype_ = '0515') THEN
      Zpk_Emp_No_Provide_Api.Init_Structure(Str_Itab_, 'SsiData');
      Zpk_Emp_No_Provide_Api.Fill_Array_Emp(Emp_Itab_, Str_Itab_, c_Company_Id, Emp_No_, 'SsiData',
                                            'SsiData', 'SSI_DATA_TAB', Provide_Date_From_,
                                            Provide_Date_To_, 'DATE_FROM', 'INSUR_WITHDRAW_DATE');
      FOR Rec_ IN Get_Abs_ LOOP
        i_ := Nvl(Emp_Itab_.Last, 0) + 1;
        Emp_Itab_(i_).Set_Name := 'AbsCalendarPeriod';
        Emp_Itab_(i_).Date_From := Rec_.Date_From;
        Emp_Itab_(i_).Date_To := Rec_.Date_To;
        Emp_Itab_(i_).N1 := 0;
      END LOOP;
      --
      -- clear ssi endda not to overrlapping
      i_ := Emp_Itab_.First;
      WHILE (i_ IS NOT NULL) LOOP
        IF Emp_Itab_(i_).Set_Name = 'SsiData' THEN
          Emp_Itab_(i_).Date_To := Emp_Itab_(i_).Date_From;
        END IF;
        i_ := Emp_Itab_.Next(i_);
      END LOOP;
    END IF;
    -- marge sort array
    Zpk_Emp_No_Provide_Api.Marge_Array(Emp_Itab_);
    Zpk_Emp_No_Provide_Api.Sort_Array(Emp_Itab_);
    -- check overllaping thrashes
    -- to do add valid_to < valid_from
    i_ := Emp_Itab_.First;
    WHILE (i_ IS NOT NULL) LOOP
      j_ := Emp_Itab_.First;
      WHILE (j_ IS NOT NULL) LOOP
        /*        dbms_output.put_line(emp_itab_(i_)
                                     .set_name || 'X' ||
                                      to_char(emp_itab_(i_).date_from, 'YYYYMMDD') || 'X' ||
                                      to_char(emp_itab_(j_).date_from, 'YYYYMMDD') || 'X' ||
                                      to_char(emp_itab_(j_).date_to, 'YYYYMMDD'));
        */
        IF (Emp_Itab_(i_).Set_Name = Emp_Itab_(j_).Set_Name AND --
           Emp_Itab_(i_).Date_From BETWEEN --
           Emp_Itab_(j_).Date_From AND Emp_Itab_(j_).Date_To AND --
            i_ != j_) THEN
          Add_Error___(Emp_No_, 'MatrixDataOverllpaing', 10,
                       'Date overlapping for set ' || --
                        Emp_Itab_(i_).Set_Name || ' and pair ' || To_Char(Emp_Itab_(i_).Date_From) ||
                        ' and ' || To_Char(Emp_Itab_(j_).Date_From) || ' - ' ||
                        To_Char(Emp_Itab_(j_).Date_To));
        END IF;
        j_ := Emp_Itab_.Next(j_);
      END LOOP;
      i_ := Emp_Itab_.Next(i_);
    END LOOP;
    -- do the rest
    Zpk_Emp_No_Provide_Api.Check_Gap_Exists(Error_Cnt_,
                                            -- todo variable to log
                                            Emp_Itab_, Get_Emp_First_Employement(Emp_No_),
                                            Get_Emp_Last_Termination(Emp_No_), NULL,
                                            Raise_Error_ => FALSE, Init_ => TRUE, Clear_ => TRUE);
    --
    RETURN Emp_Itab_;
  END Get_Emp_Matrix;
  PROCEDURE Dump_Table_To_Csv(File_Name_ IN VARCHAR2, Col_Max_ NUMBER DEFAULT 99) IS
    l_Output      Utl_File.File_Type;
    l_Thecursor   INTEGER DEFAULT Dbms_Sql.Open_Cursor;
    l_Columnvalue VARCHAR2(4000);
    l_Status      INTEGER;
    l_Colcnt      NUMBER := 0;
    l_Separator   VARCHAR2(1);
    l_Desctbl     Dbms_Sql.Desc_Tab;
    Query_        VARCHAR2(2000);
  BEGIN
    Query_ := 'SELECT * FROM IC_XX_IMPORT_TAB T WHERE Session_Id = ' || Userenv('SESSIONID') ||
              ' ORDER BY S' || To_Char(Nvl(Col_Max_, 99));
    Query_ := REPLACE(Query_, 'ORDER BY S ', 'ORDER BY S');
    --
    l_Output := Utl_File.Fopen(c_Dir, File_Name_, 'w');
    Dbms_Sql.Parse(l_Thecursor, Query_, Dbms_Sql.Native);
    Dbms_Sql.Describe_Columns(l_Thecursor, l_Colcnt, l_Desctbl);
    FOR i IN 1 .. l_Colcnt LOOP
      Utl_File.Put(l_Output, l_Separator || '"' || l_Desctbl(i).Col_Name || '"');
      Dbms_Sql.Define_Column(l_Thecursor, i, l_Columnvalue, 4000);
      l_Separator := ';';
      -- max limit
      IF i >= Col_Max_ THEN
        EXIT;
      END IF;
    END LOOP;
    Utl_File.New_Line(l_Output);
    l_Status := Dbms_Sql.Execute(l_Thecursor);
    WHILE (Dbms_Sql.Fetch_Rows(l_Thecursor) > 0) LOOP
      l_Separator := '';
      FOR i IN 1 .. l_Colcnt LOOP
        Dbms_Sql.Column_Value(l_Thecursor, i, l_Columnvalue);
        Utl_File.Put(l_Output, l_Separator || REPLACE(l_Columnvalue, Chr(13) || Chr(10), ' '));
        l_Separator := ';';
        -- max limit
        IF i >= Col_Max_ THEN
          EXIT;
        END IF;
      END LOOP;
      Utl_File.New_Line(l_Output);
    END LOOP;
    Dbms_Sql.Close_Cursor(l_Thecursor);
    Utl_File.Fclose(l_Output);
    --execute immediate 'alter session set nls_date_format=''dd-MON-yy'' ';
    COMMIT; -- to releas locks
  EXCEPTION
    WHEN OTHERS THEN
      IF Dbms_Sql.Is_Open(l_Thecursor) THEN
        Dbms_Sql.Close_Cursor(l_Thecursor);
      END IF;
      IF Utl_File.Is_Open(l_Output) THEN
        Utl_File.Fclose(l_Output);
      END IF;
      Dbms_Output.Put_Line(Substr(SQLERRM, 1, 200));
      --execute immediate 'alter session set nls_date_format=''dd-MON-yy'' ';
      RAISE;
  END Dump_Table_To_Csv;
  --
  FUNCTION Get_Mapping(Typ_         IN VARCHAR2,
                       Value_       IN VARCHAR2,
                       Err_         IN BOOLEAN DEFAULT TRUE,
                       Mapping_Set_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    New_Value_ Intface_Conv_List_Cols_Tab.New_Value%TYPE;
    Old_Value_ Intface_Conv_List_Cols_Tab.Old_Value%TYPE;
    Group_     VARCHAR2(20);
    Temp_      VARCHAR2(200);
    Sep_       VARCHAR2(2) := '$$';
  BEGIN
    IF Mapping_Set_ IS NULL THEN
      Group_ := c_Conv_Group_Out_;
    ELSE
      Group_ := Mapping_Set_;
    END IF;
    Old_Value_ := Lpad(c_Company_Id, 4, '0') || '^' || Typ_ || '^' || Value_;
    IF Value_ IS NOT NULL THEN
      New_Value_ := Intface_Conv_List_Cols_Api.Get_New_Value(Group_, Old_Value_);
      IF New_Value_ IS NOT NULL THEN
        IF Instr(New_Value_, Sep_) > 0
           AND New_Value_ IS NOT NULL THEN
          New_Value_ := Substr(New_Value_, 1, Instr(New_Value_, Sep_) - 1);
        END IF;
        RETURN New_Value_;
      ELSE
        Old_Value_ := '****' || '^' || Typ_ || '^' || Value_;
        New_Value_ := Intface_Conv_List_Cols_Api.Get_New_Value(Group_, Old_Value_);
        IF Instr(New_Value_, Sep_) > 0
           AND New_Value_ IS NOT NULL THEN
          New_Value_ := Substr(New_Value_, 1, Instr(New_Value_, Sep_) - 1);
        END IF;
        --
        IF New_Value_ IS NOT NULL THEN
          RETURN New_Value_;
        ELSE
          IF Err_ THEN
            Raise_Application_Error(-20001,
                                    'There is no convertion in ' || Group_ || ' for ' || Old_Value_);
          ELSE
            Dbms_Output.Put_Line('Mapping for ' || Group_ || ' has not been found for: ' || Value_);
            --
            CASE Typ_
              WHEN m_Werks_Id THEN
                Temp_      := Substr(Value_, 1, 4);
                Old_Value_ := Lpad(c_Company_Id, 4, '0') || '^' || Typ_ || '^' || Value_;
              WHEN m_Btrtl_Id THEN
                Temp_      := Substr(Value_, 1, 4);
                Old_Value_ := Lpad(c_Company_Id, 4, '0') || '^' || Typ_ || '^' || Value_;
              WHEN m_Country_Iso_Id THEN
                Temp_ := Value_;
              WHEN m_Param_Id THEN
                Temp_ := '?' || Sep_ || Wage_Code_Param_Api.Get_Param_Name(c_Company_Id, Value_);
              WHEN m_Wagecode_Type THEN
                Temp_ := '?' || Sep_ || Hrp_Wage_Code_Api.Get_Name(c_Company_Id, Value_);
                --
                FOR Rec_ IN (SELECT MAX(t.Tax_Year * 100 + t.Tax_Month) Taxed_
                               FROM Hrp_Wc_Archive_Tax t
                              WHERE t.Company_Id = c_Company_Id
                                AND t.Wage_Code_Id = Value_) LOOP
                  Temp_ := Temp_ || '(' || c_Company_Id || ')' || ' - ' || Rec_.Taxed_;
                END LOOP;
              ELSE
                Temp_ := '?';
            END CASE;
            --
            INSERT INTO Intface_Conv_List_Cols_Tab
              (Conv_List_Id, Old_Value, New_Value, Rowversion)
            VALUES
              (Group_, Old_Value_, Temp_, SYSDATE);
            --
            RETURN '?';
          END IF;
        END IF;
      END IF;
    ELSE
      RETURN NULL;
    END IF;
  END Get_Mapping;
  PROCEDURE Init IS
  BEGIN
    Errortab.Delete;
  END Init;
BEGIN
  Init;
EXCEPTION
  WHEN OTHERS THEN
    Dbms_Output.Put_Line(Dbms_Utility.Format_Error_Backtrace);
END Zpk_Sap_Exp;
/
set define on
