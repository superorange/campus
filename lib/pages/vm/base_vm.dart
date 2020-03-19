abstract class BaseVm {
  int pageIndex = 0;
  bool netState = true;
  Future loading();
  Future loadMore();
}
