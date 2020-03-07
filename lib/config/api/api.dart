class Api{
  //api构建
//  static const baseUrl = 'http://api.ifree.top:8899';
  static const baseUrl = 'http://127.0.0.1:100';
  static const socketUrl = 'ws://127.0.0.1:100';
  static const chat = '/chat';
  //user api    >>>post
  static const login = '/user/login';
  static const register = '/user/register';
  //userInformation 包含所有信息   >>>get
  static const userInformation ='/user/information';
  //修改信息   >>>put
  static const userInformationUpdate ='/user/update';
  //用户搜索   >>>get
  static const userSearch = '/user/search';

  //shop api
  //商品推荐列表api   >>>get
  static const goodsList = '/shop/goods/list';
  //修改商品   >>put
  static const goodsUpdate = '/shop/goods/update';
  //增加商品   >>>post
  static const goods = '/goods/list';
  //商品留言查询  >>>get
  static const goodsComments = '/shop/goods/comments';
  //增加商品留言   >>>post
  static const goodsCommentsAdd = '/shop/goods/comments/add';
  //修改商品留言   >>>put
  static const goodsCommentsUpdate = '/shop/goods/comments/update';
  //商品搜索   >>>get
  static const goodsSearch = '/shop/goods/search';

  //校园帮助工具
  //查询课表   >>>get
  static const schoolTimeTable = '/school/timetable';
  //课表修改    >>>put
  static const schoolTimeTableUpdate = '/school/timetable/update';
  //查询图书信息   >>>>get
  static const schoolLibrary = '/school/library';
  //图书操作（续借。。。） >>>put ???
  static const schoolLibraryUpdate = '/school/library/update';
  //图书搜索
  static const schoolLibrarySearch = '/school/library/search';
  //校园新闻   >>>get
  static const schoolNews = '/school/news';

  //论坛 类似百度贴吧形式
  //查询帖子数量
  static const  forumArticleList= '/form/article/list';  //get
  static const  forumArticleAdd= '/form/article/add';   //post
  static const  forumArticleUpdate= '/form/article/update';  //put
  static const  forumArticleSearch= '/form/article/search';  //get

  static String token ='';
  static String userId = '';



//通信，在线聊天，（websocket）暂定

  /**亮点**/
  //基于区块链的消息
  //表白，计划，等






}