//+------------------------------------------------------------------+
//|                                       ExpertCandlesStochPSAR.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
#include <Expert\Signal\SignalCandlesStoch.mqh>
#include <Expert\Trailing\TrailingParabolicSAR.mqh>
#include <Expert\Money\MoneyNone.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string         Inp_Expert_Title                    ="ExpertCandlesStochPSAR";
int                  Expert_MagicNumber                  =2748;
bool                 Expert_EveryTick                    =false;
//--- inputs for signal
input int            Inp_Signal_CandlesStoch_Range       =6;
input int            Inp_Signal_CandlesStoch_Minimum     =25;
input double         Inp_Signal_CandlesStoch_ShadowBig   =0.5;
input double         Inp_Signal_CandlesStoch_ShadowSmall =0.2;
input double         Inp_Signal_CandlesStoch_Limit       =0.0;
input double         Inp_Signal_CandlesStoch_TakeProfit  =1.0;
input double         Inp_Signal_CandlesStoch_StopLoss    =2.0;
input int            Inp_Signal_CandlesStoch_Expiration  =4;
input int            Inp_Signal_CandlesStoch_PeriodK     =8;
input int            Inp_Signal_CandlesStoch_PeriodD     =3;
input int            Inp_Signal_CandlesStoch_PeriodSlow  =3;
input ENUM_STO_PRICE Inp_Signal_CandlesStoch_Applied     =STO_LOWHIGH;
input int            Inp_Signal_CandlesStoch_ExtrMap     =11184810;
//--- inputs for trailing
input double         Inp_Trailing_ParabolicSAR_Step      =0.02;
input double         Inp_Trailing_ParabolicSAR_Maximum   =0.2;
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(-1);
     }
//--- Creation of signal object
   CSignalCandlesStoch *signal=new CSignalCandlesStoch;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(-2);
     }
//--- Add signal to expert (will be deleted automatically))
   if(!ExtExpert.InitSignal(signal))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing signal");
      ExtExpert.Deinit();
      return(-3);
     }
//--- Set signal parameters
   signal.Range(Inp_Signal_CandlesStoch_Range);
   signal.Minimum(Inp_Signal_CandlesStoch_Minimum);
   signal.ShadowBig(Inp_Signal_CandlesStoch_ShadowBig);
   signal.ShadowSmall(Inp_Signal_CandlesStoch_ShadowSmall);
   signal.Limit(Inp_Signal_CandlesStoch_Limit);
   signal.TakeProfit(Inp_Signal_CandlesStoch_TakeProfit);
   signal.StopLoss(Inp_Signal_CandlesStoch_StopLoss);
   signal.Expiration(Inp_Signal_CandlesStoch_Expiration);
   signal.PeriodK(Inp_Signal_CandlesStoch_PeriodK);
   signal.PeriodD(Inp_Signal_CandlesStoch_PeriodD);
   signal.PeriodSlow(Inp_Signal_CandlesStoch_PeriodSlow);
   signal.Applied(Inp_Signal_CandlesStoch_Applied);
   signal.ExtrMap(Inp_Signal_CandlesStoch_ExtrMap);
//--- Check signal parameters
   if(!signal.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error signal parameters");
      ExtExpert.Deinit();
      return(-4);
     }
//--- Creation of trailing object
   CTrailingPSAR *trailing=new CTrailingPSAR;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(-5);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(-6);
     }
//--- Set trailing parameters
   trailing.Step(Inp_Trailing_ParabolicSAR_Step);
   trailing.Maximum(Inp_Trailing_ParabolicSAR_Maximum);
//--- Check trailing parameters
   if(!trailing.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error trailing parameters");
      ExtExpert.Deinit();
      return(-7);
     }
//--- Creation of money object
   CMoneyNone *money=new CMoneyNone;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(-8);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(-9);
     }
//--- Set money parameters
//--- Check money parameters
   if(!money.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error money parameters");
      ExtExpert.Deinit();
      return(-10);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(-11);
     }
//--- ok
   return(0);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//| Function-event handler "tick"                                    |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//| Function-event handler "trade"                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
