
import 'package:cloud_firestore/cloud_firestore.dart';

class Search
{
  String source;
  String destination;
  String description;
  String cost;
  String spot;
  String date;
  String Arrivaltime;
  String departuretime;
  String number;
  Search(this.source,this.departuretime,this.Arrivaltime,this.destination,this.cost,this.date,this.description,this.number,this.spot);
   /*Search.fromMap(Map<String,dynamic> data)
   {
     source=data['source'];
      destination=data['destination'];
       description=data['description'];
        cost=data['cost'];
         spot=data['spot'];
          Arrivaltime=data['Arrivaltime'];
           departuretime=data['departuretime'];
            number=data['number'];
             date=data['date'];

   }*/

}