//+------------------------------------------------------------------+
//|                                                    LastOrder.mqh |
//|                                                   A.Lopatin 2014 |
//|                                              diver.stv@gmail.com |
//+------------------------------------------------------------------+
#property copyright "A.Lopatin 2014"
#property link      "diver.stv@gmail.com"
//#property strict
#property version   "1.00"
//+------------------------------------------------------------------+
//|    get_last_order() returns ticket number of the last order.     |
//|    The function returns -1 value when it havent found last order.|
//|    Arguments: magic - Magic Number ID filtering orders. When 0   |
//|    it is not used.                                               |
//|    type - type order (buy, sell, sell limit, buy limit,          |
//|    sell stop, buy stop) for filtering orders.                    |
//|    mode - pool of orders: MODE-TRADES - trade orders,            |
//|    MODE_HISTORY - closed orders.                                 |
//+------------------------------------------------------------------+

int get_last_order(int magic,int type=-1,int mode=MODE_TRADES)
  {
   int     orders_total  = 0, ticket  = -1;
   string  symbol        = Symbol();
   datetime opn_time     = 0, ord_time = 0;

   if(mode==MODE_HISTORY)
      orders_total=OrdersHistoryTotal();
   else
      orders_total=OrdersTotal();

   for(int i=0; i<orders_total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,mode))
        {
         if(OrderSymbol()!=symbol)
            continue;
         if(OrderType()==type || type==-1)
           {
            if(OrderMagicNumber()==magic || magic==0)
              {
               if(mode==MODE_TRADES)
                  ord_time=OrderOpenTime();
               else
                  ord_time=OrderCloseTime();

               if(ord_time>opn_time)
                 {
                  opn_time=ord_time;
                  ticket=OrderTicket();
                 }
              }
           }
        }
     }//end for

   return(ticket);
  }
//+------------------------------------------------------------------+
//|    get_first_order() returns ticket number of the first order.   |
//|    The function returns -1 value when it havent found first order|
//|    Arguments: magic - Magic Number ID filtering orders. When 0   |
//|    it is not used.                                               |
//|    type - type order (buy, sell, sell limit, buy limit,          |
//|    sell stop, buy stop) for filtering orders.                    |
//|    mode - pool of orders: MODE-TRADES - trade orders,            |
//|    MODE_HISTORY - closed orders.                                 |
//+------------------------------------------------------------------+
int get_first_order(int magic,int type=-1,int mode=MODE_TRADES)
  {
   int     orders_total  = 0, ticket  = -1;
   string  symbol        = Symbol();
   datetime opn_time     = 2*TimeCurrent(), ord_time = 0;

   if(mode==MODE_HISTORY)
      orders_total=OrdersHistoryTotal();
   else
      orders_total=OrdersTotal();

   for(int i=0; i<orders_total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,mode))
        {
         if(OrderSymbol()!=symbol)
            continue;
         if(OrderType()==type || type==-1)
           {
            if(OrderMagicNumber()==magic || magic==0)
              {
               if(mode==MODE_TRADES)
                  ord_time=OrderOpenTime();
               else
                  ord_time=OrderCloseTime();

               if(ord_time<opn_time)
                 {
                  opn_time=ord_time;
                  ticket=OrderTicket();
                 }
              }
           }
        }
     }//end for

   return(ticket);
  }
//+------------------------------------------------------------------+
//|   order_lots() returns trade volume by ticket number.            |
//|   Arguments: ticket - ticket number of the order.                |
//|    mode - pool of orders: MODE-TRADES - trade orders,            |
//|    MODE_HISTORY - closed orders.                                 |
//+------------------------------------------------------------------+
double order_lots(int ticket,int mode=MODE_TRADES)
  {
   double _Lots=0;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      _Lots=OrderLots();

   return(_Lots);
  }
//+----------------------------------------------------------------------+
//| order_comment() returns string comment of the order by ticket number |
//|   Arguments: ticket - ticket number of the order.                    |
//|    mode - pool of orders: MODE-TRADES - trade orders,                |
//|    MODE_HISTORY - closed orders.                                     |
//+----------------------------------------------------------------------+
string order_comment(int ticket,int mode=MODE_TRADES)
  {
   string str="";

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      str=OrderComment();

   return(str);
  }
//+----------------------------------------------------------------------+
//| order_type() returns type of the order by ticket number              |
//|   Arguments: ticket - ticket number of the order.                    |
//|    mode - pool of orders: MODE-TRADES - trade orders,                |
//|    MODE_HISTORY - closed orders.                                     |
//+----------------------------------------------------------------------+
int order_type(int ticket,int mode=MODE_TRADES)
  {
   int type=-1;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      type=OrderType();

   return(type);
  }
//+----------------------------------------------------------------------+
//| order_open_price() returns open price of the order by ticket number. |
//|   Arguments: ticket - ticket number of the order.                    |
//|    mode - pool of orders: MODE-TRADES - trade orders,                |
//|    MODE_HISTORY - closed orders.                                     |
//+----------------------------------------------------------------------+
double order_open_price(int ticket,int mode=MODE_TRADES)
  {
   double price=-1;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      price=OrderOpenPrice();

   return(price);
  }
//+-----------------------------------------------------------------------+
//| order_close_price() returns close price of the order by ticket number.|
//|   Arguments: ticket - ticket number of the order.                     |
//|    mode - pool of orders: MODE-TRADES - trade orders,                 |
//|    MODE_HISTORY - closed orders.                                      |
//+-----------------------------------------------------------------------+
double order_close_price(int ticket,int mode=MODE_TRADES)
  {
   double price=-1;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      price=OrderClosePrice();

   return(price);
  }
//+-----------------------------------------------------------------------+
//| order_open_time() returns open time of the order by ticket number.    |
//|   Arguments: ticket - ticket number of the order.                     |
//|    mode - pool of orders: MODE-TRADES - trade orders,                 |
//|    MODE_HISTORY - closed orders.                                      |
//+-----------------------------------------------------------------------+
datetime order_open_time(int ticket,int mode=MODE_TRADES)
  {
   datetime time=0;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      time=OrderOpenTime();

   return(time);
  }
//+-----------------------------------------------------------------------+
//| order_close_time() returns close time of the order by ticket number.  |
//|   Arguments: ticket - ticket number of the order.                     |
//|    mode - pool of orders: MODE-TRADES - trade orders,                 |
//|    MODE_HISTORY - closed orders.                                      |
//+-----------------------------------------------------------------------+
datetime order_close_time(int ticket,int mode=MODE_TRADES)
  {
   datetime time=0;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
      time=OrderCloseTime();

   return(time);
  }

// --- Triggers of the closing the orders
#define CLOSE_BY_TP        1   // by takeprofit    
#define CLOSE_BY_SL        -1  // by stoploss
#define CLOSE_BY_MANUAL    0   // manual
//+--------------------------------------------------------------------------+
//| close_by() returns the trigger of closing the order:by takeprofit (1),   |
//| by stoploss (-1), manual(0).It is defined based on comment of the order. |
//| Arguments: ticket - ticket number of the order.                          |
//|            mode - pool of orders: MODE-TRADES - trade orders,            |
//|            MODE_HISTORY - closed orders.                                 |
//+--------------------------------------------------------------------------+
int close_by(int ticket,int mode=MODE_TRADES)
  {
   int retn=CLOSE_BY_MANUAL;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
     {

      if(-1!=StringFind(OrderComment(),"[sl]",0))
        {
         retn=CLOSE_BY_SL;
        }
      else if(-1!=StringFind(OrderComment(),"[tp]",0))
        {
         retn=CLOSE_BY_TP;
        }
     }

   return(retn);
  }
//+-------------------------------------------------------------------------+
//| close_by2() returns the trigger of closing the order:by takeprofit (1), |
//| by stoploss (-1), manual(0).                                            |
//| It is defined based on the close price and open price of the order.     |
//| Arguments: ticket - ticket number of the order.                         |
//|            mode - pool of orders: MODE-TRADES - trade orders,           |
//|            MODE_HISTORY - closed orders.                                |
//+-------------------------------------------------------------------------+
int close_by2(int ticket,int mode=MODE_TRADES)
  {
   int retn=CLOSE_BY_MANUAL;

   if(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET,mode))
     {
      if(MathAbs(OrderClosePrice()-OrderStopLoss())<=1*Point)
         retn=CLOSE_BY_SL;
      else if(MathAbs(OrderClosePrice()-OrderTakeProfit())<=1*Point)
                                                            retn=CLOSE_BY_TP;
     }

   return(retn);
  }
//+-----------------------------------------------------------------------------+
//| orders_count() returns the count of the opened orders.                      |
//| Arguments: magic - Magic Number ID filtering orders. When 0 it is not used. |
//| type - orders type (buy, sell, sell limit, buy limit, sell stop, buy stop)  |
//| for filtering orders. When -1 is not used.                                  |
//| comment - comment string of the orders. When "" (empty) is not used.        |
//+-----------------------------------------------------------------------------+
int orders_count(int magic,int type=-1,string comment="")
  {
   int orders_total=OrdersTotal(),count=0;

   for(int i=0; i<orders_total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()!=Symbol())
            continue;
         if((OrderMagicNumber()==magic || magic==0)
            && (OrderType()==type || type==-1))
           {
            if(comment=="" || OrderComment()==comment)
               count++;
           }
        }
     }

   return(count);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| no any order, no live order and no pending order                 |
//+------------------------------------------------------------------+

bool is_no_order(int &magic)
  {
   if(orders_count(magic)==0)
     {
      return(true);
     }
   else
     {
      return(false);
     }

  }
//+------------------------------------------------------------------+
bool is_market_order(int &magic) //either buy or sell
  {
   if((orders_count(magic,OP_BUY)==1 && orders_count(magic,OP_SELL)==0)
      || (orders_count(magic,OP_BUY)==0 && orders_count(magic,OP_SELL)==1)
      )
     {
      return(true);
     }
   else
     {
      return(false);
     }

  }
//+------------------------------------------------------------------+

void ftx2(int ticket,int markingtrailingpoints=60,int trailingpoints=20)
  {
   double spread;
   spread=(Ask-Bid);
   double stoppoint=MarketInfo(Symbol(),MODE_STOPLEVEL);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      double newstop=0;
      bool ok=false;
      if(OrderType()==OP_BUY)
        {
         if((OrderStopLoss()<OrderOpenPrice() || OrderStopLoss()==0) && Bid>OrderOpenPrice()+((20+stoppoint)*Point))
           {
            newstop=OrderOpenPrice()+spread;
            if(OrderStopLoss()==0)
              {
               ok=true;
              }
            else if(OrderStopLoss()!=0 && newstop>OrderStopLoss())
              {
               ok=true;
              }

           }
         if(OrderStopLoss()!=0 && OrderStopLoss()>=OrderOpenPrice() && Bid>=OrderStopLoss()+markingtrailingpoints*Point)
           {
            newstop=OrderStopLoss()+trailingpoints*Point;
            if(newstop>OrderStopLoss())
               ok=true;
           }
        }
      else
      if(OrderType()==OP_SELL)
        {
         if((OrderStopLoss()<OrderOpenPrice() || OrderStopLoss()==0) && Ask<OrderOpenPrice()-((20+stoppoint)*Point))
           {
            newstop=OrderOpenPrice()-spread;
            if(OrderStopLoss()==0)
              {
               ok=true;
              }
            else if(OrderStopLoss()!=0 && newstop<OrderStopLoss())
              {
               ok=true;
              }

           }
         if(OrderStopLoss()!=0 && OrderStopLoss()>=OrderOpenPrice() && Ask<=OrderStopLoss()-markingtrailingpoints*Point && newstop<OrderStopLoss())
           {
            newstop=OrderStopLoss()-trailingpoints*Point;
            if(newstop<OrderStopLoss())
               ok=true;
           }
        }

      if(newstop!=0 && ok)
        {
         //newstop=NormalizeDouble(newstop,digits);
         //ModStopLoss(OrderTicket(),newstop,clrLightBlue);
         if(OrderModify(OrderTicket(),OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration(),clrLightBlue))
           {
            Print("Mod Done");
           }

        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int order_count2(int magic,int type)
  {
   int count=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderMagicNumber()==magic && OrderType()==type)
           {
            count++;
           }
        }
     }
   return(count);
  }
//+------------------------------------------------------------------+

int order_period_seconds(int ticket)
  {
   datetime age=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      datetime open;

      open=OrderOpenTime();
      age=TimeCurrent()-open;
     }

   return((int)age);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double order_profit(int ticket)
  {
   double profit=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      profit=OrderProfit();
     }
   return(profit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double order_profitHistory(int ticket)
  {
   double profit=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY))
     {
      profit=OrderProfit();
     }
   return(profit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double order_lotsHistory(int ticket)
  {
   double _Lots=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY))
     {
      _Lots=OrderLots();
     }
   return(_Lots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double order_stoploss(int ticket)
  {
   double stop=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      stop=OrderStopLoss();
     }
   return(stop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close_order_immediate(int ticket)
  {
   double price=Bid;
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      if(OrderType()==OP_BUY)
        {
         price=Bid;
        }
      if(OrderType()==OP_SELL)
        {
         price=Ask;
        }
      Print(__FUNCTION__,", ",OrderClose(OrderTicket(),OrderLots(),price,2));
      while(IsTradeContextBusy())
        {
         Sleep(100);
        }
     }
  }
//+------------------------------------------------------------------+
double getBreakEven(int yourmagic,int ordertype)
  {
   double sumWeight=0;
   double sumProduct=0;

   int count=0;

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==ordertype && OrderMagicNumber()==yourmagic)
           {
            count++;
            sumWeight=sumWeight+OrderLots();
            sumProduct=sumProduct+(OrderLots()*OrderOpenPrice());
           }
        }
     }

   if(count>1 && sumWeight>0)
     {
      return(NormalizeDouble(sumProduct/sumWeight,
             (int)MarketInfo(OrderSymbol(),MODE_DIGITS))
             );
     }
   else return(-1);
  }
//+------------------------------------------------------------------+
bool order_modify_stoploss(int ticket,double stops,color yourcolor=clrPink)
  {
   bool modok=false;
   if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
     {

      modok=OrderModify(OrderTicket(),OrderOpenPrice(),stops,OrderTakeProfit(),OrderExpiration(),yourcolor);

     }
   return(modok);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool order_modify_takeprofit(int ticket,double take,color yourcolor=clrPink)
  {
   bool modok=false;
   if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
     {

      modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),take,OrderExpiration(),yourcolor);

     }
   return(modok);
  }
//+------------------------------------------------------------------+
double order_loss_point(int ticket,int mode=0)
                                            /*mode 0 = return in point, mode 1=return in decimal*/
  {
   int retVal=0;
   double k=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)==true)
     {
      if(OrderType()==OP_BUY && OrderOpenPrice()>Bid)
        {
         k=OrderOpenPrice()-Bid;
        }
      else if(OrderType()==OP_SELL && OrderOpenPrice()<Ask)
        {
         k=Ask-OrderOpenPrice();
        }
      else return(0);
     }

   if(k>0)
     {
      retVal=(int)(k*MathPow(10,MarketInfo(OrderSymbol(),MODE_DIGITS)));
     }
   else return(-1);

   switch(mode)
     {
      case  0:
         return(NormalizeDouble(retVal,0));
         break;
      case  1:
         return(NormalizeDouble(k,(int)MarketInfo(OrderSymbol(),MODE_DIGITS)));
         break;
      default:
         return(NormalizeDouble(retVal,0));
         break;
     }

  }
//+------------------------------------------------------------------+
bool IsAnOrder(int magic)
  {
   if((order_count2(magic,OP_BUY)==1 && order_count2(magic,OP_SELL)==0)
      && (order_count2(magic,OP_BUY)==0 && order_count2(magic,OP_SELL)==1)
      )
     {
      return(true);
     }
   else return(false);
  }
//+------------------------------------------------------------------+
int HowManyOrder(int magic)
  {
   int order=0;
   order=order_count2(magic,OP_BUY)+order_count2(magic,OP_SELL);
   return(order);
  }
//+------------------------------------------------------------------+
double order_takeprofit(int ticket)
  {
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      return(OrderTakeProfit());
     }
   else return(0);
  }
//+------------------------------------------------------------------+
//double order_stoploss(int ticket)
//  {
//   if(OrderSelect(ticket,SELECT_BY_TICKET))
//     {
//      return(OrderStopLoss());
//     }
//   else return(0);
//  }

double order_loss(int ticket,int mode=0)
                                      /*mode 0 = return in point, mode 1=return in decimal*/
  {
//int retVal=0;
   double k=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)==true)
     {
      if(OrderType()==OP_BUY && OrderOpenPrice()>Bid)
        {
         k=OrderOpenPrice()-Bid;
        }
      else if(OrderType()==OP_SELL && OrderOpenPrice()<Ask)
        {
         k=Ask-OrderOpenPrice();
        }
      else return(0);
     }
   return(k);
  }
//+------------------------------------------------------------------+
bool GroupModifyTargetPrice(int mn,int type,double price,double additionProfit)
  {
   bool modok=true;
//---
   if(type==OP_BUY)
     {
      price=price+additionProfit;
     }
//---
   if(type==OP_SELL)
     {
      price=price-additionProfit;
     }
//---
   price=NormalizeDouble(price,Digits);
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {

         //---
         if(OrderMagicNumber()==mn && OrderSymbol()==Symbol() && OrderType()==type)
           {

            if(price!=OrderTakeProfit())
              {
               modok=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),price,OrderExpiration(),clrDarkKhaki);
               while(IsTradeContextBusy())
                 {
                  Sleep(200);
                 }
               if(GetLastError()>0)
                 {
                  Print(__FUNCTION__,":: error modifying order");
                 }
              }
           }
        }

     }
   return(modok);
  }
//+------------------------------------------------------------------+
bool GroupModifyStoploss(int mn,int type,double price)
  {
   bool modok=true;
//---
//if(type==OP_BUY)
//     {
//      price=price+additionProfit;
//     }
////---
//   if(type==OP_SELL)
//     {
//      price=price-additionProfit;
//     }
//---
   price=NormalizeDouble(price,Digits);
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {

         //---
         if(OrderMagicNumber()==mn && OrderSymbol()==Symbol() && OrderType()==type)
           {

            if(price!=OrderStopLoss())
              {
               modok=OrderModify(OrderTicket(),OrderOpenPrice(),price,OrderTakeProfit(),OrderExpiration(),clrDarkGreen);
               while(IsTradeContextBusy())
                 {
                  Sleep(200);
                 }
               if(GetLastError()>0)
                 {
                  Print(__FUNCTION__,":: error modifying order");
                 }
              }
           }
        }

     }
   return(modok);
  }
//+------------------------------------------------------------------+
bool GroupCheckTargetPrice(int mn,int type,double checkprice=0)
  {
   bool modok=true;
   double sametp=0;
   if(checkprice==0)
     {
      sametp=0;
     }
   else
     {
      sametp=NormalizeDouble(checkprice,Digits);
     }
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         //price=NormalizeDouble(price,Digits);
         if(OrderMagicNumber()==mn && OrderSymbol()==Symbol() && OrderType()==type)
           {
            if(sametp==0)
              {
               sametp=OrderTakeProfit();
              }
            else
              {
               modok=modok && OrderTakeProfit()==sametp;
              }

           }
        }

     }
   return(modok);
  }
//+------------------------------------------------------------------+
double order_sum_profit(int mn)
  {
   double sprofit=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         sprofit=sprofit+OrderProfit();
        }
     }
   return(sprofit);
  }
//+------------------------------------------------------------------+
void order_close_ALL(int mn)
  {
   Print(__FUNCTION__+":: start force closing''''''''''''");
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS) && OrderMagicNumber()==mn)
        {
         double exe=MarketInfo(Symbol(),MODE_BID);
         if(OrderType()==OP_BUY) exe=MarketInfo(Symbol(),MODE_BID);
         if(OrderType()==OP_SELL) exe=MarketInfo(Symbol(),MODE_ASK);

         bool closeok=OrderClose(OrderTicket(),OrderLots(),exe,10,clrRed);
         while(IsTradeContextBusy())
           {
            Sleep(300);
           }
         if(closeok)
           {
            Print(__FUNCTION__+":: force closing #"+IntegerToString(OrderTicket()));
           }
        }
     }
   Print(__FUNCTION__+":: end force closing''''''''''''");
  }
//+------------------------------------------------------------------+
double order_profit_points(int ticket)
  {
   double gainpoints=0;
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      if(OrderProfit()>0)
        {
         gainpoints=OrderProfit()/(OrderLots()*MarketInfo(OrderSymbol(),MODE_LOTSIZE));
        }
     }
   gainpoints=NormalizeDouble(gainpoints,(int)MarketInfo(OrderSymbol(),MODE_DIGITS));
   return(gainpoints);
  }
//+------------------------------------------------------------------+

int MyOrdersTotal(int magic)
  {
   int count=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS) && OrderMagicNumber()==magic && OrderSymbol()==Symbol())
        {
         count++;
        }
     }
   return(count);
  }
//+------------------------------------------------------------------+
