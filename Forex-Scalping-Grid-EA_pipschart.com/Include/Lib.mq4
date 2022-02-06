//+------------------------------------------------------------------+
//|                                                          Lib.mq4 |
//|                                             Komgrit Sungkhaphong |
//|                               http://iamforextrader.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Komgrit Sungkhaphong"
#property link      "http://iamforextrader.blogspot.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double xpips(double val)
  {
   double x=0;
   x=val*MathPow(10,Digits);
   return(x);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double pts(int number)
  {
   return(number*Point);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double pips(int number)
  {
   return(number*Point*10);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CandleRange(int bar=5)
  {
   return(HP(bar)-LP(bar));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CandleRange2(int bar=5,int st=1)
  {
   return(HP(bar,st)-LP(bar,st));
  }
//+--functions HP(), LP()--------------------------------------------+
//return Highest or Lowest value from previous n bars 
//e.g. HP(5) would return highest HIGH value of last 5 bars
//e.g. LP(5) would return lowest LOW value of last 5 bars
double HP(int bar=5,int startx=1)
  {
   return(High[iHighest(Symbol(),0,MODE_HIGH,bar,startx)]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LP(int bar=5,int startx=1)
  {
   return(Low[iLowest(Symbol(),0,MODE_LOW,bar,startx)]);
  }
//+--functions HLP(), LHP()------------------------------------------+
//return Highest or Lowest value of LOW or HIGH from previous n bars 
//e.g. HLP(5) would return highest LOW value of last 5 bars
//e.g. LHP(5) would return lowest HIGH value of last 5 bars
double HLP(int bar=5,int startx=1)
  {
   return(Low[iHighest(Symbol(),0,MODE_HIGH,bar,startx)]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LHP(int bar=5,int startx=1)
  {
   return(High[iLowest(Symbol(),0,MODE_HIGH,bar,startx)]);
  }
//double GetSlope(double& array[])
//{
//   //using linear regression method
//   double slope_TF1;
//   int N;
//   double sumX,sumY;
//   double xbar,ybar;
//   double sumXY,sumXpow;
//   
//   N=ArraySize(array);
//   //calculate X-bar   
//   //calculate Y-bar
//   //calculate sum or XiYi   
//   //calculate N*X-bar*Y-Bars   
//   //calculate sum of Xi^2   
//   //calcuate N*X-bar^2   
//   for(int i=0;i<N;i++)
//   {
//      sumX=sumX+i;
//      sumY=sumY+array[i];
//      
//      sumXY=sumXY+(i*array[i]);
//      sumXpow=sumXpow+(MathPow(i,2));
//   }
//   xbar=sumX/N;
//   ybar=sumY/N;
//
//   slope_TF1=(sumXY-N*xbar*ybar)/(sumXpow-N*MathPow(xbar,2));
//   return(-slope_TF1);
//}

//close[x] to last high
//return distnace in decimal
double CH(int n)
  {
   return(Close[n]-High[1]);
  }
//close[x] to last low
//return distnace in decimal
double CL(int n)
  {
   return(Close[n]-Low[1]);
  }
//int xpips(double decimal)
//{
//   double x=0;
//   switch(Digits)
//     {
//      case  5:
//      {  
//         x=decimal*MathPow(10,Digits-1);
//        break;
//      }
//      case  4:
//      {  
//         x=decimal*MathPow(10,Digits);
//        break;
//      }
//      default:
//        break;
//     }
//   return(x);
//}

double RateOfChange(int bar)
  {
   double Cls=Close[bar];
   double ROC;
   ROC=Bid-Cls;
   ROC=NormalizeDouble(ROC/bar,Digits);
   return(ROC);
  }

//int MAGIC_LIST_BY_SYMBOL()
//{
////---
//   int _magic;
//   if(Symbol()=="GBPUSD")  _magic=100;
//   if(Symbol()=="EURUSD")  _magic=110;
//   if(Symbol()=="USDCHF")  _magic=120;
//   if(Symbol()=="AUDUSD")  _magic=130;
//   if(Symbol()=="NZDUSD")  _magic=140;
//   if(Symbol()=="USDCAD")  _magic=150;
//   if(Symbol()=="USDJPY")  _magic=160;
//   
//   if(Symbol()=="GBPAUD")  _magic=200;
//   if(Symbol()=="GBPNZD")  _magic=210;
//   if(Symbol()=="GBPCAD")  _magic=220;
//   if(Symbol()=="GBPCHF")  _magic=230;
//   if(Symbol()=="GBPJPY")  _magic=240;
//   if(Symbol()=="EURGBP")  _magic=250;
//   
//   if(Symbol()=="EURAUD")  _magic=300;
//   if(Symbol()=="EURNZD")  _magic=310;
//   if(Symbol()=="EURCAD")  _magic=320;
//   if(Symbol()=="EURCHF")  _magic=330;
//   if(Symbol()=="EURJPY")  _magic=340;
//   
//   if(Symbol()=="AUDNZD")  _magic=350;
//   if(Symbol()=="AUDCAD")  _magic=360;
//   if(Symbol()=="AUDCHF")  _magic=370;
//   if(Symbol()=="AUDJPY")  _magic=380;
//   
//   if(Symbol()=="NZDCAD")  _magic=390;
//   if(Symbol()=="NZDCHF")  _magic=400;
//   if(Symbol()=="NZDJPY")  _magic=410;
//   
//   if(Symbol()=="CADJPY")  _magic=420;
//   if(Symbol()=="CADCHF")  _magic=430;
//   
//   if(Symbol()=="CHFJPY")  _magic=440;
////---   
//   return(_magic);
//}
