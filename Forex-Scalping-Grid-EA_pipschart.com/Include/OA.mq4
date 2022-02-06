//+------------------------------------------------------------------+
//|                                              OrderAccounting.mq4 |
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


//
int OACount(int MagicNumber,int type, string _symbol)
{
   int count=0;
   for(int i=0; i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderMagicNumber()==MagicNumber &&
               OrderSymbol()==_symbol &&
               OrderType()==type)
               {
                  count++;
               }
      }
   }
   return(count);
}

int OALast(int MagicNumber,int type,string _symbol)
{
   int last_ticket=0;
   
   if(OrdersTotal()==0) return(0);
   
   for(int i=0; i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderMagicNumber()==MagicNumber &&
               OrderSymbol()==_symbol &&
               OrderType()==type &&
               OrderCloseTime()==0)
               {
                  if(OrderTicket()>last_ticket) last_ticket=OrderTicket();
               }
      }
   }
   return(last_ticket);
}



double OAPLPips(int ticket)
{
   //int Multi;
   //Multi=MathPow(10,Digits);
   double k;
   switch(Digits)
     {
      case  5: k=MathPow(10,Digits-1); break;
      case  4: k=MathPow(10,Digits); break;
      default: k=MathPow(10,Digits-1); break;
     }
   
   double p=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
   {
      if(OrderCloseTime()==0)
      {
         double price,oOpen;
         oOpen=OrderOpenPrice();
         RefreshRates();
         if(OrderType()==OP_BUY)
         {
            price=Bid;
            //if loss
            //if(oOpen>price)   return((oOpen-price));
            p=(price-oOpen)*k;
         }   
         if(OrderType()==OP_SELL)
         {
            price=Ask;
            //if loss
            //if(oOpen<price)   return((price-oOpen));
            p=(oOpen-price)*k;
         }
      }
   }
   return(p);
}
double OALots(int Magic,int type,string _symbol)
{
   double SumLots=0;
   
   for(int i=0; i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderMagicNumber()==Magic &&
               OrderSymbol()==_symbol &&
               OrderType()==type &&
               OrderCloseTime()==0)
               {
                  SumLots=SumLots+OrderLots();
               }
      }
   }
   return(SumLots);
}
double OACost(int Magic,int type,string _symbol)
{
   double SumPriceByLots=0;
   double SumLots=0;
   double BreakEvenPrice=0;
   SumLots = OALots(Magic,type,_symbol);
   if(SumLots==0)
   {
      return(-1);
      Print("BREAKEVEN::error SumLots=0");
   }
   else
   {
      BreakEvenPrice=SumPriceByLots/SumLots;
      BreakEvenPrice=NormalizeDouble(BreakEvenPrice,Digits);
   }
   return(BreakEvenPrice);
}

void OACloseAll()
{
   while(OrdersTotal()>0)
   {
      for(int i=0;i<OrdersTotal();i++)
      {
         while(IsTradeContextBusy())
         {
            Sleep(100);
         }
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         {
            OAClose(OrderTicket());
         }   

      }
   }
}

//OACloseAllbyType(MagicNumber,type,_symbol);
void OACloseAllbyType(int MagicNumber, int type, string _symbol)
{
   while(OrdersTotal()>0)
   {
      for(int i=0;i<OACount(MagicNumber,type,_symbol);i++)
      {
         while(IsTradeContextBusy())
         {
            Sleep(100);
         }
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         {
            if(OrderType()==type)   OAClose(OrderTicket());
         }   

      }
   }
}

void OAClose(int ticket)
{
   if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
   {
      RefreshRates();
      double price;
      if(OrderType()==OP_BUY)
      {
         price=MarketInfo(OrderSymbol(),MODE_BID);
         while(IsTradeContextBusy())   Sleep(50);
         if(OrderClose(OrderTicket(),OrderLots(),price,5,Gray)==true)
            Print("OACloseAll:Successful close order#"+IntegerToString(OrderTicket()));
      }
      if(OrderType()==OP_SELL)
      {
         price=MarketInfo(OrderSymbol(),MODE_ASK);
         while(IsTradeContextBusy())   Sleep(50);
         if(OrderClose(OrderTicket(),OrderLots(),price,5,Gray)==true)
            Print("OACloseAll:Successful close order#"+IntegerToString(OrderTicket()));
      }
   }
}




double OABreakEvenPrice(int MagicNumber,int type, string _symbol)
{
   double SumPriceByLots=0;
   double SumLots=0;
   double BreakEvenPrice=0;
   
   for(int i=0; i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderMagicNumber()==MagicNumber &&
               OrderSymbol()==_symbol &&
               OrderType()==type )
               {
                  SumLots=SumLots+OrderLots();
                  SumPriceByLots=SumPriceByLots+(OrderOpenPrice()*OrderLots());                  
               }
      }
   }
   
   if(SumLots==0)
   {
      return(0);
      //Print("BREAKEVEN::error SumLots=0");
   }
   else
   {
      BreakEvenPrice=SumPriceByLots/SumLots;
      BreakEvenPrice=NormalizeDouble(BreakEvenPrice,(int)MarketInfo(_symbol,MODE_DIGITS));
   }
   return(BreakEvenPrice);
}

bool IsNoPosition()
{
   if(OACount(MAGIC,OP_BUY,Symbol())==0 && OACount(MAGIC,OP_SELL,Symbol())==0) return(true);
   else return(false);
}

bool IsBuy()
{
   if(OACount(MAGIC,OP_BUY,Symbol())==1) return(true);
   else return(false);
}

bool IsBuys()
{
   if(OACount(MAGIC,OP_BUY,Symbol())>=2) return(true);
   else return(false);
}

bool IsNoBuy()
{
   if(OACount(MAGIC,OP_BUY,Symbol())==0) return(true);
   else return(false);
}

bool IsSell()
{
   if(OACount(MAGIC,OP_SELL,Symbol())==1) return(true);
   else return(false);
}

bool IsSells()
{
   if(OACount(MAGIC,OP_SELL,Symbol())>=2) return(true);
   else return(false);
}

bool IsNoSell()
{
   if(OACount(MAGIC,OP_SELL,Symbol())==0) return(true);
   else return(false);
}