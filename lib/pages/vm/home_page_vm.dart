import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/home_page_swiper_model.dart';
import 'package:flutter_app/service/home_page_service.dart';

class HomePageVm with ChangeNotifier{

  List<Newslist> _swiperUrl=[];
  List<Newslist> get  swiperUrl => _swiperUrl;
  void getSwiperImage(){
      HomePageService().getHomePageSwiper().then((val){
        HomePageSwiperModel homePageSwiperModel=HomePageSwiperModel.fromJson(val.data);
        _swiperUrl=homePageSwiperModel.newslist;
        notifyListeners();
      },onError: (e){

      });
  }

}