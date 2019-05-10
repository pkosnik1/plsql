set define off
CREATE OR REPLACE PACKAGE IFSAPP.ZPK_MIG_ABS_CALC_BASE_API IS
  Module_  CONSTANT VARCHAR2(25) := 'PAYROL';
  Lu_Name_ CONSTANT VARCHAR2(25) := 'ZpkMigAbsCalcBase';
  Lu_Type_ CONSTANT VARCHAR2(6) := 'Entity';
  TYPE Public_Rec IS RECORD(
    Entry_Date              Hrp_Abs_Calc_Base_Tab.Entry_Date%TYPE,
    Average_Rate            Hrp_Abs_Calc_Base_Tab.Average_Rate%TYPE,
    Copied_From_Abs_Id      Hrp_Abs_Calc_Base_Tab.Copied_From_Abs_Id%TYPE,
    Payroll_List_Id         Hrp_Abs_Calc_Base_Tab.Payroll_List_Id%TYPE,
    Corected                Hrp_Abs_Calc_Base_Tab.Corected%TYPE,
    Avg_Rate_Corection      Hrp_Abs_Calc_Base_Tab.Avg_Rate_Corection%TYPE,
    Alternative_Wc          Hrp_Abs_Calc_Base_Tab.Alternative_Wc%TYPE,
    Min_Remuneration        Hrp_Abs_Calc_Base_Tab.Min_Remuneration%TYPE,
    Valorization_Rate       Hrp_Abs_Calc_Base_Tab.Valorization_Rate%TYPE,
    Base_After_Valorization Hrp_Abs_Calc_Base_Tab.Base_After_Valorization%TYPE,
    Pl_Period_Type          Hrp_Abs_Calc_Base_Tab.Pl_Period_Type%TYPE,
    Abs_Calc_Base_Type_Id   Hrp_Abs_Calc_Base_Tab.Abs_Calc_Base_Type_Id%TYPE);
  TYPE t_Log_Row IS RECORD(
    Log_Id   NUMBER,
    Log_Type VARCHAR2(200),
    S1       VARCHAR2(200),
    S2       VARCHAR2(200),
    S3       VARCHAR2(200),
    S4       VARCHAR2(200),
    N1       NUMBER,
    N2       NUMBER,
    N3       NUMBER,
    N4       NUMBER,
    D1       DATE,
    D2       DATE,
    D3       DATE,
    D4       DATE);
  TYPE t_Log_Tab IS TABLE OF t_Log_Row;
  TYPE t_Net_Factor_Details IS RECORD(
    VALUE        Hrp_Wc_Archive_Det_Tab.Value%TYPE,
    Origin_Value Hrp_Wc_Archive_Det_Tab.Value%TYPE,
    Tax_Year     Hrp_Wc_Archive_Det_Tab.Tax_Year%TYPE,
    Tax_Month    Hrp_Wc_Archive_Det_Tab.Tax_Month%TYPE,
    --payroll_list_id hrp_wc_archive_det_tab.payroll_list_id%type,
    Contribution NUMBER,
    Base         NUMBER,
    Current_List BOOLEAN);
  TYPE t_Net_Factor_Details_Tab IS TABLE OF t_Net_Factor_Details INDEX BY BINARY_INTEGER;
  TYPE t_Net_Factor IS RECORD(
    Calc_Type           VARCHAR2(20),
    Wc_Group            VARCHAR2(20),
    Period_Seq          NUMBER,
    Date_From           DATE,
    Date_To             DATE,
    Wage_Code_Id        Hrp_Wc_Archive_Tab.Wage_Code_Id%TYPE,
    Summarised_Value    Hrp_Wc_Archive_Tab.Summarised_Value%TYPE,
    Accurate_Net_Factor NUMBER,
    Gr_Net_Factor       NUMBER,
    Details             t_Net_Factor_Details_Tab);
  TYPE t_Net_Factor_Tab IS TABLE OF t_Net_Factor INDEX BY BINARY_INTEGER;
  Gl_Log_Mode_ VARCHAR2(20) := 'NOTACTIVE';
  Gl_Warrning_01_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_BASE_DIFF';
  Gl_Warrning_02_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_BASE_OTHER';
  Gl_Warrning_03_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_NET_FACT_MAX';
  Gl_Warrning_04_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_NET_FACT_MIN';
  Gl_Warrning_05_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_NET_FACT_ACC';
  Gl_Warrning_06_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_NET_FACT_NVL';
  Gl_Warrning_07_ CONSTANT VARCHAR2(20) := 'ZPK_ABS_REST';
  -----------------------------------------------------------------------------
  -------------------- PRIVATE BASE METHODS -----------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- PUBLIC BASE METHODS ------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PROTECTED METHODS --------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
  -----------------------------------------------------------------------------
  PROCEDURE Zpk_Set_Pipe_Log(Log_Mode_   IN VARCHAR2 DEFAULT NULL,
                             Company_Id_ IN VARCHAR DEFAULT NULL);
  PROCEDURE Zpk_Get_Pipe_Log(Out_Log_Mode_ OUT VARCHAR2);
  PROCEDURE Insert_Wage_Codes_4_6(Base_Rec_                IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                                  Period_Seq_              IN NUMBER,
                                  Payroll_Rec_             IN Hrp_Pay_List_Api.Public_Rec,
                                  Payroll_List_Id_         IN VARCHAR2,
                                  Wc_Group_                IN VARCHAR2,
                                  Graced_Period_Date_From_ IN DATE,
                                  Bonus_Date_              IN DATE,
                                  Paid_Way_                IN VARCHAR2,
                                  Wc_Type_                 IN VARCHAR2,
                                  Calc_Type_               IN VARCHAR2,
                                  Wage_Code_Elements_Tab_  IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                  Zpk_Log_Tab_             IN OUT t_Log_Tab,
                                  Gr_Contribution_         IN VARCHAR2,
                                  Gr_Base_                 IN VARCHAR2,
                                  Period_Type_             IN VARCHAR2 DEFAULT 'TRANSACTION',
                                  Include_Payroll_Values_  IN VARCHAR2 DEFAULT 'FALSE');
  PROCEDURE Zpk_Insert_Wage_Codes_4_6(Wc_Value_     IN OUT NUMBER,
                                      Net_Factor_   OUT NUMBER,
                                      For_Period_   IN OUT VARCHAR2,
                                      Company_Id_   IN VARCHAR2,
                                      Emp_No_       IN VARCHAR2,
                                      Account_Date_ IN DATE,
                                      Paid_To_      IN DATE,
                                      --Base_Rec_                IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                                      --Period_Seq_              IN NUMBER,
                                      --Payroll_Rec_             IN Hrp_Pay_List_Api.Public_Rec,
                                      --Payroll_List_Id_         IN VARCHAR2,
                                      Wc_Group_  IN VARCHAR2,
                                      Paid_Way_  IN VARCHAR2,
                                      Wc_Type_   IN VARCHAR2,
                                      Calc_Type_ IN VARCHAR2,
                                      --Wage_Code_Elements_Tab_  IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                      --Zpk_Log_Tab_             IN OUT t_Log_Tab,
                                      Gr_Contribution_        IN VARCHAR2,
                                      Gr_Base_                IN VARCHAR2,
                                      Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                                      Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE');
  PROCEDURE Insert_Wage_Codes_Adv1( --base_rec_               IN hrp_abs_calc_base_tab%ROWTYPE,
                                   Wc_Value_        IN OUT NUMBER,
                                   Net_Factor_      OUT NUMBER,
                                   Company_Id_      IN VARCHAR2,
                                   Emp_No_          IN VARCHAR2,
                                   Account_Date_    IN DATE,
                                   Wc_Group_        IN VARCHAR2,
                                   Wc_Type_         IN VARCHAR2,
                                   Trans_Type_      IN NUMBER,
                                   Zpk_Nf_Tab_      IN OUT NOCOPY t_Net_Factor_Tab,
                                   Gr_Contribution_ IN VARCHAR2 DEFAULT NULL,
                                   Gr_Base_         IN VARCHAR2 DEFAULT NULL);
  PROCEDURE Classify_Year(Wc_Value_              IN OUT NUMBER,
                          Net_Factor_            OUT NUMBER,
                          Base_Rec_              IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                          Abs_Rec_               IN Absence_Registration_Tab%ROWTYPE,
                          Wc_Group_              IN VARCHAR2,
                          Base_Wc_Group_         IN VARCHAR2,
                          Contribution_Wc_Group_ IN VARCHAR2,
                          Payroll_List_Id_       IN VARCHAR2,
                          Payroll_Rec_           IN Hrp_Pay_List_Api.Public_Rec,
                          Calendar_Type_Id_      IN VARCHAR2,
                          Wc_Type_               IN VARCHAR2,
                          Bonus_Date_            IN DATE,
                          Paid_Way_              IN VARCHAR2,
                          Graced_Back_           IN NUMBER,
                          Ground_Months_         IN NUMBER,
                          --Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                          --Zpk_Log_Tab_            IN OUT t_Log_Tab,
                          Round_Precision_        IN NUMBER DEFAULT 4,
                          Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                          Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE',
                          Count_One_Year_         IN BOOLEAN DEFAULT FALSE);
  FUNCTION Classify_4months(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                            Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                            Wc_Group_               IN VARCHAR2,
                            Base_Wc_Group_          IN VARCHAR2,
                            Contribution_Wc_Group_  IN VARCHAR2,
                            Payroll_List_Id_        IN VARCHAR2,
                            Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                            Calendar_Type_Id_       IN VARCHAR2,
                            Wc_Type_                IN VARCHAR2,
                            Paid_Way_               IN VARCHAR2,
                            Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                            Zpk_Log_Tab_            IN OUT t_Log_Tab,
                            Round_Precision_        IN NUMBER DEFAULT 4,
                            Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                            Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2;
  FUNCTION Classify_Quarter(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                            Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                            Wc_Group_               IN VARCHAR2,
                            Base_Wc_Group_          IN VARCHAR2,
                            Contribution_Wc_Group_  IN VARCHAR2,
                            Payroll_List_Id_        IN VARCHAR2,
                            Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                            Calendar_Type_Id_       IN VARCHAR2,
                            Wc_Type_                IN VARCHAR2,
                            Paid_Way_               IN VARCHAR2,
                            Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                            Zpk_Log_Tab_            IN OUT t_Log_Tab,
                            Round_Precision_        IN NUMBER DEFAULT 4,
                            Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                            Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2;
  FUNCTION Classify_Month(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                          Month_                  IN DATE,
                          Base_Wc_Group_          IN VARCHAR2,
                          Contribution_Wc_Group_  IN VARCHAR2,
                          Validation_Date_        IN DATE,
                          Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                          Payroll_List_Id_        IN VARCHAR2,
                          Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                          Zpk_Log_Tab_            IN OUT t_Log_Tab,
                          Round_Precision_        IN NUMBER DEFAULT 4,
                          Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2;
  FUNCTION Check_And_Copy_Base(Abs_Rec_               IN Absence_Registration_Tab%ROWTYPE,
                               Payroll_List_Id_       IN VARCHAR2,
                               Payroll_Rec_           IN Hrp_Pay_List_Api.Public_Rec,
                               No_Of_Months_          IN NUMBER,
                               Abs_Calc_Base_Type_Id_ IN VARCHAR2,
                               Constant_Wc_Group_     IN VARCHAR2,
                               Notupdated_Wc_Group_   IN VARCHAR2,
                               Updated_Wc_Group_      IN VARCHAR2,
                               Zpk_Log_Tab_           IN OUT t_Log_Tab) RETURN VARCHAR2;
  PROCEDURE Copy_Base(Base_Rec_        IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                      Abs_Rec_To_      IN Absence_Registration_Tab%ROWTYPE,
                      Payroll_List_Id_ IN VARCHAR2,
                      Payroll_Rec_     IN Hrp_Pay_List_Api.Public_Rec,
                      Wc_Group1_       IN VARCHAR2 DEFAULT NULL,
                      Wc_Group2_       IN VARCHAR2 DEFAULT NULL,
                      Wc_Group3_       IN VARCHAR2 DEFAULT NULL);
  FUNCTION Abs_Base1(Company_Id_             IN VARCHAR2,
                     Emp_No_                 IN VARCHAR2,
                     Payroll_List_Id_        IN VARCHAR2,
                     Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                     Parameters_             IN VARCHAR2,
                     Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                     Wage_Code_Id_           IN VARCHAR2,
                     Valid_Date_             IN DATE) RETURN NUMBER;
  FUNCTION Abs_Base2(Company_Id_             IN VARCHAR2,
                     Emp_No_                 IN VARCHAR2,
                     Payroll_List_Id_        IN VARCHAR2,
                     Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                     Parameters_             IN VARCHAR2,
                     Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                     Wage_Code_Id_           IN VARCHAR2,
                     Valid_Date_             IN DATE) RETURN NUMBER;
  -----------------------------------------------------------------------------
  -------------------- FOUNDATION1 METHODS ------------------------------------
  -----------------------------------------------------------------------------
  PROCEDURE Init;
END Zpk_Mig_Abs_Calc_Base_Api;
/
CREATE OR REPLACE PACKAGE BODY IFSAPP.ZPK_MIG_ABS_CALC_BASE_API IS

  --
  TYPE t_Baias_Wage_Code_Tab IS TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(20);
  Baias_Tab_ t_Baias_Wage_Code_Tab;
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC IMPLEMENTATION METHOD DECLARATIONS ---------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- IMPLEMENTATION BASE METHODS ----------------------------
  -----------------------------------------------------------------------------
  -- Lock_By_Id___
  --    Client-support to lock a specific instance of the logical unit.
  --
  -- Lock_By_Keys___
  --    Server support to lock a specific instance of the logical unit.
  --
  -- Get_Object_By_Id___
  --    Get LU-record from the database with a specified object identity.
  --
  -- Get_Object_By_Keys___
  --    Get LU-record from the database with specified key columns.
  --
  -- Check_Exist___
  --    Check if a specific LU-instance already exist in the database.
  --
  -- Get_Id_Version_By_Keys___
  --    Get the current OBJID and OBJVERSION for a specific LU-instance.
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
  -----------------------------------------------------------------------------
  PROCEDURE Zpk_Reconfigure_Log___(Log_Status_ IN VARCHAR2, Company_Id_ IN VARCHAR2) IS
    --
    Dummy_ VARCHAR2(1);
    --
    CURSOR Exist_Key IS
      SELECT 'X'
        FROM Hrp_Config_Det_Tab
       WHERE Company_Id = Company_Id_
         AND Config_Id = 'TECH'
         AND Seq_No = 1239;
  BEGIN
    --
    OPEN Exist_Key;
    FETCH Exist_Key
      INTO Dummy_;
    IF Exist_Key%NOTFOUND THEN
      CLOSE Exist_Key;
    ELSE
      UPDATE Hrp_Config_Det_Tab t
         SET t.Id          = Log_Status_,
             t.Description = REPLACE(t.Description, '<<DisableByParallelCalc>>'),
             t.Rowversion  = SYSDATE
       WHERE Company_Id = Company_Id_
         AND Config_Id = 'TECH'
         AND Seq_No = 1239;
      CLOSE Exist_Key;
    END IF;
  END Zpk_Reconfigure_Log___;
  PROCEDURE Zpk_Warrning_Add___(Company_Id_      IN VARCHAR2,
                                Emp_No_          IN VARCHAR2,
                                Payroll_List_Id_ IN VARCHAR2,
                                Warrning_Id_     IN VARCHAR2,
                                Wage_Code_Id_    IN VARCHAR2,
                                N01_             IN NUMBER DEFAULT NULL,
                                S01_             IN VARCHAR2 DEFAULT NULL) IS
    Dummy_         VARCHAR2(2000);
    Temp_Seq_      VARCHAR2(20);
    Warning_Text_  VARCHAR2(200);
    Prev_Avg_Rate_ NUMBER;
    Avg_Rate_      NUMBER;
    Ret_           NUMBER;
    -- 01
    Abs_Id_             NUMBER;
    Abs_Calc_Base_Type_ VARCHAR2(200);
    -- 02
    Months_Back_ NUMBER;
    -- 03
    Max_Value_ NUMBER;
    -- 04
    Min_Value_ NUMBER;
  BEGIN
    -- difference warning
    IF Warrning_Id_ = Gl_Warrning_01_ THEN
      Abs_Id_             := N01_;
      Abs_Calc_Base_Type_ := S01_;
      Prev_Avg_Rate_      := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_,
                                                                        Emp_No_, Abs_Id_, 'FALSE',
                                                                        Abs_Calc_Base_Type_);
      IF Temp_Seq_ > 1 THEN
        Temp_Seq_      := Temp_Seq_ - 1;
        Prev_Avg_Rate_ := Nvl(Hrp_Abs_Calc_Base_Api.Get_Average_Rate(Company_Id_, Emp_No_, Abs_Id_,
                                                                     Temp_Seq_), 0);
        IF (Abs(Prev_Avg_Rate_ - Avg_Rate_) / Avg_Rate_) > 0.02
           AND Nvl(Avg_Rate_, 0) <> 0 THEN
          IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                       Warrning_Id_) IS NULL THEN
            Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                             'DIFFTOPREV: Average rete difference after recalculation is greater then 2%, previous = :P1, current = :P2.',
                                                             NULL, Prev_Avg_Rate_, Avg_Rate_);
            Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                          Wage_Code_Id_, 1, '=', 1, Warrning_Id_,
                                                          Warning_Text_);
          END IF;
        END IF;
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_02_ THEN
      Months_Back_ := N01_;
      IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                   Warrning_Id_) IS NULL THEN
        Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                         'GRACETIME: Bonuses has been found in grace period. Ground months parameter has been set on :P1 .',
                                                         NULL, To_Char(Months_Back_, '00'));
        Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                      Wage_Code_Id_, 1, '=', 1, Gl_Warrning_02_,
                                                      Warning_Text_);
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_03_
          AND Nvl(N01_, 0) <> 0 THEN
      Max_Value_ := Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z003',
                                                                               SYSDATE),
                        (1371 / 1000));
      IF N01_ < ((-1) * Max_Value_) THEN
        IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                     Warrning_Id_) IS NULL THEN
          Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                           'GRACETIME: Netting factor is outside bounds <:P1,99999>.',
                                                           NULL, To_Char(Max_Value_, '00.9999'));
          Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                        Wage_Code_Id_, 1, '=', 1, Gl_Warrning_03_,
                                                        Warning_Text_);
        END IF;
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_04_
          AND Nvl(N01_, 0) <> 0 THEN
      Min_Value_ := Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z004',
                                                                               SYSDATE), (245 / 1000));
      IF N01_ > ((-1) * Min_Value_) THEN
        IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                     Warrning_Id_) IS NULL THEN
          Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                           'GRACETIME: Netting factor is outside bounds <0,:P1>.',
                                                           NULL, To_Char(Min_Value_, '00.9999'));
          Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                        Wage_Code_Id_, 1, '=', 1, Gl_Warrning_04_,
                                                        Warning_Text_);
        END IF;
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_05_ THEN
      IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                   Warrning_Id_) IS NULL THEN
        Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                         'ACCURATEWC: Calculated netting factor differ from original equal :P1.',
                                                         NULL, To_Char(N01_, '0.0000'));
        Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                      Wage_Code_Id_, 1, '=', 1, Gl_Warrning_05_,
                                                      Warning_Text_);
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_06_ THEN
      IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                   Warrning_Id_) IS NULL THEN
        Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_,
                                                         'ACCURATEWC: Calculated netting factor can not be set.',
                                                         NULL);
        Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                      Wage_Code_Id_, 1, '=', 1, Gl_Warrning_06_,
                                                      Warning_Text_);
      END IF;
    ELSIF Warrning_Id_ = Gl_Warrning_07_ THEN
      IF Hrp_Pay_List_Warning_Api.Get_Warning_Text(Company_Id_, Payroll_List_Id_, Emp_No_,
                                                   Warrning_Id_) IS NULL THEN
        Warning_Text_ := Language_Sys.Translate_Constant(Lu_Name_, 'OTHERWARNING: :P1.', NULL, S01_);
        Ret_          := Payroll_Util_Api.Iff_Warning(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                      Wage_Code_Id_, 1, '=', 1, Gl_Warrning_07_,
                                                      Warning_Text_);
      END IF;
    ELSE
      NULL;
    END IF;
    --
    Dummy_ := Ret_;
    --
  END Zpk_Warrning_Add___;
  PROCEDURE Zpk_Log_Entry_Add___(l_Log_Tab IN OUT t_Log_Tab,
                                 Log_Type_ IN VARCHAR2,
                                 S1_       IN VARCHAR2 DEFAULT NULL,
                                 S2_       IN VARCHAR2 DEFAULT NULL,
                                 S3_       IN VARCHAR2 DEFAULT NULL,
                                 S4_       IN VARCHAR2 DEFAULT NULL,
                                 N1_       IN NUMBER DEFAULT NULL,
                                 N2_       IN NUMBER DEFAULT NULL,
                                 N3_       IN NUMBER DEFAULT NULL,
                                 N4_       IN NUMBER DEFAULT NULL,
                                 D1_       IN DATE DEFAULT NULL,
                                 D2_       IN DATE DEFAULT NULL,
                                 D3_       IN DATE DEFAULT NULL,
                                 D4_       IN DATE DEFAULT NULL) IS
    Log_Id_ NUMBER;
  BEGIN
    Log_Id_ := Nvl(l_Log_Tab.Last, 0) + 1;
    l_Log_Tab.Extend;
    l_Log_Tab(Log_Id_).Log_Id := Log_Id_;
    l_Log_Tab(Log_Id_).Log_Type := Log_Type_;
    l_Log_Tab(Log_Id_).S1 := S1_;
    l_Log_Tab(Log_Id_).S2 := S2_;
    l_Log_Tab(Log_Id_).S3 := S3_;
    l_Log_Tab(Log_Id_).S4 := S4_;
    l_Log_Tab(Log_Id_).N1 := N1_;
    l_Log_Tab(Log_Id_).N2 := N2_;
    l_Log_Tab(Log_Id_).N3 := N3_;
    l_Log_Tab(Log_Id_).N4 := N4_;
    l_Log_Tab(Log_Id_).D1 := D1_;
    l_Log_Tab(Log_Id_).D2 := D2_;
    l_Log_Tab(Log_Id_).D3 := D3_;
    l_Log_Tab(Log_Id_).D4 := D4_;
  END Zpk_Log_Entry_Add___;
  PROCEDURE Zpk_Log_Entry_Save___(l_Log_Tab IN t_Log_Tab,
                                  --base_rec_                   IN hrp_abs_calc_base_tab%ROWTYPE,
                                  Abs_Rec_         IN Absence_Registration_Tab%ROWTYPE,
                                  Company_Id_      IN VARCHAR2,
                                  Payroll_List_Id_ IN VARCHAR2,
                                  Emp_No_          IN VARCHAR2,
                                  Valid_Date_      IN VARCHAR2,
                                  Wage_Code_Id_    IN VARCHAR2,
                                  Function_Id_     IN VARCHAR2,
                                  Base_Type_       IN NUMBER) IS
    Enable_Function_Log_ VARCHAR2(1);
    --log_id_              NUMBER;
    Text_     VARCHAR2(200);
    Log_Type_ VARCHAR2(200);
    --line_ver_            VARCHAR2(2)   := '||';
    Line_Hor_   VARCHAR2(200) := '=';
    Line_Has_   VARCHAR2(200) := '#';
    Line_Left_  VARCHAR2(200) := '<<< ';
    Line_Right_ VARCHAR2(200) := ' >>>';
    Star_Left_  VARCHAR2(200) := '*** ';
    Star_Right_ VARCHAR2(200) := ' ***';
    Line_Len_   NUMBER := 100;
    Show_Not_Null_Wc_ BOOLEAN := FALSE;
    TYPE t_Tab IS TABLE OF Hrp_Wage_Code_Tab%ROWTYPE;
    g_Tab t_Tab;
    PROCEDURE Add_Entry(Text_ IN VARCHAR2) IS
    BEGIN
      Hrp_Pl_Wc_Value_Log_Api.Insert_Long_Text(Company_Id_, Payroll_List_Id_, Emp_No_, Valid_Date_,
                                               Wage_Code_Id_, Function_Id_, Text_);
    END Add_Entry;
    FUNCTION Wc_Name(Wage_Code_Id_ IN VARCHAR2) RETURN VARCHAR2 IS
      Ret_ VARCHAR2(50);
    BEGIN
      IF g_Tab.Last IS NOT NULL THEN
        FOR i IN g_Tab.First .. g_Tab.Last LOOP
          IF g_Tab(i).Wage_Code_Id = Wage_Code_Id_ THEN
            Ret_ := g_Tab(i).Name;
            EXIT;
          END IF;
        END LOOP;
      END IF;
      IF Ret_ IS NULL THEN
        Ret_ := Substr(Hrp_Wage_Code_Api.Get_Name(Company_Id_, Wage_Code_Id_), 1, 50);
        g_Tab.Extend;
        g_Tab(g_Tab.Last).Company_Id := Company_Id_;
        g_Tab(g_Tab.Last).Wage_Code_Id := Wage_Code_Id_;
        g_Tab(g_Tab.Last).Name := Ret_;
      END IF;
      RETURN Substr(Ret_, 1, 50);
    END Wc_Name;
    FUNCTION Line_Ver_Last(Text_ IN VARCHAR2) RETURN VARCHAR2 IS
      Ret_ VARCHAR2(200);
    BEGIN
      Ret_ := Rpad(Text_, Line_Len_ - 2, ' ');
      Ret_ := Ret_ || '||';
      RETURN Ret_;
    END Line_Ver_Last;
    FUNCTION Line_Sizing(Text_ IN VARCHAR2, Sizing_ IN NUMBER) RETURN VARCHAR2 IS
      Ret_ VARCHAR2(200);
      Num_ NUMBER;
      Sep_ VARCHAR2(10) := Rpad(' ', 10, ' ');
      --line_1_b_ NUMBER := 1;
      Line_1_e_ NUMBER := 30;
      --line_2_b_ NUMBER := 1;
      Line_2_e_ NUMBER := 40;
      --line_3_b_ NUMBER := 1;
      Line_3_e_ NUMBER := 50;
    BEGIN
      CASE Sizing_
        WHEN 0 THEN
          Num_ := Nvl(Text_, '0');
          Ret_ := To_Char(Num_, '00000000.00') || Sep_;
        WHEN 1 THEN
          Ret_ := Rpad(Text_, Line_1_e_ - 2, ' ');
        WHEN 2 THEN
          Ret_ := Rpad(Text_, Line_2_e_ - 2, ' ');
        WHEN 3 THEN
          Ret_ := Rpad(Text_, Line_3_e_ - 2, ' ');
      END CASE;
      RETURN Ret_;
    END Line_Sizing;
  BEGIN
    Enable_Function_Log_ := Nvl(Substr(Hrp_Config_Det_Api.Get_Id(Company_Id_, 1239), 1, 1), '0');
    IF Enable_Function_Log_ = '1'
       AND Nvl(Gl_Log_Mode_, '!@#$@!') IN ('ACTIVESIMPLE', 'ACTIVEFULL') THEN
      IF Nvl(l_Log_Tab.Last, 0) > 0 THEN
        --wage code name tab
        g_Tab := t_Tab();
        --technical lines
        Line_Hor_ := Rpad('=', Line_Len_, Line_Hor_);
        Line_Has_ := Rpad('#', Line_Len_, Line_Has_);
        -- << INTRO >>
        Text_ := Line_Has_;
        Add_Entry(Text_);
        Text_ := Function_Id_;
        Text_ := Line_Left_ || Text_ || Line_Right_;
        Add_Entry(Text_);
        Text_ := ' BASIC INFO ABOUT ABSENCE CALCULATION ON CURRNET LIST - ' || Payroll_List_Id_ ||
                 ' : ';
        Add_Entry(Text_);
        CASE Base_Type_
          WHEN -1 THEN
            Text_ := 'MONTHLY';
          WHEN 2 THEN
            Text_ := '3MONTHLY';
          WHEN 4 THEN
            Text_ := '4MONTHLY';
          WHEN 12 THEN
            Text_ := 'YEARLY';
          ELSE
            Text_ := 'NULL';
        END CASE;
        Text_ := ' CALCULTATION BASE TYPE: ' || Text_;
        Add_Entry(Text_);
        Text_ := Line_Sizing(' ', 1) || '1. ABSENCE_ID - ' || Abs_Rec_.Absence_Id;
        Add_Entry(Text_);
        Text_ := Line_Sizing(' ', 1) || '2. ABSENCE_TYPE - ' || Abs_Rec_.Absence_Type_Id;
        Add_Entry(Text_);
        Text_ := Line_Sizing(' ', 1) || '3. DATA_FROM - ' ||
                 To_Char(Abs_Rec_.Date_From, 'YYYY-MM-DD');
        Add_Entry(Text_);
        Text_ := Line_Sizing(' ', 1) || '4. DATA_TO - ' || To_Char(Abs_Rec_.Date_To, 'YYYY-MM-DD');
        Add_Entry(Text_);
        Text_ := Line_Has_;
        Add_Entry(Text_);
        FOR i IN 1 .. l_Log_Tab.Last LOOP
          BEGIN
            Log_Type_ := l_Log_Tab(i).Log_Type;
            CASE
              WHEN Log_Type_ IN ('CLASS_YEARLY_DEF', 'CLASS_MONTHLY_DEF', 'CLASS_3MONTHLY_DEF',
                                 'CLASS_4MONTHLY_DEF') THEN
                IF l_Log_Tab(i).S1 = 'GENERATEWAY' THEN
                  Text_ := ' PARAMETER FOR CREATING BASE ';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := ' SET OF PARAMETER CHOOSEN FOR BASE CREATEING ';
                  Add_Entry(Text_);
                  Text_ := '1. ANY BASE EXISTS - ' || l_Log_Tab(i).S2;
                  Add_Entry(Text_);
                  Text_ := '2. BASE EXISTS ON DATE - ' || l_Log_Tab(i).S3;
                  Add_Entry(Text_);
                  Text_ := '3. CHECK AND COPY BASE - ' || l_Log_Tab(i).S4;
                  Add_Entry(Text_);
                  Text_ := '4. RECALCULATE - ' || To_Char(l_Log_Tab(i).N1);
                  Add_Entry(Text_);
                  Text_ := '5. RECALCULATE CONDITIONAL - ' || To_Char(l_Log_Tab(i).N2);
                  Add_Entry(Text_);
                  Text_ := '6. CORRECTION - ' || To_Char(l_Log_Tab(i).N3);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'ABSLOOP' THEN
                  Text_ := ' CURRENT ABS CALCULATION ';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := ' CURRENT CALCULATED/RECALCULATED ABSENC BASE ';
                  Add_Entry(Text_);
                  Text_ := '1. ABSENCE_ID - ' || To_Char(l_Log_Tab(i).N1);
                  Add_Entry(Text_);
                  Text_ := '2. ABSENCE_TYPE - ' || l_Log_Tab(i).S2;
                  Add_Entry(Text_);
                  Text_ := '3. DATA_FROM - ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := '4. DATA_TO - ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 IN ('BASENOTFOUND', 'BASECOPIED', 'BASECOPIEDALTERNATIVE') THEN
                  Text_ := ' PARAMETER FOR COPY BASE ';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := ' LOOKING FOR BASE TO COPY ';
                  Add_Entry(Text_);
                  Text_ := '1. COPIED/NOTFOUD - ' || l_Log_Tab(i).S1;
                  Add_Entry(Text_);
                  Text_ := '2. COPY_BASE_ANOTHER - ' || l_Log_Tab(i).S2;
                  Add_Entry(Text_);
                  Text_ := '3. ABSTYPE - ' || l_Log_Tab(i).S3;
                  Add_Entry(Text_);
                  Text_ := '4. CHECK FROM ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := '5. CHECK TO ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := '6. ASSIGMENT FROM - ' || To_Char(l_Log_Tab(i).D3, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := '7. ASSIGMENT TO - ' || To_Char(l_Log_Tab(i).D4, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'PERIODMONTH' THEN
                  Text_ := ' CALCULATING PERIOD - ' || To_Char(l_Log_Tab(i).N4, '00');
                  Text_ := Text_ || '          ';
                  Text_ := Text_ || ' Date from: ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Text_ := Text_ || ' Date to: ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'ORGIN' THEN
                  Text_ := ' Date from: ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Text_ := Text_ || ' Date to: ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'GRACE'
                       AND l_Log_Tab(i).S2 IS NULL THEN
                  IF l_Log_Tab(i).D1 <> l_Log_Tab(i).D3 THEN
                    Text_ := ' Date from: ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                    Text_ := Text_ || ' Date to: ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                    Text_ := Text_ || ' GRACED DATE';
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'GRACE'
                       AND l_Log_Tab(i).S2 = 'BONUS' THEN
                  Text_ := ' BONUS is looking for date: ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := ' TAX pay way has been set on : ' || l_Log_Tab(i).S3;
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'GRACE'
                       AND l_Log_Tab(i).S2 = 'COPY' THEN
                  Text_ := ' Periodic base for this absence has been copied from previous seq.';
                  Add_Entry(Text_);
                END IF;
                Text_ := Line_Hor_;
                Add_Entry(Text_);
              WHEN Log_Type_ IN ('CLASS_YEARLY_CONTR', 'CLASS_MONTHLY_CONTR', 'CLASS_ALTER_CONTR',
                                 'CLASS_3MONTHLY_CONTR', 'CLASS_4MONTHLY_CONTR') THEN
                -- YEARLY-BASE
                IF l_Log_Tab(i).S1 = 'BASE_HEAD' THEN
                  Text_ := 'BASE CALCULATION - FROM PERIOD';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'BASE_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF l_Log_Tab(i).S3 = 'CURRENTLIST' THEN
                    Text_ := Text_ || ' ( *** WAGE CODE FROM  CURRENT LIST *** )';
                  END IF;
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'CONTR_HEAD' THEN
                  Text_ := 'CONTRIBUTION CALCULATION - FROM PERIOD';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'CONTR_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF l_Log_Tab(i).S3 = 'CURRENTLIST' THEN
                    Text_ := Text_ || ' ( *** WAGE CODE FROM  CURRENT LIST *** )';
                  END IF;
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'CALC_HEAD' THEN
                  Text_ := 'ALTERNATIVE WAGE CODE IN CALC GROUP FOR ALTERNATIVE - FROM PERIOD';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'CALC_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF l_Log_Tab(i).S3 = 'CURRENTLIST' THEN
                    Text_ := Text_ || ' ( *** WAGE CODE FROM  CURRENT LIST *** )';
                  END IF;
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'PERIOD' THEN
                  Text_ := Line_Hor_;
                  Add_Entry(Text_);
                  Text_ := '>>> PERIOD ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM') || ' <<<<';
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' CONTRIBUTION FOR PERIOD ', 3);
                  Text_ := Text_ || ' = ';
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  IF Log_Type_ <> 'CLASS_MONTHLY_CONTR' THEN
                    Text_ := Text_ || Line_Sizing(' CONTRIBUTION CUMULATIVE ', 3);
                    Text_ := Text_ || ' = ';
                    Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  END IF;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' BASE FOR PERIOD ', 3);
                  Text_ := Text_ || '          = ';
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N3), 0);
                  IF Log_Type_ <> 'CLASS_MONTHLY_CONTR' THEN
                    Text_ := Text_ || Line_Sizing(' BASE CUMULATIVE ', 3);
                    Text_ := Text_ || '          = ';
                    Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N4), 0);
                  END IF;
                  Add_Entry(Text_);
                  IF Log_Type_ = 'CLASS_MONTHLY_CONTR' THEN
                    Text_ := Text_ || Line_Sizing(' CALCULATED NETTING FACTOR ', 3);
                    Text_ := Text_ || '          = ';
                    Text_ := Text_ || To_Char(l_Log_Tab(i).N4, '00.0000');
                    Add_Entry(Text_);
                  END IF;
                  Text_ := Line_Hor_;
                  Add_Entry(Text_);
                END IF;
              WHEN Log_Type_ IN ('CLASS_YEARLY_CUR', 'CLASS_3MONTHLY_CUR', 'CLASS_4MONTHLY_CUR',
                                 'CLASS_ALTER_CUR') THEN
                -- log according current list
                -- << YEARLY-BASE >>
                IF l_Log_Tab(i).S1 = 'BASE_HEAD' THEN
                  Text_ := 'BASE CALCULATION - FROM CURRENT LIST';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := ' Date from: ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM-DD');
                  Text_ := Text_ || ' Date to: ' || To_Char(l_Log_Tab(i).D2, 'YYYY-MM-DD');
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'BASE_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'CONTR_HEAD' THEN
                  Text_ := 'CONTRIBUTION CALCULATION - FROM CURRENT LIST';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'CONTR_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'CALC_HEAD' THEN
                  Text_ := 'ALTERNATIVE RATE - FROM CURRENT LIST';
                  Text_ := Star_Left_ || Text_ || Star_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Sizing(' VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' CUM VALUE ', 1);
                  Text_ := Text_ || Line_Sizing(' WAGE CODE ID ', 1);
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'CALC_BODY' THEN
                  IF Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Text_ := '*';
                  ELSE
                    Text_ := ' ';
                  END IF;
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || Line_Sizing(To_Char(l_Log_Tab(i).N2), 0);
                  Text_ := Text_ || '     ' || Line_Sizing(l_Log_Tab(i).S2, 1);
                  Text_ := Text_ || '     ' || Wc_Name(l_Log_Tab(i).S2);
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                END IF;
              WHEN Log_Type_ IN ('CLASS_YEARLY_ALL', 'CLASS_3MONTHLY_ALL', 'CLASS_4MONTHLY_ALL',
                                 'CLASS_MONTHLY_ALL', 'CLASS_ALTER_ALL') THEN
                IF l_Log_Tab(i).S1 = 'ALL' THEN
                  -- << NETTING >>
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                  Text_ := ' NETTING FACTOR ON ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM');
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := ' CONTRIBUTION FOR ALL PERIODS = ';
                  Text_ := Text_ || To_Char(l_Log_Tab(i).N1);
                  Add_Entry(Text_);
                  Text_ := ' BASE FOR ALL PERIODS = ';
                  Text_ := Text_ || To_Char(l_Log_Tab(i).N2);
                  Add_Entry(Text_);
                  Text_ := ' CALCULATED NETTING FACTOR = ';
                  Text_ := Text_ || To_Char(l_Log_Tab(i).N3, '00.0000');
                  Add_Entry(Text_);
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'REGFACTOR' THEN
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                  Text_ := ' NETTING FACTOR HAS BEEN TAKEN FROM CONSTANT PARAMTER WSK10011 = ';
                  Text_ := Text_ || To_Char(l_Log_Tab(i).N1, '00.0000');
                  Add_Entry(Text_);
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                END IF;
              WHEN Log_Type_ IN ('CLASS_ALTER_AVG') THEN
                IF l_Log_Tab(i).S1 = 'AVG' THEN
                  Text_ := Line_Hor_;
                  Add_Entry(Text_);
                  Text_ := 'ALTERNATIVE AVERAGE RATE';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := '1. Wage code sum value: ' || l_Log_Tab(i).N2;
                  Add_Entry(Text_);
                  Text_ := '2. Average rate value: ' || l_Log_Tab(i).N1;
                  Add_Entry(Text_);
                  Text_ := Line_Hor_;
                  Add_Entry(Text_);
                END IF;
              WHEN Log_Type_ IN ('CLASS_WC') THEN
                IF l_Log_Tab(i).S1 = 'OPEN' THEN
                  -- << WC HEAD >>
                  Text_ := ' ';
                  Add_Entry(Text_);
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                  Text_ := 'START OF CLASSIFICATION OF WAGE CODES FOR';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  IF l_Log_Tab(i).S3 IS NOT NULL THEN
                    Text_ := '1. GROUP: ' || l_Log_Tab(i).S3;
                    Add_Entry(Text_);
                    Text_ := '2. TYPE: ' || l_Log_Tab(i).S4;
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_HEAD' THEN
                  Text_ := ' >>>>> FOR ' || l_Log_Tab(i).S2 || ' - ( ' || Wc_Name(l_Log_Tab(i).S2) || ' )';
                  Add_Entry(Text_);
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 = 'PREV' THEN
                  Text_ := 'INSERT TO PERIOD ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM') || ' - ' ||
                           To_Char(l_Log_Tab(i).D1, 'YYYY-MM');
                  Text_ := Text_ || ' VALUE: ' || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 = 'CURR' THEN
                  Text_ := 'INSERT TO PERIOD ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM') || ' - ' ||
                           To_Char(l_Log_Tab(i).D1, 'YYYY-MM');
                  Text_ := Text_ || ' VALUE: ' || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  Text_ := Text_ || ' -> CURR LIST WC FOR: ' ||
                           To_Char(l_Log_Tab(i).D3, 'YYYY-MM-YY');
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 IN ('SKIPVALID') THEN
                  Text_ := '!!! Skipped Due Constant Parameter Validation Requirement - For All Periods ';
                  Text_ := Text_ || ' VALUE: ' || Line_Sizing(0, 0);
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 IN ('SKIPCURR', 'SKIPARCH') THEN
                  Text_ := '!!! Skipped Due Other Reason - In Period' ||
                           To_Char(l_Log_Tab(i).D1, 'YYYY-MM') || ' - ' ||
                           To_Char(l_Log_Tab(i).D1, 'YYYY-MM');
                  Text_ := Text_ || ' VALUE: ' || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 IN ('INSCURR', 'INSARCH') THEN
                  Text_ := '!!! Greaced Insert - In Period ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM') ||
                           ' - ' || To_Char(l_Log_Tab(i).D1, 'YYYY-MM');
                  Text_ := Text_ || ' VALUE: ' || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'WC_BODY'
                       AND l_Log_Tab(i).S2 IN ('FUTUREDEL', 'FUTUREINS') THEN
                  Text_ := 'FUTURE PAYMENT IN AMOUNT: ' || Line_Sizing(To_Char(l_Log_Tab(i).N1), 0);
                  IF l_Log_Tab(i).S2 = 'FUTUREDEL' THEN
                    Text_ := Text_ || ' HAS NOT BEEN CLASSIFIED ';
                  ELSE
                    Text_ := Text_ || ' HAS BEEN CLASSIFIED ';
                  END IF;
                  Text_ := Text_ || ' FROM ' || l_Log_Tab(i).S3 || ' - ' ||
                           Wc_Name(l_Log_Tab(i).S3) || '.';
                  IF Show_Not_Null_Wc_
                     OR Nvl(l_Log_Tab(i).N1, 0) <> 0 THEN
                    Add_Entry(Text_);
                  END IF;
                ELSIF l_Log_Tab(i).S1 = 'CLOSE' THEN
                  Text_ := 'END OF CLASSIFICATION OF WAGE CODES FOR';
                  Text_ := Line_Left_ || Text_ || Line_Right_;
                  Add_Entry(Text_);
                  Text_ := Line_Has_;
                  Add_Entry(Text_);
                  Text_ := ' ';
                  Add_Entry(Text_);
                END IF;
              WHEN Log_Type_ IN ('PLAIN_TEXT') THEN
                Text_ := l_Log_Tab(i).S1;
                Add_Entry(Text_);
            END CASE;
          EXCEPTION
            WHEN OTHERS THEN
              Text_ := ' LINE GENERATED ERROR ';
              Add_Entry(Text_);
          END;
        END LOOP;
      ELSE
        Text_ := ' NO LOG GENERATED ';
        Add_Entry(Text_);
      END IF;
    ELSE
      -- enabling log
      Text_ := ' LOG FUNCTION IS DISABLE ';
      --add_entry(text_);
    END IF;
  END Zpk_Log_Entry_Save___;
  FUNCTION Zpk_Calc_Grace_Months___(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                                    Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                                    Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                                    Payroll_List_Id_        IN VARCHAR2,
                                    Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                    Include_Payroll_Values_ IN VARCHAR2,
                                    Wc_Group_Type_          IN VARCHAR2,
                                    Wc_Group_               IN VARCHAR2,
                                    Base_Wc_Group_          IN VARCHAR2,
                                    Contribution_Wc_Group_  IN VARCHAR2,
                                    Wc_Type_                IN VARCHAR2,
                                    Ground_Months_          IN NUMBER,
                                    Grace_Back_Max_         IN NUMBER,
                                    Paid_                   IN VARCHAR2 DEFAULT 'TRUE') RETURN DATE IS
    Base_Value_            NUMBER;
    Contribution_Value_    NUMBER;
    Last_                  NUMBER;
    Bonus_Period_          DATE;
    Period_Date_From_      DATE;
    Period_Date_To_        DATE;
    Period_Date_From_Arch_ DATE;
    Period_Date_From_Curr_ DATE;
    Derivate_Tax_Period_   DATE;
    Bonus_Exist_           BOOLEAN := FALSE;
    --return
    Months_Back_ NUMBER;
    Ret_         NUMBER;
    --warning
    --warning_text_        VARCHAR2(2000);
    CURSOR Get_Months_To_Nett_Factor IS
      SELECT Company_Id,
             Emp_No,
             MAX(Trunc(Validation_Date, 'MONTH')) Validation_Date,
             SUM(a.Summarised_Value) Summarised_Value
        FROM Hrp_Wc_Archive_Tab a
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Validation_Date BETWEEN Period_Date_From_ AND Period_Date_To_
         AND Wage_Code_Id IN
             (SELECT Wage_Code_Id
                FROM Calculation_Group_Members_Tab b
               WHERE Company_Id = a.Company_Id
                 AND Calc_Group_Id = Wc_Group_
                 AND Calc_Group_Valid_From =
                     (SELECT MAX(c.Calc_Group_Valid_From)
                        FROM Calculation_Group_Tab c
                       WHERE c.Company_Id = b.Company_Id
                         AND c.Calc_Group_Id = b.Calc_Group_Id
                         AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date))
            -- tax classificatin constraints
         AND (
             /* bonus tax classificatni is skipped */
              Paid_ = 'FALSE'
             /* bonus tax classificatni is checking */
              OR
              (
              /* bonus is paid 'be' current payroll list tax period */
               (Tax_Year * 100 + Tax_Month) <= To_Number(To_Char(Derivate_Tax_Period_, 'YYYYMM'))
              /* bonus is paid 'be' illness period is began */
               AND (Tax_Year * 100 + Tax_Month) <= To_Number(To_Char(Abs_Rec_.Date_From, 'YYYYMM'))))
       GROUP BY Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH')
       ORDER BY Trunc(Validation_Date, 'MONTH') DESC;
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
  BEGIN
    Period_Date_To_   := Trunc(Abs_Rec_.Date_From, 'MONTH') - 1;
    Period_Date_From_ := Trunc(Add_Months(Abs_Rec_.Date_From,
                                          (-1 * (Grace_Back_Max_ + Ground_Months_))), 'MONTH');
    --
    Derivate_Tax_Period_ := To_Date(Hrp_Pay_List_Api.Get_Tax_Period(Base_Rec_.Company_Id,
                                                                    Payroll_List_Id_), 'YYYYMM');
    --
    IF Wc_Group_Type_ = '12' THEN
      -- check arrchive for bonuss
      FOR Rec_ IN Get_Months_To_Nett_Factor LOOP
        Base_Value_         := 0;
        Contribution_Value_ := 0;
        FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
          Base_Value_ := Base_Value_ + Hrp_Wc_Archive_Api.Get_Value_For_Period(Base_Rec_.Company_Id,
                                                                               Base_Rec_.Emp_No,
                                                                               Bwc_Rec_.Wage_Code_Id,
                                                                               Rec_.Validation_Date,
                                                                               Last_Day(Rec_.Validation_Date)) *
                         Bwc_Rec_.Arythm_Sign;
        END LOOP;
        FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
          Contribution_Value_ := Contribution_Value_ + Hrp_Wc_Archive_Api.Get_Value_For_Period(Base_Rec_.Company_Id,
                                                                                               Base_Rec_.Emp_No,
                                                                                               Cwc_Rec_.Wage_Code_Id,
                                                                                               Rec_.Validation_Date,
                                                                                               Last_Day(Rec_.Validation_Date)) *
                                 Cwc_Rec_.Arythm_Sign;
        END LOOP;
        -- for migration purpose or additional list
        IF Nvl(Rec_.Summarised_Value, 0) <> 0 THEN
          IF Nvl(Base_Value_, 0) = 0 THEN
            --Error_Sys.Appl_General(lu_name_, 'NOBASE: Function ZPK_ABSBASE2_CA - There is no base for wage code group :P1 for validation period :P2 !', base_wc_group_, to_char(rec_.validation_date,'YYYY-MM'));
            Zpk_Warrning_Add___(Base_Rec_.Company_Id, Base_Rec_.Emp_No, Payroll_List_Id_,
                                Gl_Warrning_07_, '42000', N01_ => 0,
                                S01_ => 'There is no base for validateion period' ||
                                         To_Char(Rec_.Validation_Date, 'YYYY-MM'));
          ELSIF Nvl(Contribution_Value_, 0) = 0 THEN
            --Error_Sys.Appl_General(lu_name_, 'NOCONTR: Function ZPK_ABSBASE2_CA - There is no contribution for wage code group :P1 for validation period :P2 !', contribution_wc_group_, to_char(rec_.validation_date,'YYYY-MM'));
            Zpk_Warrning_Add___(Base_Rec_.Company_Id, Base_Rec_.Emp_No, Payroll_List_Id_,
                                Gl_Warrning_07_, '42000', N01_ => 0,
                                S01_ => 'There is no contribution for validateion period' ||
                                         To_Char(Rec_.Validation_Date, 'YYYY-MM'));
          END IF;
        END IF;
        Period_Date_From_Arch_ := Trunc(Rec_.Validation_Date, 'MONTH');
        Bonus_Exist_           := TRUE;
        EXIT;
      END LOOP;
      Period_Date_From_Arch_ := Nvl(Period_Date_From_Arch_, Period_Date_From_);
      -- check current list for bonus
      IF Include_Payroll_Values_ = 'TRUE'
      --AND paid_ = 'FALSE' -- 20160401 ZpkChange
       THEN
        Period_Date_From_Curr_ := Trunc(Period_Date_From_, 'MONTH');
        -- for current list
        -- look out for retro tax period, it should be replaced by current payroll list tax period
        --derivate_tax_period_ := TO_DATE(hrp_pay_list_api.Get_Accounting_Period(base_rec_.company_id,payroll_list_id_),'YYYYMM');
        --
        FOR Wc_Rec_ IN Get_Wc_(Wc_Group_) LOOP
          Last_ := Wage_Code_Elements_Tab_.Last;
          FOR i_ IN 1 .. Nvl(Last_, 0) LOOP
            IF Wage_Code_Elements_Tab_(i_)
             .Wage_Code_Id = Wc_Rec_.Wage_Code_Id
                AND Wage_Code_Elements_Tab_(i_).Validation_Date BETWEEN Period_Date_From_ AND
                Period_Date_To_
               --AND   (to_number(to_char(wage_code_elements_tab_(i_).wc_tax_period,'YYYYMM')) <= to_number(to_char(period_date_to_,'YYYYMM')) OR paid_ = 'FALSE') THEN
                AND (To_Number(To_Char(Derivate_Tax_Period_, 'YYYYMM')) <=
                     To_Number(To_Char(Abs_Rec_.Date_From, 'YYYYMM')) OR Paid_ = 'FALSE') THEN
              IF Wage_Code_Elements_Tab_(i_).Value IS NOT NULL THEN
                Period_Date_From_Curr_ := Greatest(Period_Date_From_Curr_,
                                                   Trunc(Wage_Code_Elements_Tab_(i_).Validation_Date,
                                                          'MONTH'));
                Bonus_Exist_           := TRUE;
              END IF;
            END IF;
          END LOOP;
        END LOOP;
      END IF;
      Period_Date_From_Curr_ := Nvl(Period_Date_From_Curr_, Period_Date_From_);
      -- set new months back
      Bonus_Period_ := Trunc(Greatest(Period_Date_From_Curr_, Period_Date_From_Arch_), 'MONTH');
      Months_Back_  := Months_Between(Period_Date_To_ + 1, Bonus_Period_);
      Months_Back_  := Greatest(Months_Back_, Ground_Months_);
      IF To_Char(Bonus_Period_, 'MM.DD') <> '12.01'
         AND Bonus_Exist_ THEN
        Error_Sys.Appl_General(Lu_Name_,
                               'NOPROPBONUS: Function ZPK_ABSBASE2_CA - Yearly bonus period date ( :P1 ) is not properly set!',
                               To_Char(Bonus_Period_, 'YYYY-MM'));
      END IF;
    END IF;
    Months_Back_ := Nvl(Months_Back_, Ground_Months_);
    --UPDATED wc can not be graced
    IF Wc_Type_ = '3'
       AND Months_Back_ > Ground_Months_ THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'NOTUPDATEWC: Function ZPK_ABSBASE2_CA - Period can not be graced for wc group  :P1 !',
                             Wc_Group_);
    END IF;
    --ADD WARNING
    IF Months_Back_ > Ground_Months_
       AND Bonus_Exist_ THEN
      Zpk_Warrning_Add___(Base_Rec_.Company_Id, Base_Rec_.Emp_No, Payroll_List_Id_, Gl_Warrning_02_,
                          '42000', N01_ => Months_Back_, S01_ => '');
    END IF;
    IF Bonus_Exist_ THEN
      RETURN Bonus_Period_;
    ELSE
      RETURN NULL;
    END IF;
  END Zpk_Calc_Grace_Months___;
  FUNCTION Get_Value_For_Period___(Company_Id_      IN VARCHAR2,
                                   Emp_No_          IN VARCHAR2,
                                   Wage_Code_Id_    IN VARCHAR2,
                                   Validation_From_ IN DATE,
                                   Validation_To_   IN DATE,
                                   Tax_Period_To_   IN NUMBER,
                                   Type_            IN VARCHAR2 DEFAULT 'TAXCHECK') RETURN NUMBER IS
    Temp_ NUMBER;
    CURSOR c_ IS
      SELECT SUM(Summarised_Value)
        FROM Hrp_Wc_Archive_Tab t
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_
         AND ((((t.Tax_Year * 100 + t.Tax_Month) <= Tax_Period_To_) AND Type_ = 'TAXCHECK') OR
             Type_ = 'TAXNOTCHECK')
         AND Validation_Date BETWEEN Validation_From_ AND Validation_To_;
  BEGIN
    OPEN c_;
    FETCH c_
      INTO Temp_;
    CLOSE c_;
    RETURN Nvl(Temp_, 0);
  END Get_Value_For_Period___;
  FUNCTION Zpk_Get_Value_Adv___(Validation_Date_        IN DATE,
                                Wage_Code_Id_           IN VARCHAR2,
                                Type_                   IN VARCHAR2,
                                Wc_Valid_From_          IN DATE,
                                Period_Date_To_         IN DATE,
                                Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type)
    RETURN NUMBER IS
    Temp_ Hrp_Pl_Wc_Value_Tab.Value%TYPE := 0;
    Last_ NUMBER;
  BEGIN
    Last_ := Wage_Code_Elements_Tab_.Last;
    IF Type_ = 'TAXCHECK' THEN
      FOR i_ IN 1 .. Nvl(Last_, 0) LOOP
        IF Wage_Code_Elements_Tab_(i_)
         .Wage_Code_Id = Wage_Code_Id_
            AND Wage_Code_Elements_Tab_(i_).Validation_Date BETWEEN Wc_Valid_From_ AND
            Validation_Date_
            AND To_Number(To_Char(Wage_Code_Elements_Tab_(i_).Wc_Tax_Period, 'YYYYMM')) <=
            To_Number(To_Char(Period_Date_To_, 'YYYYMM')) THEN
          Temp_ := Temp_ + Wage_Code_Elements_Tab_(i_).Value;
        END IF;
      END LOOP;
      RETURN Temp_;
    ELSIF Type_ = 'TAXNOTCHECK' THEN
      FOR i_ IN 1 .. Nvl(Last_, 0) LOOP
        IF Wage_Code_Elements_Tab_(i_).Wage_Code_Id = Wage_Code_Id_
            AND Wage_Code_Elements_Tab_(i_)
           .Validation_Date BETWEEN Wc_Valid_From_ AND Validation_Date_ THEN
          Temp_ := Temp_ + Wage_Code_Elements_Tab_(i_).Value;
        END IF;
      END LOOP;
    ELSE
      Temp_ := 0;
    END IF;
    RETURN Temp_;
  END Zpk_Get_Value_Adv___;
  FUNCTION Zpk_Get_Alternative_Value___(Company_Id_                 IN VARCHAR2,
                                        Emp_No_                     IN VARCHAR2,
                                        Payroll_List_Id_            IN VARCHAR2,
                                        Payroll_Rec_                IN Hrp_Pay_List_Api.Public_Rec,
                                        Abs_Rec_                    IN Absence_Registration_Tab%ROWTYPE,
                                        Calc_Param_Group_           IN VARCHAR2,
                                        Base_Wc_Group_              IN VARCHAR2,
                                        Contribution_Wc_Group_      IN VARCHAR2,
                                        Wage_Code_Elements_Tab_     IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                        Zpk_Log_Tab_                IN OUT t_Log_Tab,
                                        Tmp_Include_Payroll_Values_ IN VARCHAR2) RETURN NUMBER IS
    Base_Value_         NUMBER;
    Contribution_Value_ NUMBER;
    Calc_Param_Value_   NUMBER;
    Netting_Factor_     NUMBER;
    Avg_Rate_           NUMBER;
    Base_Value1_         NUMBER;
    Contribution_Value1_ NUMBER;
    Calc_Param_Value1_   NUMBER;
    Temp_Value_          NUMBER;
    --
    Date_From_ DATE;
    Date_To_   DATE;
    --
    Paid_Way_          VARCHAR2(20) := 'TAXNOTCHECK'; --'TAXCHECK';
    Plain_Text_        VARCHAR2(2000);
    Bonus_Group_Check_ NUMBER;
    Bonus_Group_       VARCHAR2(30);
    Bonus_Check_From_  DATE;
    Bonus_Check_To_    DATE;
    -- salary
    Salary_Direct_          BOOLEAN;
    Salary_Value_           NUMBER;
    Salary_Value_For_Valid_ NUMBER;
    Threshold_Fix_Nf_       NUMBER;
    Threshold_Factor_Calc_  NUMBER;
    Threshold_Factor_Max_   NUMBER;
    Salary_Wc_Stop_List_ CONSTANT VARCHAR2(2000) := '10010P;10011P;10010,10010R';
    --
    CURSOR Get_Last_Salary_ IS
      SELECT t.Amount
        FROM Employee_Salary_Tab t
       WHERE t.Company_Id = Company_Id_
         AND t.Emp_No = Emp_No_
         AND ((t.Valid_From <= Date_To_ AND t.Valid_To >= Date_To_) OR
             (t.Valid_To >= Date_From_ AND t.Valid_To <= Date_To_))
       ORDER BY t.Valid_To DESC;
    --
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Company_Id_
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
  BEGIN
    Date_From_ := Trunc(Abs_Rec_.Date_From, 'MONTH');
    Date_To_   := Last_Day(Date_From_);
    Base_Value_         := 0;
    Contribution_Value_ := 0;
    Calc_Param_Value_   := 0;
    Base_Value1_         := 0;
    Contribution_Value1_ := 0;
    Calc_Param_Value1_   := 0;
    -- validation parmeteter group existance
    Calculation_Group_Api.Exist_Group(Company_Id_, Calc_Param_Group_);
    --
    -- only for valid purpose
    OPEN Get_Last_Salary_;
    FETCH Get_Last_Salary_
      INTO Salary_Value_For_Valid_;
    CLOSE Get_Last_Salary_;
    --
    Threshold_Fix_Nf_     := Nvl(Hrp_Regulation_Api.Get_Value_Null(Company_Id_, 'Z003', SYSDATE),
                                 0.1371);
    Threshold_Factor_Max_ := Nvl(Hrp_Regulation_Api.Get_Value_Null(Company_Id_, 'Z021', SYSDATE),
                                 0.25); -- 13,71 + delta_
    --
    -- get file salary data
    IF Nvl(Hrp_Regulation_Api.Get_Value_Null(Company_Id_, 'Z020', SYSDATE), 0) = 1 THEN
      Salary_Direct_ := TRUE;
      --
      FOR Check_Rec_ IN Get_Wc_(Calc_Param_Group_) LOOP
        IF Report_Sys.Parse_Parameter(Check_Rec_.Wage_Code_Id, Salary_Wc_Stop_List_) = 'TRUE' THEN
          Error_Sys.Record_General(Lu_Name_,
                                   'ALTWCSTOPLISTVALID: Calculation parameter group :P1 consists some of forbidden wage code :P2',
                                   Calc_Param_Group_, Salary_Wc_Stop_List_);
        END IF;
      END LOOP;
      --
      OPEN Get_Last_Salary_;
      FETCH Get_Last_Salary_
        INTO Salary_Value_;
      CLOSE Get_Last_Salary_;
      --
      --
      Plain_Text_ := 'Salary value has been classified based on employee files in amount of ' ||
                     To_Char(Salary_Value_, '999990.00');
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'PLAIN_TEXT', S1_ => Plain_Text_);
      --
    ELSE
      --
      Plain_Text_ := 'Salary value will be classified based on wage code archive and current list';
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'PLAIN_TEXT', S1_ => Plain_Text_);
      --
      Salary_Direct_ := FALSE;
    END IF;
    --
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'BASE_HEAD', D1_ => Date_From_,
                         D2_ => Date_To_, D3_ => Date_From_);
    FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
      --temp_value_ := 0;
      Temp_Value_ := Hrp_Wc_Archive_Api.Get_Value_For_Period(Company_Id_, Emp_No_,
                                                             Bwc_Rec_.Wage_Code_Id, Date_From_,
                                                             Date_To_) * Bwc_Rec_.Arythm_Sign;
      Base_Value_ := Base_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'BASE_BODY',
                           S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
    END LOOP;
    Base_Value1_ := Base_Value1_ + Base_Value_;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CONTR_HEAD', D1_ => Date_From_,
                         D2_ => Date_To_, D3_ => Date_From_);
    FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
      --temp_value_ := 0;
      Temp_Value_         := Hrp_Wc_Archive_Api.Get_Value_For_Period(Company_Id_, Emp_No_,
                                                                     Cwc_Rec_.Wage_Code_Id,
                                                                     Date_From_, Date_To_) *
                             Cwc_Rec_.Arythm_Sign;
      Contribution_Value_ := Contribution_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CONTR_BODY',
                           S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                           N2_ => Contribution_Value_);
    END LOOP;
    Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CALC_HEAD', D1_ => Date_From_,
                         D2_ => Date_To_, D3_ => Date_From_);
    FOR Pwc_Rec_ IN Get_Wc_(Calc_Param_Group_) LOOP
      --temp_value_ := 0;
      Temp_Value_       := Hrp_Wc_Archive_Api.Get_Value_For_Period(Company_Id_, Emp_No_,
                                                                   Pwc_Rec_.Wage_Code_Id, Date_From_,
                                                                   Date_To_) * Pwc_Rec_.Arythm_Sign;
      Calc_Param_Value_ := Calc_Param_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CALC_BODY',
                           S2_ => Pwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                           N2_ => Calc_Param_Value_);
    END LOOP;
    Calc_Param_Value1_ := Calc_Param_Value1_ + Calc_Param_Value_;
    -- current list
    IF Tmp_Include_Payroll_Values_ = 'TRUE' THEN
      Base_Value_         := 0;
      Contribution_Value_ := 0;
      Calc_Param_Value_   := 0;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'BASE_HEAD', D1_ => Date_From_,
                           D2_ => Date_To_, D3_ => Date_From_);
      FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
        --temp_value_ := 0;
        Temp_Value_ := Zpk_Get_Value_Adv___(Date_To_, Bwc_Rec_.Wage_Code_Id, Paid_Way_, Date_From_,
                                            Date_To_, Wage_Code_Elements_Tab_) *
                       Bwc_Rec_.Arythm_Sign;
        Base_Value_ := Base_Value_ + Temp_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'BASE_BODY',
                             S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_,
                             S3_ => 'CURRENTLIST');
      END LOOP;
      Base_Value1_ := Base_Value1_ + Base_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CONTR_HEAD',
                           D1_ => Date_From_, D2_ => Date_To_, D3_ => Date_From_);
      FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
        --temp_value_ := 0;
        Temp_Value_         := Zpk_Get_Value_Adv___(Date_To_, Cwc_Rec_.Wage_Code_Id, Paid_Way_,
                                                    Date_From_, Date_To_, Wage_Code_Elements_Tab_) *
                               Cwc_Rec_.Arythm_Sign;
        Contribution_Value_ := Contribution_Value_ + Temp_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CONTR_BODY',
                             S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                             N2_ => Contribution_Value_, S3_ => 'CURRENTLIST');
      END LOOP;
      Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CALC_HEAD', D1_ => Date_From_,
                           D2_ => Date_To_, D3_ => Date_From_);
      FOR Pwc_Rec_ IN Get_Wc_(Calc_Param_Group_) LOOP
        --temp_value_ := 0;
        Temp_Value_       := Zpk_Get_Value_Adv___(Date_To_, Pwc_Rec_.Wage_Code_Id, Paid_Way_,
                                                  Date_From_, Date_To_, Wage_Code_Elements_Tab_) *
                             Pwc_Rec_.Arythm_Sign;
        Calc_Param_Value_ := Calc_Param_Value_ + Temp_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_ALTER_CONTR', S1_ => 'CALC_BODY',
                             S2_ => Pwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                             N2_ => Calc_Param_Value_, S3_ => 'CURRENTLIST');
      END LOOP;
      Calc_Param_Value1_ := Calc_Param_Value1_ + Calc_Param_Value_;
    END IF;
    --
    -- verify if there is any periodical bonus
    Bonus_Group_Check_ := Nvl(Hrp_Regulation_Api.Get_Value_Null(Company_Id_, 'Z022', SYSDATE), 1);
    IF Bonus_Group_Check_ = 1 THEN
      FOR Rec_ IN (SELECT t.Arg_List
                     FROM Calculating_Formula_Tab t
                    WHERE t.Company_Id = Company_Id_
                      AND t.Wage_Code_Id = '42000'
                      AND t.Function_Id = 'ZPK_ABSBASE2_CA'
                      AND t.Valid_From = (SELECT MAX(Valid_From)
                                            FROM Wage_Code_Details_Tab b
                                           WHERE b.Company_Id = t.Company_Id
                                             AND b.Wage_Code_Id = t.Wage_Code_Id
                                             AND b.Valid_From <= SYSDATE)
                    ORDER BY t.Seq_No) LOOP
        Bonus_Group_      := Payroll_Util_Api.Decode_Par(Rec_.Arg_List, 3);
        Bonus_Check_To_   := Trunc(Abs_Rec_.Date_From, 'MONTH') - 1;
        Bonus_Check_From_ := Add_Months(Trunc(Abs_Rec_.Date_From, 'MONTH'), -12);
        --
        FOR Bwc_Rec_ IN Get_Wc_(Bonus_Group_) LOOP
          Temp_Value_ := 0;
          Temp_Value_ := Hrp_Wc_Archive_Api.Get_Value_For_Period(Company_Id_, Emp_No_,
                                                                 Bwc_Rec_.Wage_Code_Id,
                                                                 Bonus_Check_From_, Bonus_Check_To_) *
                         Bwc_Rec_.Arythm_Sign;
          IF Temp_Value_ <> 0 THEN
            Error_Sys.Appl_General(Lu_Name_,
                                   'ALTERVALID1: Manual correction is necessary. Bonus exists in archive for wage code :P1 in period between :P2 and :P3.',
                                   Bwc_Rec_.Wage_Code_Id, To_Char(Bonus_Check_From_, 'YYYY-MM-DD'),
                                   To_Char(Bonus_Check_To_, 'YYYY-MM-DD'));
          END IF;
          --
          Temp_Value_ := Zpk_Get_Value_Adv___(Bonus_Check_To_, Bwc_Rec_.Wage_Code_Id, Paid_Way_,
                                              Bonus_Check_From_, Bonus_Check_To_,
                                              Wage_Code_Elements_Tab_) * Bwc_Rec_.Arythm_Sign;
          IF Temp_Value_ <> 0 THEN
            Error_Sys.Appl_General(Lu_Name_,
                                   'ALTERVALID2: Manual correction is necessary. Bonus is paid by current list for wage code :P1 in period between :P2 and :P3.',
                                   Bwc_Rec_.Wage_Code_Id, To_Char(Bonus_Check_From_, 'YYYY-MM-DD'),
                                   To_Char(Bonus_Check_To_, 'YYYY-MM-DD'));
          END IF;
        END LOOP;
      END LOOP;
    END IF;
    --
    IF (Nvl(Base_Value1_, 0) = 0 AND Nvl(Contribution_Value1_, 0) <> 0) THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'CONTRORBASENULL1: Null base for not null contribution value :P1 in calculation :P2.',
                             Contribution_Value1_, 'ALTERNATIVE');
    END IF;
    IF (Nvl(Base_Value1_, 0) <> 0 AND Nvl(Contribution_Value1_, 0) = 0) THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'CONTRORBASENULL2: Null contribution for not null base value :P1 in calculation :P2.',
                             Base_Value1_, 'ALTERNATIVE');
    END IF;
    IF Base_Value1_ <> 0 THEN
      Netting_Factor_ := Round(Contribution_Value1_ / Base_Value1_, 4) * -1;
    ELSE
      Netting_Factor_ := 0;
    END IF;
    --looking fix parameter
    IF Netting_Factor_ = 0
       OR Netting_Factor_ IS NULL THEN
      Netting_Factor_ := Reg_Const_Data_Api.Get_Cp_On_Day(Company_Id_, Emp_No_, 'WSK10011', Date_To_);
    END IF;
    --raise error
    IF Netting_Factor_ = 0
       OR Netting_Factor_ IS NULL THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'NETFACTNULL: Netting factor has not been set. There is no constsant parameter WSK10011.');
    END IF;
    --warning
    IF Salary_Direct_ THEN
      --
      Calc_Param_Value1_ := Nvl(Calc_Param_Value1_, 0) + Nvl(Salary_Value_, 0);
      --
      Avg_Rate_ := Nvl(Calc_Param_Value1_, 0) + Nvl(Calc_Param_Value1_, 0) * Netting_Factor_;
    ELSE
      Avg_Rate_ := Nvl(Calc_Param_Value1_, 0) + Nvl(Calc_Param_Value1_, 0) * Netting_Factor_;
    END IF;
    --
    Avg_Rate_ := Avg_Rate_ / 30;
    Avg_Rate_ := Round(Avg_Rate_, 2);
    --
    -- validation of value
    IF Avg_Rate_ < 0 THEN
      Error_Sys.Appl_General(Lu_Name_, 'ALTERVALID3: Alternative value  :P1 cannot be less than 0',
                             Avg_Rate_);
    END IF;
    --
    Salary_Value_For_Valid_ := Salary_Value_For_Valid_ -
                               Salary_Value_For_Valid_ * Threshold_Fix_Nf_;
    Threshold_Factor_Calc_  := Abs((Avg_Rate_ * 30) - Salary_Value_For_Valid_) /
                               Salary_Value_For_Valid_;
    --
    --
    Plain_Text_ := 'Calculated value differ from salary value on ' ||
                   To_Char(Threshold_Factor_Calc_, '90.00') || ' %';
    --
    IF Threshold_Factor_Calc_ > Threshold_Factor_Max_ THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'ALTERVALID4: Alternative value safe factor :P1 is greater than threshold value :P2',
                             To_Char(Threshold_Factor_Calc_, '90.0000'),
                             To_Char(Threshold_Factor_Max_, '90.0000'));
    END IF;
    --
    RETURN Avg_Rate_;
    --
  END Zpk_Get_Alternative_Value___;
  FUNCTION Get_Baias_Data____(Company_Id_ IN VARCHAR2) RETURN BOOLEAN IS
    --
    Record_Mark_ VARCHAR2(1) := ';';
    Item_Mark_   VARCHAR2(2) := '->';
    --
    Wc_Baias_List_ VARCHAR2(2000);
    Part_          VARCHAR2(200);
    m_Wc_          VARCHAR2(20);
    s_Wc_          VARCHAR2(20);
    --
    From_ NUMBER;
    To_   NUMBER;
    Sep_  NUMBER;
    --
  BEGIN
    -- check process mode of current wage code
    -- for full retro mode accept values below 0
    --
    Baias_Tab_.Delete;
    --
    IF Nvl(Hrp_Regulation_Api.Get_Value_Null(Company_Id_, 'Z019', SYSDATE), 0) = 1 THEN
      Wc_Baias_List_ := Hrp_Regulation_Api.Get_Name(Company_Id_, 'Z019');
      -- check last mark
      -- example 10010P->10011P;
      IF Substr(Wc_Baias_List_, -1, 1) <> Record_Mark_ THEN
        Wc_Baias_List_ := Wc_Baias_List_ || Record_Mark_;
      END IF;
      --
      From_ := 1;
      To_   := Instr(Wc_Baias_List_, Record_Mark_, From_, 1);
      WHILE To_ > 0 LOOP
        Part_ := Substr(Wc_Baias_List_, From_, To_ - From_ + 1);
        Sep_  := Instr(Part_, Item_Mark_, From_, 1);
        m_Wc_ := Substr(Wc_Baias_List_, From_, Sep_ - From_);
        s_Wc_ := Substr(Wc_Baias_List_, Sep_ + Length(Item_Mark_), To_ - Sep_ - Length(Item_Mark_));
        -- validation
        Hrp_Wage_Code_Api.Exist(Company_Id_, m_Wc_);
        Hrp_Wage_Code_Api.Exist(Company_Id_, s_Wc_);
        -- registration
        IF NOT Baias_Tab_.Exists(s_Wc_) THEN
          Baias_Tab_(s_Wc_) := m_Wc_;
        END IF;
        --
        From_ := To_ + 1;
        To_   := Instr(Wc_Baias_List_, Record_Mark_, From_, 1);
      END LOOP;
      --
      RETURN TRUE;
    END IF;
    --
    RETURN FALSE;
  EXCEPTION
    WHEN OTHERS THEN
      Error_Sys.Record_General(Lu_Name_,
                               'WAGECODELIST: Baias wage code list error during preparation internal table :P1',
                               Substr(SQLERRM, 1, 200));
  END Get_Baias_Data____;
  FUNCTION Zpk_Calc_Details_Net_Factor___(Mode_            IN VARCHAR2,
                                          Itab_            IN OUT NOCOPY t_Net_Factor_Tab,
                                          Zpk_Log_Tab_     IN OUT t_Log_Tab,
                                          Company_Id_      IN VARCHAR2,
                                          Emp_No_          IN VARCHAR2,
                                          Absence_Id_      IN VARCHAR2,
                                          Payroll_List_Id_ IN VARCHAR2,
                                          Seq_             IN NUMBER,
                                          Period_Seq_      IN NUMBER,
                                          Calc_Type_       IN VARCHAR2,
                                          Wc_Group_        IN VARCHAR2,
                                          Date_From_       IN DATE,
                                          Wage_Code_Id_    IN VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    --
    i_ NUMBER;
    j_ NUMBER;
    --
    Info_       VARCHAR2(2000);
    Attr_       VARCHAR2(2000);
    Objid_      VARCHAR2(50);
    Objversion_ VARCHAR2(2000);
    --
    Cumulated_Net_Factor_ NUMBER;
    Cumulated_Value_      NUMBER;
    Contribution_         NUMBER;
    Base_                 NUMBER;
    --
    Original_Net_Factor_ NUMBER;
    Netting_Factor_      NUMBER;
    --
    Plain_Text_      VARCHAR2(2000);
    Temp_Rec_        t_Net_Factor;
    Prev_Period_Seq_ NUMBER;
    Prev_Date_From_  DATE;
    --
    CURSOR Get_Wc_(Wc_Group_ IN VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Company_Id_
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
    --
  BEGIN
    IF Mode_ = 1 THEN
      --
      i_ := Itab_.First;
      WHILE (i_ IS NOT NULL) LOOP
        IF Itab_(i_).Calc_Type <> Calc_Type_
            OR Itab_(i_).Wc_Group <> Wc_Group_
            OR Itab_(i_).Wage_Code_Id <> Wage_Code_Id_
            OR Itab_(i_).Period_Seq <> Period_Seq_
            OR Itab_(i_).Date_From <> Date_From_ THEN
          i_ := Itab_.Next(i_);
          Continue;
        END IF;
        j_                    := Itab_(i_).Details.First;
        Cumulated_Net_Factor_ := NULL;
        Cumulated_Value_      := NULL;
        Contribution_         := NULL;
        Base_                 := NULL;
        WHILE (j_ IS NOT NULL) LOOP
          IF Itab_(i_).Details(j_).Base IS NOT NULL
              AND Itab_(i_).Details(j_).Base <> 0 THEN
            -- PAKOCA Path 170801
            --base_                 := nvl(base_,0) + itab_(i_).details(j_).base;
            --contribution_         := nvl(contribution_,0) + itab_(i_).details(j_).contribution;
            Base_         := Itab_(i_).Details(j_).Base;
            Contribution_ := Nvl(Itab_(i_).Details(j_).Contribution, 0);
            IF Itab_(i_).Details(j_).Value < 0 THEN
              Cumulated_Net_Factor_ := Nvl(Cumulated_Net_Factor_, 0) + 0 * (Contribution_ / Base_);
              Cumulated_Value_      := Nvl(Cumulated_Value_, 0) + 0;
            ELSE
              Cumulated_Net_Factor_ := Nvl(Cumulated_Net_Factor_, 0) + Itab_(i_).Details(j_)
                                      .Value * (Contribution_ / Base_);
              Cumulated_Value_      := Nvl(Cumulated_Value_, 0) + Itab_(i_).Details(j_).Value;
            END IF;
            --cumulated_value_ := nvl(cumulated_value_,0) + itab_(i_).details(j_).value;
          ELSE
            --
            Plain_Text_           := 'There is null base or contribution in array for wage code ' ||
                                     Wage_Code_Id_ || ' in period ' || Period_Seq_;
            Cumulated_Net_Factor_ := NULL;
            EXIT;
          END IF;
          j_ := Itab_(i_).Details.Next(j_);
        END LOOP;
        --
        -- for temporary storage
        IF Cumulated_Net_Factor_ = 0
           OR Cumulated_Net_Factor_ IS NULL THEN
          Netting_Factor_ := 0;
        ELSE
          Netting_Factor_ := Round(Cumulated_Net_Factor_ / Cumulated_Value_, 4) * -1;
        END IF;
        Itab_(i_).Accurate_Net_Factor := Netting_Factor_;
        -- for presentation purpose only
        IF Netting_Factor_ IS NULL THEN
          -- warrning should be raised
          Plain_Text_ := 'There is null accurate netting for wage code ' || Wage_Code_Id_ ||
                         ' in period ' || Period_Seq_;
        END IF;
        Netting_Factor_ := Nvl(Netting_Factor_, 0);
        EXIT;
      END LOOP;
      --
      RETURN Netting_Factor_;
      --
    ELSIF Mode_ = 2 THEN
      -- for periodical base this calculation will be repedted as many time as wage codes is in the group
      Cumulated_Net_Factor_ := NULL;
      Cumulated_Value_      := NULL;
      i_                    := Itab_.First;
      IF i_ IS NOT NULL THEN
        Cumulated_Net_Factor_ := 0;
        Cumulated_Value_      := 0;
        WHILE (i_ IS NOT NULL) LOOP
          --IF itab_(i_).period_seq <> period_seq_ THEN
          IF Calc_Type_ = 'MONTHLY' THEN
            IF Itab_(i_).Calc_Type <> Calc_Type_
                OR Itab_(i_).Period_Seq <> Period_Seq_ THEN
              i_ := Itab_.Next(i_);
              Continue;
            END IF;
          ELSE
            IF Itab_(i_).Calc_Type <> Calc_Type_
                OR
               --itab_(i_).wc_group <> wc_group_ OR
               Itab_(i_).Period_Seq <> Period_Seq_
                OR Itab_(i_).Date_From <> Date_From_ THEN
              i_ := Itab_.Next(i_);
              Continue;
            END IF;
          END IF;
          --
          IF Itab_(i_).Summarised_Value < 0 THEN
            Cumulated_Net_Factor_ := Cumulated_Net_Factor_ + 0 * 0;
            Cumulated_Value_      := Cumulated_Value_ + 0;
          ELSE
            Cumulated_Net_Factor_ := Cumulated_Net_Factor_ + Itab_(i_)
                                    .Accurate_Net_Factor * Itab_(i_).Summarised_Value;
            Cumulated_Value_      := Cumulated_Value_ + Itab_(i_).Summarised_Value;
          END IF;
          --
          Itab_(i_).Gr_Net_Factor := Round(Cumulated_Net_Factor_ / Cumulated_Value_, 4);
          --
          i_ := Itab_.Next(i_);
        END LOOP;
        --
        IF (Cumulated_Value_ = 0 OR Cumulated_Value_ IS NULL)
           AND (Cumulated_Net_Factor_ IS NOT NULL AND Cumulated_Net_Factor_ <> 0) THEN
          Error_Sys.Appl_General(Lu_Name_,
                                 'ACCURATENULLDEV: Cumulated value is equal 0 for base :P1 in period :P2 and wage code group :P3',
                                 Calc_Type_, Date_From_, Wc_Group_);
        END IF;
        --
        IF Cumulated_Net_Factor_ IS NOT NULL
           AND Cumulated_Net_Factor_ <> 0 THEN
          Cumulated_Net_Factor_ := Round(Cumulated_Net_Factor_ / Cumulated_Value_, 4);
        END IF;
        -- sunchronize all wage code for processing type
        i_ := Itab_.First;
        WHILE (i_ IS NOT NULL) LOOP
          IF Calc_Type_ = 'MONTHLY' THEN
            IF Itab_(i_).Calc_Type = Calc_Type_
                AND Itab_(i_).Period_Seq = Period_Seq_ THEN
              Itab_(i_).Gr_Net_Factor := Cumulated_Net_Factor_;
            END IF;
          ELSE
            IF Itab_(i_).Calc_Type = Calc_Type_
                AND
               --itab_(i_).wc_group = wc_group_ AND
               Itab_(i_).Period_Seq = Period_Seq_
                AND Itab_(i_).Date_From = Date_From_ THEN
              Itab_(i_).Gr_Net_Factor := Cumulated_Net_Factor_;
            END IF;
          END IF;
          i_ := Itab_.Next(i_);
        END LOOP;
      END IF;
      --
      IF Calc_Type_ IN ('MONTHLY') THEN
        Original_Net_Factor_ := Hrp_Abs_Calc_Month_Api.Get_Netting_Factor(Company_Id_, Emp_No_,
                                                                          Absence_Id_, Seq_,
                                                                          Period_Seq_);
        Hrp_Abs_Calc_Month_Api.Get_Id_Version_By_Key(Objid_, Objversion_, Company_Id_, Emp_No_,
                                                     Absence_Id_, Seq_, Period_Seq_);
      ELSE
        Original_Net_Factor_ := Hrp_Abs_Calc_Other_Api.Get_Netting_Factor(Company_Id_, Emp_No_,
                                                                          Absence_Id_, Seq_,
                                                                          Period_Seq_, Date_From_,
                                                                          Calc_Type_);
        Hrp_Abs_Calc_Other_Api.Get_Id_Version_By_Key(Objid_, Objversion_, Company_Id_, Emp_No_,
                                                     Absence_Id_, Seq_, Period_Seq_, Date_From_,
                                                     Calc_Type_);
      END IF;
      -- storage
      IF Cumulated_Net_Factor_ IS NOT NULL THEN
        --
        IF Objid_ IS NOT NULL
           AND Objversion_ IS NOT NULL THEN
          Client_Sys.Clear_Attr(Attr_);
          IF Cumulated_Net_Factor_ <> Original_Net_Factor_
             OR (Original_Net_Factor_ IS NULL AND Cumulated_Net_Factor_ IS NOT NULL) THEN
            -- too many warnings, deep change in configuration of wage code group is necessary
            -- Zpk_Warrning_Add___(company_id_,emp_no_,payroll_list_id_,GL_WARRNING_05_,'42000',n01_ => original_net_factor_,s01_ => '');
            Client_Sys.Add_To_Attr('DESCRIPTION',
                                   'ZpkAccurateCalculation original value ' ||
                                    To_Char(Nvl(Original_Net_Factor_, 0), '00.0000'), Attr_);
          ELSE
            Client_Sys.Add_To_Attr('DESCRIPTION', 'ZpkAccurateCalculation', Attr_);
          END IF;
          Client_Sys.Add_To_Attr('NETTING_FACTOR', Cumulated_Net_Factor_, Attr_);
          IF Calc_Type_ IN ('MONTHLY') THEN
            Hrp_Abs_Calc_Month_Api.Modify__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
          ELSE
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
          END IF;
          --
          --
        END IF;
      ELSE
        IF Nvl(Original_Net_Factor_, 0) <> 0 THEN
          NULL;
        END IF;
        -- raise error for not update netting factor
        IF Nvl(Cumulated_Value_, 0) <> 0 THEN
          IF Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z017', SYSDATE),
                 1) = 1 THEN
            Error_Sys.Appl_General(Lu_Name_,
                                   'NULLCUMNETFACTOR: Calculated netting factor is null for :P1 in period :P2 and wage code group :P3',
                                   Calc_Type_, Date_From_, Wc_Group_);
          END IF;
        END IF;
        --
      END IF;
      --
      RETURN Nvl(Cumulated_Net_Factor_, 0);
      --
    ELSIF Mode_ = 3 THEN
      --
      RETURN 0;
      --
    ELSE
      --
      RETURN 0;
      --
    END IF;
  END Zpk_Calc_Details_Net_Factor___;
  PROCEDURE Zpk_Add_Details_Net_Factor___(Itab_                   IN OUT NOCOPY t_Net_Factor_Tab,
                                          Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                          Company_Id_             IN VARCHAR2,
                                          Emp_No_                 IN VARCHAR2,
                                          Payroll_List_Id_        IN VARCHAR2,
                                          Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                                          Wc_Group_               IN VARCHAR2,
                                          Wc_Bias_Group_          IN VARCHAR2,
                                          Gr_Contribution_        IN VARCHAR2,
                                          Gr_Base_                IN VARCHAR2,
                                          Calc_Type_              IN VARCHAR2,
                                          Wc_Type_                IN VARCHAR2,
                                          --
                                          Current_List_     IN BOOLEAN,
                                          Wage_Code_Id_     IN Hrp_Wc_Archive_Tab.Wage_Code_Id%TYPE,
                                          Summarised_Value_ IN Hrp_Wc_Archive_Tab.Summarised_Value%TYPE,
                                          Period_Seq_       IN Hrp_Abs_Calc_Month_Tab.Period_Seq%TYPE,
                                          Date_From_        IN Hrp_Abs_Calc_Month_Tab.Date_From%TYPE,
                                          Date_To_          IN Hrp_Abs_Calc_Month_Tab.Date_To%TYPE,
                                          Arythm_Sign_      IN Calculation_Group_Members_Tab.Arythm_Sign%TYPE,
                                          --
                                          Validation_Date_ IN DATE DEFAULT NULL) IS
    --
    i_ NUMBER;
    j_ NUMBER;
    --
    Value_      NUMBER;
    Value_Tmp_  NUMBER;
    Tax_Period_ DATE;
    --
    CURSOR Get_Wc_Det1_ IS
      SELECT t.*
        FROM Hrp_Wc_Archive_Tab t
       WHERE Company_Id = Company_Id_
         AND ((Validation_Date BETWEEN Date_From_ AND Date_To_ AND Calc_Type_ IN ('MONTHLY')) OR
             (Trunc(Validation_Date, 'MONTH') = Trunc(Validation_Date_, 'MONTH') AND
             Calc_Type_ IN ('QUARTERLY', 'YEARLY', 'M4MONTHLY')))
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_;
    CURSOR Get_Wc_Det2_(Wage_Code_Id_ VARCHAR2, Tax_Year_ NUMBER, Tax_Month_ NUMBER) IS
      SELECT t.*
        FROM Hrp_Wc_Archive_Tab t
       WHERE Company_Id = Company_Id_
         AND Tax_Year = Tax_Year_
         AND Tax_Month = Tax_Month_
            --AND   validation_date BETWEEN data_from_ AND data_to_
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_;
    CURSOR Get_Wc_(Wc_Group_ IN VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Company_Id_
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
  BEGIN
    -- for archive value allway take new position for new wage code
    i_ := NULL;
    IF NOT Current_List_ THEN
      -- only for long term wage code
      IF Calc_Type_ IN ('QUARTERLY', 'YEARLY', 'M4MONTHLY') THEN
        i_ := Itab_.First;
        WHILE (i_ IS NOT NULL) LOOP
          IF Itab_(i_).Calc_Type = Calc_Type_
              AND Itab_(i_).Wc_Group = Wc_Type_
              AND Itab_(i_).Period_Seq = Period_Seq_
              AND Itab_(i_).Date_From = Date_From_
              AND Itab_(i_).Wage_Code_Id = Wage_Code_Id_ THEN
            EXIT;
          END IF;
          i_ := Itab_.Next(i_);
        END LOOP;
      END IF;
      -- if not found take next position
      IF i_ IS NULL THEN
        i_ := Nvl(Itab_.Last, 0) + 1;
      END IF;
      --
      Itab_(i_).Calc_Type := Calc_Type_;
      Itab_(i_).Wc_Group := Wc_Type_;
      Itab_(i_).Period_Seq := Period_Seq_;
      Itab_(i_).Date_From := Date_From_;
      Itab_(i_).Date_To := Date_To_;
      Itab_(i_).Wage_Code_Id := Wage_Code_Id_;
      Itab_(i_).Summarised_Value := Summarised_Value_ * Arythm_Sign_;
      Itab_(i_).Accurate_Net_Factor := NULL;
      --
    ELSE
      -- add heder with agregated wage code value
      -- for current list value check if any archive wage code has been found
      i_ := Itab_.First;
      WHILE (i_ IS NOT NULL) LOOP
        IF Itab_(i_).Calc_Type = Calc_Type_
            AND Itab_(i_).Wc_Group = Wc_Type_
            AND Itab_(i_).Period_Seq = Period_Seq_
            AND Itab_(i_).Date_From = Date_From_
            AND Itab_(i_).Wage_Code_Id = Wage_Code_Id_ THEN
          EXIT;
        END IF;
        i_ := Itab_.Next(i_);
      END LOOP;
      -- if not found take next position
      IF i_ IS NULL THEN
        i_ := Nvl(Itab_.Last, 0) + 1;
        Itab_(i_).Summarised_Value := Summarised_Value_ * Arythm_Sign_;
      ELSE
        Itab_(i_).Summarised_Value := Itab_(i_)
                                      .Summarised_Value + Nvl(Summarised_Value_ * Arythm_Sign_, 0);
      END IF;
      --
      Itab_(i_).Calc_Type := Calc_Type_;
      Itab_(i_).Wc_Group := Wc_Type_;
      Itab_(i_).Period_Seq := Period_Seq_;
      Itab_(i_).Date_From := Date_From_;
      Itab_(i_).Date_To := Date_To_;
      Itab_(i_).Wage_Code_Id := Wage_Code_Id_;
      --
      Itab_(i_).Accurate_Net_Factor := NULL;
    END IF;
    --
    -- add details with splited contribution
    IF NOT Current_List_ THEN
      -- for archive value
      FOR Wc_Rec_Det_ IN Get_Wc_Det1_ LOOP
        j_ := Nvl(Itab_(i_).Details.Last, 0) + 1;
        Itab_(i_).Details(j_).Value := Wc_Rec_Det_.Summarised_Value * Arythm_Sign_;
        Itab_(i_).Details(j_).Tax_Year := Wc_Rec_Det_.Tax_Year;
        Itab_(i_).Details(j_).Tax_Month := Wc_Rec_Det_.Tax_Month;
        Itab_(i_).Details(j_).Current_List := Current_List_;
        --itab_(i_).details(j_).payroll_list_id  := wc_rec_det_.payroll_list_id;
        -- calculate contribution
        Value_ := 0;
        FOR Wc_Rec_ IN Get_Wc_(Gr_Contribution_) LOOP
          FOR Wc_Rec_Net_ IN Get_Wc_Det2_(Wc_Rec_.Wage_Code_Id, Wc_Rec_Det_.Tax_Year,
                                          Wc_Rec_Det_.Tax_Month) LOOP
            Value_Tmp_ := Wc_Rec_Net_.Summarised_Value * Wc_Rec_.Arythm_Sign;
            -- do not classify wage code with return for contribution for accurated calculation?
            --IF value_tmp_ >= 0 THEN
            Value_ := Value_ + Value_Tmp_;
            --END IF;
          END LOOP;
        END LOOP;
        Itab_(i_).Details(j_).Contribution := Value_;
        -- calculate base
        Value_ := 0;
        FOR Wc_Rec_ IN Get_Wc_(Gr_Base_) LOOP
          FOR Wc_Rec_Net_ IN Get_Wc_Det2_(Wc_Rec_.Wage_Code_Id, Wc_Rec_Det_.Tax_Year,
                                          Wc_Rec_Det_.Tax_Month) LOOP
            Value_Tmp_ := Wc_Rec_Net_.Summarised_Value * Wc_Rec_.Arythm_Sign;
            -- do not classify wage code with return for base for accurated calculation?
            --IF value_tmp_ >= 0 THEN
            Value_ := Value_ + Value_Tmp_;
            --END IF;
          END LOOP;
        END LOOP;
        Itab_(i_).Details(j_).Base := Value_;
      END LOOP;
    ELSE
      -- for current list
      Tax_Period_ := To_Date(Hrp_Pay_List_Api.Get_Tax_Period(Company_Id_, Payroll_List_Id_),
                             'YYYYMM');
      --
      j_ := Nvl(Itab_(i_).Details.Last, 0) + 1;
      Itab_(i_).Details(j_).Value := Summarised_Value_;
      Itab_(i_).Details(j_).Tax_Year := To_Number(To_Char(Tax_Period_, 'YYYY'));
      Itab_(i_).Details(j_).Tax_Month := To_Number(To_Char(Tax_Period_, 'MM'));
      Itab_(i_).Details(j_).Current_List := Current_List_;
      --itab_(i_).details(j_).payroll_list_id  := payroll_list_id_;
      -- calculate contribution
      Value_ := 0;
      FOR Wc_Rec_ IN Get_Wc_(Gr_Contribution_) LOOP
        --value_tmp_ := Hrp_Pl_Wc_Value_API.Get_Value_Adv1(date_to_,wc_rec_.wage_code_id,2,date_from_,wage_code_elements_tab_ ) * wc_rec_.arythm_sign;
        Value_Tmp_ := Hrp_Pl_Wc_Value_Api.Get_Value_Adv1(Database_Sys.Get_Last_Calendar_Date,
                                                         Wc_Rec_.Wage_Code_Id, 2,
                                                         Database_Sys.Get_First_Calendar_Date,
                                                         Wage_Code_Elements_Tab_) *
                      Wc_Rec_.Arythm_Sign;
        -- do not classify wage code with return for contribution for accurated calculation?
        --IF value_tmp_ >= 0 THEN
        Value_ := Value_ + Value_Tmp_;
        --END IF;
      END LOOP;
      Itab_(i_).Details(j_).Contribution := Value_;
      -- calculate base
      Value_ := 0;
      FOR Wc_Rec_ IN Get_Wc_(Gr_Base_) LOOP
        Value_Tmp_ := Hrp_Pl_Wc_Value_Api.Get_Value_Adv1(Database_Sys.Get_Last_Calendar_Date,
                                                         Wc_Rec_.Wage_Code_Id, 2,
                                                         Database_Sys.Get_First_Calendar_Date,
                                                         Wage_Code_Elements_Tab_) *
                      Wc_Rec_.Arythm_Sign;
        -- do not classify wage code with return for base for accurated calculation?
        --IF value_tmp_ >= 0 THEN
        Value_ := Value_ + Value_Tmp_;
        --END IF;
      END LOOP;
      Itab_(i_).Details(j_).Base := Value_;
    END IF;
  END Zpk_Add_Details_Net_Factor___;
  PROCEDURE Zpk_Recalc_Baias___(Itab_        IN OUT NOCOPY t_Net_Factor_Tab,
                                Company_Id_  IN VARCHAR2,
                                Emp_No_      IN VARCHAR2,
                                Payroll_Rec_ IN Hrp_Pay_List_Api.Public_Rec,
                                Calc_Type_   IN VARCHAR2,
                                Wc_Type_     IN VARCHAR2,
                                Period_Seq_  IN Hrp_Abs_Calc_Month_Tab.Period_Seq%TYPE,
                                Date_From_   IN Hrp_Abs_Calc_Month_Tab.Date_From%TYPE,
                                Date_To_     IN Hrp_Abs_Calc_Month_Tab.Date_To%TYPE) IS
    Master_Wage_Code_ VARCHAR2(20);
    --
    Temp_Tax_Year_     NUMBER;
    Temp_Tax_Month_    NUMBER;
    Temp_Value_        NUMBER;
    Temp_Remain_Value_ NUMBER;
    --
    To_Recalculated_      BOOLEAN;
    Base_                 NUMBER;
    Contribution_         NUMBER;
    Cumulated_Net_Factor_ NUMBER;
    Cumulated_Value_      NUMBER;
    Netting_Factor_       NUMBER;
    --
    i_  NUMBER;
    j_  NUMBER;
    Ii_ NUMBER;
    Jj_ NUMBER;
  BEGIN
    --
    -- check if wage code is baias mode and correct recalculated wage code value for pair wage code
    -- for particular functionality, baias wage have to be collected after regular one
    --
    i_ := Itab_.First;
    WHILE (i_ IS NOT NULL) LOOP
      IF Itab_(i_).Calc_Type = Calc_Type_
          AND Itab_(i_).Wc_Group = Wc_Type_
          AND Itab_(i_).Period_Seq = Period_Seq_
          AND Itab_(i_).Date_From = Date_From_
          AND Baias_Tab_.Exists(Itab_(i_).Wage_Code_Id) THEN
        -- get all item where value is less then 0 from tax separated deatails
        --
        -- register master wage code for pair searcheing
        Master_Wage_Code_ := Baias_Tab_(Itab_(i_).Wage_Code_Id);
        --
        Temp_Remain_Value_ := 0;
        --
        j_ := Itab_(i_).Details.First;
        WHILE (j_ IS NOT NULL) LOOP
          IF Itab_(i_).Details(j_).Value < 0 THEN
            --
            Temp_Tax_Year_     := Itab_(i_).Details(j_).Tax_Year;
            Temp_Tax_Month_    := Itab_(i_).Details(j_).Tax_Month;
            Temp_Remain_Value_ := Itab_(i_).Details(j_).Value + Temp_Remain_Value_;
            --
            Ii_ := Itab_.First;
            WHILE (Ii_ IS NOT NULL) LOOP
              IF Itab_(Ii_).Calc_Type = Calc_Type_
                  AND Itab_(Ii_).Wc_Group = Wc_Type_
                  AND Itab_(Ii_).Period_Seq = Period_Seq_
                  AND Itab_(Ii_).Date_From = Date_From_
                  AND Itab_(Ii_).Wage_Code_Id = Master_Wage_Code_ -- get master wage code id
               THEN
                To_Recalculated_ := FALSE;
                --
                Jj_ := Itab_(Ii_).Details.First;
                WHILE (Jj_ IS NOT NULL) LOOP
                  IF Itab_(Ii_).Details(Jj_).Tax_Year = Temp_Tax_Year_
                      AND Itab_(Ii_).Details(Jj_).Tax_Month = Temp_Tax_Month_
                      AND Itab_(Ii_).Details(Jj_).Value > 0
                      AND Temp_Remain_Value_ < 0 THEN
                    -- store ogigin value
                    IF Itab_(Ii_).Details(Jj_).Origin_Value IS NULL THEN
                      Itab_(Ii_).Details(Jj_).Origin_Value := Itab_(Ii_).Details(Jj_).Value;
                    END IF;
                    --
                    To_Recalculated_ := TRUE;
                    --
                    Temp_Value_ := 0;
                    --
                    IF Itab_(Ii_).Details(Jj_).Value + Temp_Remain_Value_ > 0 THEN
                      Temp_Value_        := Temp_Remain_Value_;
                      Temp_Remain_Value_ := 0;
                      --
                      Itab_(Ii_).Details(Jj_).Value := Itab_(Ii_).Details(Jj_).Value + Temp_Value_;
                    ELSE
                      Temp_Value_        := Itab_(Ii_).Details(Jj_).Value;
                      Temp_Remain_Value_ := Temp_Remain_Value_ + Temp_Value_;
                      --
                      Itab_(Ii_).Details(Jj_).Value := 0;
                    END IF;
                    --
                    Dbms_Output.Put_Line(Jj_ || ' ' || Itab_(Ii_).Details(Jj_).Origin_Value || ' ' || Itab_(Ii_).Details(Jj_)
                                         .Value || ' ' || Nvl(Temp_Remain_Value_, 0));
                    --
                    IF Temp_Remain_Value_ = 0 THEN
                      EXIT;
                    END IF;
                  END IF;
                  Jj_ := Itab_(Ii_).Details.Next(Jj_);
                END LOOP;
                -- recalculate cumulated netting factor for all items of particular wage code (first level)
                -- all neccesary value has been already updated
                IF To_Recalculated_ THEN
                  Jj_ := Itab_(Ii_).Details.First;
                  WHILE (Jj_ IS NOT NULL) LOOP
                    IF Nvl(Itab_(Ii_).Details(Jj_).Base, 0) <> 0 THEN
                      Base_         := Itab_(Ii_).Details(Jj_).Base;
                      Contribution_ := Nvl(Itab_(Ii_).Details(Jj_).Contribution, 0);
                      IF Itab_(Ii_).Details(Jj_).Value < 0 THEN
                        Cumulated_Net_Factor_ := Nvl(Cumulated_Net_Factor_, 0) +
                                                 0 * (Contribution_ / Base_);
                        Cumulated_Value_      := Nvl(Cumulated_Value_, 0) + 0;
                      ELSE
                        Cumulated_Net_Factor_ := Nvl(Cumulated_Net_Factor_, 0) + Itab_(Ii_).Details(Jj_)
                                                .Value * (Contribution_ / Base_);
                        Cumulated_Value_      := Nvl(Cumulated_Value_, 0) + Itab_(Ii_).Details(Jj_)
                                                .Value;
                      END IF;
                    ELSE
                      Cumulated_Net_Factor_ := NULL;
                    END IF;
                    --
                    Jj_ := Itab_(Ii_).Details.Next(Jj_);
                  END LOOP;
                  -- register recalculate netting factor
                  IF Cumulated_Net_Factor_ = 0
                     OR Cumulated_Net_Factor_ IS NULL THEN
                    Netting_Factor_ := 0;
                  ELSE
                    Netting_Factor_ := Round(Cumulated_Net_Factor_ / Cumulated_Value_, 4) * -1;
                  END IF;
                  --
                  Itab_(Ii_).Accurate_Net_Factor := Netting_Factor_;
                END IF;
                -- close performing the wage code, wage code can be registered only one
                EXIT;
              END IF;
              Ii_ := Itab_.Next(Ii_);
            END LOOP;
          END IF;
          --
          j_ := Itab_(i_).Details.Next(j_);
        END LOOP;
      END IF;
      --
      i_ := Itab_.Next(i_);
    END LOOP;
  END Zpk_Recalc_Baias___;
  FUNCTION Copy_Base_Other___(Company_Id_   IN VARCHAR2,
                              Emp_No_       IN VARCHAR2,
                              Absence_Id_   IN VARCHAR2,
                              Base_Type_    IN VARCHAR2,
                              Abs_Base_Seq_ IN NUMBER,
                              Target_Seq_   IN NUMBER) RETURN NUMBER IS
    Info_         VARCHAR2(2000);
    Objid_        VARCHAR2(2000);
    Objversion_   VARCHAR2(2000);
    Attr_         VARCHAR2(2000);
    Header_Added_ VARCHAR2(2000) := 'FALSE';
    CURSOR Source_Base_Header_ IS
      SELECT *
        FROM Hrp_Abs_Calc_Base_Tab t
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Abs_Base_Seq_;
    CURSOR Source_Other_ IS
      SELECT *
        FROM Hrp_Abs_Calc_Other_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Abs_Base_Seq_
         AND Hrp_Abs_Calc_Other_Type = Base_Type_;
    CURSOR Source_Other_Det_(Period_Seq_ NUMBER, Date_From_ DATE, Type_ VARCHAR2) IS
      SELECT *
        FROM Hrp_Abs_Calc_Other_Wc_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Abs_Base_Seq_
         AND Period_Seq = Period_Seq_
         AND Date_From = Date_From_
         AND Hrp_Abs_Calc_Other_Type = Type_;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Copy_Base_Other___');
    FOR h_Rec_ IN Source_Base_Header_ LOOP
      Header_Added_ := 'TRUE';
      FOR o_Rec_ IN Source_Other_ LOOP
        Client_Sys.Clear_Attr(Attr_);
        Client_Sys.Add_To_Attr('COMPANY_ID', h_Rec_.Company_Id, Attr_);
        Client_Sys.Add_To_Attr('EMP_NO', h_Rec_.Emp_No, Attr_);
        Client_Sys.Add_To_Attr('ABSENCE_ID', h_Rec_.Absence_Id, Attr_);
        Client_Sys.Add_To_Attr('SEQ', Target_Seq_, Attr_);
        Client_Sys.Add_To_Attr('PERIOD_SEQ', o_Rec_.Period_Seq, Attr_);
        Client_Sys.Add_To_Attr('DATE_FROM', o_Rec_.Date_From, Attr_);
        Client_Sys.Add_To_Attr('DATE_TO', o_Rec_.Date_To, Attr_);
        Client_Sys.Add_To_Attr('WORKING_DAYS', o_Rec_.Working_Days, Attr_);
        Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', o_Rec_.Norma_Working_Days, Attr_);
        Client_Sys.Add_To_Attr('MONTHS_IN_PERIOD', o_Rec_.Months_In_Period, Attr_);
        Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                               Hrp_Abs_Calc_Other_Type_Api.Decode(o_Rec_.Hrp_Abs_Calc_Other_Type),
                               Attr_);
        Client_Sys.Add_To_Attr('SELECTED', o_Rec_.Selected, Attr_);
        Client_Sys.Add_To_Attr('DESCRIPTION', o_Rec_.Description, Attr_);
        Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', o_Rec_.Gross_Base_Value, Attr_);
        Client_Sys.Add_To_Attr('NETTING_FACTOR', o_Rec_.Netting_Factor, Attr_);
        Client_Sys.Add_To_Attr('NET_BASE_VALUE', o_Rec_.Net_Base_Value, Attr_);
        Client_Sys.Add_To_Attr('COR_VALUE', o_Rec_.Cor_Value, Attr_);
        Hrp_Abs_Calc_Other_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        FOR Od_Rec_ IN Source_Other_Det_(o_Rec_.Period_Seq, o_Rec_.Date_From,
                                         o_Rec_.Hrp_Abs_Calc_Other_Type) LOOP
          Client_Sys.Clear_Attr(Attr_);
          Client_Sys.Add_To_Attr('COMPANY_ID', h_Rec_.Company_Id, Attr_);
          Client_Sys.Add_To_Attr('EMP_NO', h_Rec_.Emp_No, Attr_);
          Client_Sys.Add_To_Attr('ABSENCE_ID', h_Rec_.Absence_Id, Attr_);
          Client_Sys.Add_To_Attr('SEQ', Target_Seq_, Attr_);
          Client_Sys.Add_To_Attr('PERIOD_SEQ', Od_Rec_.Period_Seq, Attr_);
          Client_Sys.Add_To_Attr('DATE_FROM', Od_Rec_.Date_From, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                                 Hrp_Abs_Calc_Other_Type_Api.Decode(Od_Rec_.Hrp_Abs_Calc_Other_Type),
                                 Attr_);
          Client_Sys.Add_To_Attr('WAGE_CODE_ID', Od_Rec_.Wage_Code_Id, Attr_);
          Client_Sys.Add_To_Attr('VALUE', Od_Rec_.Value, Attr_);
          Client_Sys.Add_To_Attr('SYSTEM_GENERATED', Od_Rec_.System_Generated, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE',
                                 Hrp_Abs_Wc_Type_Api.Decode(Od_Rec_.Hrp_Abs_Wc_Type), Attr_);
          Hrp_Abs_Calc_Other_Wc_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        END LOOP;
      END LOOP;
    END LOOP;
    IF Header_Added_ = 'TRUE' THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END Copy_Base_Other___;
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PROTECTED METHODS --------------------------
  -----------------------------------------------------------------------------
  PROCEDURE Get_Base_4months_Dates_(Company_Id_       IN VARCHAR2,
                                    Calendar_Type_Id_ IN VARCHAR2,
                                    Current_Date_     IN DATE,
                                    Date_From_        OUT DATE,
                                    Date_To_          OUT DATE) IS
    CURSOR Get_First_Period_ IS
      SELECT Date_From, Date_To
        FROM (SELECT Date_From, Add_Months(Date_From, 4) - 1 Date_To
                FROM Hrp_Abs_Base_Cal_Type_Det_Tab
               WHERE Company_Id = Company_Id_
                 AND Calendar_Type_Id = Calendar_Type_Id_
              UNION
              SELECT Add_Months(Date_From, 4), Add_Months(Date_From, 8) - 1 Date_To
                FROM Hrp_Abs_Base_Cal_Type_Det_Tab
               WHERE Company_Id = Company_Id_
                 AND Calendar_Type_Id = Calendar_Type_Id_
              UNION
              SELECT Add_Months(Date_From, 8), Add_Months(Date_From, 12) - 1 Date_To
                FROM Hrp_Abs_Base_Cal_Type_Det_Tab
               WHERE Company_Id = Company_Id_
                 AND Calendar_Type_Id = Calendar_Type_Id_)
       WHERE Current_Date_ BETWEEN Date_From AND Date_To;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Get_Base_4Months_Dates_');
    IF Hrp_Abs_Base_Cal_Type_Api.Get_Standard_Calendar(Company_Id_, Calendar_Type_Id_) = 'TRUE' THEN
      IF (To_Number(To_Char(Trunc((Current_Date_), 'MONTH'), 'MM')) BETWEEN 1 AND 4) THEN
        Date_From_ := Trunc((Current_Date_), 'Y');
        Date_To_   := Add_Months(Trunc((Current_Date_), 'Y'), 4) - 1;
      ELSIF (To_Number(To_Char(Trunc((Current_Date_), 'MONTH'), 'MM')) BETWEEN 5 AND 8) THEN
        Date_From_ := Add_Months(Trunc((Current_Date_), 'Y'), 4);
        Date_To_   := Add_Months(Trunc((Current_Date_), 'Y'), 8) - 1;
      ELSIF (To_Number(To_Char(Trunc((Current_Date_), 'MONTH'), 'MM')) BETWEEN 9 AND 12) THEN
        Date_From_ := Add_Months(Trunc((Current_Date_), 'Y'), 8);
        Date_To_   := Add_Months(Trunc((Current_Date_), 'Y'), 12) - 1;
      END IF;
    ELSE
      OPEN Get_First_Period_;
      FETCH Get_First_Period_
        INTO Date_From_, Date_To_;
      CLOSE Get_First_Period_;
    END IF;
  END Get_Base_4months_Dates_;
  -----------------------------------------------------------------------------
  -------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
  -----------------------------------------------------------------------------
  PROCEDURE Zpk_Set_Pipe_Log(Log_Mode_   IN VARCHAR2 DEFAULT NULL,
                             Company_Id_ IN VARCHAR DEFAULT NULL) IS
    User_          VARCHAR2(30);
    Pipe_Name_     VARCHAR2(30);
    Str_Date_      VARCHAR2(30);
    Rc_            INTEGER;
    Pipe_Size_     INTEGER := 20000; -- bytes
    Synch_Timeout_ INTEGER := 5; -- seconds - 10 min
    Dummy_ VARCHAR2(1);
    CURSOR Exist_Key IS
      SELECT 'X'
        FROM Hrp_Config_Det_Tab
       WHERE Company_Id = Company_Id_
         AND Config_Id = 'TECH'
         AND Seq_No = 1239;
  BEGIN
    User_      := Upper(Substr(Fnd_Session_Api.Get_Fnd_User, 1, 30));
    Pipe_Name_ := 'PAYROLL_LOG_' || User_;
    Str_Date_ := To_Char(SYSDATE, 'YYYYMMDDHH24MISS');
    --remove
    Rc_ := Dbms_Pipe.Remove_Pipe(Pipe_Name_);
    --add new
    IF Log_Mode_ IS NULL THEN
      Dbms_Pipe.Pack_Message('ACTIVESIMPLE');
    ELSIF Log_Mode_ = 'FULL' THEN
      Dbms_Pipe.Pack_Message('ACTIVEFULL');
    ELSE
      Dbms_Pipe.Pack_Message('NOTACTIVE');
    END IF;
    Dbms_Pipe.Pack_Message(Str_Date_);
    Rc_ := Dbms_Pipe.Send_Message(Pipe_Name_, Synch_Timeout_, Pipe_Size_);
    IF (Rc_ = 0) THEN
      --Trace_SYS.Message('. Pipe set corrctly = ' || to_char(rc_));
      OPEN Exist_Key;
      FETCH Exist_Key
        INTO Dummy_;
      IF Exist_Key%NOTFOUND THEN
        CLOSE Exist_Key;
      ELSE
        UPDATE Hrp_Config_Det_Tab t
           SET t.Id          = 1,
               t.Description = REPLACE(t.Description, '<<DisableByParallelCalc>>'),
               t.Rowversion  = SYSDATE
         WHERE Company_Id = Company_Id_
           AND Config_Id = 'TECH'
           AND Seq_No = 1239;
        CLOSE Exist_Key;
      END IF;
    ELSE
      NULL;
      --Trace_SYS.Message('. Pipe set error corrctly = ' || to_char(rc_));
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END Zpk_Set_Pipe_Log;
  PROCEDURE Zpk_Get_Pipe_Log(Out_Log_Mode_ OUT VARCHAR2) IS
    User_         VARCHAR2(30);
    Pipe_Name_    VARCHAR2(30);
    Ld_Send_Date_ VARCHAR2(30);
    Str_Date_     DATE;
    Max_Delta_    NUMBER;
    Lc_Log_Mode_  VARCHAR2(30);
    Rc_           INTEGER;
  BEGIN
    IF Transaction_Sys.Is_Session_Deferred THEN
      Lc_Log_Mode_ := 'NOTACTIVE';
    ELSE
      User_      := Upper(Substr(Fnd_Session_Api.Get_Fnd_User, 1, 30));
      Pipe_Name_ := 'PAYROLL_LOG_' || User_;
      Max_Delta_ := (1 / 24 / 60) * 10;
      --remove
      Rc_ := Dbms_Pipe.Receive_Message(Pipe_Name_, 0);
      IF Rc_ = 0 THEN
        Dbms_Pipe.Unpack_Message(Lc_Log_Mode_);
        Dbms_Pipe.Unpack_Message(Ld_Send_Date_);
        Str_Date_ := To_Date(Ld_Send_Date_, 'YYYYMMDDHH24MISS');
        IF (SYSDATE - Str_Date_) > Max_Delta_ THEN
          Lc_Log_Mode_ := 'NOTACTIVE';
          Dbms_Output.Put_Line('Pipe <<' || Pipe_Name_ || '>> to old');
        ELSE
          Dbms_Output.Put_Line(Lc_Log_Mode_);
          Dbms_Output.Put_Line(Ld_Send_Date_);
          Zpk_Set_Pipe_Log; -- set pipe log again
        END IF;
      END IF;
      --
      Gl_Log_Mode_ := Nvl(Lc_Log_Mode_, 'NOTACTIVE');
      --
      IF (Rc_ = 0) THEN
        NULL;
        --Trace_SYS.Message('. Log mode set from Pipe on ' || gl_log_mode_);
      ELSE
        NULL;
        --Trace_SYS.Message('. Log mode not set. Pipe not found');
      END IF;
      Out_Log_Mode_ := Gl_Log_Mode_;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      Out_Log_Mode_ := NULL;
      Dbms_Output.Put_Line('Rc: ' || Rc_);
      Dbms_Output.Put_Line('Err: ' || Substr(SQLERRM, 1, 200));
  END Zpk_Get_Pipe_Log;
  PROCEDURE Insert_Wage_Codes_4_6(Base_Rec_                IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                                  Period_Seq_              IN NUMBER,
                                  Payroll_Rec_             IN Hrp_Pay_List_Api.Public_Rec,
                                  Payroll_List_Id_         IN VARCHAR2,
                                  Wc_Group_                IN VARCHAR2,
                                  Graced_Period_Date_From_ IN DATE,
                                  Bonus_Date_              IN DATE,
                                  Paid_Way_                IN VARCHAR2,
                                  Wc_Type_                 IN VARCHAR2,
                                  Calc_Type_               IN VARCHAR2,
                                  Wage_Code_Elements_Tab_  IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                  Zpk_Log_Tab_             IN OUT t_Log_Tab,
                                  Gr_Contribution_         IN VARCHAR2,
                                  Gr_Base_                 IN VARCHAR2,
                                  Period_Type_             IN VARCHAR2 DEFAULT 'TRANSACTION',
                                  Include_Payroll_Values_  IN VARCHAR2 DEFAULT 'FALSE') IS
    Info_       VARCHAR2(2000);
    Objid_      VARCHAR2(2000);
    Objversion_ VARCHAR2(2000);
    Attr_       VARCHAR2(2000);
    Attr_Other_ VARCHAR2(2000);
    Value_             NUMBER;
    Val_Grace_Up_      NUMBER;
    Val_Grace_Up_Tmp_  NUMBER;
    From_Date_         DATE;
    To_Date_           DATE;
    Prev_Value_        NUMBER;
    Prev_Net_          NUMBER;
    Value_Ins_         NUMBER;
    Wc_Type_Ins_       VARCHAR2(20);
    Prev_Wage_Code_Id_ Calculation_Group_Members_Tab.Wage_Code_Id%TYPE;
    Last_              NUMBER;
    Period_To_         NUMBER;
    Arch_Tax_Period_   NUMBER;
    Temp_              NUMBER;
    Temp_Adv1_         NUMBER;
    Amount_            NUMBER;
    Wc_Exists_         BOOLEAN;
    Sys_Generated_     VARCHAR2(5);
    Validation_Date_   DATE;
    Is_Last_Period_    BOOLEAN := FALSE;
    --
    Net_Month_ Hrp_Abs_Calc_Month_Tab.Netting_Factor%TYPE;
    -- calc accurate
    Zpk_Nf_Tab_    t_Net_Factor_Tab;
    Calc_Accurate_ BOOLEAN;
    Nf_Copied_     BOOLEAN;
    Dummy_         NUMBER;
    Wc_Bias_Group_ Calculation_Group_Tab.Calc_Group_Id%TYPE;
    --
    CURSOR Insert_To_ IS
      SELECT t.*,
             t.Rowid Objid,
             Ltrim(Lpad(To_Char(Rowversion, 'YYYYMMDDHH24MISS'), 2000)) Objversion
        FROM Hrp_Abs_Calc_Other_Tab t
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Absence_Id = Base_Rec_.Absence_Id
         AND Seq = Base_Rec_.Seq
         AND Hrp_Abs_Calc_Other_Type = Calc_Type_
         AND Period_Seq = Period_Seq_
      --AND selected = 'TRUE'
       ORDER BY Date_From;
    CURSOR Get_Wc_ IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
    CURSOR Exist_Control(Company_Id_   IN VARCHAR2,
                         Emp_No_       IN VARCHAR2,
                         Wage_Code_Id_ IN VARCHAR2,
                         Date_From_    IN DATE,
                         Date_To_      IN DATE) IS
      SELECT 1
        FROM Hrp_Wc_Archive_Tab
       WHERE Company_Id = Company_Id_
         AND Validation_Date BETWEEN Date_From_ AND Date_To_
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_;
    /*    CURSOR Get_Net_Month IS
    SELECT Netting_Factor
      FROM Hrp_Abs_Calc_Month_Tab
     WHERE Company_Id = Base_Rec_.Company_Id
       AND Emp_No = Base_Rec_.Emp_No
       AND Absence_Id = Base_Rec_.Absence_Id
       AND Seq = Base_Rec_.Seq
       AND Date_To = To_Date_;*/
    CURSOR c_(Company_Id_      IN VARCHAR2,
              Emp_No_          IN VARCHAR2,
              Wage_Code_Id_    IN VARCHAR2,
              Date_From_       IN DATE,
              Date_To_         IN DATE,
              Validation_Date_ IN DATE) IS
      SELECT Tax_Year, Tax_Month, Summarised_Value
        FROM Hrp_Wc_Archive_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_
            --AND validation_date BETWEEN date_from_ AND date_to_
         AND Trunc(Validation_Date, 'MONTH') = Trunc(Validation_Date_, 'MONTH')
       ORDER BY Validation_Date DESC;
    CURSOR Other_c_Exists_(Wc_Type_Tmp_ IN VARCHAR2) IS
      SELECT t.*,
             t.Rowid Objid,
             Ltrim(Lpad(To_Char(Rowversion, 'YYYYMMDDHH24MISS'), 2000)) Objversion
        FROM Hrp_Abs_Calc_Other_Wc_Tab t
       WHERE t.Company_Id = Base_Rec_.Company_Id
         AND t.Emp_No = Base_Rec_.Emp_No
         AND t.Absence_Id = Base_Rec_.Absence_Id
         AND t.Seq = Base_Rec_.Seq
         AND t.Hrp_Abs_Calc_Other_Type = Calc_Type_
         AND t.Hrp_Abs_Wc_Type = Wc_Type_Tmp_;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Insert_Wage_Codes_4_6');
    Wc_Type_Ins_   := Wc_Type_;
    Sys_Generated_ := 'TRUE';
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'OPEN', S2_ => Calc_Type_);
    --for tax controll
    Period_To_ := To_Number(To_Char(Absence_Registration_Api.Get_Date_From(Base_Rec_.Company_Id,
                                                                           Base_Rec_.Emp_No,
                                                                           Base_Rec_.Absence_Id),
                                    'YYYYMM'));
    --
    -- active accurat calculation
    IF Nvl(Hrp_Regulation_Api.Get_Value_Null(Base_Rec_.Company_Id, 'Z011', SYSDATE), 0) = 1
       OR Base_Rec_.Abs_Calc_Base_Type_Id = 'ZPK' THEN
      Calc_Accurate_ := TRUE;
    ELSE
      Calc_Accurate_ := FALSE;
    END IF;
    --
    FOR Wc_Rec_ IN Get_Wc_ LOOP
      --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_WC',s1_ => 'WC_HEAD', s2_ => wc_rec_.wage_code_id);
      Value_      := NULL;
      Prev_Value_ := NULL;
      Prev_Net_   := NULL;
      --
      FOR Rec_ IN Insert_To_ LOOP
        From_Date_  := Rec_.Date_From;
        To_Date_    := Rec_.Date_To;
        Prev_Value_ := Value_;
        Value_      := NULL;
        Amount_     := NULL;
        -- MOVE GRACE TIME FOR YEARLY BONUS
        IF Rec_.Hrp_Abs_Calc_Other_Type = 'YEARLY' THEN
          From_Date_       := Nvl(Graced_Period_Date_From_, Rec_.Date_From);
          Val_Grace_Up_    := NULL;
          Validation_Date_ := Bonus_Date_;
        ELSIF Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY', 'M4MONTHLY') THEN
          Val_Grace_Up_    := NULL;
          Validation_Date_ := To_Date_;
          -- check if last period
          Is_Last_Period_ := FALSE;
          IF To_Date_ = Last_Day(To_Date(Period_To_ || '01', 'YYYYMMDD') - 1) THEN
            Is_Last_Period_ := TRUE;
          END IF;
        END IF;
        --
        OPEN Exist_Control(Rec_.Company_Id, Rec_.Emp_No, Wc_Rec_.Wage_Code_Id, From_Date_, To_Date_);
        FETCH Exist_Control
          INTO Temp_;
        IF Exist_Control%FOUND THEN
          IF Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY', 'YEARLY', 'M4MONTHLY') THEN
            FOR Bonus_Rec_ IN c_(Rec_.Company_Id, Rec_.Emp_No, Wc_Rec_.Wage_Code_Id, From_Date_,
                                 To_Date_, Validation_Date_) LOOP
              Arch_Tax_Period_ := Bonus_Rec_.Tax_Year * 100 + Bonus_Rec_.Tax_Month;
              IF Arch_Tax_Period_ > Period_To_ THEN
                Val_Grace_Up_ := Nvl(Val_Grace_Up_, 0) + Bonus_Rec_.Summarised_Value;
                Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'SKIPARCH',
                                     S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Val_Grace_Up_,
                                     D1_ => Rec_.Date_From, D2_ => Rec_.Date_To);
              ELSE
                IF Rec_.Hrp_Abs_Calc_Other_Type IN ('YEARLY') THEN
                  Value_ := Nvl(Value_, 0) + Bonus_Rec_.Summarised_Value;
                ELSIF Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY', 'M4MONTHLY') THEN
                  Value_ := Nvl(Value_, 0) + Bonus_Rec_.Summarised_Value;
                END IF;
                -- value grace up is no longer supported
                -- add details info
                IF Calc_Accurate_
                   AND Value_ <> 0 THEN
                  Zpk_Add_Details_Net_Factor___( --
                                                Zpk_Nf_Tab_, Wage_Code_Elements_Tab_,
                                                Rec_.Company_Id, Rec_.Emp_No,
                                                --
                                                Payroll_List_Id_, Payroll_Rec_, Wc_Group_,
                                                Wc_Bias_Group_, Gr_Contribution_, Gr_Base_,
                                                Rec_.Hrp_Abs_Calc_Other_Type, Wc_Type_,
                                                --
                                                FALSE, Wc_Rec_.Wage_Code_Id, Value_, Rec_.Period_Seq,
                                                Rec_.Date_From, Rec_.Date_To, Wc_Rec_.Arythm_Sign,
                                                --
                                                Validation_Date_);
                END IF;
              END IF;
            END LOOP;
          END IF;
        END IF;
        CLOSE Exist_Control;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'PREV',
                             S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Value_, D1_ => Rec_.Date_From,
                             D2_ => Rec_.Date_To);
        /**/
        IF Nvl(Value_, 0) = 0
           AND Nvl(Val_Grace_Up_, 0) <> 0 THEN
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'INSARCH',
                               S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Val_Grace_Up_,
                               D1_ => Rec_.Date_From, D2_ => Rec_.Date_To);
        END IF;
        IF Include_Payroll_Values_ = 'TRUE' THEN
          Last_             := Wage_Code_Elements_Tab_.Last;
          Temp_Adv1_        := NULL;
          Val_Grace_Up_Tmp_ := NULL;
          FOR i_ IN 1 .. Nvl(Last_, 0) LOOP
            IF Wage_Code_Elements_Tab_(i_)
             .Wage_Code_Id = Wc_Rec_.Wage_Code_Id
                AND Wage_Code_Elements_Tab_(i_).Validation_Date BETWEEN From_Date_ AND To_Date_ THEN
              IF Wage_Code_Elements_Tab_(i_).Value IS NOT NULL THEN
                IF Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY', 'M4MONTHLY', 'YEARLY') THEN
                  IF To_Number(Payroll_Rec_.Tax_Period) > Period_To_
                     AND Trunc(Wage_Code_Elements_Tab_(i_).Validation_Date, 'MONTH') =
                     Trunc(Validation_Date_, 'MONTH') THEN
                    Val_Grace_Up_Tmp_ := Nvl(Val_Grace_Up_Tmp_, 0) + Wage_Code_Elements_Tab_(i_)
                                        .Value;
                    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY',
                                         S2_ => 'SKIPCURR', S3_ => Wc_Rec_.Wage_Code_Id,
                                         N1_ => Wage_Code_Elements_Tab_(i_).Value,
                                         D1_ => Rec_.Date_From, D2_ => Rec_.Date_To,
                                         D3_ => Wage_Code_Elements_Tab_(i_).Validation_Date);
                  ELSIF Trunc(Wage_Code_Elements_Tab_(i_).Validation_Date, 'MONTH') =
                        Trunc(Validation_Date_, 'MONTH') THEN
                    Temp_Adv1_ := Nvl(Temp_Adv1_, 0) + Wage_Code_Elements_Tab_(i_).Value;
                    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'CURR',
                                         S3_ => Wc_Rec_.Wage_Code_Id,
                                         N1_ => Wage_Code_Elements_Tab_(i_).Value,
                                         D1_ => Rec_.Date_From, D2_ => Rec_.Date_To,
                                         D3_ => Wage_Code_Elements_Tab_(i_).Validation_Date);
                    -- value grace up is no longer supported
                    -- add details info
                    IF Calc_Accurate_
                       AND Temp_Adv1_ <> 0 THEN
                      Zpk_Add_Details_Net_Factor___( --
                                                    Zpk_Nf_Tab_, Wage_Code_Elements_Tab_,
                                                    Rec_.Company_Id, Rec_.Emp_No,
                                                    --
                                                    Payroll_List_Id_, Payroll_Rec_, Wc_Group_,
                                                    Wc_Bias_Group_, Gr_Contribution_, Gr_Base_,
                                                    Rec_.Hrp_Abs_Calc_Other_Type, Wc_Type_,
                                                    --
                                                    TRUE, Wc_Rec_.Wage_Code_Id, Temp_Adv1_,
                                                    Rec_.Period_Seq, Rec_.Date_From, Rec_.Date_To,
                                                    Wc_Rec_.Arythm_Sign,
                                                    --
                                                    Validation_Date_);
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
          END LOOP;
          /**/
          IF Nvl(Temp_Adv1_, 0) = 0
             AND Nvl(Val_Grace_Up_Tmp_, 0) <> 0 THEN
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'INSCURR',
                                 S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Val_Grace_Up_Tmp_,
                                 D1_ => Rec_.Date_From, D2_ => Rec_.Date_To);
          END IF;
          IF Temp_Adv1_ IS NOT NULL THEN
            Value_ := Nvl(Value_, 0) + Temp_Adv1_;
          END IF;
        END IF;
        -- to accurate nettig factor calculation skip
        Nf_Copied_ := FALSE;
        --
        IF Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY')
           AND Value_ IS NULL
           AND Is_Last_Period_
           AND
           Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id, 'Z005',
                                                                      SYSDATE), 1) = 1 THEN
          -- copy previous bonus value !!!
          Value_ := Prev_Value_;
          --IF  nvl(value_,0) <> 0
          --AND rec_.netting_factor = 0
          --AND nvl(prev_net_,0) <> 0 THEN
          Client_Sys.Clear_Attr(Attr_Other_);
          Client_Sys.Add_To_Attr('DESCRIPTION', 'ZpkCopyPrevValue', Attr_Other_);
          Client_Sys.Add_To_Attr('NETTING_FACTOR', Nvl(Prev_Net_, 0), Attr_Other_);
          Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_, 'DOAUTO');
          --
          Nf_Copied_ := TRUE;
          --END IF;
        ELSIF Rec_.Hrp_Abs_Calc_Other_Type IN ('M4MONTHLY')
              AND Value_ IS NULL
              AND Is_Last_Period_
              AND
              Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id,
                                                                         'Z006', SYSDATE), 1) = 1 THEN
          -- copy previous bonus value
          Value_ := Prev_Value_;
          --IF  nvl(value_,0) <> 0
          --AND rec_.netting_factor = 0
          --AND nvl(prev_net_,0) <> 0 THEN
          Client_Sys.Clear_Attr(Attr_Other_);
          Client_Sys.Add_To_Attr('DESCRIPTION', 'ZpkCopyPrevValue', Attr_Other_);
          Client_Sys.Add_To_Attr('NETTING_FACTOR', Nvl(Prev_Net_, 0), Attr_Other_);
          Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_, 'DOAUTO');
          --
          Nf_Copied_ := TRUE;
          --END IF;
        ELSIF Rec_.Hrp_Abs_Calc_Other_Type = 'YEARLY' THEN
          --classification future payment in case of lack normal bonses
          IF Nvl(Value_, 0) = 0
             AND (Nvl(Val_Grace_Up_Tmp_, 0) <> 0 OR Nvl(Val_Grace_Up_, 0) <> 0) THEN
            IF Nvl(Val_Grace_Up_, 0) <> 0 THEN
              Value_ := Val_Grace_Up_; -- from archive
            ELSE
              Value_ := Val_Grace_Up_Tmp_; -- from current list
            END IF;
            Wc_Type_Ins_   := 'FUTURE';
            Sys_Generated_ := 'FALSE';
          END IF;
        END IF;
        --
        IF Nvl(Value_, 0) != 0 THEN
          IF Rec_.Hrp_Abs_Calc_Other_Type = 'QUARTERLY' THEN
            IF Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id,
                                                                          'Z009', SYSDATE), 1) = 1 THEN
              -- full period classyfied
              Value_Ins_ := Value_;
            ELSE
              Value_Ins_ := Round((Value_ / 3) * Rec_.Months_In_Period, 2);
            END IF;
          ELSIF Rec_.Hrp_Abs_Calc_Other_Type = 'M4MONTHLY' THEN
            Value_Ins_ := Round((Value_ / 4) * Rec_.Months_In_Period, 2);
          ELSIF Rec_.Hrp_Abs_Calc_Other_Type = 'HALF_YEARLY' THEN
            Value_Ins_ := Round((Value_ / 6) * Rec_.Months_In_Period, 2);
          ELSE
            Value_Ins_ := Value_;
          END IF;
          Client_Sys.Clear_Attr(Attr_);
          Client_Sys.Add_To_Attr('COMPANY_ID', Rec_.Company_Id, Attr_);
          Client_Sys.Add_To_Attr('EMP_NO', Rec_.Emp_No, Attr_);
          Client_Sys.Add_To_Attr('ABSENCE_ID', Rec_.Absence_Id, Attr_);
          Client_Sys.Add_To_Attr('SEQ', Rec_.Seq, Attr_);
          Client_Sys.Add_To_Attr('PERIOD_SEQ', Rec_.Period_Seq, Attr_);
          Client_Sys.Add_To_Attr('DATE_FROM', Rec_.Date_From, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                                 Hrp_Abs_Calc_Other_Type_Api.Decode(Rec_.Hrp_Abs_Calc_Other_Type),
                                 Attr_);
          Client_Sys.Add_To_Attr('WAGE_CODE_ID', Wc_Rec_.Wage_Code_Id, Attr_);
          Client_Sys.Add_To_Attr('VALUE', Nvl(Value_Ins_, 0), Attr_);
          Client_Sys.Add_To_Attr('SYSTEM_GENERATED', Sys_Generated_, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE', Hrp_Abs_Wc_Type_Api.Decode(Wc_Type_Ins_), Attr_);
          Hrp_Abs_Calc_Other_Wc_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
          IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;
        END IF;
        IF Value_ IS NOT NULL
           AND Value_ = 0 THEN
          IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;
        END IF;
        IF Value_ IS NULL
           AND Rec_.Hrp_Abs_Calc_Other_Type IN ('QUARTERLY')
           AND
           Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id, 'Z007',
                                                                      SYSDATE), 1) = 1 THEN
          IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;
        END IF;
        IF Value_ IS NULL
           AND Rec_.Hrp_Abs_Calc_Other_Type IN ('M4MONTHLY')
           AND
           Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id, 'Z008',
                                                                      SYSDATE), 1) = 1 THEN
          IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;
        END IF;
        --
        -- prior calculation section for accurate netting factor calulation
        IF Calc_Accurate_ THEN
          Rec_.Netting_Factor := Zpk_Calc_Details_Net_Factor___(1, Zpk_Nf_Tab_, Zpk_Log_Tab_,
                                                                Rec_.Company_Id, Rec_.Emp_No,
                                                                Rec_.Absence_Id, Payroll_List_Id_,
                                                                Rec_.Seq, Rec_.Period_Seq, Calc_Type_,
                                                                Wc_Type_, Rec_.Date_From,
                                                                Wc_Rec_.Wage_Code_Id);
        END IF;
        -- end of period if neccesary actual netting factor
        IF Calc_Accurate_ THEN
          IF NOT Nf_Copied_ THEN
            Rec_.Netting_Factor := Zpk_Calc_Details_Net_Factor___(2, Zpk_Nf_Tab_, Zpk_Log_Tab_,
                                                                  Rec_.Company_Id, Rec_.Emp_No,
                                                                  Rec_.Absence_Id, Payroll_List_Id_,
                                                                  Rec_.Seq, Rec_.Period_Seq,
                                                                  Calc_Type_, Wc_Type_,
                                                                  Rec_.Date_From,
                                                                  Wc_Rec_.Wage_Code_Id);
          END IF;
        END IF;
        -- for coping between period
        Prev_Net_ := Rec_.Netting_Factor;
        --
      END LOOP;
    END LOOP;
    --
    IF Calc_Accurate_ THEN
      -- add log information
      Dummy_ := Zpk_Calc_Details_Net_Factor___(3, Zpk_Nf_Tab_, Zpk_Log_Tab_, Base_Rec_.Company_Id,
                                               Base_Rec_.Emp_No, Base_Rec_.Absence_Id,
                                               Payroll_List_Id_, Base_Rec_.Seq, NULL, NULL, NULL,
                                               NULL, NULL);
    END IF;
    --
    --
    -- clearing hrp_abs_calc_other_tab from future wage code
    -- in case of future wage code, accurate netting factor is not applied
    IF Calc_Type_ = 'YEARLY' THEN
      IF Paid_Way_ = 'TAXCHECK' THEN
        --delete wc
        FOR Rec_ IN Other_c_Exists_('FUTURE') LOOP
          Hrp_Abs_Calc_Other_Wc_Api.Remove__(Info_, Rec_.Objid, Rec_.Objversion, 'DOAUTO');
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'FUTUREDEL',
                               S3_ => Rec_.Wage_Code_Id, N1_ => Rec_.Value);
        END LOOP;
      ELSE
        --modify wc
        Client_Sys.Clear_Attr(Attr_Other_);
        Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE_DB', 'CONSTANT', Attr_Other_);
        FOR Rec_ IN Other_c_Exists_('FUTURE') LOOP
          Hrp_Abs_Calc_Other_Wc_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                             'DOAUTO');
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'FUTUREINS',
                               S3_ => Rec_.Wage_Code_Id, N1_ => Rec_.Value);
        END LOOP;
      END IF;
    END IF;
    --
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'CLOSE', S2_ => Calc_Type_);
  END Insert_Wage_Codes_4_6;
  PROCEDURE Zpk_Insert_Wage_Codes_4_6(Wc_Value_     IN OUT NUMBER,
                                      Net_Factor_   OUT NUMBER,
                                      For_Period_   IN OUT VARCHAR2,
                                      Company_Id_   IN VARCHAR2,
                                      Emp_No_       IN VARCHAR2,
                                      Account_Date_ IN DATE,
                                      Paid_To_      IN DATE,
                                      --Base_Rec_                IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                                      --Period_Seq_              IN NUMBER,
                                      --Payroll_Rec_             IN Hrp_Pay_List_Api.Public_Rec,
                                      --Payroll_List_Id_         IN VARCHAR2,
                                      Wc_Group_ IN VARCHAR2,
                                      --Graced_Period_Date_From_ IN DATE,
                                      --Bonus_Date_              IN DATE,
                                      Paid_Way_  IN VARCHAR2,
                                      Wc_Type_   IN VARCHAR2,
                                      Calc_Type_ IN VARCHAR2,
                                      --Wage_Code_Elements_Tab_  IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                                      --Zpk_Log_Tab_             IN OUT t_Log_Tab,
                                      Gr_Contribution_        IN VARCHAR2,
                                      Gr_Base_                IN VARCHAR2,
                                      Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                                      Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') IS
    Info_       VARCHAR2(2000);
    Objid_      VARCHAR2(2000);
    Objversion_ VARCHAR2(2000);
    Attr_       VARCHAR2(2000);
    Attr_Other_ VARCHAR2(2000);
    Value_             NUMBER;
    Val_Grace_Up_      NUMBER;
    Val_Grace_Up_Tmp_  NUMBER;
    From_Date_         DATE;
    To_Date_           DATE;
    Prev_Value_        NUMBER;
    Prev_Net_          NUMBER;
    Value_Ins_         NUMBER;
    Wc_Type_Ins_       VARCHAR2(20);
    Prev_Wage_Code_Id_ Calculation_Group_Members_Tab.Wage_Code_Id%TYPE;
    Last_              NUMBER;
    Period_To_         NUMBER;
    Arch_Tax_Period_   NUMBER;
    Temp_              NUMBER;
    Temp_Adv1_         NUMBER;
    Amount_            NUMBER;
    Wc_Exists_         BOOLEAN;
    Sys_Generated_     VARCHAR2(5);
    Validation_Date_   DATE;
    Is_Last_Period_    BOOLEAN := FALSE;
    --
    Net_Month_ Hrp_Abs_Calc_Month_Tab.Netting_Factor%TYPE;
    -- calc accurate
    Zpk_Nf_Tab_    t_Net_Factor_Tab;
    Calc_Accurate_ BOOLEAN;
    Nf_Copied_     BOOLEAN;
    Dummy_         NUMBER;
    Wc_Bias_Group_ Calculation_Group_Tab.Calc_Group_Id%TYPE;
    -- new .....
    Wage_Code_Elements_Tab_ Hrp_Pay_List_Api.Wage_Code_Elements_Type;
    Payroll_List_Id_        VARCHAR2(2000) := 'DUMMY';
    Payroll_Rec_            Hrp_Pay_List_Api.Public_Rec;
    -- log tab
    Zpk_Log_Tab_ t_Log_Tab := t_Log_Tab();
    --
    CURSOR Insert_To_ IS
      SELECT 1 Seq,
             1 Period_Seq,
             1 Absence_Id,
             Trunc(Account_Date_, 'MONTH') Date_From,
             Last_Day(Account_Date_) Date_To
        FROM Dual;
    /*CURSOR Insert_To_ IS
    SELECT t.*,
           t.Rowid Objid,
           Ltrim(Lpad(To_Char(Rowversion, 'YYYYMMDDHH24MISS'), 2000)) Objversion
      FROM Hrp_Abs_Calc_Other_Tab t
     WHERE Company_Id = Base_Rec_.Company_Id
       AND Emp_No = Base_Rec_.Emp_No
       AND Absence_Id = Base_Rec_.Absence_Id
       AND Seq = Base_Rec_.Seq
       AND Hrp_Abs_Calc_Other_Type = Calc_Type_
       AND Period_Seq = Period_Seq_
    --AND selected = 'TRUE'
     ORDER BY Date_From;*/
    CURSOR Get_Wc_ IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Company_Id_
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
    CURSOR Exist_Control(Company_Id_   IN VARCHAR2,
                         Emp_No_       IN VARCHAR2,
                         Wage_Code_Id_ IN VARCHAR2,
                         Date_From_    IN DATE,
                         Date_To_      IN DATE) IS
      SELECT 1
        FROM Hrp_Wc_Archive_Tab
       WHERE Company_Id = Company_Id_
            -- AND Validation_Date BETWEEN Date_From_ AND Date_To_
         AND Validation_Date BETWEEN Date_From_ - 9999 AND Date_To_ + 9999
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_;
    /*    CURSOR Get_Net_Month IS
    SELECT Netting_Factor
      FROM Hrp_Abs_Calc_Month_Tab
     WHERE Company_Id = Base_Rec_.Company_Id
       AND Emp_No = Base_Rec_.Emp_No
       AND Absence_Id = Base_Rec_.Absence_Id
       AND Seq = Base_Rec_.Seq
       AND Date_To = To_Date_;*/
    CURSOR c_(Company_Id_      IN VARCHAR2,
              Emp_No_          IN VARCHAR2,
              Wage_Code_Id_    IN VARCHAR2,
              Date_From_       IN DATE,
              Date_To_         IN DATE,
              Validation_Date_ IN DATE) IS
      SELECT Tax_Year, Tax_Month, Summarised_Value, Validation_Date
        FROM Hrp_Wc_Archive_Tab t
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Wage_Code_Id = Wage_Code_Id_
            --AND validation_date BETWEEN date_from_ AND date_to_
            --AND Trunc(Validation_Date, 'MONTH') = Trunc(Validation_Date_, 'MONTH')
         --AND (Tax_Year * 100 + Tax_Month) = To_Char(Date_To_, 'YYYYMM')
         AND (t.accounting_year * 100 + t.accounting_month) = To_Char(Date_To_, 'YYYYMM')
       ORDER BY Validation_Date DESC;
    CURSOR Other_c_Exists_(Wc_Type_Tmp_ IN VARCHAR2) IS
      SELECT t.*,
             t.Rowid Objid,
             Ltrim(Lpad(To_Char(Rowversion, 'YYYYMMDDHH24MISS'), 2000)) Objversion
        FROM Hrp_Abs_Calc_Other_Wc_Tab t
       WHERE t.Company_Id = Company_Id_
         AND t.Emp_No = Emp_No_
            --AND t.Absence_Id = Base_Rec_.Absence_Id
            --AND t.Seq = Base_Rec_.Seq
         AND 1 = 2
         AND t.Hrp_Abs_Calc_Other_Type = Calc_Type_
         AND t.Hrp_Abs_Wc_Type = Wc_Type_Tmp_;
  BEGIN
    --General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Insert_Wage_Codes_4_6');
    Wc_Type_Ins_   := Wc_Type_;
    Sys_Generated_ := 'TRUE';
    --Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'OPEN', S2_ => Calc_Type_);
    --for tax controll
    /*Period_To_ := To_Number(To_Char(Absence_Registration_Api.Get_Date_From(Base_Rec_.Company_Id,
                                           Base_Rec_.Emp_No,
                                           Base_Rec_.Absence_Id),
    'YYYYMM'));*/
    Period_To_ := To_Number(To_Char(Paid_To_, 'YYYYMM'));
    --
    -- active accurat calculation
    Calc_Accurate_ := TRUE;
    /*IF Nvl(Hrp_Regulation_Api.Get_Value_Null(Base_Rec_.Company_Id, 'Z011', SYSDATE), 0) = 1
       OR Base_Rec_.Abs_Calc_Base_Type_Id = 'ZPK' THEN
      Calc_Accurate_ := TRUE;
    ELSE
      Calc_Accurate_ := FALSE;
    END IF;*/
    --
    FOR Wc_Rec_ IN Get_Wc_ LOOP
      --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_WC',s1_ => 'WC_HEAD', s2_ => wc_rec_.wage_code_id);
      Value_      := NULL;
      Prev_Value_ := NULL;
      Prev_Net_   := NULL;
      --
      FOR Rec_ IN Insert_To_ LOOP
        From_Date_  := Rec_.Date_From;
        To_Date_    := Rec_.Date_To;
        Prev_Value_ := Value_;
        Value_      := NULL;
        Amount_     := NULL;
        -- MOVE GRACE TIME FOR YEARLY BONUS
        IF Calc_Type_ = 'YEARLY' THEN
          --From_Date_       := Nvl(Graced_Period_Date_From_, Rec_.Date_From);
          From_Date_    := Rec_.Date_From;
          Val_Grace_Up_ := NULL;
          --Validation_Date_ := Bonus_Date_;
          Validation_Date_ := To_Date_;
        ELSIF Calc_Type_ IN ('QUARTERLY', 'M4MONTHLY') THEN
          Val_Grace_Up_    := NULL;
          Validation_Date_ := To_Date_;
          -- check if last period
          Is_Last_Period_ := FALSE;
          IF To_Date_ = Last_Day(To_Date(Period_To_ || '01', 'YYYYMMDD') - 1) THEN
            Is_Last_Period_ := TRUE;
          END IF;
        END IF;
        --
        OPEN Exist_Control(Company_Id_, Emp_No_, Wc_Rec_.Wage_Code_Id, From_Date_, To_Date_);
        FETCH Exist_Control
          INTO Temp_;
        IF Exist_Control%FOUND THEN
          IF Calc_Type_ IN ('QUARTERLY', 'YEARLY', 'M4MONTHLY') THEN
            FOR Bonus_Rec_ IN c_(Company_Id_, Emp_No_, Wc_Rec_.Wage_Code_Id, From_Date_, To_Date_,
                                 Validation_Date_) LOOP
              Arch_Tax_Period_ := Bonus_Rec_.Tax_Year * 100 + Bonus_Rec_.Tax_Month;
               /*  IF Arch_Tax_Period_ > Period_To_ THEN
                Val_Grace_Up_ := Nvl(Val_Grace_Up_, 0) + Bonus_Rec_.Summarised_Value;
                             Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'SKIPARCH',
                S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Val_Grace_Up_,
                D1_ => Rec_.Date_From, D2_ => Rec_.Date_To);
              ELSE*/
                -- generalization last period is transfered
                For_Period_ := To_Char(Bonus_Rec_.Validation_Date, 'YYYYMM');
                Validation_Date_ := Bonus_Rec_.Validation_Date;
                IF Calc_Type_ IN ('YEARLY') THEN
                  Value_ := Nvl(Value_, 0) + Bonus_Rec_.Summarised_Value;
                ELSIF Calc_Type_ IN ('QUARTERLY', 'M4MONTHLY') THEN
                  Value_ := Nvl(Value_, 0) + Bonus_Rec_.Summarised_Value;
                END IF;
                -- value grace up is no longer supported
                -- add details info
                IF Calc_Accurate_
                   AND Value_ <> 0 THEN
                  Zpk_Add_Details_Net_Factor___( --
                                                Zpk_Nf_Tab_, Wage_Code_Elements_Tab_, Company_Id_,
                                                Emp_No_,
                                                --
                                                Payroll_List_Id_, Payroll_Rec_, Wc_Group_,
                                                Wc_Bias_Group_, Gr_Contribution_, Gr_Base_,
                                                Calc_Type_, Wc_Type_,
                                                --
                                                FALSE, Wc_Rec_.Wage_Code_Id, Value_, Rec_.Period_Seq,
                                                Rec_.Date_From, Rec_.Date_To, Wc_Rec_.Arythm_Sign,
                                                --
                                                Validation_Date_);
                END IF;
              --END IF;
            END LOOP;
          END IF;
        END IF;
        CLOSE Exist_Control;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'PREV',
                             S3_ => Wc_Rec_.Wage_Code_Id, N1_ => Value_, D1_ => Rec_.Date_From,
                             D2_ => Rec_.Date_To);
        -- to accurate nettig factor calculation skip
        Nf_Copied_ := FALSE;
        --
        IF Calc_Type_ IN ('QUARTERLY')
           AND Value_ IS NULL
           AND Is_Last_Period_
           AND Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z005',
                                                                          SYSDATE), 1) = 1 THEN
          -- copy previous bonus value !!!
          Value_     := Prev_Value_;
          Nf_Copied_ := TRUE;
          --END IF;
        ELSIF Calc_Type_ IN ('M4MONTHLY')
              AND Value_ IS NULL
              AND Is_Last_Period_
              AND Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z006',
                                                                             SYSDATE), 1) = 1 THEN
          -- copy previous bonus value
          Value_ := Prev_Value_;
          --
          Nf_Copied_ := TRUE;
          --END IF;
        ELSIF Calc_Type_ = 'YEARLY' THEN
          --classification future payment in case of lack normal bonses
          IF Nvl(Value_, 0) = 0
             AND (Nvl(Val_Grace_Up_Tmp_, 0) <> 0 OR Nvl(Val_Grace_Up_, 0) <> 0) THEN
            IF Nvl(Val_Grace_Up_, 0) <> 0 THEN
              Value_ := Val_Grace_Up_; -- from archive
            ELSE
              Value_ := Val_Grace_Up_Tmp_; -- from current list
            END IF;
            Wc_Type_Ins_   := 'FUTURE';
            Sys_Generated_ := 'FALSE';
          END IF;
        END IF;
        --
        IF Nvl(Value_, 0) != 0 THEN
          IF Calc_Type_ = 'QUARTERLY' THEN
            IF Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z009',
                                                                          SYSDATE), 1) = 1 THEN
              -- full period classyfied
              Value_Ins_ := Value_;
            ELSE
              Value_Ins_ := Round((Value_ / 3) * 3, 2);
            END IF;
          ELSIF Calc_Type_ = 'M4MONTHLY' THEN
            Value_Ins_ := Round((Value_ / 4) * 4, 2);
          ELSIF Calc_Type_ = 'HALF_YEARLY' THEN
            Value_Ins_ := Round((Value_ / 6) * 6, 2);
          ELSE
            Value_Ins_ := Value_;
          END IF;
          Client_Sys.Clear_Attr(Attr_);
          /*Client_Sys.Add_To_Attr('COMPANY_ID', Rec_.Company_Id_, Attr_);
          Client_Sys.Add_To_Attr('EMP_NO', Rec_.Emp_No_, Attr_);
          Client_Sys.Add_To_Attr('ABSENCE_ID', Rec_.Absence_Id, Attr_);
          Client_Sys.Add_To_Attr('SEQ', Rec_.Seq, Attr_);
          Client_Sys.Add_To_Attr('PERIOD_SEQ', Rec_.Period_Seq, Attr_);
          Client_Sys.Add_To_Attr('DATE_FROM', Rec_.Date_From, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                                 Hrp_Abs_Calc_Other_Type_Api.Decode(Calc_Type_),
                                 Attr_);
          Client_Sys.Add_To_Attr('WAGE_CODE_ID', Wc_Rec_.Wage_Code_Id, Attr_);
          Client_Sys.Add_To_Attr('VALUE', Nvl(Value_Ins_, 0), Attr_);
          Client_Sys.Add_To_Attr('SYSTEM_GENERATED', Sys_Generated_, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE', Hrp_Abs_Wc_Type_Api.Decode(Wc_Type_Ins_), Attr_);
          Hrp_Abs_Calc_Other_Wc_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');*/
          /*       IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            --Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
            --                                'DOAUTO');
          END IF;*/
        END IF;
        /* IF Value_ IS NOT NULL
           AND Value_ = 0 THEN
         \* IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;*\
        END IF;*/
        /*IF Value_ IS NULL
           AND Calc_Type_ IN ('QUARTERLY')
           AND
           Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z007',
                                                                      SYSDATE), 1) = 1 THEN
          \*IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                            'DOAUTO');
          END IF;*\
        END IF;*/
        /*IF Value_ IS NULL
           AND Calc_Type_ IN ('M4MONTHLY')
           AND
           Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id, 'Z008',
                                                                      SYSDATE), 1) = 1 THEN
          IF Rec_.Selected = 'FALSE' THEN
            Client_Sys.Clear_Attr(Attr_Other_);
            Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_Other_);
            --Hrp_Abs_Calc_Other_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
            --                                'DOAUTO');
          END IF;
        END IF;*/
        --
        -- prior calculation section for accurate netting factor calulation
        IF Calc_Accurate_ THEN
          Net_Factor_ := Zpk_Calc_Details_Net_Factor___(1, Zpk_Nf_Tab_, Zpk_Log_Tab_, Company_Id_,
                                                        Emp_No_, Rec_.Absence_Id, Payroll_List_Id_,
                                                        Rec_.Seq, Rec_.Period_Seq, Calc_Type_,
                                                        Wc_Type_, Rec_.Date_From,
                                                        Wc_Rec_.Wage_Code_Id);
        END IF;
        -- end of period if neccesary actual netting factor
        IF Calc_Accurate_ THEN
          IF NOT Nf_Copied_ THEN
            Net_Factor_ := Zpk_Calc_Details_Net_Factor___(2, Zpk_Nf_Tab_, Zpk_Log_Tab_, Company_Id_,
                                                          Emp_No_, Rec_.Absence_Id, Payroll_List_Id_,
                                                          Rec_.Seq, Rec_.Period_Seq, Calc_Type_,
                                                          Wc_Type_, Rec_.Date_From,
                                                          Wc_Rec_.Wage_Code_Id);
          END IF;
        END IF;
        -- for coping between period
        Prev_Net_ := Net_Factor_;
        --
      END LOOP;
    END LOOP;
    --
    IF Calc_Accurate_ THEN
      -- add log information
      Dummy_ := Zpk_Calc_Details_Net_Factor___(3, Zpk_Nf_Tab_, Zpk_Log_Tab_, Company_Id_, Emp_No_, 1,
                                               Payroll_List_Id_, 1, NULL, NULL, NULL, NULL, NULL);
    END IF;
    --
    --
    -- clearing hrp_abs_calc_other_tab from future wage code
    -- in case of future wage code, accurate netting factor is not applied
    IF Calc_Type_ = 'YEARLY' THEN
      IF Paid_Way_ = 'TAXCHECK' THEN
        --delete wc
        FOR Rec_ IN Other_c_Exists_('FUTURE') LOOP
          Hrp_Abs_Calc_Other_Wc_Api.Remove__(Info_, Rec_.Objid, Rec_.Objversion, 'DOAUTO');
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'FUTUREDEL',
                               S3_ => Rec_.Wage_Code_Id, N1_ => Rec_.Value);
        END LOOP;
      ELSE
        --modify wc
        Client_Sys.Clear_Attr(Attr_Other_);
        Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE_DB', 'CONSTANT', Attr_Other_);
        FOR Rec_ IN Other_c_Exists_('FUTURE') LOOP
          Hrp_Abs_Calc_Other_Wc_Api.Modify__(Info_, Rec_.Objid, Rec_.Objversion, Attr_Other_,
                                             'DOAUTO');
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_WC', S1_ => 'WC_BODY', S2_ => 'FUTUREINS',
                               S3_ => Rec_.Wage_Code_Id, N1_ => Rec_.Value);
        END LOOP;
      END IF;
    END IF;
    --
    Wc_Value_   := Value_Ins_;
    Net_Factor_ := Net_Factor_;
  END Zpk_Insert_Wage_Codes_4_6;
  PROCEDURE Insert_Wage_Codes_Adv1(
                                   --base_rec_               IN hrp_abs_calc_base_tab%ROWTYPE,
                                   Wc_Value_        IN OUT NUMBER,
                                   Net_Factor_      OUT NUMBER,
                                   Company_Id_      IN VARCHAR2,
                                   Emp_No_          IN VARCHAR2,
                                   Account_Date_    IN DATE,
                                   Wc_Group_        IN VARCHAR2,
                                   Wc_Type_         IN VARCHAR2,
                                   Trans_Type_      IN NUMBER,
                                   Zpk_Nf_Tab_      IN OUT NOCOPY t_Net_Factor_Tab,
                                   Gr_Contribution_ IN VARCHAR2 DEFAULT NULL,
                                   Gr_Base_         IN VARCHAR2 DEFAULT NULL) IS
    Info_           VARCHAR2(2000);
    Objid_          VARCHAR2(2000);
    Objversion_     VARCHAR2(2000);
    Attr_           VARCHAR2(2000);
    Value_          NUMBER;
    From_Date_      DATE;
    Netting_Factor_ NUMBER := NULL;
    Arch_Value_     NUMBER;
    Month_Value_    NUMBER;
    Date_From_      DATE;
    Date_To_        DATE;
    Log_Value_      NUMBER;
    -- calc accurate
    Calc_Accurate_ BOOLEAN;
    --   netting_factor_accurate_ NUMBER;
    --   original_net_factor_    NUMBER;
    --   cumulated_net_factor_   NUMBER;
    --   cumulated_value_        NUMBER;
    --   contribution_           NUMBER;
    --   base_                   NUMBER;
    --   i_                      NUMBER;
    --   j_                      NUMBER;
    Temp_Rec_               t_Net_Factor;
    Prev_Period_Seq_        NUMBER;
    Wc_Bias_Group_          Calculation_Group_Tab.Calc_Group_Id%TYPE;
    Wc_Control_             Calculation_Group_Tab.Calc_Group_Id%TYPE;
    Contr_Correction_Baise_ BOOLEAN := FALSE;
    Plain_Text_             VARCHAR2(2000);
    /*   CURSOR insert_to_ IS
    SELECT ROWID,t.*
    FROM hrp_abs_calc_month_tab t
    WHERE company_id = company_id_
    AND emp_no = emp_no_
    AND absence_id = base_rec_.absence_id
    AND seq = base_rec_.seq
    AND selected = 'TRUE';*/
    CURSOR Get_Wc_ IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Company_Id_
         AND b.Calc_Group_Id = Nvl(Wc_Group_, Wc_Bias_Group_)
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= SYSDATE);
    New_Period_Seq_             NUMBER;
    New_Absence_Id_             NUMBER := 999;
    New_Seq_                    NUMBER := 9;
    New_Payroll_List_Id_        VARCHAR2(20) := 'DUMMY';
    New_Wage_Code_Elements_Tab_ Hrp_Pay_List_Api.Wage_Code_Elements_Type;
    New_Payroll_Rec_            Hrp_Pay_List_Api.Public_Rec;
    New_Zpk_Log_Tab_            t_Log_Tab;
  BEGIN
    Calc_Accurate_  := TRUE;
    New_Period_Seq_ := To_Number(To_Char(Account_Date_, 'YYYYMM'));
    From_Date_      := Account_Date_;
    --
    FOR Wc_Rec_ IN Get_Wc_ LOOP
      IF 'TRANSACTION' = 'TRANSACTION' THEN
        Value_ := Wc_Rec_.Arythm_Sign *
                  Hrp_Wc_Archive_Api.Get_Value_For_Period(Company_Id_, Emp_No_, Wc_Rec_.Wage_Code_Id,
                                                          From_Date_, Last_Day(From_Date_));
        -- add details info
        IF Calc_Accurate_
           AND Value_ <> 0 THEN
          Zpk_Add_Details_Net_Factor___( --
                                        Zpk_Nf_Tab_, New_Wage_Code_Elements_Tab_, Company_Id_,
                                        Emp_No_,
                                        --
                                        New_Payroll_List_Id_, New_Payroll_Rec_, Wc_Group_,
                                        Wc_Bias_Group_, Gr_Contribution_, Gr_Base_, 'MONTHLY',
                                        Wc_Type_,
                                        --
                                        FALSE, Wc_Rec_.Wage_Code_Id, Value_, New_Period_Seq_,
                                        Trunc(From_Date_, 'MONTH'), Last_Day(From_Date_),
                                        Wc_Rec_.Arythm_Sign
                                        --
                                        );
        END IF;
      ELSE
        Value_ := 0;
      END IF;
      --
      Arch_Value_ := Value_;
      --
      -- prior calculation section for accurate netting factor calulation
      IF Calc_Accurate_ THEN
        Netting_Factor_ := Zpk_Calc_Details_Net_Factor___(1, Zpk_Nf_Tab_, New_Zpk_Log_Tab_,
                                                          Company_Id_, Emp_No_, New_Absence_Id_,
                                                          New_Payroll_List_Id_, New_Seq_,
                                                          New_Period_Seq_, 'MONTHLY', Wc_Type_,
                                                          From_Date_, Wc_Rec_.Wage_Code_Id);
      END IF;
      --
      IF Value_ != 0 THEN
        Wc_Value_ := Wc_Value_ + Value_;
        /*Client_Sys.Clear_Attr(attr_);
        Client_Sys.Add_To_Attr('COMPANY_ID',         company_id_,        attr_);
        Client_Sys.Add_To_Attr('EMP_NO',             emp_no_,            attr_);
        Client_Sys.Add_To_Attr('ABSENCE_ID',         rec_.absence_id,        attr_);
        Client_Sys.Add_To_Attr('SEQ',                rec_.seq,               attr_);
        Client_Sys.Add_To_Attr('PERIOD_SEQ',         rec_.period_seq,        attr_);
        Client_Sys.Add_To_Attr('WAGE_CODE_ID',       wc_rec_.wage_code_id,   attr_);
        --Client_Sys.Add_To_Attr('NETTING_FACTOR',     netting_factor_,        attr_);
        -- due to difficulties with the delivery of consistent value, netting factor will not be displayed to user
        Client_Sys.Add_To_Attr('NETTING_FACTOR',     0,        attr_);
        Client_Sys.Add_To_Attr('PARAM_ID',           param_id_,              attr_);
        Client_Sys.Add_To_Attr('VALUE',              value_,                 attr_);
        Client_Sys.Add_To_Attr('ARCH_VALUE',         arch_value_,            attr_);
        Client_Sys.Add_To_Attr('SYSTEM_GENERATED',   'TRUE',                 attr_);
        IF wc_type_= 'BASEEXCLUDED' THEN
           Client_Sys.Add_To_Attr('SELECTED',        'FALSE',                 attr_);
        ELSE
           Client_Sys.Add_To_Attr('SELECTED',        'TRUE',                 attr_);
        END IF;
        Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE',    Hrp_Abs_Wc_Type_Api.Decode(wc_type_), attr_);
        Hrp_Abs_Calc_Month_Wc_Api.New__(info_, objid_, objversion_, attr_, 'DOAUTO');*/
      END IF;
    END LOOP;
    -- for each period check netting factor and if neccesary actual one
    IF Calc_Accurate_
       AND Wc_Type_ != 'BASEEXCLUDED' THEN
      -- if necessary actual baias value
      Zpk_Recalc_Baias___(Zpk_Nf_Tab_, Company_Id_, Emp_No_, New_Payroll_Rec_, 'MONTHLY', Wc_Type_,
                          New_Period_Seq_, Trunc(From_Date_, 'MONTH'), Last_Day(From_Date_));
    ELSIF Calc_Accurate_
          AND Wc_Type_ = 'BASEEXCLUDED' THEN
      --
      Netting_Factor_ := Zpk_Calc_Details_Net_Factor___(2, Zpk_Nf_Tab_, New_Zpk_Log_Tab_,
                                                        Company_Id_, Emp_No_, New_Absence_Id_,
                                                        New_Payroll_List_Id_, New_Seq_,
                                                        New_Period_Seq_, 'MONTHLY', Wc_Type_,
                                                        From_Date_);
    END IF;
    Net_Factor_ := Netting_Factor_;
  END Insert_Wage_Codes_Adv1;
  PROCEDURE Classify_Year(Wc_Value_              IN OUT NUMBER,
                          Net_Factor_            OUT NUMBER,
                          Base_Rec_              IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                          Abs_Rec_               IN Absence_Registration_Tab%ROWTYPE,
                          Wc_Group_              IN VARCHAR2,
                          Base_Wc_Group_         IN VARCHAR2,
                          Contribution_Wc_Group_ IN VARCHAR2,
                          Payroll_List_Id_       IN VARCHAR2,
                          Payroll_Rec_           IN Hrp_Pay_List_Api.Public_Rec,
                          Calendar_Type_Id_      IN VARCHAR2,
                          Wc_Type_               IN VARCHAR2,
                          Bonus_Date_            IN DATE,
                          Paid_Way_              IN VARCHAR2,
                          Graced_Back_           IN NUMBER,
                          Ground_Months_         IN NUMBER,
                          --Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                          --Zpk_Log_Tab_            IN OUT t_Log_Tab,
                          Round_Precision_        IN NUMBER DEFAULT 4,
                          Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                          Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE',
                          Count_One_Year_         IN BOOLEAN DEFAULT FALSE) IS
    Date_Of_Employment_      DATE;
    Period_Date_From_        DATE;
    Graced_Period_Date_From_ DATE;
    Period_Date_To_          DATE;
    Num_Of_Months_In_Period_ NUMBER;
    Norma_Working_Days_      NUMBER;
    Working_Days_            NUMBER;
    Base_Value_              NUMBER;
    Contribution_Value_      NUMBER;
    Base_Value1_             NUMBER;
    Contribution_Value1_     NUMBER;
    Netting_Factor_          NUMBER := 0;
    Executed_                BOOLEAN := FALSE;
    Info_                    VARCHAR2(2000);
    Objid_                   VARCHAR2(2000);
    Objversion_              VARCHAR2(2000);
    Attr_                    VARCHAR2(2000);
    Param_Type_              VARCHAR2(50);
    Param_Value_             VARCHAR2(1000);
    Reduce_Normal_Days_      NUMBER := 0;
    Reduce_Worked_Days_      NUMBER := 0;
    Method_Of_Day_Taking_    VARCHAR2(20);
    Temp_                    VARCHAR2(1000);
    Check_Unempl_            VARCHAR2(10);
    Days_Type_               VARCHAR2(1000);
    Wage_Class_              VARCHAR2(200);
    Day_Sched_Code_          VARCHAR2(200);
    Start_Seq_No_            VARCHAR2(200);
    Valid_To_                DATE;
    Base_Year_Date_From_     DATE;
    Base_Year_Date_To_       DATE;
    Period_Seq_              NUMBER;
    Months_To_Calculate_     NUMBER;
    Temp_Date_From_          DATE;
    Temp_Date_To_            DATE;
    Temp_Norma_Working_Days_ NUMBER;
    Temp_Working_Days_       NUMBER;
    Temp_Value_              NUMBER;
    Tax_Period_To_           NUMBER;
    -- log tab
    Zpk_Log_Tab_            t_Log_Tab := t_Log_Tab();
    Wage_Code_Elements_Tab_ Hrp_Pay_List_Api.Wage_Code_Elements_Type;
    --
    CURSOR Get_Months_To_Nett_Factor IS
      SELECT Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH') Validation_Date
        FROM Hrp_Wc_Archive_Tab a
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
            --AND validation_date BET bonus_date_WEEN period_date_from_ AND period_date_to_
         AND Trunc(Validation_Date, 'MONTH') = Trunc(Bonus_Date_, 'MONTH')
         AND Bonus_Date_ IS NOT NULL
         AND Wage_Code_Id IN
             (SELECT Wage_Code_Id
                FROM Calculation_Group_Members_Tab b
               WHERE Company_Id = a.Company_Id
                 AND Calc_Group_Id = Wc_Group_
                 AND Calc_Group_Valid_From =
                     (SELECT MAX(c.Calc_Group_Valid_From)
                        FROM Calculation_Group_Tab c
                       WHERE c.Company_Id = b.Company_Id
                         AND c.Calc_Group_Id = b.Calc_Group_Id
                         AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date))
       GROUP BY Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH')
       ORDER BY Trunc(Validation_Date, 'MONTH') DESC;
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
  BEGIN
    Wc_Value_   := 0;
    Net_Factor_ := 0;
    --General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Classify_Year');
    Date_Of_Employment_ := Emp_Employed_Time_Api.Get_Date_Of_Employment(Base_Rec_.Company_Id,
                                                                        Base_Rec_.Emp_No,
                                                                        Abs_Rec_.Date_From);
    Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Check_Unempl_, Days_Type_, Abs_Rec_.Company_Id,
                                                Abs_Rec_.Absence_Type_Id, 'CHECKUNEMPDAYS', 'FALSE');
    IF Check_Unempl_ = 'YES'
       AND Days_Type_ IS NOT NULL THEN
      Work_Sched_Assign_Api.Get_Sched_Info(Wage_Class_, Day_Sched_Code_, Start_Seq_No_, Valid_To_,
                                           Abs_Rec_.Company_Id, Abs_Rec_.Emp_No, Date_Of_Employment_);
      WHILE Date_Of_Employment_ > Trunc(Date_Of_Employment_, 'MONTH') LOOP
        IF Payroll_Util_Api.Parse_Parameter(Day_Sched_Type_Api.Get_Day_Type(Abs_Rec_.Company_Id,
                                                                            Wage_Class_,
                                                                            Day_Sched_Code_,
                                                                            Start_Seq_No_,
                                                                            Date_Of_Employment_ - 1),
                                            Days_Type_) = 'FALSE' THEN
          EXIT;
        END IF;
        Date_Of_Employment_ := Date_Of_Employment_ - 1;
      END LOOP;
    END IF;
    IF Date_Of_Employment_ <> Trunc(Date_Of_Employment_, 'MONTH') THEN
      Date_Of_Employment_ := Last_Day(Date_Of_Employment_) + 1;
    END IF;
    Period_Date_To_          := Trunc(Abs_Rec_.Date_From, 'MONTH') - 1;
    Period_Date_From_        := Trunc(Add_Months(Abs_Rec_.Date_From, -1 * Ground_Months_), 'MONTH');
    Graced_Period_Date_From_ := Trunc(Add_Months(Abs_Rec_.Date_From,
                                                 -1 * Nvl(Graced_Back_, Ground_Months_)), 'MONTH');
    /*    IF Period_Date_To_ < Date_Of_Employment_ THEN
      RETURN 'FALSE';
    END IF;*/
    IF Period_Date_From_ < Date_Of_Employment_ THEN
      Period_Date_From_ := Date_Of_Employment_;
    END IF;
    IF Graced_Period_Date_From_ < Date_Of_Employment_ THEN
      Graced_Period_Date_From_ := Date_Of_Employment_;
    END IF;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_DEF', S1_ => 'ORGIN', D1_ => Period_Date_From_,
                         D2_ => Period_Date_To_);
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_DEF', S1_ => 'GRACE',
                         D1_ => Graced_Period_Date_From_, D2_ => Period_Date_To_,
                         D3_ => Period_Date_From_);
    Base_Value1_         := 0;
    Contribution_Value1_ := 0;
    -- for tax validation rule
    Tax_Period_To_ := To_Number(To_Char(Period_Date_To_, 'YYYYMM'));
    FOR Rec_ IN Get_Months_To_Nett_Factor LOOP
      Base_Value_         := 0;
      Contribution_Value_ := 0;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CONTR', S1_ => 'BASE_HEAD');
      FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
        --temp_value_ := 0;
        Temp_Value_ := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                               Bwc_Rec_.Wage_Code_Id, Rec_.Validation_Date,
                                               Last_Day(Rec_.Validation_Date), Tax_Period_To_,
                                               Paid_Way_) * Bwc_Rec_.Arythm_Sign;
        Base_Value_ := Base_Value_ + Temp_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CONTR', S1_ => 'BASE_BODY',
                             S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
      END LOOP;
      Base_Value1_ := Base_Value1_ + Base_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CONTR', S1_ => 'CONTR_HEAD');
      FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
        --temp_value_ := 0;
        Temp_Value_         := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                       Cwc_Rec_.Wage_Code_Id, Rec_.Validation_Date,
                                                       Last_Day(Rec_.Validation_Date), Tax_Period_To_,
                                                       Paid_Way_) * Cwc_Rec_.Arythm_Sign;
        Contribution_Value_ := Contribution_Value_ + Temp_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CONTR', S1_ => 'CONTR_BODY',
                             S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                             N2_ => Contribution_Value_);
      END LOOP;
      Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CONTR', S1_ => 'PERIOD',
                           N1_ => Contribution_Value_, N2_ => Contribution_Value1_,
                           N3_ => Base_Value_, N4_ => Base_Value1_, D1_ => Rec_.Validation_Date);
      -- only one loop for last validation appearance of bonus wage code period
      EXIT;
    END LOOP;
    -- current list
    Base_Value_         := 0;
    Contribution_Value_ := 0;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CUR', S1_ => 'BASE_HEAD',
                         D1_ => Graced_Period_Date_From_, D2_ => Period_Date_To_,
                         D3_ => Period_Date_From_);
    FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
      --base_value_ := base_value_ + Hrp_Pl_Wc_Value_API.Get_Value_Adv1( period_date_to_, bwc_rec_.wage_code_id, 2, period_date_from_,        wage_code_elements_tab_ ) * bwc_rec_.arythm_sign;
      --temp_value_ := 0;
      Temp_Value_ := Zpk_Get_Value_Adv___(Last_Day(Bonus_Date_), Bwc_Rec_.Wage_Code_Id, Paid_Way_,
                                          Trunc(Bonus_Date_, 'MONTH'), Period_Date_To_,
                                          Wage_Code_Elements_Tab_) * Bwc_Rec_.Arythm_Sign;
      Base_Value_ := Base_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CUR', S1_ => 'BASE_BODY',
                           S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
    END LOOP;
    Base_Value1_ := Base_Value1_ + Base_Value_;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CUR', S1_ => 'CONTR_HEAD');
    FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
      --contribution_value_ := contribution_value_ + Hrp_Pl_Wc_Value_API.Get_Value_Adv1( period_date_to_, cwc_rec_.wage_code_id, 2, period_date_from_,        wage_code_elements_tab_ ) * cwc_rec_.arythm_sign;
      --temp_value_ := 0;
      Temp_Value_         := Zpk_Get_Value_Adv___(Last_Day(Bonus_Date_), Cwc_Rec_.Wage_Code_Id,
                                                  Paid_Way_, Trunc(Bonus_Date_, 'MONTH'),
                                                  Period_Date_To_, Wage_Code_Elements_Tab_) *
                             Cwc_Rec_.Arythm_Sign;
      Contribution_Value_ := Contribution_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_CUR', S1_ => 'BASE_BODY',
                           S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                           N2_ => Contribution_Value_);
    END LOOP;
    --
    Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
    --
    IF (Nvl(Base_Value1_, 0) = 0 AND Nvl(Contribution_Value1_, 0) <> 0) THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'CONTRORBASENULL1: Null base for not null contribution value :P1 in calculation :P2 in period :P3',
                             Contribution_Value1_, 'YEARLY', To_Char(Period_Date_To_, 'YYYY-MM-DD'));
    END IF;
    IF (Nvl(Base_Value1_, 0) <> 0 AND Nvl(Contribution_Value1_, 0) = 0) THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'CONTRORBASENULL2: Null contribution for not null base value :P1 in calculation :P2 in period :P3',
                             Base_Value1_, 'YEARLY', To_Char(Period_Date_To_, 'YYYY-MM-DD'));
    END IF;
    --
    IF Base_Value1_ <> 0 THEN
      Netting_Factor_ := Round(Contribution_Value1_ / Base_Value1_, Round_Precision_) * -1;
    ELSE
      Netting_Factor_ := 0;
    END IF;
    -- warning
    -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_03_, '42000', n01_ => netting_factor_,s01_ => '');
    -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_04_, '42000', n01_ => netting_factor_,s01_ => '');
    --
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_ALL', S1_ => 'ALL',
                         N1_ => Contribution_Value1_, N2_ => Base_Value1_, N3_ => Netting_Factor_,
                         D1_ => Period_Date_To_);
    --
    IF Count_One_Year_ THEN
      IF Trunc(Period_Date_From_, 'Y') <> Trunc(Period_Date_To_, 'Y') THEN
        Num_Of_Months_In_Period_ := Months_Between((Add_Months(Trunc(Period_Date_From_, 'Y'), 12) - 1) + 1,
                                                   Period_Date_From_);
      ELSE
        Num_Of_Months_In_Period_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_);
      END IF;
    ELSE
      Num_Of_Months_In_Period_ := Months_Between(Last_Day(Bonus_Date_) + 1,
                                                 Greatest(Trunc(Bonus_Date_, 'YEAR'),
                                                           Date_Of_Employment_));
    END IF;
    --
    Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Method_Of_Day_Taking_, Temp_, Base_Rec_.Company_Id,
                                                Abs_Rec_.Absence_Type_Id, 'METHODOFDAYTAKING',
                                                'FALSE');
    IF Method_Of_Day_Taking_ = 'SCHEDULE' THEN
      Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                     Base_Rec_.Emp_No,
                                                                     Abs_Rec_.Absence_Type_Id,
                                                                     Period_Date_From_,
                                                                     Period_Date_To_);
      Working_Days_       := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                Base_Rec_.Emp_No,
                                                                Abs_Rec_.Absence_Type_Id,
                                                                Period_Date_From_, Period_Date_To_);
    ELSIF Method_Of_Day_Taking_ = 'ARCHIVE' THEN
      --Norma working days
      Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_, Base_Rec_.Company_Id,
                                                  Abs_Rec_.Absence_Type_Id, 'WCGROUPOFNWORKDAYS',
                                                  'FALSE');
      IF Param_Type_ = 'YES'
         AND Param_Value_ IS NOT NULL THEN
        Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                Base_Rec_.Emp_No,
                                                                                Param_Value_,
                                                                                Period_Date_From_,
                                                                                Period_Date_To_);
      ELSE
        Norma_Working_Days_ := 0;
      END IF;
      --Working days
      Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_, Base_Rec_.Company_Id,
                                                  Abs_Rec_.Absence_Type_Id, 'WCGROUPOFWORKDAYS',
                                                  'FALSE');
      IF Param_Type_ = 'YES'
         AND Param_Value_ IS NOT NULL THEN
        Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                          Base_Rec_.Emp_No,
                                                                          Param_Value_,
                                                                          Period_Date_From_,
                                                                          Period_Date_To_);
      ELSE
        Working_Days_ := 0;
      END IF;
    ELSIF Method_Of_Day_Taking_ = 'ARCHIVEANDSCHEDULE' THEN
      --Norma working days
      Norma_Working_Days_ := 0;
      Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_, Base_Rec_.Company_Id,
                                                  Abs_Rec_.Absence_Type_Id, 'WCGROUPOFNWORKDAYS',
                                                  'FALSE');
      IF Param_Type_ = 'YES'
         AND Param_Value_ IS NOT NULL THEN
        Months_To_Calculate_ := Months_Between(Period_Date_To_, Period_Date_From_) - 1;
        FOR i_ IN 0 .. Months_To_Calculate_ LOOP
          Temp_Date_From_          := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
          Temp_Date_To_            := Last_Day(Temp_Date_From_);
          Temp_Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                       Base_Rec_.Emp_No,
                                                                                       Param_Value_,
                                                                                       Temp_Date_From_,
                                                                                       Temp_Date_To_);
          IF Temp_Norma_Working_Days_ = 0 THEN
            Temp_Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                                Base_Rec_.Emp_No,
                                                                                Abs_Rec_.Absence_Type_Id,
                                                                                Temp_Date_From_,
                                                                                Temp_Date_To_);
          END IF;
          Norma_Working_Days_ := Norma_Working_Days_ + Temp_Norma_Working_Days_;
        END LOOP;
      ELSE
        Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                       Base_Rec_.Emp_No,
                                                                       Abs_Rec_.Absence_Type_Id,
                                                                       Period_Date_From_,
                                                                       Period_Date_To_);
      END IF;
      --Working days
      Working_Days_ := 0;
      Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_, Base_Rec_.Company_Id,
                                                  Abs_Rec_.Absence_Type_Id, 'WCGROUPOFWORKDAYS',
                                                  'FALSE');
      IF Param_Type_ = 'YES'
         AND Param_Value_ IS NOT NULL THEN
        Months_To_Calculate_ := Months_Between(Period_Date_To_, Period_Date_From_) - 1;
        FOR i_ IN 0 .. Months_To_Calculate_ LOOP
          Temp_Date_From_    := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
          Temp_Date_To_      := Last_Day(Temp_Date_From_);
          Temp_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                 Base_Rec_.Emp_No,
                                                                                 Param_Value_,
                                                                                 Temp_Date_From_,
                                                                                 Temp_Date_To_);
          IF Temp_Working_Days_ = 0 THEN
            Temp_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                     Base_Rec_.Emp_No,
                                                                     Abs_Rec_.Absence_Type_Id,
                                                                     Temp_Date_From_, Temp_Date_To_);
          END IF;
          Working_Days_ := Working_Days_ + Temp_Working_Days_;
        END LOOP;
      ELSE
        Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                            Abs_Rec_.Absence_Type_Id,
                                                            Period_Date_From_, Period_Date_To_);
      END IF;
    ELSE
      Norma_Working_Days_ := 0;
      Working_Days_       := 0;
    END IF;
    --
    Client_Sys.Clear_Attr(Attr_);
    Client_Sys.Add_To_Attr('COMPANY_ID', Base_Rec_.Company_Id, Attr_);
    Client_Sys.Add_To_Attr('EMP_NO', Base_Rec_.Emp_No, Attr_);
    Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
    Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
    Period_Seq_ := Hrp_Abs_Calc_Other_Api.Generate_Period_Seq(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                              Base_Rec_.Absence_Id, Base_Rec_.Seq,
                                                              'YEARLY');
    Client_Sys.Add_To_Attr('PERIOD_SEQ', Period_Seq_, Attr_);
    Client_Sys.Add_To_Attr('DATE_FROM', Period_Date_From_, Attr_);
    Client_Sys.Add_To_Attr('DATE_TO', Period_Date_To_, Attr_);
    Client_Sys.Add_To_Attr('WORKING_DAYS', Working_Days_, Attr_);
    Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Norma_Working_Days_, Attr_);
    Client_Sys.Add_To_Attr('MONTHS_IN_PERIOD', Num_Of_Months_In_Period_, Attr_);
    Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE', Hrp_Abs_Calc_Other_Type_Api.Decode('YEARLY'),
                           Attr_);
    Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_);
    Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', 0, Attr_);
    Client_Sys.Add_To_Attr('NETTING_FACTOR', Netting_Factor_, Attr_);
    Client_Sys.Add_To_Attr('NET_BASE_VALUE', 0, Attr_);
    Hrp_Abs_Calc_Other_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
    /**/
    IF Wc_Type_ = '1' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_,
                                                      Graced_Period_Date_From_, Bonus_Date_,
                                                      Paid_Way_, 'CONSTANT', 'YEARLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '2' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_,
                                                      Graced_Period_Date_From_, Bonus_Date_,
                                                      Paid_Way_, 'NOTUPDATED', 'YEARLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '3' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,graced_period_date_from_,bonus_date_,paid_way_,'UPDATE','YEARLY',    wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    ELSIF Wc_Type_ = '4' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,graced_period_date_from_,bonus_date_,paid_way_,'FIXED','YEARLY',     wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    END IF;
    --RETURN 'TRUE';
  END Classify_Year;
  FUNCTION Classify_4months(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                            Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                            Wc_Group_               IN VARCHAR2,
                            Base_Wc_Group_          IN VARCHAR2,
                            Contribution_Wc_Group_  IN VARCHAR2,
                            Payroll_List_Id_        IN VARCHAR2,
                            Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                            Calendar_Type_Id_       IN VARCHAR2,
                            Wc_Type_                IN VARCHAR2,
                            Paid_Way_               IN VARCHAR2,
                            Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                            Zpk_Log_Tab_            IN OUT t_Log_Tab,
                            Round_Precision_        IN NUMBER DEFAULT 4,
                            Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                            Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2 IS
    Date_Of_Employment_      DATE;
    Period_Date_From_        DATE;
    Period_Date_To_          DATE;
    Num_Of_Months_In_Period_ NUMBER;
    Quarter_                 NUMBER := 1;
    Norma_Working_Days_      NUMBER;
    Working_Days_            NUMBER;
    Base_Value_              NUMBER;
    Contribution_Value_      NUMBER;
    Base_Value1_             NUMBER;
    Contribution_Value1_     NUMBER;
    Netting_Factor_          NUMBER := 0;
    Executed_                BOOLEAN := FALSE;
    Info_                    VARCHAR2(2000);
    Objid_                   VARCHAR2(2000);
    Objversion_              VARCHAR2(2000);
    Attr_                    VARCHAR2(2000);
    Classify_Flag_           VARCHAR2(5) := 'FALSE';
    Param_Type_              VARCHAR2(50);
    Param_Value_             VARCHAR2(1000);
    Reduce_Normal_Days_      NUMBER := 0;
    Reduce_Worked_Days_      NUMBER := 0;
    Method_Of_Day_Taking_    VARCHAR2(20);
    Temp_                    VARCHAR2(1000);
    Check_Unempl_            VARCHAR2(10);
    Days_Type_               VARCHAR2(1000);
    Wage_Class_              VARCHAR2(200);
    Day_Sched_Code_          VARCHAR2(200);
    Start_Seq_No_            VARCHAR2(200);
    Valid_To_                DATE;
    Base_Quarter_Date_From_  DATE;
    Base_Quarter_Date_To_    DATE;
    Period_Seq_              NUMBER;
    Months_To_Calculate_     NUMBER;
    Temp_Date_From_          DATE;
    Temp_Date_To_            DATE;
    Temp_Norma_Working_Days_ NUMBER;
    Temp_Working_Days_       NUMBER;
    Next_Period_             BOOLEAN := TRUE;
    Period_                  NUMBER := 1;
    Temp_Base_Date_          DATE;
    Temp_Value_              NUMBER;
    Tax_Period_To_           NUMBER;
    CURSOR Get_Months_To_Nett_Factor IS
      SELECT Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH') Validation_Date
        FROM Hrp_Wc_Archive_Tab a
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Validation_Date BETWEEN Period_Date_From_ AND Period_Date_To_
         AND Wage_Code_Id IN
             (SELECT Wage_Code_Id
                FROM Calculation_Group_Members_Tab b
               WHERE Company_Id = a.Company_Id
                 AND Calc_Group_Id = Wc_Group_
                 AND Calc_Group_Valid_From =
                     (SELECT MAX(c.Calc_Group_Valid_From)
                        FROM Calculation_Group_Tab c
                       WHERE c.Company_Id = b.Company_Id
                         AND c.Calc_Group_Id = b.Calc_Group_Id
                         AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date))
       GROUP BY Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH');
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Classify_4Months');
    Date_Of_Employment_ := Emp_Employed_Time_Api.Get_Date_Of_Employment(Base_Rec_.Company_Id,
                                                                        Base_Rec_.Emp_No,
                                                                        Abs_Rec_.Date_From);
    Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Check_Unempl_, Days_Type_, Abs_Rec_.Company_Id,
                                                Abs_Rec_.Absence_Type_Id, 'CHECKUNEMPDAYS', 'FALSE');
    IF Check_Unempl_ = 'YES'
       AND Days_Type_ IS NOT NULL THEN
      Work_Sched_Assign_Api.Get_Sched_Info(Wage_Class_, Day_Sched_Code_, Start_Seq_No_, Valid_To_,
                                           Abs_Rec_.Company_Id, Abs_Rec_.Emp_No, Date_Of_Employment_);
      WHILE Date_Of_Employment_ > Trunc(Date_Of_Employment_, 'MONTH') LOOP
        IF Payroll_Util_Api.Parse_Parameter(Day_Sched_Type_Api.Get_Day_Type(Abs_Rec_.Company_Id,
                                                                            Wage_Class_,
                                                                            Day_Sched_Code_,
                                                                            Start_Seq_No_,
                                                                            Date_Of_Employment_ - 1),
                                            Days_Type_) = 'FALSE' THEN
          EXIT;
        END IF;
        Date_Of_Employment_ := Date_Of_Employment_ - 1;
      END LOOP;
    END IF;
    IF Date_Of_Employment_ <> Trunc(Date_Of_Employment_, 'MONTH') THEN
      Date_Of_Employment_ := Last_Day(Date_Of_Employment_) + 1;
    END IF;
    Period_Date_To_ := Abs_Rec_.Date_From;
    Temp_Base_Date_ := Period_Date_To_;
    Period_         := 1;
    WHILE Next_Period_ LOOP
      Netting_Factor_ := 0;
      Zpk_Mig_Abs_Calc_Base_Api.Get_Base_4months_Dates_(Abs_Rec_.Company_Id, Calendar_Type_Id_,
                                                        Temp_Base_Date_, Base_Quarter_Date_From_,
                                                        Base_Quarter_Date_To_);
      IF Base_Quarter_Date_From_ IS NULL
         OR Base_Quarter_Date_To_ IS NULL THEN
        Error_Sys.Record_General(Lu_Name_,
                                 'BASECALENNOTVALID: Absence base calendar type is not valid for absence id :P1.',
                                 Abs_Rec_.Absence_Id);
      END IF;
      IF Period_ = 1 THEN
        IF (Period_Date_To_ > Base_Quarter_Date_To_) THEN
          Period_Date_To_ := Base_Quarter_Date_To_;
        ELSE
          Period_Date_To_ := Last_Day(Add_Months(Period_Date_To_, -1));
        END IF;
      ELSE
        Period_Date_To_ := Base_Quarter_Date_To_;
      END IF;
      Temp_Base_Date_   := Base_Quarter_Date_From_ - 1;
      Period_Date_From_ := Greatest(Base_Quarter_Date_From_,
                                    Add_Months(Trunc(Abs_Rec_.Date_From, 'MM'), -12));
      IF Period_Date_From_ < Date_Of_Employment_ THEN
        Period_Date_From_ := Date_Of_Employment_;
      END IF;
      Period_ := Period_ + 1;
      IF Period_ > 5 THEN
        Next_Period_ := FALSE;
        EXIT;
      END IF;
      -- for tax validation rule
      Tax_Period_To_ := To_Number(To_Char(Abs_Rec_.Date_From, 'YYYYMM'));
      IF Period_Date_To_ >= Period_Date_From_ THEN
        Base_Value1_         := 0;
        Contribution_Value1_ := 0;
        FOR Rec_ IN Get_Months_To_Nett_Factor LOOP
          Base_Value_         := 0;
          Contribution_Value_ := 0;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CONTR', S1_ => 'BASE_HEAD');
          FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
            --temp_value_ := 0;
            Temp_Value_ := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                   Bwc_Rec_.Wage_Code_Id, Rec_.Validation_Date,
                                                   Last_Day(Rec_.Validation_Date), Tax_Period_To_) *
                           Bwc_Rec_.Arythm_Sign;
            Base_Value_ := Base_Value_ + Temp_Value_;
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CONTR', S1_ => 'BASE_BODY',
                                 S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                                 N2_ => Base_Value_);
          END LOOP;
          Base_Value1_ := Base_Value1_ + Base_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CONTR', S1_ => 'CONTR_HEAD');
          FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
            --temp_value_ := 0;
            Temp_Value_         := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                           Cwc_Rec_.Wage_Code_Id,
                                                           Rec_.Validation_Date,
                                                           Last_Day(Rec_.Validation_Date),
                                                           Tax_Period_To_) * Cwc_Rec_.Arythm_Sign;
            Contribution_Value_ := Contribution_Value_ + Temp_Value_;
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CONTR', S1_ => 'CONTR_BODY',
                                 S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                                 N2_ => Contribution_Value_);
          END LOOP;
          Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CONTR', S1_ => 'PERIOD',
                               N1_ => Contribution_Value_, N2_ => Contribution_Value1_,
                               N3_ => Base_Value_, N4_ => Base_Value1_, D1_ => Rec_.Validation_Date);
        END LOOP;
        -- current list
        Base_Value_         := 0;
        Contribution_Value_ := 0;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CUR', S1_ => 'BASE_HEAD',
                             D1_ => Period_Date_From_, D2_ => Period_Date_To_,
                             D3_ => Period_Date_From_);
        FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
          --temp_value_ := 0;
          Temp_Value_ := Zpk_Get_Value_Adv___(Period_Date_To_, Bwc_Rec_.Wage_Code_Id, Paid_Way_,
                                              Period_Date_From_, Period_Date_To_,
                                              Wage_Code_Elements_Tab_) * Bwc_Rec_.Arythm_Sign;
          Base_Value_ := Base_Value_ + Temp_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CUR', S1_ => 'BASE_BODY',
                               S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
        END LOOP;
        Base_Value1_ := Base_Value1_ + Base_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CUR', S1_ => 'CONTR_HEAD');
        FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
          --temp_value_ := 0;
          Temp_Value_         := Zpk_Get_Value_Adv___(Period_Date_To_, Cwc_Rec_.Wage_Code_Id,
                                                      Paid_Way_, Period_Date_From_, Period_Date_To_,
                                                      Wage_Code_Elements_Tab_) *
                                 Cwc_Rec_.Arythm_Sign;
          Contribution_Value_ := Contribution_Value_ + Temp_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_CUR', S1_ => 'BASE_BODY',
                               S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                               N2_ => Contribution_Value_);
        END LOOP;
        Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
        IF (Nvl(Base_Value1_, 0) = 0 AND Nvl(Contribution_Value1_, 0) <> 0) THEN
          Error_Sys.Appl_General(Lu_Name_,
                                 'CONTRORBASENULL1: Null base for not null contribution value :P1 in calculation :P2 in period :P3',
                                 Contribution_Value1_, '4MONTHLY',
                                 To_Char(Period_Date_To_, 'YYYY-MM-DD'));
        END IF;
        IF (Nvl(Base_Value1_, 0) <> 0 AND Nvl(Contribution_Value1_, 0) = 0) THEN
          Error_Sys.Appl_General(Lu_Name_,
                                 'CONTRORBASENULL2: Null contribution for not null base value :P1 in calculation :P2 in period :P3',
                                 Base_Value1_, '4MONTHLY', To_Char(Period_Date_To_, 'YYYY-MM-DD'));
        END IF;
        IF Base_Value1_ <> 0 THEN
          Netting_Factor_ := Round(Contribution_Value1_ / Base_Value1_, Round_Precision_) * -1;
        ELSE
          Netting_Factor_ := 0;
        END IF;
        -- warning
        -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_03_, '42000', n01_ => netting_factor_,s01_ => '');
        -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_04_, '42000', n01_ => netting_factor_,s01_ => '');
        Num_Of_Months_In_Period_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_);
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_ALL', S1_ => 'ALL',
                             N1_ => Contribution_Value1_, N2_ => Base_Value1_,
                             N3_ => Netting_Factor_, D1_ => Period_Date_To_);
        Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Method_Of_Day_Taking_, Temp_,
                                                    Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                    'METHODOFDAYTAKING', 'FALSE');
        IF Method_Of_Day_Taking_ = 'SCHEDULE' THEN
          Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                         Base_Rec_.Emp_No,
                                                                         Abs_Rec_.Absence_Type_Id,
                                                                         Period_Date_From_,
                                                                         Period_Date_To_);
          Working_Days_       := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                    Base_Rec_.Emp_No,
                                                                    Abs_Rec_.Absence_Type_Id,
                                                                    Period_Date_From_,
                                                                    Period_Date_To_);
          -----------------------------------------------------------------------------------------------------------------------------------------------------
        ELSIF Method_Of_Day_Taking_ = 'ARCHIVE' THEN
          --Norma working days
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFNWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                    Base_Rec_.Emp_No,
                                                                                    Param_Value_,
                                                                                    Period_Date_From_,
                                                                                    Period_Date_To_);
          ELSE
            Norma_Working_Days_ := 0;
          END IF;
          --Working days
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                              Base_Rec_.Emp_No,
                                                                              Param_Value_,
                                                                              Period_Date_From_,
                                                                              Period_Date_To_);
          ELSE
            Working_Days_ := 0;
          END IF;
          ----------------------------------------------------------------------------------------------------------------------------------------------------
        ELSIF Method_Of_Day_Taking_ = 'ARCHIVEANDSCHEDULE' THEN
          --Norma working days
          Norma_Working_Days_ := 0;
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFNWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Months_To_Calculate_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_) - 1;
            FOR i_ IN 0 .. Months_To_Calculate_ LOOP
              Temp_Date_From_          := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
              Temp_Date_To_            := Last_Day(Temp_Date_From_);
              Temp_Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                           Base_Rec_.Emp_No,
                                                                                           Param_Value_,
                                                                                           Temp_Date_From_,
                                                                                           Temp_Date_To_);
              IF Temp_Norma_Working_Days_ = 0 THEN
                Temp_Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                                    Base_Rec_.Emp_No,
                                                                                    Abs_Rec_.Absence_Type_Id,
                                                                                    Temp_Date_From_,
                                                                                    Temp_Date_To_);
              END IF;
              Norma_Working_Days_ := Norma_Working_Days_ + Temp_Norma_Working_Days_;
            END LOOP;
          ELSE
            Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                           Base_Rec_.Emp_No,
                                                                           Abs_Rec_.Absence_Type_Id,
                                                                           Period_Date_From_,
                                                                           Period_Date_To_);
          END IF;
          --Working days
          Working_Days_ := 0;
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Months_To_Calculate_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_) - 1;
            FOR i_ IN 0 .. Months_To_Calculate_ LOOP
              Temp_Date_From_    := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
              Temp_Date_To_      := Last_Day(Temp_Date_From_);
              Temp_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                     Base_Rec_.Emp_No,
                                                                                     Param_Value_,
                                                                                     Temp_Date_From_,
                                                                                     Temp_Date_To_);
              IF Temp_Working_Days_ = 0 THEN
                Temp_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                         Base_Rec_.Emp_No,
                                                                         Abs_Rec_.Absence_Type_Id,
                                                                         Temp_Date_From_,
                                                                         Temp_Date_To_);
              END IF;
              Working_Days_ := Working_Days_ + Temp_Working_Days_;
            END LOOP;
          ELSE
            Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                Base_Rec_.Emp_No,
                                                                Abs_Rec_.Absence_Type_Id,
                                                                Period_Date_From_, Period_Date_To_);
          END IF;
        ELSE
          Norma_Working_Days_ := 0;
          Working_Days_       := 0;
        END IF;
        Client_Sys.Clear_Attr(Attr_);
        Client_Sys.Add_To_Attr('COMPANY_ID', Base_Rec_.Company_Id, Attr_);
        Client_Sys.Add_To_Attr('EMP_NO', Base_Rec_.Emp_No, Attr_);
        Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
        Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
        IF Period_Seq_ IS NULL THEN
          Period_Seq_ := Hrp_Abs_Calc_Other_Api.Generate_Period_Seq(Base_Rec_.Company_Id,
                                                                    Base_Rec_.Emp_No,
                                                                    Base_Rec_.Absence_Id,
                                                                    Base_Rec_.Seq, 'M4MONTHLY');
        END IF;
        Client_Sys.Add_To_Attr('PERIOD_SEQ', Period_Seq_, Attr_);
        Client_Sys.Add_To_Attr('DATE_FROM', Period_Date_From_, Attr_);
        Client_Sys.Add_To_Attr('DATE_TO', Period_Date_To_, Attr_);
        Client_Sys.Add_To_Attr('WORKING_DAYS', Working_Days_, Attr_);
        Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Norma_Working_Days_, Attr_);
        Client_Sys.Add_To_Attr('MONTHS_IN_PERIOD', Num_Of_Months_In_Period_, Attr_);
        Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                               Hrp_Abs_Calc_Other_Type_Api.Decode('M4MONTHLY'), Attr_);
        Client_Sys.Add_To_Attr('SELECTED', 'FALSE', Attr_);
        Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', 0, Attr_);
        Client_Sys.Add_To_Attr('NETTING_FACTOR', Netting_Factor_, Attr_);
        Client_Sys.Add_To_Attr('NET_BASE_VALUE', 0, Attr_);
        Hrp_Abs_Calc_Other_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        Classify_Flag_ := 'TRUE';
      END IF;
    END LOOP;
    --
    IF Wc_Type_ = '1' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_, NULL, NULL,
                                                      Paid_Way_, 'CONSTANT', 'M4MONTHLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '2' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_, NULL, NULL,
                                                      Paid_Way_, 'NOTUPDATED', 'M4MONTHLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '3' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,NULL,NULL,paid_way_,'UPDATE','M4MONTHLY',    wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    ELSIF Wc_Type_ = '4' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,NULL,NULL,paid_way_,'FIXED','M4MONTHLY',     wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    END IF;
    --
    RETURN Classify_Flag_;
  END Classify_4months;
  FUNCTION Classify_Quarter(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                            Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                            Wc_Group_               IN VARCHAR2,
                            Base_Wc_Group_          IN VARCHAR2,
                            Contribution_Wc_Group_  IN VARCHAR2,
                            Payroll_List_Id_        IN VARCHAR2,
                            Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                            Calendar_Type_Id_       IN VARCHAR2,
                            Wc_Type_                IN VARCHAR2,
                            Paid_Way_               IN VARCHAR2,
                            Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                            Zpk_Log_Tab_            IN OUT t_Log_Tab,
                            Round_Precision_        IN NUMBER DEFAULT 4,
                            Period_Type_            IN VARCHAR2 DEFAULT 'TRANSACTION',
                            Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2 IS
    Date_Of_Employment_      DATE;
    Period_Date_From_        DATE;
    Period_Date_To_          DATE;
    Num_Of_Months_In_Period_ NUMBER;
    Quarter_                 NUMBER := 1;
    Norma_Working_Days_      NUMBER;
    Working_Days_            NUMBER;
    Base_Value_              NUMBER;
    Contribution_Value_      NUMBER;
    Base_Value1_             NUMBER;
    Contribution_Value1_     NUMBER;
    Netting_Factor_          NUMBER := 0;
    Executed_                BOOLEAN := FALSE;
    Info_                    VARCHAR2(2000);
    Objid_                   VARCHAR2(2000);
    Objversion_              VARCHAR2(2000);
    Attr_                    VARCHAR2(2000);
    Classify_Flag_           VARCHAR2(5) := 'FALSE';
    Param_Type_              VARCHAR2(50);
    Param_Value_             VARCHAR2(1000);
    Reduce_Normal_Days_      NUMBER := 0;
    Reduce_Worked_Days_      NUMBER := 0;
    Method_Of_Day_Taking_    VARCHAR2(20);
    Temp_                    VARCHAR2(1000);
    Check_Unempl_            VARCHAR2(10);
    Days_Type_               VARCHAR2(1000);
    Wage_Class_              VARCHAR2(200);
    Day_Sched_Code_          VARCHAR2(200);
    Start_Seq_No_            VARCHAR2(200);
    Valid_To_                DATE;
    Base_Quarter_Date_From_  DATE;
    Base_Quarter_Date_To_    DATE;
    Period_Seq_              NUMBER;
    Months_To_Calculate_     NUMBER;
    Temp_Date_From_          DATE;
    Temp_Date_To_            DATE;
    Temp_Norma_Working_Days_ NUMBER;
    Temp_Working_Days_       NUMBER;
    Next_Period_             BOOLEAN := TRUE;
    Period_                  NUMBER := 1;
    Temp_Base_Date_          DATE;
    Temp_Value_              NUMBER;
    Tax_Period_To_           NUMBER;
    Moved_Period_Date_From_ DATE;
    CURSOR Get_Months_To_Nett_Factor IS
      SELECT Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH') Validation_Date
        FROM Hrp_Wc_Archive_Tab a
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Validation_Date BETWEEN Period_Date_From_ AND Period_Date_To_
         AND Wage_Code_Id IN
             (SELECT Wage_Code_Id
                FROM Calculation_Group_Members_Tab b
               WHERE Company_Id = a.Company_Id
                 AND Calc_Group_Id = Wc_Group_
                 AND Calc_Group_Valid_From =
                     (SELECT MAX(c.Calc_Group_Valid_From)
                        FROM Calculation_Group_Tab c
                       WHERE c.Company_Id = b.Company_Id
                         AND c.Calc_Group_Id = b.Calc_Group_Id
                         AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date))
       GROUP BY Company_Id, Emp_No, Trunc(Validation_Date, 'MONTH');
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Classify_Quarter');
    Date_Of_Employment_ := Emp_Employed_Time_Api.Get_Date_Of_Employment(Base_Rec_.Company_Id,
                                                                        Base_Rec_.Emp_No,
                                                                        Abs_Rec_.Date_From);
    Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Check_Unempl_, Days_Type_, Abs_Rec_.Company_Id,
                                                Abs_Rec_.Absence_Type_Id, 'CHECKUNEMPDAYS', 'FALSE');
    IF Check_Unempl_ = 'YES'
       AND Days_Type_ IS NOT NULL THEN
      Work_Sched_Assign_Api.Get_Sched_Info(Wage_Class_, Day_Sched_Code_, Start_Seq_No_, Valid_To_,
                                           Abs_Rec_.Company_Id, Abs_Rec_.Emp_No, Date_Of_Employment_);
      WHILE Date_Of_Employment_ > Trunc(Date_Of_Employment_, 'MONTH') LOOP
        IF Payroll_Util_Api.Parse_Parameter(Day_Sched_Type_Api.Get_Day_Type(Abs_Rec_.Company_Id,
                                                                            Wage_Class_,
                                                                            Day_Sched_Code_,
                                                                            Start_Seq_No_,
                                                                            Date_Of_Employment_ - 1),
                                            Days_Type_) = 'FALSE' THEN
          EXIT;
        END IF;
        Date_Of_Employment_ := Date_Of_Employment_ - 1;
      END LOOP;
    END IF;
    IF Date_Of_Employment_ <> Trunc(Date_Of_Employment_, 'MONTH') THEN
      Date_Of_Employment_ := Last_Day(Date_Of_Employment_) + 1;
    END IF;
    Period_Date_To_ := Abs_Rec_.Date_From;
    Temp_Base_Date_ := Period_Date_To_;
    Period_         := 1;
    WHILE Next_Period_ LOOP
      Netting_Factor_ := 0;
      Hrp_Abs_Base_Cal_Type_Det_Api.Get_Base_Quarter_Dates(Abs_Rec_.Company_Id, Calendar_Type_Id_,
                                                           Temp_Base_Date_, Base_Quarter_Date_From_,
                                                           Base_Quarter_Date_To_);
      IF Base_Quarter_Date_From_ IS NULL
         OR Base_Quarter_Date_To_ IS NULL THEN
        Error_Sys.Record_General(Lu_Name_,
                                 'BASECALENNOTVALID: Absence base calendar type is not valid for absence id :P1.',
                                 Abs_Rec_.Absence_Id);
      END IF;
      IF Period_ = 1 THEN
        IF Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Base_Rec_.Company_Id, 'Z009',
                                                                      SYSDATE), 1) = 1 THEN
          -- full period classyfied
          Period_Date_To_ := Base_Quarter_Date_From_ - 1;
        ELSE
          IF (Period_Date_To_ > Base_Quarter_Date_To_) THEN
            Period_Date_To_ := Base_Quarter_Date_To_;
          ELSE
            Period_Date_To_ := Last_Day(Add_Months(Period_Date_To_, -1));
          END IF;
        END IF;
        --moved_period_date_from_ := add_months(trunc(period_date_to_,'MM'),-12);
        Moved_Period_Date_From_ := Add_Months(Trunc(Abs_Rec_.Date_From, 'MM'), -12);
      ELSE
        Period_Date_To_ := Base_Quarter_Date_To_;
      END IF;
      Temp_Base_Date_ := Base_Quarter_Date_From_ - 1;
      --period_date_from_ := greatest( base_quarter_date_from_, add_months(trunc(abs_rec_.date_from,'MM'),-12) );
      Period_Date_From_ := Greatest(Base_Quarter_Date_From_, Moved_Period_Date_From_);
      IF Period_Date_From_ < Date_Of_Employment_ THEN
        Period_Date_From_ := Date_Of_Employment_;
      END IF;
      Period_ := Period_ + 1;
      IF Period_ > 6 THEN
        Next_Period_ := FALSE;
        EXIT;
      END IF;
      -- for tax validation rule
      Tax_Period_To_ := To_Number(To_Char(Abs_Rec_.Date_From, 'YYYYMM'));
      IF Period_Date_To_ >= Period_Date_From_ THEN
        Base_Value1_         := 0;
        Contribution_Value1_ := 0;
        FOR Rec_ IN Get_Months_To_Nett_Factor LOOP
          Base_Value_         := 0;
          Contribution_Value_ := 0;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CONTR', S1_ => 'BASE_HEAD');
          FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
            --temp_value_ := 0;
            Temp_Value_ := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                   Bwc_Rec_.Wage_Code_Id, Rec_.Validation_Date,
                                                   Last_Day(Rec_.Validation_Date), Tax_Period_To_) *
                           Bwc_Rec_.Arythm_Sign;
            Base_Value_ := Base_Value_ + Temp_Value_;
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CONTR', S1_ => 'BASE_BODY',
                                 S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                                 N2_ => Base_Value_);
          END LOOP;
          Base_Value1_ := Base_Value1_ + Base_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CONTR', S1_ => 'CONTR_HEAD');
          FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
            --temp_value_ := 0;
            Temp_Value_         := Get_Value_For_Period___(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                           Cwc_Rec_.Wage_Code_Id,
                                                           Rec_.Validation_Date,
                                                           Last_Day(Rec_.Validation_Date),
                                                           Tax_Period_To_) * Cwc_Rec_.Arythm_Sign;
            Contribution_Value_ := Contribution_Value_ + Temp_Value_;
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CONTR', S1_ => 'CONTR_BODY',
                                 S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                                 N2_ => Contribution_Value_);
          END LOOP;
          Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CONTR', S1_ => 'PERIOD',
                               N1_ => Contribution_Value_, N2_ => Contribution_Value1_,
                               N3_ => Base_Value_, N4_ => Base_Value1_, D1_ => Rec_.Validation_Date);
        END LOOP;
        -- current list
        Base_Value_         := 0;
        Contribution_Value_ := 0;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CUR', S1_ => 'BASE_HEAD',
                             D1_ => Period_Date_From_, D2_ => Period_Date_To_,
                             D3_ => Period_Date_From_);
        FOR Bwc_Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
          --temp_value_ := 0;
          Temp_Value_ := Zpk_Get_Value_Adv___(Period_Date_To_, Bwc_Rec_.Wage_Code_Id, Paid_Way_,
                                              Period_Date_From_, Period_Date_To_,
                                              Wage_Code_Elements_Tab_) * Bwc_Rec_.Arythm_Sign;
          Base_Value_ := Base_Value_ + Temp_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CUR', S1_ => 'BASE_BODY',
                               S2_ => Bwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
        END LOOP;
        Base_Value1_ := Base_Value1_ + Base_Value_;
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CUR', S1_ => 'CONTR_HEAD');
        FOR Cwc_Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
          --temp_value_ := 0;
          Temp_Value_         := Zpk_Get_Value_Adv___(Period_Date_To_, Cwc_Rec_.Wage_Code_Id,
                                                      Paid_Way_, Period_Date_From_, Period_Date_To_,
                                                      Wage_Code_Elements_Tab_) *
                                 Cwc_Rec_.Arythm_Sign;
          Contribution_Value_ := Contribution_Value_ + Temp_Value_;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_CUR', S1_ => 'BASE_BODY',
                               S2_ => Cwc_Rec_.Wage_Code_Id, N1_ => Temp_Value_,
                               N2_ => Contribution_Value_);
        END LOOP;
        Contribution_Value1_ := Contribution_Value1_ + Contribution_Value_;
        IF (Nvl(Base_Value1_, 0) = 0 AND Nvl(Contribution_Value1_, 0) <> 0) THEN
          Error_Sys.Appl_General(Lu_Name_,
                                 'CONTRORBASENULL1: Null base for not null contribution value :P1 in calculation :P2 in period :P3',
                                 Contribution_Value1_, '3MONTHLY',
                                 To_Char(Period_Date_To_, 'YYYY-MM-DD'));
        END IF;
        IF (Nvl(Base_Value1_, 0) <> 0 AND Nvl(Contribution_Value1_, 0) = 0) THEN
          Error_Sys.Appl_General(Lu_Name_,
                                 'CONTRORBASENULL2: Null contribution for not null base value :P1 in calculation :P2 in period :P3',
                                 Base_Value1_, '3MONTHLY', To_Char(Period_Date_To_, 'YYYY-MM-DD'));
        END IF;
        IF Base_Value1_ <> 0 THEN
          Netting_Factor_ := Round(Contribution_Value1_ / Base_Value1_, Round_Precision_) * -1;
        ELSE
          Netting_Factor_ := 0;
        END IF;
        -- warning
        -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_03_, '42000', n01_ => netting_factor_,s01_ => '');
        -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_04_, '42000', n01_ => netting_factor_,s01_ => '');
        Num_Of_Months_In_Period_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_);
        Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_ALL', S1_ => 'ALL',
                             N1_ => Contribution_Value1_, N2_ => Base_Value1_,
                             N3_ => Netting_Factor_, D1_ => Period_Date_To_);
        Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Method_Of_Day_Taking_, Temp_,
                                                    Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                    'METHODOFDAYTAKING', 'FALSE');
        IF Method_Of_Day_Taking_ = 'SCHEDULE' THEN
          Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                         Base_Rec_.Emp_No,
                                                                         Abs_Rec_.Absence_Type_Id,
                                                                         Period_Date_From_,
                                                                         Period_Date_To_);
          Working_Days_       := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                    Base_Rec_.Emp_No,
                                                                    Abs_Rec_.Absence_Type_Id,
                                                                    Period_Date_From_,
                                                                    Period_Date_To_);
          -----------------------------------------------------------------------------------------------------------------------------------------------------
        ELSIF Method_Of_Day_Taking_ = 'ARCHIVE' THEN
          --Norma working days
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFNWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                    Base_Rec_.Emp_No,
                                                                                    Param_Value_,
                                                                                    Period_Date_From_,
                                                                                    Period_Date_To_);
          ELSE
            Norma_Working_Days_ := 0;
          END IF;
          --Working days
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                              Base_Rec_.Emp_No,
                                                                              Param_Value_,
                                                                              Period_Date_From_,
                                                                              Period_Date_To_);
          ELSE
            Working_Days_ := 0;
          END IF;
          ----------------------------------------------------------------------------------------------------------------------------------------------------
        ELSIF Method_Of_Day_Taking_ = 'ARCHIVEANDSCHEDULE' THEN
          --Norma working days
          Norma_Working_Days_ := 0;
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFNWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Months_To_Calculate_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_) - 1;
            FOR i_ IN 0 .. Months_To_Calculate_ LOOP
              Temp_Date_From_          := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
              Temp_Date_To_            := Last_Day(Temp_Date_From_);
              Temp_Norma_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                           Base_Rec_.Emp_No,
                                                                                           Param_Value_,
                                                                                           Temp_Date_From_,
                                                                                           Temp_Date_To_);
              IF Temp_Norma_Working_Days_ = 0 THEN
                Temp_Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                                    Base_Rec_.Emp_No,
                                                                                    Abs_Rec_.Absence_Type_Id,
                                                                                    Temp_Date_From_,
                                                                                    Temp_Date_To_);
              END IF;
              Norma_Working_Days_ := Norma_Working_Days_ + Temp_Norma_Working_Days_;
            END LOOP;
          ELSE
            Norma_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Norm_Work_Days(Base_Rec_.Company_Id,
                                                                           Base_Rec_.Emp_No,
                                                                           Abs_Rec_.Absence_Type_Id,
                                                                           Period_Date_From_,
                                                                           Period_Date_To_);
          END IF;
          --Working days
          Working_Days_ := 0;
          Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Param_Type_, Param_Value_,
                                                      Base_Rec_.Company_Id, Abs_Rec_.Absence_Type_Id,
                                                      'WCGROUPOFWORKDAYS', 'FALSE');
          IF Param_Type_ = 'YES'
             AND Param_Value_ IS NOT NULL THEN
            Months_To_Calculate_ := Months_Between(Period_Date_To_ + 1, Period_Date_From_) - 1;
            FOR i_ IN 0 .. Months_To_Calculate_ LOOP
              Temp_Date_From_    := Add_Months(Trunc(Period_Date_From_, 'MM'), i_);
              Temp_Date_To_      := Last_Day(Temp_Date_From_);
              Temp_Working_Days_ := Hrp_Wc_Archive_Api.Get_Wc_Group_Value_For_Period(Base_Rec_.Company_Id,
                                                                                     Base_Rec_.Emp_No,
                                                                                     Param_Value_,
                                                                                     Temp_Date_From_,
                                                                                     Temp_Date_To_);
              IF Temp_Working_Days_ = 0 THEN
                Temp_Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                         Base_Rec_.Emp_No,
                                                                         Abs_Rec_.Absence_Type_Id,
                                                                         Temp_Date_From_,
                                                                         Temp_Date_To_);
              END IF;
              Working_Days_ := Working_Days_ + Temp_Working_Days_;
            END LOOP;
          ELSE
            Working_Days_ := Hrp_Abs_Calc_Month_Api.s_Work_Days(Base_Rec_.Company_Id,
                                                                Base_Rec_.Emp_No,
                                                                Abs_Rec_.Absence_Type_Id,
                                                                Period_Date_From_, Period_Date_To_);
          END IF;
        ELSE
          Norma_Working_Days_ := 0;
          Working_Days_       := 0;
        END IF;
        Client_Sys.Clear_Attr(Attr_);
        Client_Sys.Add_To_Attr('COMPANY_ID', Base_Rec_.Company_Id, Attr_);
        Client_Sys.Add_To_Attr('EMP_NO', Base_Rec_.Emp_No, Attr_);
        Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
        Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
        IF Period_Seq_ IS NULL THEN
          Period_Seq_ := Hrp_Abs_Calc_Other_Api.Generate_Period_Seq(Base_Rec_.Company_Id,
                                                                    Base_Rec_.Emp_No,
                                                                    Base_Rec_.Absence_Id,
                                                                    Base_Rec_.Seq, 'QUARTERLY');
        END IF;
        Client_Sys.Add_To_Attr('PERIOD_SEQ', Period_Seq_, Attr_);
        Client_Sys.Add_To_Attr('DATE_FROM', Period_Date_From_, Attr_);
        Client_Sys.Add_To_Attr('DATE_TO', Period_Date_To_, Attr_);
        Client_Sys.Add_To_Attr('WORKING_DAYS', Working_Days_, Attr_);
        Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Norma_Working_Days_, Attr_);
        Client_Sys.Add_To_Attr('MONTHS_IN_PERIOD', Num_Of_Months_In_Period_, Attr_);
        Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                               Hrp_Abs_Calc_Other_Type_Api.Decode('QUARTERLY'), Attr_);
        Client_Sys.Add_To_Attr('SELECTED', 'FALSE', Attr_);
        Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', 0, Attr_);
        Client_Sys.Add_To_Attr('NETTING_FACTOR', Netting_Factor_, Attr_);
        Client_Sys.Add_To_Attr('NET_BASE_VALUE', 0, Attr_);
        Hrp_Abs_Calc_Other_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        Classify_Flag_ := 'TRUE';
      END IF;
    END LOOP;
    --
    IF Wc_Type_ = '1' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_, NULL, NULL,
                                                      Paid_Way_, 'CONSTANT', 'QUARTERLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '2' THEN
      Zpk_Mig_Abs_Calc_Base_Api.Insert_Wage_Codes_4_6(Base_Rec_, Period_Seq_, Payroll_Rec_,
                                                      Payroll_List_Id_, Wc_Group_, NULL, NULL,
                                                      Paid_Way_, 'NOTUPDATED', 'QUARTERLY',
                                                      Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                      Contribution_Wc_Group_, Base_Wc_Group_,
                                                      Period_Type_, Include_Payroll_Values_);
    ELSIF Wc_Type_ = '3' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,NULL,NULL,paid_way_,'UPDATE','QUARTERLY',    wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    ELSIF Wc_Type_ = '4' THEN
      NULL;
      --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_4_6(base_rec_,period_seq_,payroll_rec_,payroll_list_id_,wc_group_,NULL,NULL,paid_way_,'FIXED','QUARTERLY',     wage_code_elements_tab_,zpk_log_tab_,contribution_wc_group_,base_wc_group_,period_type_,include_payroll_values_);
    END IF;
    --
    RETURN Classify_Flag_;
  END Classify_Quarter;
  FUNCTION Classify_Month(Base_Rec_               IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                          Month_                  IN DATE,
                          Base_Wc_Group_          IN VARCHAR2,
                          Contribution_Wc_Group_  IN VARCHAR2,
                          Validation_Date_        IN DATE,
                          Abs_Rec_                IN Absence_Registration_Tab%ROWTYPE,
                          Payroll_List_Id_        IN VARCHAR2,
                          Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                          Zpk_Log_Tab_            IN OUT t_Log_Tab,
                          Round_Precision_        IN NUMBER DEFAULT 4,
                          Include_Payroll_Values_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2 IS
    Info_                 VARCHAR2(2000);
    Objid_                VARCHAR2(2000);
    Objversion_           VARCHAR2(2000);
    Attr_                 VARCHAR2(2000);
    Working_Days_         NUMBER;
    Norma_Working_Days_   NUMBER;
    Working_Hours_        NUMBER;
    Norma_Working_Hours_  NUMBER;
    Ret_Val_              VARCHAR2(5) := 'FALSE';
    Base_Value_           NUMBER := 0;
    Contribution_Value_   NUMBER := 0;
    Param_Type_           VARCHAR2(50);
    Param_Value_          VARCHAR2(1000);
    Reduce_Normal_Days_   NUMBER := 0;
    Reduce_Normal_Hours_  NUMBER := 0;
    Reduce_Worked_Days_   NUMBER := 0;
    Reduce_Worked_Hours_  NUMBER := 0;
    Method_Of_Day_Taking_ VARCHAR2(50);
    Temp_                 VARCHAR2(1000);
    Temp_Value_           NUMBER;
    Netting_Factor_       NUMBER;
    CURSOR Get_Wc_(Wc_Group_ VARCHAR2) IS
      SELECT b.*
        FROM Calculation_Group_Members_Tab b
       WHERE b.Company_Id = Base_Rec_.Company_Id
         AND b.Calc_Group_Id = Wc_Group_
         AND b.Calc_Group_Valid_From =
             (SELECT MAX(c.Calc_Group_Valid_From)
                FROM Calculation_Group_Tab c
               WHERE c.Company_Id = b.Company_Id
                 AND c.Calc_Group_Id = b.Calc_Group_Id
                 AND c.Calc_Group_Valid_From <= Validation_Date_);
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'HRP_ABS_CALC_MONTH_API', 'Classify_Month');
    Hrp_Abs_Calc_Month_Api.Calculate_Days_And_Hours(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                    Abs_Rec_.Absence_Type_Id, Trunc(Month_, 'MONTH'),
                                                    Last_Day(Month_), Working_Days_,
                                                    Norma_Working_Days_, Working_Hours_,
                                                    Norma_Working_Hours_);
    Client_Sys.Clear_Attr(Attr_);
    Client_Sys.Add_To_Attr('COMPANY_ID', Base_Rec_.Company_Id, Attr_);
    Client_Sys.Add_To_Attr('EMP_NO', Base_Rec_.Emp_No, Attr_);
    Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
    Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
    Client_Sys.Add_To_Attr('PERIOD_SEQ',
                           Hrp_Abs_Calc_Month_Api.Generate_Period_Seq(Base_Rec_.Company_Id,
                                                                       Base_Rec_.Emp_No,
                                                                       Base_Rec_.Absence_Id,
                                                                       Base_Rec_.Seq), Attr_);
    Client_Sys.Add_To_Attr('DATE_FROM', Trunc(Month_, 'MONTH'), Attr_);
    Client_Sys.Add_To_Attr('DATE_TO', Last_Day(Month_), Attr_);
    Client_Sys.Add_To_Attr('WORKING_DAYS', Working_Days_, Attr_);
    Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Norma_Working_Days_, Attr_);
    Client_Sys.Add_To_Attr('WORKING_HOURS', Working_Hours_, Attr_);
    Client_Sys.Add_To_Attr('NORMA_WORKING_HOURS', Norma_Working_Hours_, Attr_);
    IF Norma_Working_Days_ / 2 > Working_Days_
       OR Norma_Working_Days_ = 0 THEN
      Client_Sys.Add_To_Attr('SELECTED', 'FALSE', Attr_);
    ELSE
      Client_Sys.Add_To_Attr('SELECTED', 'TRUE', Attr_);
      Ret_Val_ := 'TRUE';
    END IF;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'BASE_HEAD');
    FOR Rec_ IN Get_Wc_(Base_Wc_Group_) LOOP
      --temp_value_ := 0;
      Temp_Value_ := Hrp_Wc_Archive_Api.Get_Value_For_Period(Rec_.Company_Id, Base_Rec_.Emp_No,
                                                             Rec_.Wage_Code_Id,
                                                             Trunc(Month_, 'MONTH'), Last_Day(Month_)) *
                     Rec_.Arythm_Sign;
      Base_Value_ := Base_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'BASE_BODY',
                           S2_ => Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Base_Value_);
      IF Include_Payroll_Values_ = 'TRUE' THEN
        --base_value_ := nvl(base_value_,0) + Hrp_Pl_Wc_Value_API.Get_Value_Adv1( last_day(month_), rec_.wage_code_id, 2, trunc(month_, 'MONTH'), wage_code_elements_tab_ ) * rec_.arythm_sign;
        --temp_value_ := 0;
        Temp_Value_ := Hrp_Pl_Wc_Value_Api.Get_Value_Adv1(Last_Day(Month_), Rec_.Wage_Code_Id, 2,
                                                          Trunc(Month_, 'MONTH'),
                                                          Wage_Code_Elements_Tab_) *
                       Rec_.Arythm_Sign;
        Base_Value_ := Base_Value_ + Temp_Value_;
        IF Temp_Value_ <> 0 THEN
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'BASE_BODY',
                               S2_ => Rec_.Wage_Code_Id, S3_ => 'CURRENTLIST', N1_ => Temp_Value_,
                               N2_ => Base_Value_);
        END IF;
      END IF;
    END LOOP;
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'CONTR_HEAD');
    FOR Rec_ IN Get_Wc_(Contribution_Wc_Group_) LOOP
      --contribution_value_ := contribution_value_ + Hrp_Wc_Archive_Api.Get_Value_For_Period(rec_.company_id, base_rec_.emp_no, rec_.wage_code_id, trunc(month_, 'MONTH'), last_day(month_)) * rec_.arythm_sign;
      --temp_value_ := 0;
      Temp_Value_         := Hrp_Wc_Archive_Api.Get_Value_For_Period(Rec_.Company_Id,
                                                                     Base_Rec_.Emp_No,
                                                                     Rec_.Wage_Code_Id,
                                                                     Trunc(Month_, 'MONTH'),
                                                                     Last_Day(Month_)) *
                             Rec_.Arythm_Sign;
      Contribution_Value_ := Contribution_Value_ + Temp_Value_;
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'CONTR_BODY',
                           S2_ => Rec_.Wage_Code_Id, N1_ => Temp_Value_, N2_ => Contribution_Value_);
      IF Include_Payroll_Values_ = 'TRUE' THEN
        --contribution_value_ := nvl(contribution_value_,0) + Hrp_Pl_Wc_Value_API.Get_Value_Adv1( last_day(month_), rec_.wage_code_id, 2, trunc(month_, 'MONTH'), wage_code_elements_tab_ )* rec_.arythm_sign;
        --temp_value_ := 0;
        Temp_Value_         := Hrp_Pl_Wc_Value_Api.Get_Value_Adv1(Last_Day(Month_),
                                                                  Rec_.Wage_Code_Id, 2,
                                                                  Trunc(Month_, 'MONTH'),
                                                                  Wage_Code_Elements_Tab_) *
                               Rec_.Arythm_Sign;
        Contribution_Value_ := Contribution_Value_ + Temp_Value_;
        IF Temp_Value_ <> 0 THEN
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'CONTR_BODY',
                               S2_ => Rec_.Wage_Code_Id, S3_ => 'CURRENTLIST', N1_ => Temp_Value_,
                               N2_ => Contribution_Value_);
        END IF;
      END IF;
    END LOOP;
    IF Base_Value_ <> 0
       AND Ret_Val_ = 'TRUE' THEN
      Netting_Factor_ := Round(Contribution_Value_ / Base_Value_, Round_Precision_) * -1;
      Client_Sys.Add_To_Attr('NETTING_FACTOR', Netting_Factor_, Attr_);
    ELSE
      Client_Sys.Add_To_Attr('NETTING_FACTOR', 0, Attr_);
    END IF;
    -- warning
    -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_03_, '42000', n01_ => netting_factor_,s01_ => '');
    -- Zpk_Warrning_Add___(base_rec_.company_id, base_rec_.emp_no, payroll_list_id_, GL_WARRNING_04_, '42000', n01_ => netting_factor_,s01_ => '');
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_CONTR', S1_ => 'PERIOD', N1_ => Base_Value_,
                         N3_ => Contribution_Value_, N4_ => Netting_Factor_, D1_ => Last_Day(Month_));
    --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_MONTHLY_ALL',s1_ => 'ALL',    n1_ => contribution_value_,n2_ => base_value_,n3_ => netting_factor_);
    Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', 0, Attr_);
    Client_Sys.Add_To_Attr('NET_BASE_VALUE', 0, Attr_);
    Hrp_Abs_Calc_Month_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
    RETURN Ret_Val_;
  END Classify_Month;
  FUNCTION Check_And_Copy_Base(Abs_Rec_               IN Absence_Registration_Tab%ROWTYPE,
                               Payroll_List_Id_       IN VARCHAR2,
                               Payroll_Rec_           IN Hrp_Pay_List_Api.Public_Rec,
                               No_Of_Months_          IN NUMBER,
                               Abs_Calc_Base_Type_Id_ IN VARCHAR2,
                               Constant_Wc_Group_     IN VARCHAR2,
                               Notupdated_Wc_Group_   IN VARCHAR2,
                               Updated_Wc_Group_      IN VARCHAR2,
                               Zpk_Log_Tab_           IN OUT t_Log_Tab) RETURN VARCHAR2 IS
    Base_Rec_         Hrp_Abs_Calc_Base_Tab%ROWTYPE;
    Check_From_       DATE;
    Check_To_         DATE;
    Assignment_From_  DATE;
    Assignment_To_    DATE;
    Do_Another_       VARCHAR2(10);
    Abs_Type_         VARCHAR2(2000);
    Calc_Param_Type_  VARCHAR2(100);
    Calc_Param_Value_ VARCHAR2(100);
    Assignment_Type_  VARCHAR2(100);
    Work_Time_        NUMBER;
    Dummy_            VARCHAR2(1);
    Temp_Assignment_Type_ VARCHAR2(100);
    Temp_Assignment_From_ DATE;
    Temp_Assignment_To_   DATE;
    Temp_Work_Time_       NUMBER;
    CURSOR C2_ IS
      SELECT a.*
        FROM Hrp_Abs_Calc_Base_Tab a, Absence_Registration_Tab b
       WHERE a.Company_Id = b.Company_Id
         AND a.Emp_No = b.Emp_No
         AND a.Absence_Id = b.Absence_Id
         AND a.Emp_No = Abs_Rec_.Emp_No
         AND a.Company_Id = Abs_Rec_.Company_Id
         AND b.Rowstate NOT IN ('Cancelled', 'CalculationCancelled')
         AND Payroll_Util_Api.Parse_Parameter(b.Absence_Type_Id, Abs_Type_) = 'TRUE'
         AND b.Date_To BETWEEN Check_From_ AND Check_To_
         AND b.Date_From BETWEEN Assignment_From_ AND Assignment_To_
         AND a.Abs_Calc_Base_Type_Id = Abs_Calc_Base_Type_Id_
       ORDER BY b.Date_From DESC, a.Entry_Date DESC, a.Seq DESC;
    CURSOR C3_ IS
      SELECT a.*
        FROM Hrp_Abs_Calc_Base_Tab a, Absence_Registration_Tab b
       WHERE a.Company_Id = b.Company_Id
         AND a.Emp_No = b.Emp_No
         AND a.Absence_Id = b.Absence_Id
         AND a.Emp_No = Abs_Rec_.Emp_No
         AND a.Company_Id = Abs_Rec_.Company_Id
         AND b.Absence_Id = Abs_Rec_.Absence_Id
         AND a.Alternative_Wc IS NOT NULL
         AND b.Rowstate NOT IN ('Cancelled', 'CalculationCancelled')
         AND a.Abs_Calc_Base_Type_Id = Abs_Calc_Base_Type_Id_
       ORDER BY a.Entry_Date DESC, a.Seq DESC;
    CURSOR C4_(c_Absence_Id_ NUMBER) IS
      SELECT '1'
        FROM Absence_Registration_Tab t
       WHERE t.Company_Id = Abs_Rec_.Company_Id
         AND t.Emp_No = Abs_Rec_.Emp_No
         AND t.Absence_Id = c_Absence_Id_
         AND t.Rowstate IN ('Partly Calculated', 'Calculated')
         AND EXISTS (SELECT 1
                FROM Absence_Period_Calculation_Tab p
               WHERE p.Company_Id = t.Company_Id
                 AND p.Emp_No = t.Emp_No
                 AND p.Absence_Id = t.Absence_Id
                 AND (p.Amount <> 0 OR p.Payroll_List_Id = 'MIGRATION'))
      UNION ALL
      SELECT '1'
        FROM Absence_Registration_Tab t
       WHERE t.Company_Id = Abs_Rec_.Company_Id
         AND t.Emp_No = Abs_Rec_.Emp_No
         AND t.Absence_Id = c_Absence_Id_
         AND t.Rowstate IN ('Registered');
    CURSOR Get_Assignment(Valid_From_ DATE) IS
      SELECT Cpa.Assignment_Id, Cpa.Valid_From, Cpa.Valid_To, Pat.Work_Time
        FROM Company_Pers_Assign_Tab Cpa, Pers_Assignment_Type_Tab Pat
       WHERE Cpa.Assignment_Id = Pat.Assignment_Id
         AND Cpa.Company_Id = Abs_Rec_.Company_Id
         AND Cpa.Emp_No = Abs_Rec_.Emp_No
         AND Cpa.Primary = '1'
         AND Valid_From_ BETWEEN Cpa.Valid_From AND Cpa.Valid_To;
    CURSOR Get_Assignment1(Valid_From_ DATE, Valid_To_ DATE) IS
      SELECT Cpa.Assignment_Id, Cpa.Valid_From, Cpa.Valid_To, Pat.Work_Time
        FROM Company_Pers_Assign_Tab Cpa, Pers_Assignment_Type_Tab Pat
       WHERE Cpa.Assignment_Id = Pat.Assignment_Id
         AND Cpa.Company_Id = Abs_Rec_.Company_Id
         AND Cpa.Emp_No = Abs_Rec_.Emp_No
         AND Cpa.Primary = '1'
         AND ((Cpa.Valid_From BETWEEN Valid_From_ AND Valid_To_) OR
             (Cpa.Valid_From < Valid_From_ AND Cpa.Valid_To >= Valid_From_))
       ORDER BY Valid_From DESC;
    -- new cursor definition
    CURSOR Zpk_Get_Assignment(Valid_From_ DATE) IS
      SELECT Cpa.Assignment_Id, Cpa.Valid_From, Cpa.Valid_To, Pat.Work_Time
        FROM Company_Pers_Assign_Tab Cpa, Pers_Assignment_Type_Tab Pat
       WHERE Cpa.Assignment_Id = Pat.Assignment_Id
         AND Cpa.Company_Id = Abs_Rec_.Company_Id
         AND Cpa.Emp_No = Abs_Rec_.Emp_No
         AND Cpa.Primary = '1'
         AND Cpa.Valid_From <= Valid_From_
       ORDER BY Cpa.Valid_From DESC;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Check_And_Copy_Base');
    Check_From_ := Add_Months(Trunc(Abs_Rec_.Date_From, 'MONTH'), No_Of_Months_ * -1);
    Check_To_   := Abs_Rec_.Date_From - 1;
    /*
    OPEN get_assignment(abs_rec_.date_from);
    FETCH get_assignment INTO assignment_type_,assignment_from_,assignment_to_,work_time_;
    CLOSE get_assignment;
    */
    OPEN Zpk_Get_Assignment(Abs_Rec_.Date_From);
    LOOP
      FETCH Zpk_Get_Assignment
        INTO Temp_Assignment_Type_, Temp_Assignment_From_, Temp_Assignment_To_, Temp_Work_Time_;
      --
      EXIT WHEN Zpk_Get_Assignment%NOTFOUND;
      EXIT WHEN Temp_Work_Time_ != Work_Time_ AND Temp_Work_Time_ IS NOT NULL AND Work_Time_ IS NOT NULL;
      Assignment_Type_ := Temp_Assignment_Type_;
      Assignment_From_ := Least(Nvl(Assignment_From_, Temp_Assignment_From_), Temp_Assignment_From_);
      Assignment_To_   := Greatest(Nvl(Assignment_To_, Temp_Assignment_To_), Temp_Assignment_To_);
      Work_Time_       := Temp_Work_Time_;
    END LOOP;
    CLOSE Zpk_Get_Assignment;
    /*
    FOR rec_ IN get_assignment1(check_from_, check_to_) LOOP
    IF work_time_ = rec_.work_time THEN
    assignment_from_ := LEAST(assignment_from_, rec_.valid_from);
    END IF;
    EXIT WHEN work_time_ != rec_.work_time;
    END LOOP;
    */
    Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Do_Another_, Abs_Type_, Abs_Rec_.Company_Id,
                                                Abs_Rec_.Absence_Type_Id, 'COPYBASEANOTHER', 'FALSE');
    IF Do_Another_ = 'YES'
       AND Abs_Type_ IS NOT NULL THEN
      OPEN C2_;
      FETCH C2_
        INTO Base_Rec_;
      IF C2_%FOUND THEN
        CLOSE C2_;
        -- Check that any of the periods of the selected absence have ever been paid
        OPEN C4_(Base_Rec_.Absence_Id);
        FETCH C4_
          INTO Dummy_;
        IF C4_%FOUND THEN
          CLOSE C4_;
          --
          Copy_Base(Base_Rec_, Abs_Rec_, Payroll_List_Id_, Payroll_Rec_, Constant_Wc_Group_,
                    Notupdated_Wc_Group_, Updated_Wc_Group_);
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_DEF', S1_ => 'BASECOPIED',
                               S2_ => Do_Another_, S3_ => Abs_Type_, D1_ => Check_From_,
                               D2_ => Check_To_, D3_ => Assignment_From_, D4_ => Assignment_To_);
          RETURN 'COPPIED';
          --
        END IF;
        CLOSE C4_;
      END IF;
      --
      IF C2_%ISOPEN THEN
        CLOSE C2_;
      END IF;
    END IF;
    --   /*
    --   -- alternative wc copied reason
    --   Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(calc_param_type_, calc_param_value_, abs_rec_.company_id, abs_rec_.absence_type_id, 'ALTERNATIVEAVGRATE', 'FALSE');
    --   IF nvl(calc_param_type_,'NO') = 'YES' AND calc_param_value_ IS NOT NULL THEN
    --      OPEN c3_;
    --      FETCH c3_ INTO base_rec_;
    --      IF c3_%FOUND THEN
    --         CLOSE c3_;
    --         Copy_Base(base_rec_, abs_rec_, payroll_list_id_, payroll_rec_, constant_wc_group_, notupdated_wc_group_, updated_wc_group_ );
    --         Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_MONTHLY_DEF',s1_ => 'BASECOPIEDALTERNATIVE',
    --                              s2_ => do_another_,s3_ => abs_type_,
    --                              d1_ => check_from_,d2_ => check_to_,d3_ => assignment_from_,d4_ => assignment_to_);
    --         RETURN 'COPPIED';
    --      END IF;
    --      CLOSE c3_;
    --   END IF;
    --   */
    Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_DEF', S1_ => 'BASENOTFOUND',
                         S2_ => Do_Another_, S3_ => Abs_Type_, D1_ => Check_From_, D2_ => Check_To_,
                         D3_ => Assignment_From_, D4_ => Assignment_To_);
    RETURN 'NOTFOUND';
  END Check_And_Copy_Base;
  PROCEDURE Copy_Base(Base_Rec_        IN Hrp_Abs_Calc_Base_Tab%ROWTYPE,
                      Abs_Rec_To_      IN Absence_Registration_Tab%ROWTYPE,
                      Payroll_List_Id_ IN VARCHAR2,
                      Payroll_Rec_     IN Hrp_Pay_List_Api.Public_Rec,
                      Wc_Group1_       IN VARCHAR2 DEFAULT NULL,
                      Wc_Group2_       IN VARCHAR2 DEFAULT NULL,
                      Wc_Group3_       IN VARCHAR2 DEFAULT NULL) IS
    Info_           VARCHAR2(2000);
    Objid_          VARCHAR2(2000);
    Objversion_     VARCHAR2(2000);
    Attr_           VARCHAR2(2000);
    Seq_            NUMBER;
    Wc_Group_Valid_ NUMBER;
    CURSOR Month_ IS
      SELECT *
        FROM Hrp_Abs_Calc_Month_Tab
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Absence_Id = Base_Rec_.Absence_Id
         AND Seq = Base_Rec_.Seq;
    CURSOR Month_Wc_(Period_Seq_ NUMBER) IS
      SELECT *
        FROM Hrp_Abs_Calc_Month_Wc_Tab
       WHERE Company_Id = Base_Rec_.Company_Id
         AND Emp_No = Base_Rec_.Emp_No
         AND Absence_Id = Base_Rec_.Absence_Id
         AND Seq = Base_Rec_.Seq
         AND Period_Seq = Period_Seq_
         AND Param_Id IS NULL
         AND Agreement_No IS NULL;
    FUNCTION Check_Wc___(Wage_Code_Id_ VARCHAR2, Wc_Group_Valid_ NUMBER) RETURN BOOLEAN IS
      Dummy_ NUMBER;
      CURSOR Check_Wc_ IS
        SELECT 1
          FROM Calculation_Group_Members_Tab b
         WHERE b.Company_Id = Base_Rec_.Company_Id
           AND b.Calc_Group_Id IN (Wc_Group1_, Wc_Group2_, Wc_Group3_)
           AND b.Wage_Code_Id = Wage_Code_Id_
           AND b.Calc_Group_Valid_From =
               (SELECT MAX(c.Calc_Group_Valid_From)
                  FROM Calculation_Group_Tab c
                 WHERE c.Company_Id = b.Company_Id
                   AND c.Calc_Group_Id = b.Calc_Group_Id
                   AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
    BEGIN
      -- froce not checking
      IF Wc_Group_Valid_ = 0 THEN
        RETURN(TRUE);
      END IF;
      OPEN Check_Wc_;
      FETCH Check_Wc_
        INTO Dummy_;
      IF (Check_Wc_%FOUND) THEN
        CLOSE Check_Wc_;
        RETURN(TRUE);
      END IF;
      CLOSE Check_Wc_;
      RETURN FALSE;
    END Check_Wc___;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Copy_Base');
    Wc_Group_Valid_ := Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Abs_Rec_To_.Company_Id,
                                                                                  'Z010', SYSDATE), 0);
    Seq_ := Hrp_Abs_Calc_Base_Api.Set_Seq(Abs_Rec_To_.Company_Id, Abs_Rec_To_.Emp_No,
                                          Abs_Rec_To_.Absence_Id);
    Client_Sys.Clear_Attr(Attr_);
    Client_Sys.Add_To_Attr('COMPANY_ID', Abs_Rec_To_.Company_Id, Attr_);
    Client_Sys.Add_To_Attr('EMP_NO', Abs_Rec_To_.Emp_No, Attr_);
    Client_Sys.Add_To_Attr('ABSENCE_ID', Abs_Rec_To_.Absence_Id, Attr_);
    Client_Sys.Add_To_Attr('SEQ', Seq_, Attr_);
    Client_Sys.Add_To_Attr('ENTRY_DATE', Payroll_Rec_.Validation_Date, Attr_);
    Client_Sys.Add_To_Attr('AVERAGE_RATE', Base_Rec_.Average_Rate, Attr_);
    -- annopl Client_Sys.Add_To_Attr('CORECTED', 'FALSE', attr_);
    Client_Sys.Add_To_Attr('CORECTED', Base_Rec_.Corected, Attr_);
    Client_Sys.Add_To_Attr('PAYROLL_LIST_ID', Payroll_List_Id_, Attr_);
    Client_Sys.Add_To_Attr('COPIED_FROM_ABS_ID', Base_Rec_.Absence_Id, Attr_);
    Client_Sys.Add_To_Attr('AVG_RATE_CORECTION', Base_Rec_.Avg_Rate_Corection, Attr_);
    Client_Sys.Add_To_Attr('VALORIZATION_RATE', Base_Rec_.Valorization_Rate, Attr_);
    Client_Sys.Add_To_Attr('BASE_AFTER_VALORIZATION', Base_Rec_.Base_After_Valorization, Attr_);
    Client_Sys.Add_To_Attr('ABS_CALC_BASE_TYPE_ID', Base_Rec_.Abs_Calc_Base_Type_Id, Attr_);
    Hrp_Abs_Calc_Base_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
    FOR Month_Rec_ IN Month_ LOOP
      Client_Sys.Clear_Attr(Attr_);
      Client_Sys.Add_To_Attr('COMPANY_ID', Abs_Rec_To_.Company_Id, Attr_);
      Client_Sys.Add_To_Attr('EMP_NO', Abs_Rec_To_.Emp_No, Attr_);
      Client_Sys.Add_To_Attr('ABSENCE_ID', Abs_Rec_To_.Absence_Id, Attr_);
      Client_Sys.Add_To_Attr('SEQ', Seq_, Attr_);
      Client_Sys.Add_To_Attr('PERIOD_SEQ', Month_Rec_.Period_Seq, Attr_);
      Client_Sys.Add_To_Attr('DATE_FROM', Month_Rec_.Date_From, Attr_);
      Client_Sys.Add_To_Attr('DATE_TO', Month_Rec_.Date_To, Attr_);
      Client_Sys.Add_To_Attr('WORKING_DAYS', Month_Rec_.Working_Days, Attr_);
      Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Month_Rec_.Norma_Working_Days, Attr_);
      Client_Sys.Add_To_Attr('WORKING_HOURS', Month_Rec_.Working_Hours, Attr_);
      Client_Sys.Add_To_Attr('NORMA_WORKING_HOURS', Month_Rec_.Norma_Working_Hours, Attr_);
      Client_Sys.Add_To_Attr('SELECTED', Month_Rec_.Selected, Attr_);
      Client_Sys.Add_To_Attr('DESCRIPTION', Month_Rec_.Description, Attr_);
      Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', Month_Rec_.Gross_Base_Value, Attr_);
      Client_Sys.Add_To_Attr('NETTING_FACTOR', Month_Rec_.Netting_Factor, Attr_);
      Client_Sys.Add_To_Attr('NET_BASE_VALUE', Month_Rec_.Net_Base_Value, Attr_);
      Client_Sys.Add_To_Attr('COR_VALUE', Month_Rec_.Cor_Value, Attr_);
      Hrp_Abs_Calc_Month_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
      FOR Wc_Rec_ IN Month_Wc_(Month_Rec_.Period_Seq) LOOP
        IF Check_Wc___(Wc_Rec_.Wage_Code_Id, Wc_Group_Valid_) THEN
          Client_Sys.Clear_Attr(Attr_);
          Client_Sys.Add_To_Attr('COMPANY_ID', Abs_Rec_To_.Company_Id, Attr_);
          Client_Sys.Add_To_Attr('EMP_NO', Abs_Rec_To_.Emp_No, Attr_);
          Client_Sys.Add_To_Attr('ABSENCE_ID', Abs_Rec_To_.Absence_Id, Attr_);
          Client_Sys.Add_To_Attr('SEQ', Seq_, Attr_);
          Client_Sys.Add_To_Attr('PERIOD_SEQ', Month_Rec_.Period_Seq, Attr_);
          Client_Sys.Add_To_Attr('WAGE_CODE_ID', Wc_Rec_.Wage_Code_Id, Attr_);
          Client_Sys.Add_To_Attr('VALUE', Wc_Rec_.Value, Attr_);
          Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE',
                                 Hrp_Abs_Wc_Type_Api.Decode(Wc_Rec_.Hrp_Abs_Wc_Type), Attr_);
          Client_Sys.Add_To_Attr('SYSTEM_GENERATED', 'TRUE', Attr_);
          Client_Sys.Add_To_Attr('SELECTED', Wc_Rec_.Selected, Attr_);
          Client_Sys.Add_To_Attr('AGREEMENT_NO', Wc_Rec_.Agreement_No, Attr_);
          Hrp_Abs_Calc_Month_Wc_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        END IF;
      END LOOP;
    END LOOP;
  END Copy_Base;
  FUNCTION Abs_Base1(Company_Id_             IN VARCHAR2,
                     Emp_No_                 IN VARCHAR2,
                     Payroll_List_Id_        IN VARCHAR2,
                     Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                     Parameters_             IN VARCHAR2,
                     Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                     Wage_Code_Id_           IN VARCHAR2,
                     Valid_Date_             IN DATE) RETURN NUMBER IS
    Last_Abs_Rec_               Absence_Registration_Tab%ROWTYPE;
    Abs_Calc_Base_Type_         VARCHAR2(20);
    Abs_Type_                   VARCHAR2(1000);
    Ground_Months_              NUMBER;
    Constant_Wc_Group_          VARCHAR2(50);
    Notupdated_Wc_Group_        VARCHAR2(50);
    Updated_Wc_Group_           VARCHAR2(50);
    Base_Wc_Group_              VARCHAR2(50);
    Contribution_Wc_Group_      VARCHAR2(50);
    Include_Payroll_Values_     NUMBER;
    Tmp_Include_Payroll_Values_ VARCHAR2(5);
    Wc_Rate_                    VARCHAR2(50);
    Max_Break_                  NUMBER;
    Months_Back_                NUMBER;
    Recalculate_Temp_           VARCHAR2(1);
    Recalculate_                VARCHAR2(1);
    Abs_From_                   DATE;
    Abs_To_                     DATE;
    Exist_Base_                 VARCHAR2(5);
    Exist_Base_On_Date_         VARCHAR2(5);
    No_Employment_Months_       NUMBER;
    Date_Of_Employment_         DATE;
    i_                          NUMBER;
    Current_Month_              DATE;
    Base_Rec_                   Hrp_Abs_Calc_Base_Tab%ROWTYPE;
    Is_Any_Classified_          VARCHAR2(5) := 'FALSE';
    Assignment_Type_            VARCHAR2(100);
    Assignment_Type_m_          VARCHAR2(100);
    Avg_Rate_                   NUMBER;
    Check_And_Copy_Base_        VARCHAR2(20);
    Temp_Seq_                   NUMBER;
    Calc_Param_Type_            VARCHAR2(100);
    Calc_Param_Value_           VARCHAR2(1000);
    Objid_                      VARCHAR2(2000);
    Objversion_                 VARCHAR2(2000);
    Attr_                       VARCHAR2(2000);
    Info_                       VARCHAR2(2000);
    Check_Unempl_               VARCHAR2(10);
    Days_Type_                  VARCHAR2(1000);
    Wage_Class_                 VARCHAR2(200);
    Day_Sched_Code_             VARCHAR2(200);
    Start_Seq_No_               VARCHAR2(200);
    Valid_To_                   DATE;
    Round_Precision_            NUMBER;
    Log_Mode_                   VARCHAR2(50);
    First_Abs_From_             DATE;
    Abs_Id_                     NUMBER;
    -- log tab
    Zpk_Log_Tab_ t_Log_Tab := t_Log_Tab();
    -- init itab for details calculation
    Zpk_Nf_Tab_ t_Net_Factor_Tab;
    CURSOR Abs_ IS
      SELECT *
        FROM Absence_Registration_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Payroll_Util_Api.Parse_Parameter(Absence_Type_Id, Abs_Type_) = 'TRUE'
         AND (Date_From BETWEEN Abs_From_ AND Abs_To_ OR Date_To BETWEEN Abs_From_ AND Abs_To_ OR
             (Date_From <= Abs_From_ AND Date_To >= Abs_To_))
         AND Rowstate NOT IN ('Cancelled', 'CalculationCancelled')
       ORDER BY Date_From;
    CURSOR Get_Assignment(Valid_From_ DATE) IS
      SELECT Assignment_Id
        FROM Company_Pers_Assign_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Primary = '1'
         AND Valid_From_ BETWEEN Valid_From AND Valid_To;
    CURSOR Corr_(Abs_Id_ IN VARCHAR2, Abs_Calc_Base_t_Id_ IN VARCHAR2) IS
      SELECT Avg_Rate_Corection
        FROM Hrp_Abs_Calc_Base_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Abs_Id_
         AND Abs_Calc_Base_Type_Id = Abs_Calc_Base_t_Id_
       ORDER BY Seq DESC;
    Avg_Rate_Correction_ NUMBER;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Abs_Base1');
    Abs_Calc_Base_Type_     := Payroll_Util_Api.Decode_Par(Parameters_, 1);
    Abs_Type_               := Payroll_Util_Api.Decode_Par(Parameters_, 2);
    Ground_Months_          := Payroll_Util_Api.Decode_Par(Parameters_, 3);
    Constant_Wc_Group_      := Payroll_Util_Api.Decode_Par(Parameters_, 4);
    Notupdated_Wc_Group_    := Payroll_Util_Api.Decode_Par(Parameters_, 5);
    Updated_Wc_Group_       := Payroll_Util_Api.Decode_Par(Parameters_, 6);
    Base_Wc_Group_          := Payroll_Util_Api.Decode_Par(Parameters_, 7);
    Contribution_Wc_Group_  := Payroll_Util_Api.Decode_Par(Parameters_, 8);
    Months_Back_            := Payroll_Util_Api.Decode_Par(Parameters_, 9);
    Recalculate_            := Substr(Payroll_Util_Api.Decode_Par(Parameters_, 10), 1, 1);
    Round_Precision_        := Nvl(Payroll_Util_Api.Decode_Par(Parameters_, 11), 4);
    Include_Payroll_Values_ := Payroll_Util_Api.Decode_Par(Parameters_, 12);
    Max_Break_ := 3;
    --init log mode value
    Zpk_Get_Pipe_Log(Log_Mode_);
    IF Include_Payroll_Values_ = 0 THEN
      Tmp_Include_Payroll_Values_ := 'FALSE';
    ELSIF Include_Payroll_Values_ = 1 THEN
      Tmp_Include_Payroll_Values_ := 'TRUE';
    ELSE
      Error_Sys.Appl_General(Lu_Name_, 'ERRPAYROLLVAL: Wrong parameter value.');
    END IF;
    --recalculate
    -- [0]- generate or copy absence base considering corrections
    -- [1]- generate or copy absence base without considering corrections
    -- [2]- always generate absence base without copy or corrections
    -- [4]- conditional generation
    Abs_From_           := Add_Months(Trunc(Payroll_Rec_.Date_To, 'MONTH'), Months_Back_ * -1);
    Abs_To_             := Trunc(Last_Day(Payroll_Rec_.Date_To));
    Date_Of_Employment_ := Emp_Employed_Time_Api.Get_Date_Of_Employment(Company_Id_, Emp_No_,
                                                                        Payroll_Rec_.Validation_Date);
    -- find base start of abs base period to regenerate all already calculated periods
    IF Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_, 'Z002', SYSDATE), 0) = 1 THEN
      FOR Abs_Rec_ IN Abs_ LOOP
        Abs_Id_         := Hrp_Abs_Calc_Base_Api.Get_Abs_Id(Company_Id_, Emp_No_,
                                                            Abs_Rec_.Absence_Id, 'MONTHLY',
                                                            Abs_Calc_Base_Type_);
        First_Abs_From_ := Trunc(Absence_Registration_Api.Get_Date_From(Company_Id_, Emp_No_,
                                                                        Abs_Id_), 'MONTH');
        EXIT;
      END LOOP;
      IF Abs_Id_ IS NOT NULL THEN
        Abs_From_ := Least(Abs_From_, Nvl(First_Abs_From_, Abs_From_));
      END IF;
    END IF;
    --
    FOR Abs_Rec_ IN Abs_ LOOP
      Hrp_Abs_Calc_Base_Api.Base_Exist_On_Date(Exist_Base_, Exist_Base_On_Date_, Company_Id_,
                                               Emp_No_, Abs_Rec_.Absence_Id, Abs_Calc_Base_Type_,
                                               Payroll_Rec_.Validation_Date);
      Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_DEF', S1_ => 'ABSLOOP',
                           S2_ => Abs_Rec_.Absence_Type_Id, N1_ => Abs_Rec_.Absence_Id,
                           D1_ => Abs_Rec_.Date_From, D2_ => Abs_Rec_.Date_To);
      IF Exist_Base_On_Date_ = 'FALSE'
         OR (Exist_Base_On_Date_ = 'TRUE' AND Recalculate_ IN ('1', '2', '4')) THEN
        IF (Abs_Rec_.Rowstate = 'Registered' AND Exist_Base_ = 'FALSE')
           OR (Abs_Rec_.Rowstate = 'Registered' AND Exist_Base_ = 'TRUE' AND
           Recalculate_ IN ('1', '2', '4'))
           OR (Abs_Rec_.Rowstate IN ('Partly Calculated', 'Calculated') AND
           Recalculate_ IN ('1', '2', '4')) THEN
          -- 131213 ANNOPL (START)
          Avg_Rate_Correction_ := NULL;
          OPEN Corr_(Abs_Rec_.Absence_Id, Abs_Calc_Base_Type_);
          FETCH Corr_
            INTO Avg_Rate_Correction_;
          CLOSE Corr_;
          IF Avg_Rate_Correction_ IS NULL
             AND Recalculate_ = '4' THEN
            Recalculate_Temp_ := '1';
          ELSE
            Recalculate_Temp_ := Recalculate_;
          END IF;
          -- 131213 ANNOPL (FINISH)
          --IF recalculate_ IN ( '0', '1' ) THEN
          IF Recalculate_Temp_ IN ('0', '1') THEN
            Check_And_Copy_Base_ := Zpk_Mig_Abs_Calc_Base_Api.Check_And_Copy_Base(Abs_Rec_,
                                                                                  Payroll_List_Id_,
                                                                                  Payroll_Rec_,
                                                                                  Max_Break_,
                                                                                  Abs_Calc_Base_Type_,
                                                                                  Constant_Wc_Group_,
                                                                                  Notupdated_Wc_Group_,
                                                                                  Updated_Wc_Group_,
                                                                                  Zpk_Log_Tab_);
          ELSE
            Check_And_Copy_Base_ := 'NOTFOUND';
          END IF;
          Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_DEF', S1_ => 'GENERATEWAY',
                               S2_ => Exist_Base_, S3_ => Exist_Base_On_Date_,
                               S4_ => Check_And_Copy_Base_, N1_ => To_Number(Recalculate_),
                               N2_ => To_Number(Recalculate_Temp_), N3_ => Avg_Rate_Correction_);
          -- IF check_and_copy_base_ = 'NOTFOUND' THEN
          IF (Check_And_Copy_Base_ = 'NOTFOUND' AND Recalculate_Temp_ <> '4') THEN
            Hrp_Abs_Calc_Base_Api.Insert_Base(Base_Rec_, Abs_Rec_, Payroll_List_Id_,
                                              Payroll_Rec_.Validation_Date, Abs_Calc_Base_Type_);
            No_Employment_Months_ := Months_Between(Trunc(Abs_Rec_.Date_From, 'MONTH') - 1,
                                                    Date_Of_Employment_);
            OPEN Get_Assignment(Abs_Rec_.Date_From);
            FETCH Get_Assignment
              INTO Assignment_Type_;
            CLOSE Get_Assignment;
            --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_MONTHLY_DEF',s1_ => 'ORGIN', d1_ => abs_rec_.date_from,d2_ => add_months(abs_rec_.date_from, ground_months_ * -1));
            --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_MONTHLY_DEF',s1_ => 'GRACE', d1_ => graced_period_date_from_, d2_ => period_date_to_, d3_ => period_date_from_);
            FOR i_ IN 1 .. Ground_Months_ LOOP
              Current_Month_ := Add_Months(Abs_Rec_.Date_From, i_ * -1);
              ---------------------
              Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Check_Unempl_, Days_Type_,
                                                          Abs_Rec_.Company_Id,
                                                          Abs_Rec_.Absence_Type_Id, 'CHECKUNEMPDAYS',
                                                          'FALSE');
              IF Check_Unempl_ = 'YES'
                 AND Days_Type_ IS NOT NULL THEN
                Work_Sched_Assign_Api.Get_Sched_Info(Wage_Class_, Day_Sched_Code_, Start_Seq_No_,
                                                     Valid_To_, Abs_Rec_.Company_Id, Abs_Rec_.Emp_No,
                                                     Date_Of_Employment_);
                WHILE Date_Of_Employment_ > Trunc(Current_Month_, 'MONTH') LOOP
                  IF Payroll_Util_Api.Parse_Parameter(Day_Sched_Type_Api.Get_Day_Type(Abs_Rec_.Company_Id,
                                                                                      Wage_Class_,
                                                                                      Day_Sched_Code_,
                                                                                      Start_Seq_No_,
                                                                                      Date_Of_Employment_ - 1),
                                                      Days_Type_) = 'FALSE' THEN
                    EXIT;
                  END IF;
                  Date_Of_Employment_ := Date_Of_Employment_ - 1;
                END LOOP;
              END IF;
              ---------------------
              IF Date_Of_Employment_ <= Trunc(Current_Month_, 'MONTH') THEN
                OPEN Get_Assignment(Trunc(Current_Month_, 'MONTH'));
                FETCH Get_Assignment
                  INTO Assignment_Type_m_;
                CLOSE Get_Assignment;
                IF Assignment_Type_m_ != Assignment_Type_ THEN
                  EXIT;
                END IF;
                Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_MONTHLY_DEF', S1_ => 'PERIODMONTH',
                                     D1_ => Trunc(Current_Month_, 'MONTH'),
                                     D2_ => Last_Day(Current_Month_), N4_ => i_);
                --Zpk_Log_Entry_Add___(zpk_log_tab_,'CLASS_MONTHLY_DEF',s1_ => 'ORGIN', d1_ =>  trunc(current_month_, 'MONTH'),d2_ => last_day(current_month_));
                IF Zpk_Mig_Abs_Calc_Base_Api.Classify_Month(Base_Rec_, Current_Month_,
                                                            Base_Wc_Group_, Contribution_Wc_Group_,
                                                            Payroll_Rec_.Validation_Date, Abs_Rec_,
                                                            Payroll_List_Id_, Wage_Code_Elements_Tab_,
                                                            Zpk_Log_Tab_, Round_Precision_,
                                                            Tmp_Include_Payroll_Values_) = 'TRUE' THEN
                  Is_Any_Classified_ := 'TRUE';
                END IF;
              END IF;
            END LOOP;
            IF Is_Any_Classified_ = 'FALSE' THEN
              Hrp_Abs_Calc_Month_Api.Check_Classifcation(Base_Rec_);
            END IF;
            -- clear cache array
            Zpk_Nf_Tab_.Delete;
            --
            --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_Adv1(base_rec_,payroll_rec_,payroll_list_id_,constant_wc_group_,  'CONSTANT',    5,wage_code_elements_tab_,zpk_log_tab_,zpk_nf_tab_,contribution_wc_group_,base_wc_group_,'TRANSACTION',tmp_include_payroll_values_);
            --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_Adv1(base_rec_,payroll_rec_,payroll_list_id_,notupdated_wc_group_,'NOTUPDATED',  5,wage_code_elements_tab_,zpk_log_tab_,zpk_nf_tab_,contribution_wc_group_,base_wc_group_,'TRANSACTION',tmp_include_payroll_values_);
            --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_Adv1(base_rec_,payroll_rec_,payroll_list_id_,NULL,                'BASEEXCLUDED',5,wage_code_elements_tab_,zpk_log_tab_,zpk_nf_tab_,contribution_wc_group_,base_wc_group_,'TRANSACTION',tmp_include_payroll_values_);
            --ZPK_MIG_ABS_CALC_BASE_API.Insert_Wage_Codes_Adv1(base_rec_, payroll_rec_, updated_wc_group_,    'UPDATE',      5, payroll_list_id_, wage_code_elements_tab_, zpk_log_tab_, 'TRANSACTION', tmp_include_payroll_values_);
            --
            Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
          ELSE
            Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                    Abs_Rec_.Absence_Id, 'FALSE',
                                                                    Abs_Calc_Base_Type_);
            IF Hrp_Abs_Calc_Base_Api.Get_Corected(Company_Id_, Emp_No_, Abs_Rec_.Absence_Id,
                                                  Temp_Seq_) = 'FALSE' THEN
              Base_Rec_ := Hrp_Abs_Calc_Base_Api.Get_Abs_Base_Rec(Company_Id_, Emp_No_,
                                                                  Abs_Rec_.Absence_Id, Temp_Seq_);
              Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
            END IF;
          END IF;
        ELSE
          Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                  Abs_Rec_.Absence_Id, 'FALSE',
                                                                  Abs_Calc_Base_Type_);
          IF Hrp_Abs_Calc_Base_Api.Get_Corected(Company_Id_, Emp_No_, Abs_Rec_.Absence_Id, Temp_Seq_) =
             'FALSE' THEN
            Base_Rec_ := Hrp_Abs_Calc_Base_Api.Get_Abs_Base_Rec(Company_Id_, Emp_No_,
                                                                Abs_Rec_.Absence_Id, Temp_Seq_);
            Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
          END IF;
        END IF;
      ELSE
        Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                Abs_Rec_.Absence_Id, 'FALSE',
                                                                Abs_Calc_Base_Type_);
        IF Hrp_Abs_Calc_Base_Api.Get_Corected(Company_Id_, Emp_No_, Abs_Rec_.Absence_Id, Temp_Seq_) =
           'FALSE' THEN
          Base_Rec_ := Hrp_Abs_Calc_Base_Api.Get_Abs_Base_Rec(Company_Id_, Emp_No_,
                                                              Abs_Rec_.Absence_Id, Temp_Seq_);
          Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
        END IF;
      END IF;
      IF Avg_Rate_ IS NULL THEN
        Hrp_Abs_Type_Calc_Param_Api.Get_Param_Value(Calc_Param_Type_, Calc_Param_Value_,
                                                    Company_Id_, Abs_Rec_.Absence_Type_Id,
                                                    'ALTERNATIVEAVGRATE', 'FALSE');
        IF Nvl(Calc_Param_Type_, 'NO') = 'YES' THEN
          --avg_rate_ := Hrp_Pl_Wc_Value_API.Get_Value_Adv1(NULL, calc_param_value_, 1, NULL, wage_code_elements_tab_);
          Avg_Rate_ := Zpk_Get_Alternative_Value___(Company_Id_, Emp_No_, Payroll_List_Id_,
                                                    Payroll_Rec_, Abs_Rec_, Calc_Param_Value_,
                                                    Base_Wc_Group_, Contribution_Wc_Group_,
                                                    Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                    Tmp_Include_Payroll_Values_);
          Client_Sys.Clear_Attr(Attr_);
          Client_Sys.Add_To_Attr('AVERAGE_RATE', Avg_Rate_, Attr_);
          Client_Sys.Add_To_Attr('ALTERNATIVE_WC', Calc_Param_Value_, Attr_);
          Hrp_Abs_Calc_Base_Api.Get_Id_Version_By_Key(Objid_, Objversion_, Company_Id_, Emp_No_,
                                                      Abs_Rec_.Absence_Id, Base_Rec_.Seq);
          Hrp_Abs_Calc_Base_Api.Modify__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
        ELSE
          Error_Sys.Appl_General(Lu_Name_,
                                 'NOAVGRATE1: Function ABSBASE1 not calculated! Type: [:P1]',
                                 Abs_Calc_Base_Type_);
        END IF;
      END IF;
      Last_Abs_Rec_ := Abs_Rec_;
    END LOOP;
    Zpk_Log_Entry_Save___(Zpk_Log_Tab_, Last_Abs_Rec_, Company_Id_, Payroll_List_Id_, Emp_No_,
                          Valid_Date_, Wage_Code_Id_, 'ZPK_ABSBASE1_CA', -1);
    RETURN Nvl(Avg_Rate_, 0);
  END Abs_Base1;
  FUNCTION Abs_Base2(Company_Id_             IN VARCHAR2,
                     Emp_No_                 IN VARCHAR2,
                     Payroll_List_Id_        IN VARCHAR2,
                     Payroll_Rec_            IN Hrp_Pay_List_Api.Public_Rec,
                     Parameters_             IN VARCHAR2,
                     Wage_Code_Elements_Tab_ IN OUT NOCOPY Hrp_Pay_List_Api.Wage_Code_Elements_Type,
                     Wage_Code_Id_           IN VARCHAR2,
                     Valid_Date_             IN DATE) RETURN NUMBER IS
    Avg_Rate_                   NUMBER;
    Abs_Calc_Base_Type_         VARCHAR2(20);
    Abs_Type_                   VARCHAR2(1000);
    Wc_Group_                   VARCHAR2(50);
    Wc_Group_Type_Par_          VARCHAR2(1000);
    Wc_Group_Type_              VARCHAR2(2);
    Ground_Months_              NUMBER;
    Base_Wc_Group_              VARCHAR2(50);
    Contribution_Wc_Group_      VARCHAR2(50);
    Wc_Type_                    VARCHAR2(1);
    Abs_Rec_                    Absence_Registration_Tab%ROWTYPE;
    Is_Classified_              VARCHAR2(5) := 'FALSE';
    Calc_Type_                  VARCHAR2(50);
    Temp_Seq_                   NUMBER;
    Seq_                        NUMBER;
    Info_                       VARCHAR2(2000);
    Objid_                      VARCHAR2(2000);
    Objversion_                 VARCHAR2(2000);
    Attr_                       VARCHAR2(2000);
    Is_Copy_                    NUMBER := NULL;
    Recalculate_                VARCHAR2(1);
    Is_Copied_                  BOOLEAN := FALSE;
    Abs_Id_                     VARCHAR2(50);
    Calendar_Type_Id_           VARCHAR2(20);
    Temp_                       NUMBER;
    Round_Precision_            NUMBER;
    Include_Payroll_Values_     NUMBER;
    Tmp_Include_Payroll_Values_ VARCHAR2(5);
    Graced_Back_                NUMBER;
    Grace_Back_Max_             NUMBER;
    Bonus_Date_                 DATE;
    Bonus_Paid_                 DATE;
    Bonus_Notpaid_              DATE;
    Paid_Way_                   VARCHAR2(20);
    Bonus_Notpaid_Allow_        NUMBER;
    Org_Base_Entry_Date_        DATE;
    Org_Base_Seq_No_            NUMBER;
    Reg_Min_Recalc_             DATE;
    -- log tab
    Zpk_Log_Tab_ t_Log_Tab := t_Log_Tab();
    -- init itab for details calculation
    Zpk_Nf_Tab_ t_Net_Factor_Tab;
    -- warrning
    Warning_Text_   VARCHAR2(200);
    Warrning_Seq_   NUMBER;
    Prev_Avg_Rate_  NUMBER;
    Ret_            NUMBER;
    Log_Mode_       VARCHAR2(50);
    Wc_Group_Valid_ NUMBER;
    CURSOR Get_Base_ IS
      SELECT a.*
        FROM Hrp_Abs_Calc_Base_Tab a, Absence_Registration_Tab b
       WHERE a.Company_Id = Company_Id_
         AND a.Emp_No = Emp_No_
         AND a.Company_Id = b.Company_Id
         AND a.Emp_No = b.Emp_No
         AND a.Absence_Id = b.Absence_Id
         AND a.Payroll_List_Id = Payroll_List_Id_
            --      AND a.copied_from_abs_id IS NULL
            --      AND a.corected = 'FALSE'
            --Bug #60350
            --AND absence_type_id = abs_type_
         AND Payroll_Util_Api.Parse_Parameter(b.Absence_Type_Id, Abs_Type_) = 'TRUE'
         AND a.Seq = Hrp_Abs_Calc_Base_Api.Set_Seq(a.Company_Id, a.Emp_No, a.Absence_Id) - 1
         AND a.Abs_Calc_Base_Type_Id = Abs_Calc_Base_Type_
       ORDER BY b.Date_From;
    CURSOR Other_(Absence_Id_ VARCHAR2, Seq_ NUMBER) IS
      SELECT *
        FROM Hrp_Abs_Calc_Other_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Seq_
         AND Hrp_Abs_Calc_Other_Type = Calc_Type_;
    CURSOR Check_Exist_(Absence_Id_              VARCHAR2,
                        Seq_                     NUMBER,
                        Period_Seq_              NUMBER,
                        Date_From_               DATE,
                        Hrp_Abs_Calc_Other_Type_ VARCHAR2) IS
      SELECT 1
        FROM Hrp_Abs_Calc_Other_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Seq_
         AND Period_Seq = Period_Seq_
         AND Date_From = Date_From_
         AND Hrp_Abs_Calc_Other_Type = Hrp_Abs_Calc_Other_Type_;
    CURSOR Other_Wc_(Absence_Id_  VARCHAR2,
                     Seq_         NUMBER,
                     Period_Seq_  NUMBER,
                     Date_From_   DATE,
                     Period_Type_ VARCHAR2) IS
      SELECT *
        FROM Hrp_Abs_Calc_Other_Wc_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Seq = Seq_
         AND Period_Seq = Period_Seq_
         AND Date_From = Date_From_
         AND Hrp_Abs_Calc_Other_Type = Period_Type_;
    CURSOR Get_Seq_(Absence_Id_ VARCHAR2) IS
      SELECT Seq
        FROM Hrp_Abs_Calc_Base_Tab
       WHERE Company_Id = Company_Id_
         AND Emp_No = Emp_No_
         AND Absence_Id = Absence_Id_
         AND Abs_Calc_Base_Type_Id = Abs_Calc_Base_Type_
       ORDER BY Entry_Date DESC, Seq DESC;
    FUNCTION Check_Wc___(Wage_Code_Id_ VARCHAR2, Wc_Group_Valid_ NUMBER) RETURN BOOLEAN IS
      Dummy_ NUMBER;
      CURSOR Check_Wc_ IS
        SELECT 1
          FROM Calculation_Group_Members_Tab b
         WHERE b.Company_Id = Company_Id_
           AND b.Calc_Group_Id = Wc_Group_
           AND b.Wage_Code_Id = Wage_Code_Id_
           AND b.Calc_Group_Valid_From =
               (SELECT MAX(c.Calc_Group_Valid_From)
                  FROM Calculation_Group_Tab c
                 WHERE c.Company_Id = b.Company_Id
                   AND c.Calc_Group_Id = b.Calc_Group_Id
                   AND c.Calc_Group_Valid_From <= Payroll_Rec_.Validation_Date);
    BEGIN
      -- froce not checking
      IF Wc_Group_Valid_ = 0 THEN
        RETURN(TRUE);
      END IF;
      OPEN Check_Wc_;
      FETCH Check_Wc_
        INTO Dummy_;
      IF (Check_Wc_%FOUND) THEN
        CLOSE Check_Wc_;
        RETURN(TRUE);
      END IF;
      CLOSE Check_Wc_;
      RETURN FALSE;
    END Check_Wc___;
  BEGIN
    General_Sys.Init_Method(Lu_Name_, 'ZPK_MIG_ABS_CALC_BASE_API', 'Abs_Base2');
    Abs_Calc_Base_Type_     := Payroll_Util_Api.Decode_Par(Parameters_, 1);
    Abs_Type_               := Payroll_Util_Api.Decode_Par(Parameters_, 2);
    Wc_Group_               := Payroll_Util_Api.Decode_Par(Parameters_, 3);
    Wc_Group_Type_Par_      := Substr(Payroll_Util_Api.Decode_Par(Parameters_, 4), 1, 2);
    Wc_Group_Type_          := Substr(Payroll_Util_Api.Decode_Par(Wc_Group_Type_Par_, 1, Chr(44)), 1,
                                      2); -- wc_group_type_: 4 - four months, 6 - halfyearly
    Ground_Months_          := To_Number(Nvl(Payroll_Util_Api.Decode_Par(Wc_Group_Type_Par_, 2,
                                                                         Chr(44)), '12'));
    Wc_Type_                := Substr(Payroll_Util_Api.Decode_Par(Parameters_, 5), 1, 1); -- wc_type_: 1 - constant, 2 - updated, 3 - not updated, 4 - fixed
    Base_Wc_Group_          := Payroll_Util_Api.Decode_Par(Parameters_, 6);
    Contribution_Wc_Group_  := Payroll_Util_Api.Decode_Par(Parameters_, 7);
    Recalculate_            := Nvl(Substr(Payroll_Util_Api.Decode_Par(Parameters_, 8), 1, 1), 0); -- Recalculate 0-copy, 1-copy and generate, 2-generate
    Calendar_Type_Id_       := Payroll_Util_Api.Decode_Par(Parameters_, 9);
    Round_Precision_        := Nvl(Payroll_Util_Api.Decode_Par(Parameters_, 10), 4);
    Include_Payroll_Values_ := Payroll_Util_Api.Decode_Par(Parameters_, 11);
    Grace_Back_Max_         := Nvl(To_Number(Payroll_Util_Api.Decode_Par(Parameters_, 12)), 0);
    --init log mode value
    Zpk_Get_Pipe_Log(Log_Mode_);
    Wc_Group_Valid_ := Nvl(Hrp_Regulation_Value_Api.Get_Regulation_Value_For_Date(Company_Id_,
                                                                                  'Z010', SYSDATE), 0);
    -- Update and Fixed Wage code group is not supported at the moment
    -- IF wc_type_ NOT IN ('1','2','3','4') THEN
    IF Wc_Type_ NOT IN ('1', '2') THEN
      Error_Sys.Appl_General(Lu_Name_,
                             'WCTYPEERR: Function ABSBASE2_CA - Wage Code Type :P1 is not defined!',
                             Wc_Type_);
    END IF;
    IF Include_Payroll_Values_ = 0 THEN
      Tmp_Include_Payroll_Values_ := 'FALSE';
    ELSIF Include_Payroll_Values_ = 1 THEN
      Tmp_Include_Payroll_Values_ := 'TRUE';
    ELSE
      Error_Sys.Appl_General(Lu_Name_, 'ERRPAYROLLVAL: Wrong parameter value.');
    END IF;
    IF Wc_Group_Type_ = 1 THEN
      Calc_Type_ := 'YEARLY';
    ELSIF Wc_Group_Type_ = 2 THEN
      Calc_Type_ := 'QUARTERLY';
    ELSIF Wc_Group_Type_ = 3 THEN
      Calc_Type_ := 'HALF_YEARLY';
    ELSIF Wc_Group_Type_ = 4 THEN
      Calc_Type_ := 'M4MONTHLY';
    ELSIF Wc_Group_Type_ = 6 THEN
      Calc_Type_ := 'HALF_YEARLY';
    ELSIF Wc_Group_Type_ = 12 THEN
      Calc_Type_ := 'YEARLY';
    ELSE
      Calc_Type_ := NULL;
    END IF;
    FOR Base_Rec_ IN Get_Base_ LOOP
      Is_Copied_ := FALSE;
      IF Base_Rec_.Alternative_Wc IS NULL THEN
        IF Base_Rec_.Copied_From_Abs_Id IS NOT NULL
           AND Recalculate_ IN (0, 1) THEN
          Abs_Id_ := Hrp_Abs_Calc_Base_Api.Get_Abs_Id(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                      Base_Rec_.Copied_From_Abs_Id, Calc_Type_,
                                                      Abs_Calc_Base_Type_);
          --OPEN get_seq_(base_rec_.copied_from_abs_id);
          OPEN Get_Seq_(Abs_Id_);
          FETCH Get_Seq_
            INTO Seq_;
          CLOSE Get_Seq_;
          FOR Other_Rec_ IN Other_(Abs_Id_, Seq_) LOOP
            Is_Copied_ := TRUE;
            OPEN Check_Exist_(Base_Rec_.Absence_Id, Base_Rec_.Seq, Other_Rec_.Period_Seq,
                              Other_Rec_.Date_From, Other_Rec_.Hrp_Abs_Calc_Other_Type);
            FETCH Check_Exist_
              INTO Temp_;
            IF Check_Exist_%NOTFOUND THEN
              Client_Sys.Clear_Attr(Attr_);
              Client_Sys.Add_To_Attr('COMPANY_ID', Company_Id_, Attr_);
              Client_Sys.Add_To_Attr('EMP_NO', Emp_No_, Attr_);
              Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
              Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
              Client_Sys.Add_To_Attr('PERIOD_SEQ', Other_Rec_.Period_Seq, Attr_);
              Client_Sys.Add_To_Attr('DATE_FROM', Other_Rec_.Date_From, Attr_);
              Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                                     Hrp_Abs_Calc_Other_Type_Api.Decode(Other_Rec_.Hrp_Abs_Calc_Other_Type),
                                     Attr_);
              Client_Sys.Add_To_Attr('DATE_TO', Other_Rec_.Date_To, Attr_);
              Client_Sys.Add_To_Attr('WORKING_DAYS', Other_Rec_.Working_Days, Attr_);
              Client_Sys.Add_To_Attr('NORMA_WORKING_DAYS', Other_Rec_.Norma_Working_Days, Attr_);
              Client_Sys.Add_To_Attr('MONTHS_IN_PERIOD', Other_Rec_.Months_In_Period, Attr_);
              Client_Sys.Add_To_Attr('SELECTED', Other_Rec_.Selected, Attr_);
              Client_Sys.Add_To_Attr('DESCRIPTION', Other_Rec_.Description, Attr_);
              Client_Sys.Add_To_Attr('GROSS_BASE_VALUE', Other_Rec_.Gross_Base_Value, Attr_);
              Client_Sys.Add_To_Attr('NETTING_FACTOR', Other_Rec_.Netting_Factor, Attr_);
              Client_Sys.Add_To_Attr('NET_BASE_VALUE', Other_Rec_.Net_Base_Value, Attr_);
              Client_Sys.Add_To_Attr('COR_VALUE', Other_Rec_.Cor_Value, Attr_);
              Hrp_Abs_Calc_Other_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
              FOR Wc_Rec_ IN Other_Wc_(Abs_Id_, Seq_, Other_Rec_.Period_Seq, Other_Rec_.Date_From,
                                       Other_Rec_.Hrp_Abs_Calc_Other_Type) LOOP
                IF Check_Wc___(Wc_Rec_.Wage_Code_Id, Wc_Group_Valid_) THEN
                  Client_Sys.Clear_Attr(Attr_);
                  Client_Sys.Add_To_Attr('COMPANY_ID', Company_Id_, Attr_);
                  Client_Sys.Add_To_Attr('EMP_NO', Emp_No_, Attr_);
                  Client_Sys.Add_To_Attr('ABSENCE_ID', Base_Rec_.Absence_Id, Attr_);
                  Client_Sys.Add_To_Attr('SEQ', Base_Rec_.Seq, Attr_);
                  Client_Sys.Add_To_Attr('PERIOD_SEQ', Other_Rec_.Period_Seq, Attr_);
                  Client_Sys.Add_To_Attr('DATE_FROM', Other_Rec_.Date_From, Attr_);
                  Client_Sys.Add_To_Attr('HRP_ABS_CALC_OTHER_TYPE',
                                         Hrp_Abs_Calc_Other_Type_Api.Decode(Other_Rec_.Hrp_Abs_Calc_Other_Type),
                                         Attr_);
                  Client_Sys.Add_To_Attr('WAGE_CODE_ID', Wc_Rec_.Wage_Code_Id, Attr_);
                  Client_Sys.Add_To_Attr('VALUE', Wc_Rec_.Value, Attr_);
                  Client_Sys.Add_To_Attr('HRP_ABS_WC_TYPE',
                                         Hrp_Abs_Wc_Type_Api.Decode(Wc_Rec_.Hrp_Abs_Wc_Type), Attr_);
                  Client_Sys.Add_To_Attr('SYSTEM_GENERATED', 'TRUE', Attr_);
                  Hrp_Abs_Calc_Other_Wc_Api.New__(Info_, Objid_, Objversion_, Attr_, 'DOAUTO');
                END IF;
              END LOOP;
            END IF;
            CLOSE Check_Exist_;
          END LOOP;
          IF Base_Rec_.Corected = 'FALSE' THEN
            Avg_Rate_     := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
            Warrning_Seq_ := Base_Rec_.Seq;
          ELSE
            Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                    Base_Rec_.Absence_Id, 'FALSE',
                                                                    Abs_Calc_Base_Type_);
          END IF;
        END IF;
        IF (Recalculate_ IN (1, 2) AND NOT Is_Copied_)
           OR (Base_Rec_.Copied_From_Abs_Id IS NULL AND Recalculate_ = 0) THEN
          Abs_Id_  := Hrp_Abs_Calc_Base_Api.Get_Abs_Id(Company_Id_, Emp_No_,
                                                       Base_Rec_.Copied_From_Abs_Id, Calc_Type_,
                                                       Abs_Calc_Base_Type_);
          Abs_Rec_ := Absence_Registration_Api.Get_Abs_Rec(Company_Id_, Emp_No_,
                                                           Nvl(Abs_Id_, Base_Rec_.Absence_Id));
          --
          -- clear cache array in case any conncetion between bases
          Zpk_Nf_Tab_.Delete;
          --
          IF Wc_Group_Type_ = 2 THEN
            Paid_Way_ := 'TAXCHECK';
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_3MONTHLY_DEF', S1_ => 'GRACE', S2_ => 'BONUS',
                                 S3_ => Paid_Way_, D1_ => NULL);
            IF Zpk_Mig_Abs_Calc_Base_Api.Classify_Quarter(Base_Rec_, Abs_Rec_, Wc_Group_,
                                                          Base_Wc_Group_, Contribution_Wc_Group_,
                                                          Payroll_List_Id_, Payroll_Rec_,
                                                          Calendar_Type_Id_, Wc_Type_, Paid_Way_,
                                                          Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                          Round_Precision_, 'TRANSACTION',
                                                          Tmp_Include_Payroll_Values_) = 'TRUE' THEN
              Is_Classified_ := 'TRUE';
            END IF;
            /*ELSIF wc_group_type_ = 3 THEN
            IF Hrp_Abs_Calc_Other_Api.Classify_Half_Year(base_rec_, abs_rec_, wc_group_, base_wc_group_, contribution_wc_group_, payroll_rec_, calendar_type_id_, wc_type_, wage_code_elements_tab_, round_precision_) = 'TRUE' THEN
            is_classified_ := 'TRUE';
            END IF;*/
          ELSIF Wc_Group_Type_ = 4 THEN
            Paid_Way_ := 'TAXCHECK';
            Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_4MONTHLY_DEF', S1_ => 'GRACE', S2_ => 'BONUS',
                                 S3_ => Paid_Way_, D1_ => NULL);
            IF Zpk_Mig_Abs_Calc_Base_Api.Classify_4months(Base_Rec_, Abs_Rec_, Wc_Group_,
                                                          Base_Wc_Group_, Contribution_Wc_Group_,
                                                          Payroll_List_Id_, Payroll_Rec_,
                                                          Calendar_Type_Id_, Wc_Type_, Paid_Way_,
                                                          Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                          Round_Precision_, 'TRANSACTION',
                                                          Tmp_Include_Payroll_Values_) = 'TRUE' THEN
              Is_Classified_ := 'TRUE';
            END IF;
            /*ELSIF wc_group_type_ = 6 THEN
            IF ZPK_MIG_ABS_CALC_BASE_API.Classify_Half_Year(base_rec_, abs_rec_, wc_group_, base_wc_group_, contribution_wc_group_, payroll_rec_,
            calendar_type_id_, wc_type_, round_precision_, wage_code_elements_tab_,'TRANSACTION',tmp_include_payroll_values_) = 'TRUE' THEN
            is_classified_ := 'TRUE';
            END IF;*/
          ELSIF Wc_Group_Type_ = 12 THEN
            -- conditional regenerating periodical base
            Org_Base_Seq_No_ := Hrp_Abs_Calc_Base_Api.Set_Seq(Base_Rec_.Company_Id, Base_Rec_.Emp_No,
                                                              Abs_Rec_.Absence_Id) - 1;
            Reg_Min_Recalc_  := Nvl(Hrp_Regulation_Value_Api.Get_Valid_To(Company_Id_, 'Z001', 1),
                                    To_Date('2015-01-01', 'YYYY-MM-DD'));
            IF Org_Base_Seq_No_ > 1 THEN
              Org_Base_Entry_Date_ := Hrp_Abs_Calc_Base_Api.Get_Entry_Date(Base_Rec_.Company_Id,
                                                                           Base_Rec_.Emp_No,
                                                                           Abs_Rec_.Absence_Id,
                                                                           Org_Base_Seq_No_ - 1);
            END IF;
            IF Base_Rec_.Copied_From_Abs_Id IS NULL
               AND Recalculate_ = 0
               AND Org_Base_Entry_Date_ > Reg_Min_Recalc_
               AND Org_Base_Seq_No_ > 1 THEN
              Ret_ := Copy_Base_Other___(Base_Rec_.Company_Id, Base_Rec_.Emp_No, Abs_Rec_.Absence_Id,
                                         'YEARLY', Org_Base_Seq_No_ - 1, Org_Base_Seq_No_);
              Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_DEF', S1_ => 'GRACE', S2_ => 'COPY');
              Is_Classified_ := 'TRUE';
            ELSE
              Bonus_Paid_    := Zpk_Calc_Grace_Months___(Base_Rec_, Payroll_Rec_, Abs_Rec_,
                                                         Payroll_List_Id_, Wage_Code_Elements_Tab_,
                                                         Nvl(Tmp_Include_Payroll_Values_, 'FALSE'),
                                                         Wc_Group_Type_, Wc_Group_, Base_Wc_Group_,
                                                         Contribution_Wc_Group_, Wc_Type_,
                                                         Ground_Months_, Grace_Back_Max_, 'TRUE');
              Bonus_Notpaid_ := Zpk_Calc_Grace_Months___(Base_Rec_, Payroll_Rec_, Abs_Rec_,
                                                         Payroll_List_Id_, Wage_Code_Elements_Tab_,
                                                         Nvl(Tmp_Include_Payroll_Values_, 'FALSE'),
                                                         Wc_Group_Type_, Wc_Group_, Base_Wc_Group_,
                                                         Contribution_Wc_Group_, Wc_Type_,
                                                         Ground_Months_, Grace_Back_Max_, 'FALSE');
              --
              Bonus_Notpaid_Allow_ := 0; --nvl(hrp_regulation_value_api.Get_Regulation_Value_For_Date(company_id_,'ZXXX',sysdate),0);
              --set tax including path
              IF Bonus_Paid_ IS NOT NULL THEN
                Bonus_Date_ := Bonus_Paid_;
                Paid_Way_   := 'TAXCHECK';
              ELSIF Bonus_Notpaid_ IS NOT NULL
                    AND Bonus_Notpaid_Allow_ = 1 THEN
                Bonus_Date_ := Bonus_Notpaid_;
                Paid_Way_   := 'TAXNOTCHECK';
              ELSE
                Bonus_Date_ := Trunc(Abs_Rec_.Date_From, 'MONTH') - 1;
                Paid_Way_   := 'TAXCHECK';
              END IF;
              --graced_back_  := months_between(trunc(abs_rec_.date_from,'MONTH')-1, bonus_date_); HOTFIX 20160121
              Graced_Back_ := Months_Between(Trunc(Abs_Rec_.Date_From, 'MONTH'),
                                             Trunc(Bonus_Date_, 'MONTH'));
              Graced_Back_ := Greatest(Graced_Back_, Ground_Months_);
              Zpk_Log_Entry_Add___(Zpk_Log_Tab_, 'CLASS_YEARLY_DEF', S1_ => 'GRACE', S2_ => 'BONUS',
                                   S3_ => Paid_Way_, D1_ => Bonus_Date_);
              /* IF Zpk_Mig_Abs_Calc_Base_Api.Classify_Year(Base_Rec_, Abs_Rec_, Wc_Group_,
                                                         Base_Wc_Group_, Contribution_Wc_Group_,
                                                         Payroll_List_Id_, Payroll_Rec_,
                                                         Calendar_Type_Id_, Wc_Type_, Bonus_Date_,
                                                         Paid_Way_, Graced_Back_, Ground_Months_,
                                                         Wage_Code_Elements_Tab_, Zpk_Log_Tab_,
                                                         Round_Precision_, 'TRANSACTION',
                                                         Tmp_Include_Payroll_Values_, FALSE) =
                 'TRUE' THEN
                Is_Classified_ := 'TRUE';
              END IF;*/
            END IF;
          ELSE
            Error_Sys.Appl_General(Lu_Name_,
                                   'WCGRTYPEERR: Function ABSBASE2_CA - Wage Code Group Type :P1 is not defined!',
                                   Wc_Group_Type_);
          END IF;
          IF Is_Classified_ = 'TRUE' THEN
            Avg_Rate_     := Hrp_Abs_Calc_Base_Api.Calculate_Avg_Rate(Base_Rec_);
            Warrning_Seq_ := Base_Rec_.Seq;
          ELSE
            Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                    Abs_Rec_.Absence_Id, 'FALSE',
                                                                    Abs_Calc_Base_Type_);
          END IF;
          IF Avg_Rate_ IS NULL THEN
            Error_Sys.Appl_General(Lu_Name_,
                                   'NOAVGRATE2: Function ABSBASE2_CA not calculated! Type: [:P1]',
                                   Abs_Calc_Base_Type_);
          END IF;
        END IF;
      ELSE
        Avg_Rate_ := Hrp_Abs_Calc_Base_Api.Get_Current_Avg_Rate(Temp_Seq_, Company_Id_, Emp_No_,
                                                                Base_Rec_.Absence_Id, 'FALSE',
                                                                Abs_Calc_Base_Type_);
      END IF;
    END LOOP;
    Zpk_Warrning_Add___(Company_Id_, Emp_No_, Payroll_List_Id_, Gl_Warrning_01_, Wage_Code_Id_,
                        Abs_Id_, Abs_Calc_Base_Type_);
    Zpk_Log_Entry_Save___(Zpk_Log_Tab_, Abs_Rec_, Company_Id_, Payroll_List_Id_, Emp_No_,
                          Valid_Date_, Wage_Code_Id_, 'ZPK_ABSBASE2_CA', Wc_Group_Type_);
    RETURN Nvl(Avg_Rate_, 0);
  END Abs_Base2;
  -----------------------------------------------------------------------------
  -------------------- FOUNDATION1 METHODS ------------------------------------
  -----------------------------------------------------------------------------
  -- Init
  --   Dummy procedure that can be called at database startup to ensure that
  --   this package is loaded into memory for performance reasons only.
  -----------------------------------------------------------------------------
  PROCEDURE Init IS
  BEGIN
    NULL;
  END Init;
END Zpk_Mig_Abs_Calc_Base_Api;
/
set define on
