import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  
  @override
  Widget build(BuildContext context) {
    return               SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
              Row(
                children: [
                   Container(
                    margin:const EdgeInsets.only(left:15),
                    child: Column(
                   children: [

                    Image.asset(
                      "../assets/room1.jpeg",
                      width: 150,
                      height:200
                      ),
                   ],
                  )
                  ),
                   Container(
                    margin:const EdgeInsets.only(left:15),
                    child: Column(
                   children: [

                    Image.asset(
                      "../assets/room1.jpeg",
                      width: 150,
                      height:200
                      ),
                   ],
                  )
                  ),
                   Container(
                    margin:const EdgeInsets.only(left:15),
                    child: Column(
                   children: [

                    Image.asset(
                      "../assets/room1.jpeg",
                      width: 150,
                      height:200
                      ), 
                   ],
                      
                    
                  )
                  
                  ),
                   Container(
                    margin:const EdgeInsets.only(left:15),
                    child: Column(
                   children: [

                    Image.asset(
                      "../assets/room1.jpeg",
                      width: 150,
                      height:200
                      ),
                   ],
                  )
                  
                  ),
                ],
              )
  
);
  }
}