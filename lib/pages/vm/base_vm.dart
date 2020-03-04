abstract class BaseVm{

  int pageIndex=1;
  bool netState =true;
  Future loading();
  Future loadMore();

}