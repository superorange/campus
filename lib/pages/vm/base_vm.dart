abstract class BaseVm {
  int pageIndex = 1;
  bool netState;
  Future loading();
  Future loadMore();
}
