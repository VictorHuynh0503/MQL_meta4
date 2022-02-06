//+------------------------------------------------------------------+
//|                                                    SmallFunc.mqh |
//|                                                        iamgotzaa |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "iamgotzaa"
#property link      "http://www.mql5.com"
#property strict

double HighestPoint(int timeframe,int bar=5,int startx=1)
  {
   return(High[iHighest(Symbol(),timeframe,MODE_HIGH,bar,startx)]);

  }
double LowestPoint(int timeframe,int bar=5,int startx=1)
  {
   return(Low[iLowest(Symbol(),timeframe,MODE_LOW,bar,startx)]);
  }
double HighestClose(int timeframe,int bar=5,int startx=1)
  {
   return(Close[iHighest(Symbol(),timeframe,MODE_CLOSE,bar,startx)]);

  }
double LowestClose(int timeframe,int bar=5,int startx=1)
  {
   return(Close[iLowest(Symbol(),timeframe,MODE_CLOSE,bar,startx)]);
  }
  
double hp(int bar=5,int startx=1)
  {
   return(High[iHighest(Symbol(),0,MODE_HIGH,bar,startx)]);

  }
double lp(int bar=5,int startx=1)
  {
   return(Low[iLowest(Symbol(),0,MODE_LOW,bar,startx)]);
  }
double hc(int bar=5,int startx=1)
  {
   return(Close[iHighest(Symbol(),0,MODE_CLOSE,bar,startx)]);

  }
double lc(int bar=5,int startx=1)
  {
   return(Close[iLowest(Symbol(),0,MODE_CLOSE,bar,startx)]);
  }
  
void stoplosswheelbarrel(int ticket,double target,double move)
  {
   double gpoints;

   if(OrderSelect(ticket,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol())
     {
      gpoints=OrderProfit()/(OrderLots()*MarketInfo(OrderSymbol(),MODE_LOTSIZE));
      if(OrderType()==OP_BUY)
        {
         if(OrderStopLoss()==0 || OrderStopLoss()<OrderOpenPrice())
           {
            if(gpoints>target)
              {
               bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                                      OrderOpenPrice()+move,OrderTakeProfit(),OrderExpiration(),clrYellow);
              }
           }
         else
           {
            if(OrderStopLoss()>=OrderOpenPrice())
              {
               double safegpoints=OrderStopLoss()-OrderOpenPrice();
               if(gpoints-(safegpoints)>target)
                 {
                  bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                                         OrderStopLoss()+move,OrderTakeProfit(),OrderExpiration(),clrYellow);
                  if(GetLastError()>0)
                    {
                     Print(__FUNCTION__,":: error modifying order");
                    }
                 }
              }
           }
        }
      if(OrderType()==OP_SELL)
        {
         if(OrderStopLoss()==0 || OrderStopLoss()>OrderOpenPrice())
           {
            if(gpoints>target)
              {
               bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-move,OrderTakeProfit(),OrderExpiration(),clrYellow);
              }
           }
         else
           {
            if(OrderStopLoss()<=OrderOpenPrice())
              {
               double safegpoints=OrderOpenPrice()-OrderStopLoss();
               if(gpoints-(safegpoints)>target)
                 {
                  bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss()-move,OrderTakeProfit(),OrderExpiration(),clrYellow);
                  if(GetLastError()>0)
                    {
                     Print(__FUNCTION__,":: error modifying order");
                    }
                 }

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int nakedbuy(int mn,double lot)
  {
   int t=OrderSend(NULL,OP_BUY,lot,Ask,2,0,0,NULL,mn,0,clrBlue);
   return(t);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int nakedbuy(int mn,double lot,double stoploss,double takeprofit)
  {
   stoploss=NormalizeDouble(stoploss,Digits);
   takeprofit=NormalizeDouble(takeprofit,Digits);
   int t=0;
   if(stoploss==0 || stoploss<Ask)
     {
      if(takeprofit==0 || takeprofit>Ask)
        {
         t=OrderSend(NULL,OP_BUY,lot,Ask,2,stoploss,takeprofit,NULL,mn,0,clrBlue);
        }
     }

   return(t);

  }
//+------------------------------------------------------------------+
int nakedsell(int mn,double lot)
  {
   int t=OrderSend(NULL,OP_SELL,lot,Bid,2,0,0,NULL,mn,0,clrPink);
   return(t);
  }
//+------------------------------------------------------------------+
int nakedsell(int mn,double lot,double stoploss,double takeprofit)
  {
   stoploss=NormalizeDouble(stoploss,Digits);
   takeprofit=NormalizeDouble(takeprofit,Digits);
   int t=0;
   if(stoploss==0 || stoploss>Bid)
     {
      if(takeprofit==0 || takeprofit<Bid)
        {
         t=OrderSend(NULL,OP_SELL,lot,Bid,2,0,0,NULL,mn,0,clrPink);
        }
     }
   return(t);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int nakedPending(int mn,double lot,int side,double price,datetime exptime)
  {
   int t=OrderSend(NULL,side,lot,price,2,0,0,NULL,mn,exptime,clrGray);
   return(t);
  }
//+------------------------------------------------------------------+
int naked(int side,int mn,double lot)
  {
   if(side==OP_BUY)
     {
      return(nakedbuy(mn,lot));
     }
   else if(side==OP_SELL)
     {
      return(nakedsell(mn,lot));
     }
   else return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AverageBarSize(int timeframe,int bar)
  {
   double val=0;
   double retval=0;
   double open,close;
   double firstopen,lastclose;
   firstopen=iOpen(NULL,timeframe,bar);
   lastclose=iClose(NULL,timeframe,1);
   double dir=0;
   if(firstopen>lastclose)
     {
      dir=1;
     }
   else
     {
      dir=-1;
     }
   for(int i=0;i<bar;i++)
     {
      open=iOpen(NULL,timeframe,i);
      close=iClose(NULL,timeframe,i);
      val=val+(close-open);
     }
   if(bar<0)
     {
      return(-1);
     }
   retval=dir*(val/bar);
   return(retval);
  }
//+------------------------------------------------------------------+
bool isSwifty(int tf,int bar,double limit_point,double YieldDistancePercent=0.6)
  {
   double high,low;
   bool yes=false;
   bool retval=false;
   bool mustbeMixed=false;
   double totalmove=0;

   for(int i=1;i<=bar;i++)
     {
      high=iHigh(NULL,tf,i);
      low=iLow(NULL,tf,i);
      double r=high-low;
      totalmove=totalmove+r;
      if(r>limit_point)
        {
         yes=true;
        }
     }
//return(yes);
//---
   double resultantMove=HighestPoint(tf,bar,1)-LowestPoint(tf,bar,1);
   if(yes && totalmove>0)
     {
      if(resultantMove/totalmove<YieldDistancePercent)
        {
         retval=true;
        }
     }
//---
   return(retval);
  }
//+------------------------------------------------------------------+
double _p(int points)
  {
   return(points*Point);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AddTarget(int ticket,double additiontp)
  {
   bool modok=false;
   if(OrderSelect(ticket,SELECT_BY_TICKET) && OrderStopLoss()==0)
     {
      double tp=0;
      if(OrderType()==OP_BUY)
        {
         tp=OrderOpenPrice()+additiontp;
        }
      if(OrderType()==OP_SELL)
        {
         tp=OrderOpenPrice()-additiontp;
        }
      tp=NormalizeDouble(tp,Digits);
      if(tp!=OrderTakeProfit())
        {
         modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                           OrderStopLoss(),tp,OrderExpiration());

        }

      if(GetLastError()>0)
        {
         Print(__FUNCTION__,":: error modifying order");
        }
     }
   return(modok);
  }
//+------------------------------------------------------------------+
bool AddStoploss(int ticket,double additionsl)
  {
   bool modok=false;
   if(OrderSelect(ticket,SELECT_BY_TICKET) && OrderStopLoss()==0)
     {
      double sl=0;
      if(OrderType()==OP_BUY)
        {
         sl=Ask+additionsl;
        }
      if(OrderType()==OP_SELL)
        {
         sl=Bid-additionsl;
        }
      sl=NormalizeDouble(sl,Digits);
      if(sl!=OrderStopLoss())
        {
         modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                           sl,OrderTakeProfit(),OrderExpiration(),clrGray);
        }
      if(GetLastError()>0)
        {
         Print(__FUNCTION__,":: error modifying order");
        }
     }
   return(modok);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AutomaticIDGenerate()
  {
   int retval=0;
   retval=getPairCode(Symbol());
   return(retval);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getCurrencyCode(string currency3alphabet)
  {
   int retValue=0;
   if(currency3alphabet=="USD")  retValue=1;
   if(currency3alphabet=="EUR")  retValue=2;
   if(currency3alphabet=="GBP")  retValue=3;
   if(currency3alphabet=="AUD")  retValue=4;
   if(currency3alphabet=="NZD")  retValue=5;
   if(currency3alphabet=="CAD")  retValue=6;
   if(currency3alphabet=="CHF")  retValue=7;
   if(currency3alphabet=="JPY")  retValue=8;
   return(retValue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getPairCode(string yourSymbol)
  {
//check length of symbol
   if(StringLen(yourSymbol)!=6)
     {
      return(0);
     }
//get first three alphabets
   string counter=StringSubstr(yourSymbol,0,3);
//get second three alphabets
   string base=StringSubstr(yourSymbol,3,3);
   int n1,n2;
   n1=getCurrencyCode(base)*10;
   n2=getCurrencyCode(counter)*100;
   return(n1+n2);
  }
//+------------------------------------------------------------------+
bool ConsecHigherLow(int tf,int bar)
  {
   bool retval=true;
   double higherlow=0;
   for(int i=0;i<bar;i++)
     {
      double low=iLow(NULL,tf,i);
      if(low>higherlow)
        {
         higherlow=low;
         retval=retval && true;
        }
      else
        {
         retval=false;
        }
     }
   return(retval);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool ConsecLowerHigh(int tf,int bar)
  {
   bool retval=true;
   double LowerHigh=0;
   for(int i=0;i<bar;i++)
     {
      double high=iHigh(NULL,tf,i);
      if(high<LowerHigh)
        {
         LowerHigh=high;
         retval=retval && true;
        }
      else
        {
         retval=false;
        }
     }
   return(retval);
  }
//+------------------------------------------------------------------+
int GetLotSizeDigits()
  {
   int retval=2;
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   if(minlot==0.01)
     {
      return(2);
     }
   if(minlot==0.1)
     {
      return(1);
     }
   if(minlot==1 || minlot==5 || minlot==10)
     {
      return(0);
     }
   return(retval);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double PercentileNow(int tf=PERIOD_M5,int bar=150)
  {
   double mean=iMA(NULL,tf,bar,0,MODE_SMA,PRICE_CLOSE,1);
   double std=iStdDev(NULL,tf,bar,0,MODE_SMA,PRICE_CLOSE,1);
   double z=0;
   if(std>0)
     {
      z=(Bid-mean)/std;
     }
   double p=0;

   if(z<-3.4) p=0.0003;
   if(z>=-3.4 && z<-3.3) p=0.0003;
   if(z>=-3.3 && z<-3.2) p=0.0005;
   if(z>=-3.2 && z<-3.1) p=0.0007;
   if(z>=-3.1 && z<-3) p=0.001;
   if(z>=-3.0 && z<-2.9) p=0.0014;
   if(z>=-2.9 && z<-2.8) p=0.0019;
   if(z>=-2.8 && z<-2.7) p=0.0026;
   if(z>=-2.7 && z<-2.6) p=0.0036;
   if(z>=-2.6 && z<-2.5) p=0.0048;
   if(z>=-2.5 && z<-2.4) p=0.0064;
   if(z>=-2.4 && z<-2.3) p=0.0084;
   if(z>=-2.3 && z<-2.2) p=0.011;
   if(z>=-2.2 && z<-2.1) p=0.0143;
   if(z>=-2.1 && z<-2) p=0.0183;
   if(z>=-2.0 && z<-1.9) p=0.0233;
   if(z>=-1.9 && z<-1.8) p=0.0294;
   if(z>=-1.8 && z<-1.7) p=0.0367;
   if(z>=-1.7 && z<-1.6) p=0.0455;
   if(z>=-1.6 && z<-1.5) p=0.0559;
   if(z>=-1.5 && z<-1.4) p=0.0681;
   if(z>=-1.4 && z<-1.3) p=0.0823;
   if(z>=-1.3 && z<-1.2) p=0.0985;
   if(z>=-1.2 && z<-1.1) p=0.117;
   if(z>=-1.1 && z<-1.0) p=0.1379;
   if(z>=-1.0 && z<-0.9) p=0.1611;
   if(z>=-0.9 && z<-0.8) p=0.1867;
   if(z>=-0.8 && z<-0.7) p=0.2148;
   if(z>=-0.7 && z<-0.6) p=0.2451;
   if(z>=-0.6 && z<-0.5) p=0.2776;
   if(z>=-0.5 && z<-0.4) p=0.3121;
   if(z>=-0.4 && z<-0.3) p=0.3483;
   if(z>=-0.3 && z<-0.2) p=0.3859;
   if(z>=-0.2 && z<-0.1) p=0.4247;
   if(z>=-0.1 && z<0) p=0.4641;
   if(z>=0 && z<0.1) p=0.5000;
   if(z>=0.1 && z<0.2) p=0.5398;
   if(z>=0.2 && z<0.3) p=0.5793;
   if(z>=0.3 && z<0.4) p=0.6179;
   if(z>=0.4 && z<0.5) p=0.6554;
   if(z>=0.5 && z<0.6) p=0.6915;
   if(z>=0.6 && z<0.7) p=0.7257;
   if(z>=0.7 && z<0.8) p=0.758;
   if(z>=0.8 && z<0.9) p=0.7881;
   if(z>=0.9 && z<1) p=0.8159;
   if(z>=1 && z<1.1) p=0.8413;
   if(z>=1.1 && z<1.2) p=0.8643;
   if(z>=1.2 && z<1.3) p=0.8849;
   if(z>=1.3 && z<1.4) p=0.9032;
   if(z>=1.4 && z<1.5) p=0.9192;
   if(z>=1.5 && z<1.6) p=0.9332;
   if(z>=1.6 && z<1.7) p=0.9452;
   if(z>=1.7 && z<1.8) p=0.9554;
   if(z>=1.8 && z<1.9) p=0.9641;
   if(z>=1.9 && z<2) p=0.9713;
   if(z>=2 && z<2.1) p=0.9772;
   if(z>=2.1 && z<2.2) p=0.9821;
   if(z>=2.2 && z<2.3) p=0.9861;
   if(z>=2.3 && z<2.4) p=0.9893;
   if(z>=2.4 && z<2.5) p=0.9918;
   if(z>=2.5 && z<2.6) p=0.9938;
   if(z>=2.6 && z<2.7) p=0.9953;
   if(z>=2.7 && z<2.8) p=0.9965;
   if(z>=2.8 && z<2.9) p=0.9974;
   if(z>=2.9 && z<3) p=0.9981;
   if(z>=3 && z<3.1) p=0.9987;
   if(z>=3.1 && z<3.2) p=0.999;
   if(z>=3.2 && z<3.3) p=0.9993;
   if(z>=3.3 && z<3.4) p=0.9995;
   if(z>=3.4 ) p=0.9997;

   return(p*100);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stoplosswheelbarrelEXP(int ticket,double target,double move,double _exponent=0.92
                            )
  {
   double gpoints;

   if(OrderSelect(ticket,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol())
     {
      gpoints=OrderProfit()/(OrderLots()*MarketInfo(OrderSymbol(),MODE_LOTSIZE));
      if(OrderType()==OP_BUY)
        {
         if(OrderStopLoss()==0 || OrderStopLoss()<OrderOpenPrice())
           {
            if(gpoints>target)
              {
               bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                                      OrderOpenPrice()+move,OrderTakeProfit(),OrderExpiration(),clrYellow);
              }
           }
         else
           {
            if(OrderStopLoss()>=OrderOpenPrice())
              {
               double safegpoints=OrderStopLoss()-OrderOpenPrice();
               double movexp=MathPow(move,_exponent);
               movexp=NormalizeDouble(movexp,Digits);
               if(gpoints-(safegpoints)>MathPow(target+safegpoints,_exponent))
                 {
                  bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),
                                         OrderStopLoss()+move,OrderTakeProfit(),OrderExpiration(),clrYellow);
                  if(GetLastError()>0)
                    {
                     Print(__FUNCTION__,":: error modifying order");
                    }
                 }
              }
           }
        }
      if(OrderType()==OP_SELL)
        {
         if(OrderStopLoss()==0 || OrderStopLoss()>OrderOpenPrice())
           {
            if(gpoints>target)
              {
               bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-move,OrderTakeProfit(),OrderExpiration(),clrYellow);
              }
           }
         else
           {
            if(OrderStopLoss()<=OrderOpenPrice())
              {
               double safegpoints=OrderOpenPrice()-OrderStopLoss();
               if(gpoints-(safegpoints)>MathPow(target,_exponent))
                 {
                  bool modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss()-move,OrderTakeProfit(),OrderExpiration(),clrYellow);
                  if(GetLastError()>0)
                    {
                     Print(__FUNCTION__,":: error modifying order");
                    }
                 }

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
int _hour(int hours)
  {
   return(hours*60*60);
  }
//+------------------------------------------------------------------+
int _minute(int minutes)
  {
   return(minutes*60);
  }
//+------------------------------------------------------------------+
double Confluence()
  {
   double confluence=0;

   double ma600=iMA(NULL,PERIOD_M15,200,0,MODE_SMA,PRICE_CLOSE,0);
   double MarketToMa600=Bid-ma600;
   double ATR24H1=iATR(NULL,PERIOD_H1,24,0);
   double ATR24D1=iATR(NULL,PERIOD_D1,24,1);
   double Std10=iStdDev(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,1);
   double Std20_lead=iStdDev(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,1);
   double Std20_lag=iStdDev(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,5);
   double Std24H1=iStdDev(NULL,PERIOD_H1,24,0,MODE_EMA,PRICE_CLOSE,0);

   bool Lead=Std20_lead>Std20_lag;
   bool Lag=Std20_lead<Std20_lag;

   double Range5=MathAbs(HighestPoint(PERIOD_M15,5,0)-LowestPoint(PERIOD_M15,5,0));
   double coefACCEL=Range5/Std20_lag;

   bool isExtreme=Range5>200*Point;

   double ma50lag=iMA(NULL,PERIOD_M15,50,0,MODE_SMA,PRICE_CLOSE,20);
   double ma50lead=iMA(NULL,PERIOD_M15,50,0,MODE_SMA,PRICE_CLOSE,5);
   double InertMove=ma50lead-ma50lag;
//---

   bool UncertainBreakDOWN=InertMove>-_p(0);
   bool UncertainBreakUP=InertMove<_p(0);
   double d1plus=0;
   double d1minus=0;
   if(UncertainBreakDOWN) d1minus=-1;  else d1minus=0;
   if(UncertainBreakUP) d1plus=1;  else d1plus=0;
//---

   bool UncertainReverseUp=Open[96]-Close[1]>_p(1000);
   bool UncertainReverseDown=Open[96]-Close[1]<-_p(1000);

   double d2plus=0;
   double d2minus=0;
   if(UncertainReverseDown) d2minus=-1;  else d2minus=0;
   if(UncertainReverseUp) d2plus=1;  else d2plus=0;
//---

   bool ExtremePress=(High[2]-Bid)>_p(300);
   bool ExtremePush=(Ask-Low[2])>_p(300);
   double d3plus=0;
   double d3minus=0;
   if(ExtremePress) d3minus=-1;  else d3minus=0;
   if(ExtremePush) d3plus=1;  else d3plus=0;

   bool DayBullTrendOverride=false;
   bool DayBearTrendOverride=false;
   bool BullCounterOpp=false;
   bool BearCounterOpp=false;
   double Last24Hgain=iClose(NULL,PERIOD_H1,0)-iOpen(NULL,PERIOD_H1,24);

   double Last24M15gain=iClose(NULL,PERIOD_M15,0)-iOpen(NULL,PERIOD_M15,24);
   if(Last24Hgain>_p(400) && Last24Hgain<_p(900))
     {
      DayBullTrendOverride=true;
     }
   if(Last24Hgain<-_p(400) && Last24Hgain>-_p(900))
     {
      DayBearTrendOverride=true;
     }

   if(Last24Hgain<-_p(900)-(0.5*ATR24H1) || Last24M15gain<-_p(500))
     {
      BullCounterOpp=true;
     }
   if(Last24Hgain>_p(900)+(0.5*ATR24H1) || Last24M15gain>_p(500))
     {
      BearCounterOpp=true;
     }
   double d4plus=0;
   double d4minus=0;
   if(DayBearTrendOverride) d4minus=-1;  else d4minus=0;
   if(DayBullTrendOverride) d4plus=1;  else d4plus=0;

   double d5plus=0;
   double d5minus=0;
   if(BearCounterOpp) d5minus=-1;  else d5minus=0;
   if(BullCounterOpp) d5plus=1;  else d5plus=0;
//---
//exception of shooting star
   bool BullishSign=false,BearishSign=false;
   double range=High[1]-Low[1];
   double midBody=(High[1]+Low[1])/2;
   double close,open;
   close=Close[1];
   open=Open[1];

   double p=PercentileNow(5,150);

//---
//shootingstar previous bar
   if(range>_p(50))
     {
      BullishSign=MathAbs(open-close)<=0.3*range && close>midBody;
      BearishSign=MathAbs(open-close)<=0.3*range && close<midBody;
     }
   if(range>_p(150))
     {
      BullishSign=close>midBody-0.1*range;
      BearishSign=close<midBody+0.1*range;
      BullishSign=close-open>_p(200);
      BearishSign=open-close>_p(200);
     }

   double d6plus=0;
   double d6minus=0;
   if(BearishSign) d6minus=-1;  else d6minus=0;
   if(BullishSign) d6plus=1;  else d6plus=0;

//    //---

   bool CalmToBreakUp=false;
   bool CalmToBreakDown=false;
   double highclose=HighestClose(PERIOD_M15,3,3);
   double lowclose=LowestClose(PERIOD_M15,3,3);
   if(highclose-lowclose<_p(250))
     {
      CalmToBreakUp=Bid>highclose;
      CalmToBreakDown=Ask<lowclose;
     }
   double d7plus=0;
   double d7minus=0;
   if(CalmToBreakDown) d7minus=-1;  else d7minus=0;
   if(CalmToBreakUp) d7plus=1;  else d7plus=0;

   bool ConsecutiveHigherLow=ConsecHigherLow(PERIOD_M15,4);
   bool COnsecutiveLowerHigh=ConsecLowerHigh(PERIOD_M15,4);

   double d8plus=0;
   double d8minus=0;
   if(COnsecutiveLowerHigh) d8minus=-1;  else d8minus=0;
   if(ConsecutiveHigherLow) d8plus=1;  else d8plus=0;

//---
//twoboxbreak
   bool twoboxbreakup=false;
   bool twoboxbreakdown=false;

   twoboxbreakdown=iClose(NULL,PERIOD_M5,0)<LowestClose(PERIOD_M15,20,3) && iClose(NULL,PERIOD_M5,0)<LowestClose(PERIOD_M15,20,25);
   twoboxbreakup=iClose(NULL,PERIOD_M5,0)>HighestClose(PERIOD_M15,20,3) && iClose(NULL,PERIOD_M5,0)>HighestClose(PERIOD_M15,20,25);
   double d9plus=0;
   double d9minus=0;
   if(twoboxbreakdown) d9minus=-1;  else d9minus=0;
   if(twoboxbreakup) d9plus=1;  else d9plus=0;

//---

   bool followbuy=false;
   bool followsell=false;
   if(Bid-LowestPoint(PERIOD_M15,30,1)>0)
     {
      followbuy=(Bid-Close[30])/(Bid-LowestPoint(PERIOD_M15,30,1))>0.7;
     }
   if(HighestPoint(PERIOD_M15,30,1)-Bid>0)
     {
      followsell=(Close[30]-Bid)/(HighestPoint(PERIOD_M15,30,1)-Bid)>0.7;
     }

   double d10plus=0;
   double d10minus=0;
   if(followsell) d10minus=-1;  else d10minus=0;
   if(followbuy) d10plus=1;  else d10plus=0;

   double w[11];
   w[0]=0; //not use
   w[1]=0.2;   //uncertain break
   w[2]=0.1;   //uncertain reverse 
   w[3]=0.1; //extreme press/push
   w[4]=0.15; //day gain/loss overide
   w[5]=0.05; //bear/bull counter speculator
   w[6]=0.05; //bullish/bearsigh sign
   w[7]=0.1; //calm break
   w[8]=0.1; //consec high low
   w[9]=0.05; //two boxes break
   w[10]=0.1;  //follow buy sell

               //combination weight must be equal to 1.00

   confluence=confluence
              +w[1]*(d1minus+d1plus)
              +w[2]*(d2minus+d2plus)
              +w[3]*(d3minus+d3plus)
              +w[4]*(d4minus+d4plus)
              +w[5]*(d5minus+d5plus)
              +w[6]*(d6minus+d6plus)
              +w[7]*(d7minus+d7plus)
              +w[8]*(d8minus+d8plus)
              +w[9]*(d9minus+d9plus)
              +w[10]*(d10minus+d10plus);

   return(confluence);
  }
//+------------------------------------------------------------------+
double trend()
  {
   double ma1=iMA(NULL,PERIOD_M5,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ma2=iMA(NULL,PERIOD_M5,10,0,MODE_EMA,PRICE_CLOSE,0);
   double ma3=iMA(NULL,PERIOD_M5,20,0,MODE_EMA,PRICE_CLOSE,0);
   double ma4=iMA(NULL,PERIOD_M5,40,0,MODE_EMA,PRICE_CLOSE,0);

   double ma5=iMA(NULL,PERIOD_M15,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ma6=iMA(NULL,PERIOD_M15,10,0,MODE_EMA,PRICE_CLOSE,0);
   double ma7=iMA(NULL,PERIOD_M15,20,0,MODE_EMA,PRICE_CLOSE,0);
   double ma8=iMA(NULL,PERIOD_M15,40,0,MODE_EMA,PRICE_CLOSE,0);

   double magnitude1=0;
   double magnitude2=0;

   magnitude1=magnitude1+0.5*(ma1-ma2)+0.35*(ma2-ma3)+0.15*(ma3-ma4);
   magnitude2=magnitude2+0.5*(ma5-ma6)+0.35*(ma6-ma7)+0.15*(ma7-ma8);

   return(0.3*magnitude1+0.7*magnitude2);
  }
  
double gainefficiency()
{
   if(Symbol()=="GBPUSD")  ge=1.0;
   if(Symbol()=="EURUSD")  ge=1.0;
   if(Symbol()=="GBPAUD")  ge=1.8;
   if(Symbol()=="GBPNZD")  ge=1.8;
   if(Symbol()=="GBPCAD")  ge=1.8;
   if(Symbol()=="EURAUD")  ge=1.8;
   if(Symbol()=="EURNZD")  ge=2.0;
   if(Symbol()=="EURCAD")  ge=2.0;
   else ge=1.0;
   return(ge);
}

double PercentileSafetyLevelX(int orderside,int barnumber)
  {
   double ceiling=HP(barnumber);
   double floorx=LP(barnumber);
   double mkt=Bid;
   double percentile=0;
   double per_b;
   double per_s;
   string t="";
   per_b=(mkt-floorx)/(ceiling-floorx)*100;
   per_s=(ceiling-mkt)/(ceiling-floorx)*100;
   t="(pips)BLK"+DoubleToStr(xpips(ceiling-floorx),1);
   t=t+", PERTB"+DoubleToStr(per_b,1);
   t=t+", PERTS"+DoubleToStr(per_b,1);
   if(orderside==OP_BUY)
     {
      percentile=per_b;
     }
   if(orderside==OP_SELL)
     {
      percentile=per_s;
     }
   status(t);
   percentile=NormalizeDouble(percentile,2);
   return(percentile);
  }