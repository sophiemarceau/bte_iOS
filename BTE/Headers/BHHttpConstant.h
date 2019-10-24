//
//  BHHttpConstant.h
//  BitcoinHeadlines
//
//  Created by zhangyuanzhe on 2017/12/22.
//  Copyright © 2017年 zhangyuanzhe. All rights reserved.
//

#ifndef BHHttpConstant_h
#define BHHttpConstant_h
//环境 1表示： 正式 生产环境
//    0表示:  测试 开发环境
#define ONLION 0

//请求数据接口
#if ONLION
static NSString * const kDomain = @"https://m.bte.top/";
//环信 生产
static NSString * const kIMAppKey = @"1115180702253633#bteapp";
//@"1187180613253548#btesophiemarceauqu";
#else
static NSString * const kDomain = @"https://l.bte.top/";
//环信 测试
static NSString * const kIMAppKey = @"1115180702253633#bteapptest";
#endif
//生产环境
#if ONLION
static NSString * const kHeader = @"https://m.bte.top/";
static NSString * const kChart = @"https://m.bte.top/";
static NSString * const kWeChatStr = @"v2/wechat/";
static NSString * const kActivityStr = @"ad/20181024/";
//static NSString * const kGlobal = @"global";
//static NSString * const kSso = @"sso";
//static NSString * const kbandDogPush = @"bandDogPush";
//static NSString * const klzDogVotePush = @"lzDogVotePush";
//static NSString * const kindexDogPush = @"indexDog";
#define TimeString 7 * 24 * 3600
#else
//测试环境
//static NSString * const kHeader = @"http://172.16.24.196:8081/";
//static NSString * const kChart = @"http://172.16.24.196:8081/";
static NSString * const kHeader = @"https://l.bte.top/";
static NSString * const kChart = @"https://l.bte.top/";
static NSString * const kWeChatStr = @"v2/wechat/";
static NSString * const kActivityStr = @"ad/20181024/";
//static NSString * const kGlobal = @"global_test";
//static NSString * const kSso = @"ssotest";
//static NSString * const kbandDogPush = @"bandDogPushtest";
//static NSString * const klzDogVotePush = @"lzDogVotePushtest";
//static NSString * const kindexDogPush = @"indexDogTest";
#define TimeString 7
#endif

//协议地址
#define kAppBTEProtcol [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"protocol"]
// 比特易h5入口地址 市场分析
#define kAppBTEH5AnalyzeAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"index"]
// 比特易h5入口地址 策略跟随
#define kAppBTEH5FollowAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"StrategyIndex/"]
// 比特易h5入口地址 个人中心
#define kAppBTEH5MyAccountAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"iosaccount"]
// 比特易h5入口地址 行情数据
#define kAppBTEH5TradDataAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"currencyList/"]
// 比特易h5入口地址 撸庄狗
#define kAppBTEH5DogAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"feature"]
// 比特易h5入口地址 撸庄狗周报
#define kAppBTEH5featureReportAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"featureReport/"]
// 比特易h5入口地址 积分页面
#define kAppBTEH5integralCheatsAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"integralCheats/"]
// 比特易h5入口地址 撸庄狗周报
#define kAppBTEH5featureReportAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"featureReport/"]
// 比特易h5入口地址 投资详情入口地址
#define kAppStrategyAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"strategyDetail/"]
// 比特易h5入口地址 投资策略列表入口地址
#define kAppStrategyListAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"strategy"]
// 比特易h5入口地址 交易详情入口地址
#define kAppDealAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketDetail/"]
// 比特易h5入口地址 市场分析详情入口地址
#define kAppDetailDealAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"researchReport/"]
// 比特易h5入口地址 首页市场分析图表
#define kAppMarketAnalysisAddress [NSString stringWithFormat:@"%@%@%@",kChart,kWeChatStr,@"indexLine/"]
// 比特易h5入口地址 波段狗入口地址
#define kAppBrandDogAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"bandDog"]
// 比特易h5入口地址 K线底部入口
#define kAppKlineBottomAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketDetail/"]
// 比特易h5入口地址 about入口
#define kAppAboutAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"about"]
// 比特易h5入口地址 K线底部入口
#define kAppKlineBottomchainDetailAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"chainsearchprojectdetail/"]
// 比特易h5入口地址 邀请入口
#define kAppInviteResultAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"inviteResult"]
// 比特易h5入口地址 服务设置入口
#define kAppserviceSettingAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"serviceSetting"]
// 比特易h5入口地址 积分时间线入口
#define kAppIntegralListAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"integralList"]
// 比特易h5入口地址 加入官方群入口
#define kAppAddGroupAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"addGroup"]
// 比特易h5入口地址 我的资产
#define kAppAssetsAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"assets"]
// 比特易h5入口地址 研究狗入口地址
#define kResearchDogAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"researchDog/"]
// 比特易h5入口地址 合约狗入口地址
#define kAppContractDogAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"contractDog/"]
// 比特易h5入口地址 盯盘狗入口地址
#define kStareDogAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"stealingDog"]
// 比特易h5入口地址 空气指数入口地址
#define kAirIndexAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketoverview2?tab=airIndex"]
// 比特易h5入口地址 交易规模入口地址
#define kTabAmountAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketoverview2?tab=amount"]
// 比特易h5入口地址 资金流向入口地址
#define kTabNetFlowAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketoverview2?tab=netFlow"]
// 比特易h5入口地址 K线盯盘入口地址
#define kAppKlineNoteAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"stealingMonitorIndicator"]
//合约狗 合约狗分享链接
#define kGetcontractDogUrl [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"contractDog/"]

//后台生产的二维码里面扫描出来的地址
#define kGetUserInvateFrendUrl [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"register"]


#define kDigInvateFrendUrl [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"register"]
// 比特易Header H5地址
#define kHomePageHeaderH5Url [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"indexheader"]

// 比特易h5入口地址 链链查
#define kAppBTECheckChainAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"chainsearch"]

// 比特易h5入口地址 挖矿首页
#define kAppDugHomePageAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"index"]
// 比特易h5入口地址 挖矿我的算力
#define kAppMyEnergyAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"energy"]
// 比特易h5入口地址 挖矿我的钱包
#define kAppMyWalletAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"wallet"]
// 比特易h5入口地址 挖矿邀请记录
#define kAppMyInviteRecordAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"invite"]
// 比特易h5入口地址 挖矿关注公众号
#define kAppOfficialAccountsAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"OfficialAccounts"]
// 比特易h5入口地址 挖矿注册用户
#define kAppDugRegisterAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"register"]
// 比特易h5入口地址 挖矿addgroup
#define kAppjoinGroupAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"joinGroup"]
// 比特易h5入口地址 挖矿用户调研
#define kAppuserResearchAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"userResearch"]
// 比特易h5入口地址 Missionlist
#define kAppMissionlistAddress [NSString stringWithFormat:@"%@%@%@",kHeader,kActivityStr,@"mission"]
// MARK: 注册&登录
//检测账号是否注册
#define kNewOldUserPassword [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/newOldUserPassword"]
//设置新密码登录
#define kNewInstallPassword [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/installPassword"]
//登录后修改用户登录密码
#define kupdatePassword [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/password"]
//发送短信验证码
#define kMessageAuth [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/sms_v2/login"]
// 用户手机号登录接口
#define kCodeLogin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/login"]
//密码登录
#define kPwdLogin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/loginPwd"]
//获取用户信息v2
#define kGetUserInfoV2 [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/info"]
//微信用户添加接口
#define kGetWXBind [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/wx/bind"]
//微信用户取消绑定
#define kGetWXUnBind [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/wx/unbind"]
//更新用户基本信息
#define kUpdateUserInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/update"]
//获取用户信息
#define kGetUserInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/info"]
//系统密码 更新密码
#define kreSetPwd [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/password"]
//版本更新
#define kAppVersion [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/config/update"]
//获取用户信息
#define kGetOSSConfig [NSString stringWithFormat:@"%@%@",kDomain,@"app/sts/config"]
//获取用户信息
#define kGetOSSauthUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/sts/credential"]
//MARK:我的账户
//账户基本信息
#define kAcountInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/info"]
//获取当前账户电话号码
#define kAcountPhoneNum [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/info"]
//获取当前跟投信息
#define kAcountHoldInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/hold"]
//获取当前跟投份额信息
#define kAcountSettleInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/account/settle"]
//退出登录
#define kAcountUserLogout [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/logout"]
//获取用户登录状态
#define kGetUserLoginInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/online"]
//首页 未读消息数
#define kGetUnReadNum [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/message/unread"]
//MARK:首页 市场分析
#define kGetlatestInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/advise/latests"]
//用户是否已经执行今日签到
#define kifCheckin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/ifCheckin"]

//首页 获取各种Dogs的显示数字
#define kDogsNum [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dogs"]

//首页或者工具菜单 event事件统计
#define kEventCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/event"]

//用户执行每日签到
#define kCheckin [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/checkin"]

#define kGetBanner [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/v2/banner"]
//个人中心 服务设置列表
#define kAllKindsDogStatus [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/dogs"]
//个人中心 服务设置波段
#define kSubmitBandDogStatus [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/bandDog/openCloseBandDog"]
//个人中心 服务设置撸庄
#define kSubmitLzDogStatus [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/lzdog/openLzDog"]
//个人中心 服务设置合约
#define kSubmitContractDogStatus [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/future/switch"]
//个人中心 服务设置 开关打开时候弹窗提示所对应服务 消耗具体多少积分
#define kSelectDogUserScore [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dogs"]
//消息中心 列表 GET
#define kMessageCenterList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/message/list"]
//消息中心 列表 设置问已读
#define kMessageCenterRead [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/message/read"]


/**
 * 挖矿
 */
//挖矿 矿活动配置信息
#define kDigConfigInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/config"]

//挖矿 算力领取
#define kGetDigPower [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/get"]

////挖矿 用户奖励明细
//#define kGetDigIncome [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/income"]

//挖矿 用户挖矿账户及任务状态信息
#define kGetDigInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/info"]

////挖矿 用户挖矿期间邀请明细
//#define kGetDigInviteInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/invite"]

////挖矿 用户开启挖矿
#define kOpenDig [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/open"]

////挖矿 用户挖矿算力排行
//#define kDigPowerList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/power"]

//挖矿 挖矿活动规则说明
#define kDigRuleInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/rule"]

//挖矿 挖矿活动进度信息
#define kDigScheduleInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/schedule"]

//挖矿 挖矿分享后增加算力
#define kDigShare [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/share"]

//挖矿 算力签到
#define kDigSign [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/dig/sign"]

/**
 * 行情
 */
// 导航列表
#define MarketNavigateList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/navigation"]

// 板块列表
#define MarketplateList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/24h/industry"]

// 全部行情
#define allMarketList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/ticker/list"]

// 自选行情
#define optionMarketList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/market/optionalList"]

// 币种推荐列表
#define optionMainstreamList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/mainstream"]

// 币种列表
#define currencyList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/list"]

//全网/指定币种资金流向
#define currencyFoundFlowList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/trade/net/line"]

// 资金流入流出排名
#define TradeFlowRank [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/trade/net/rank"]

// 涨跌幅
#define RiseRankList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/ticker/list"]

// 交易所列表
#define SummaryList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/exchange/summary"]

// 24h排名
#define Summary24List [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/24h/info"]

// 单个币种列表
#define singleCurrencyList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/ticker"]

// 模糊搜索币种
#define searchCurrencyList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currencypair/list"]

#define addBatchCurrencyList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/market/batch/optional"]
//行情数据 币列表
#define kCoinList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/24h/info"]


//行情数据 板块详情 POST /api/currency/industry/detail
#define kPlateDetail [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/currency/industry/detail"]
/**
 * 社区
 */
// 发布评论
#define ComunityAddCommontUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/comment/add"]
// 发布帖子
#define ComunityAddArticleUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/add"]

// 帖子列表
#define ComunityCommontListUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/list"]

// 我评论的列表
#define ComunityMyCommontListUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/myComment"]

// 我发布的列表
#define ComunityMyIssueListUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/myRelease"]

// 评论回复列表
#define ComunityReplyListUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/comment/reply/list"]

// 帖子分享
#define ComunityShareUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/share/add"]

// 帖子点赞
#define ComunityPriaseUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/like/add"]

// 帖子详情
#define ComunityDetailUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/detail"]

// 帖子详情
#define ComunityIssueCommontUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/comment/add"]

// 回复评论
#define ComunityReplyCommontUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/comment/reply/add"]

// 全部已读
#define ComunityReadallUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/post/readall"]

// https://m.bte.top/v2/wechat/marketOverview
// H5行情图表
#define kMarketHeaderH5Url [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"marketoverview"]

#define kMarketcurrencyListHeaderH5Url [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"currencyList"]

// K线数据
#define kGetKLineData [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/kline/line"]

//kline  大单成交
#define kGetKlinehugeDealUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/trade/spot/hugeDeal"]

//kline  超级深度
#define kGetKlineTradeDepthUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/trade/spot/depth"]

// 交易所
#define kGetExchangeData [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/exchange/info"]
// 点评数据
#define kGetKlineCommentList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/klineComment/getComments"]

// 自选列表
#define kGetOptionalList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/market/optionalList"]

// 添加自选
#define kGetAddOptional [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/market/addOptional"]

// 删除自选
#define kGetDeleteOptional [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/market/deleteOptional"]

//合约狗 超级深度
#define kGetDepthUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/depth"]

//合约狗 大单
#define kGetAbnormityUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/abnormity"]

//合约狗 异常大单
#define kGetAbnormityLineUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/abnormity/line"]

//合约狗 爆仓单
#define kGetBurnedUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/burned"]

//合约狗 爆仓单
#define kOpencontractH5Url [NSString stringWithFormat:@"%@%@%@",kHeader,kWeChatStr,@"opencontract"]


//合约狗 所有期货币对信息
#define kGetCurrencyUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/currency"]

//合约狗 K线数据
#define kGetKlineUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/kline"]

//合约狗 开启关闭合约狗
#define kGetOpenContractDogUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/switch"]

//合约狗 合约狗获取积分
#define kGetDogGoalUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/summary"]

//合约狗 压力线
#define kGetResistanceLineUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/resistance/line"]

//合约狗 交易量
#define kGetVolumeUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/volume/line"]

//合约狗 钱包
#define kGetTxsUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/address/txs"]


// 实时资金流向
#define kGetLatestflowUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/currency/flow"]

// 历史资金流向
#define kGetHistoryflowUrl [NSString stringWithFormat:@"%@%@",kHeader,@"app/api/future/trade"]


//合约狗 首页合约狗正在使用人数
#define kGetContractDogCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/future/summary"]

//研究狗 首页研究狗正在使用人数
#define kGetResearchDogCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/researchDog/getResearchDogCount"]


//分享成功加积分
#define kaddSharePoint [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/lzdog/addSharePoint"]
//share-api : 分享API createShare
#define kcreateShare [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/share/createShare"]
//share-api : 分享API cancelShare
#define kcancelShare [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/share/cancelShare"]
//新闻快讯
#define kGetlatestNewsInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/news/latest"]
//获取首页显示的策略信息
#define kGetlatestProductInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/product/home"]
//获取首页显示的策略信息list
#define kGetlatestProductInfoList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/v2/product/home"]

//MARK:策略列表页
//获取策略列表
#define kGetlatestProductList [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/product/list"]

#define kFromSummaryCountAndincome [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/lzdog/summary"]

#define kUserCountAndincome [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/lzdog/userCountAndincome"]

#define kbandDogUserCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/bandDog/bandDogUserCount"]

#define kFromBandDogUserCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/bandDog/summary"]
//获取邀请好友
#define kGetUserInvateFrend [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/myQrCode"]
//获取邀请好友结果
#define kGetUserInvateFrendCount [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/invite/list"]
//意见反馈
#define kGetUserFeedback [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user_v2/feedback"]
//活动页
#define kGetUserActivity [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/activity"]
//活动页详情页
#define kGetUserActivityDetail [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/activity/detail"]

//获取市场分析报告地址url
#define kGetUserRepoertUrl [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/report"]

//获取公告
#define kGetUserAnnouncement [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/announcement"]
//获取首页邀请
#define kGetHomePageUserInvateFrend [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/user/myQrCode"]

//获取 首页上方 空气相关数据统计数字
#define kGetHomePageAtmospereSummmary [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/exchange/global/summary"]
//MARK:环信集成
//关联环信体系  返回用户名密码 以及 聊天室ID
#define kAddUserAndRoom [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/addUserAndRoom"]
//聊天会话页面 获取 昵称 头像
#define kHXgetUserInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/getUserInfo"]
//用户是否注册到环信(需传token)true代表已经注册过 falae代表没有注册过
#define kWhetherRegisterHX [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/userWhetherRegister"]
//用户是否注册到环信(需传token)true代表已经注册过 falae代表没有注册过
#define kWhetherRegisterHX [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/userWhetherRegister"]
//获得头像 getUserHeadImage 然后去设置用户自己的头像用
#define kgetUserHeadImage [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/getUserHeadImage"]
//环信 群组里的人数
#define kGetRoomInfo [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/emChat/getRoomInfo"]
#define kGetAliAfsApi [NSString stringWithFormat:@"%@%@",kDomain,@"app/api/ali/afs/check"]
#endif /* BHHttpConstant_h */









