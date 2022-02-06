//+------------------------------------------------------------------+
//|                                                        Trade.mq4 |
//|                                             Komgrit Sungkhaphong |
//|                               http://iamforextrader.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Komgrit Sungkhaphong"
#property link      "http://iamforextrader.blogspot.com"

//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2)
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|Trade functions                                                     |
//+------------------------------------------------------------------+
/*
double StopPoint()
{
   return(MarketInfo(Symbol(),MODE_STOPLEVEL)*Point);
}
*/
/*
Function: Trade(..)
   Require global vairable
   Order_Type
   MN =  Magic Number
   LotSize
   Price 
   Stop
   Target
   Expire
   Comment_text
   
*/

// Trade.Buy(symbol,MAGIC,0.1,stop,target,comment);
// Trade.Sell(symbol,MAGIC,0.1,stop,target,comment);
int Trade_Buy(string _symbol,int MN,double Lot,double stop=0,double tp=0,string _comment="")
{
   RefreshRates();
   double _ask;
   _ask=MarketInfo(_symbol,MODE_ASK);
   return(Trade(OP_BUY,_symbol,MN,Lot,_ask,_comment,stop,tp));
}
int Trade_Sell(string _symbol,int MN,double Lot,double stop=0,double tp=0,string _comment="")
{
   RefreshRates();
   double _bid;
   _bid=MarketInfo(_symbol,MODE_BID);
   return(Trade(OP_SELL,_symbol,MN,Lot,_bid,_comment,stop,tp));
}

int Trade
   (int Order_Type,
   string _symbol,
   int MN,
   double LotSize, 
   double Price,
   string Comment_Text="",     
   double price_stop=0, 
   double price_tp=0, 
   datetime Expire=0,
   int Slippage=3,
   color color_order=CLR_NONE
   )
   {
      int ticket_number;
      //int price_stop;
      //int price_tp;
      
      //Normalizing numbers
      LotSize=LegalizeLotSize(LotSize);
      price_tp=NormalizeDouble(price_tp,Digits);
      price_stop=NormalizeDouble(price_stop,Digits);
      //send order command
      ticket_number=OrderSend(_symbol,Order_Type,LotSize,Price,Slippage,price_stop,price_tp,Comment_Text,MN,0,color_order);
      wait_server();
      if(OrderSelect(ticket_number,SELECT_BY_TICKET)==true)
      {

         return(ticket_number);  
      }
      else
      {
         return(-1);
         //Print("error: Cannot send order, code:",GetLastError());
      }   
   }

//Function: NormalizeLotSize(lot)
// Returns = NormalizeDouble(lot, ..lot step decimal.. )
double NormalizeLotSize(double LotSize)
   {
      int LotStep=2;
      
      if(MarketInfo(Symbol(), MODE_MINLOT)==0.01)
        {
         LotStep = 2;
        }
      if(MarketInfo(Symbol(), MODE_MINLOT)==0.1)
        {
         LotStep = 1;
        }
      if(MarketInfo(Symbol(), MODE_MINLOT)==1)
        {
         LotStep = 0;
        }
      LotSize=NormalizeDouble(LotSize,LotStep);
      return(LotSize);
   }
double LegalizeLotSize(double templots)
{   
   if(templots<MarketInfo(Symbol(),MODE_MINLOT)) lots=MarketInfo(Symbol(),MODE_MINLOT);
   else if(templots>MarketInfo(Symbol(),MODE_MAXLOT)) lots=MarketInfo(Symbol(),MODE_MAXLOT);
   else
   {
      lots=NormalizeLotSize(templots);
   }
   
   
   return(templots);
}

//+------------------------------------------------------------------+

double NowBid(string _SYMBOL)
{
   RefreshRates();
   return(MarketInfo(_SYMBOL,MODE_BID));
}
double NowAsk(string _SYMBOL)
{
   RefreshRates();
   return(MarketInfo(_SYMBOL,MODE_ASK));
}

double NowSpread(string _SYMBOL)
{
   return(NowAsk(_SYMBOL)-NowBid(_SYMBOL));
}

void wait_server()
{
   while(IsTradeContextBusy())
   {
      Sleep(20);
   }
}  

void ft(int ticketnumber)
{
   double quote=0;
   double distance=0;
   double master_distance=0;
   double propose_stop=0;
   bool  price_ok=true;
   double minstop=MarketInfo(OrderSymbol(),MODE_STOPLEVEL)*Point;
   master_distance=150*Point;
   if(OrderSelect(ticketnumber,SELECT_BY_TICKET)==true && OrderCloseTime()==0)
     {      
      if(OrderType()==OP_BUY)
        {
         quote=Bid;
         if(OrderStopLoss()==0 || OrderStopLoss()<OrderOpenPrice())
           {
            distance=Bid-OrderOpenPrice();
            if(distance>100*Point)
              {
               propose_stop=OrderOpenPrice()+30*Point;
              }
           }
         if(OrderStopLoss()>OrderOpenPrice())
           {
            distance=Bid-OrderStopLoss();
            if(distance>100*Point)
              {
               propose_stop=OrderStopLoss()+30*Point;
              }
           }
         
         /*
         if(propose_stop==OrderOpenPrice())  price_ok=false;
         if(propose_stop>=OrderOpenPrice()-minstop && propose_stop<OrderOpenPrice())  price_ok=false;
         if(propose_stop>=OrderTakeProfit())  price_ok=false;         
         if(propose_stop<=OrderStopLoss())    price_ok=false;
         if(propose_stop==0)price_ok=false;
         */
         propose_stop=NormalizeDouble(propose_stop,Digits);
         if(propose_stop!=0 && propose_stop<Bid && (propose_stop<OrderOpenPrice()-minstop||propose_stop>OrderOpenPrice()))
           {
           
            if(OrderModify(OrderTicket(),OrderOpenPrice(),propose_stop,OrderTakeProfit(),OrderExpiration(),CLR_NONE)==true)
              {
               Print("MOD_OK");
              }
           }   
        }
      else if(OrderType()==OP_SELL)
        {
         quote=Ask;
         if(OrderStopLoss()==0 || OrderStopLoss()>OrderOpenPrice())
           {
            distance=OrderOpenPrice()-Ask;
            if(distance>100*Point)
              {
               propose_stop=OrderOpenPrice()-0.3*ATR;
              }
           }
         if(OrderStopLoss()<OrderOpenPrice())
           {
            distance=OrderStopLoss()-Ask;
            if(distance>100*Point)
              {
               propose_stop=OrderStopLoss()-0.3*ATR;
              }
           }
         /*
         if(propose_stop==OrderOpenPrice())  price_ok=false;
         if(propose_stop<=OrderOpenPrice()+minstop && propose_stop>OrderOpenPrice())  price_ok=false;
         if(propose_stop<=OrderTakeProfit())  price_ok=false;
         if(propose_stop>=OrderStopLoss() && OrderStopLoss()!=0)    price_ok=false;
         if(propose_stop==0)price_ok=false;
         */
         propose_stop=NormalizeDouble(propose_stop,Digits);
         if(propose_stop!=0 && propose_stop>Ask && (propose_stop>OrderOpenPrice()+minstop||propose_stop<OrderOpenPrice()))
         {
         
            if(OrderModify(OrderTicket(),OrderOpenPrice(),propose_stop,OrderTakeProfit(),OrderExpiration(),CLR_NONE)==true)
              {
               Print("MOD_OK");
              }
         }   
        }
         
         
     }
}