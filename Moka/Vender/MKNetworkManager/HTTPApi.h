//  HTTPApi.h
//  Exercise
//
//  Created by 郑克 on 15/12/8.
//  Copyright © 2015年 sanfenqiu. All rights reserved.


#ifndef HTTPApi_h
#define HTTPApi_h
// 接口用设备类型 1 表示IOS
#define DEVICE_TYPE         1
#define IMG_URL                @""


#pragma mark - 正式server

//#define WAP_URL                 @"http://119.23.221.153/moka-ios/"

#define WAP_URL                 @"https://tchat.btc123.com/moka-ios/"
#define WAP_IMAGE_URL           @"https://pro-tchat-oss.oss-cn-beijing.aliyuncs.com/"

#pragma mark - 测试server 内网

//#define WAP_URL               @"http://172.16.1.231:8888/moka-ios/"
////测试服阿里云图片服务器前缀
//#define WAP_IMAGE_URL         @"https://qianke-bucket.oss-cn-hangzhou.aliyuncs.com/"

//联鹏本机
//#define WAP_URL               @"http://172.16.1.229/"
//刘文仲本机
//#define WAP_URL               @"http://172.16.1.130:8080/"

#pragma mark - 测试server 外网
//#define WAP_URL               @"http://171.217.92.203:8788/moka-ios/"

#pragma mark - 本地server

//#define WAP_URL                @"http://192.168.21.162:8080/center/"


#pragma mark -- BTC123 server
#define BTC123APILOCAL @"https://www.btc123.com/"



#pragma mark - 版本更新

//#define api_checkVersion    @"login/edition"              //检查版本
#define api_checkAppUpdate  @"login/checkUpdate"          //检测更新

#pragma mark - 登陆注册
#define api_sendCode         @"login/sendCode"            //发送验证码 参数：phone【电话】
#define api_affirmCode       @"login/codes"               //验证验证码
#define api_register         @"login/register"            //注册
#define api_paswordLogin     @"login/login"               //密码登录
#define api_tokenLogin       @"login/loginToken"          //token登陆
#define api_updateUser       @"login/updateUser"          //修改用户资料
#define api_getTags          @"login/lableByMy"           //获取标签
#define api_postTags         @"login/Mylable"             //提交喜欢的标签
#define api_upLoadImage      @"login/uploadImg"           //上传图片
#define api_uploadMultiImages @"authentication/addIdentity" //上传多张图片
#define api_deleteImage      @"user/delPortraitl"         //删除图片
//#define api_forgetPassword   @"login/forgetPwd"           //修改密码
#define api_forgetPassword   @"login/forgetPwd2"           //修改密码
#define api_setPortrait      @"user/upPortrait"           //修改头像
#define api_setPayPassword   @"user/setUpTrPassword"      //设置账号支付密码
#define api_setLoginPasswd   @"user/upPassword"           // 修改登录密码
#define api_feedback         @"feedBack/addFeedBack"      //用户反馈 
#define api_changeCodeImage  @"user/changeImgCode"        //换图片验证码


#pragma mark - 个人中心
#define api_autoInfo         @"user/inspect"              //检查资料完整
#define api_getUserInfo      @"user/myIndex"              //个人中心首页
#define api_changeTags       @"user/upmylable"            //修改标签

#pragma mark - 首页
#define api_near_people      @"nearby/nearbyAll"          //首页附近的人
#define api_create_circle    @"circle/insert"             //创建圈子
#define api_find_circle      @"circle/selectCircleAll"    //查询圈子
#define api_circel_info      @"circle/selectCircleById"   //圈子信息
#define api_circle_info2     @"circle/selectCircleById2"  //圈子信息:不包含群成员
#define api_circle_members   @"circle/selectCircleMembers"//圈子所有的成员
#define api_update_circle    @"circle/updateCircle"       //修改圈子
#define api_update_circleImg @"circle/updateCircleImgs"   //修改圈子头像
#define api_join_circle      @"circle/addMember"          //加入免费圈子
#define api_circle_notice    @"circle/updateNotice"       //修改圈子通知
#define api_delete_member    @"circle/delMember"          //删除圈子成员 
#define api_inform_circle    @"circle/reportCircle"       //举报圈子
#define api_out_circle       @"circle/outCircle"          //退出圈子
#define api_dissolut_circle  @"circle/dissolution"        //解散圈子

#define api_member_info      @"nearby/othersIndex"        //查看用户资料
#define api_member_dynamic   @"nearby/othersMessage"      //查看用户动态
#define api_follow_user      @"follow/addFollow"          //关注 
#define api_unfollow_user    @"follow/delFollow"          //取消关注
#define api_say_hello        @"sayhello/addSayhello"      //打招呼
#define api_say_hello2       @"sayhello/addSayhello2"    //打招呼更新接口：增加输入支付密码

#pragma mark - 动态

#define api_post_dynamic     @"message/addMessage"                //发布动态
#define api_get_dynamic      @"message/findMessageAll"            //获取动态
#define api_hot_dynamic      @"message/hotfindMessageAll"         //热门动态
#define api_like_dynamic     @"thing/addThing"                    //点赞
#define api_dislike_dynamic  @"thing/delThing"                    //取消点赞
#define api_delete_dynamic   @"message/delMessage"                //删除动态
#define api_dynamic_detail   @"message/selMessage"                //查询单个动态
#define api_inform_dynamic   @"message/reportMessage"             //举报动态
#define api_addComment       @"comment/addComment"                //添加评论
#define aoi_deleteComment    @"comment/delComment"                //删除评论
#define api_unreadMessage    @"message/relateMe"                  //未读消息数量
#define api_unreadDetail     @"message/relateDetailed"            //未读详细
#define api_follow_list      @"follow/selFollow"                  //我的关注列表
#define api_myFans_list      @"follow/selFans"                      //我的粉丝
#define api_giveReward       @"message/areward"                     //打赏

#pragma mark - 聊天

#define api_chat_home        @"chat/selLately"                    //聊天首页
#define api_unreadHello_list @"chat/selSayHelloHavaRead"          //未读打招呼 列表
#define api_unreadFans_list  @"chat/selFollowHavaRead"            //未读粉丝 列表
#define api_selSayHello      @"chat/selSayHelloHava"               //打招呼修改为已看
#define api_selFans          @"chat/selFollowHava"               //查看粉丝修改为已看
#define api_my_circles       @"circle/myCircle"                   //查看自己所有的圈子
#define api_search_user      @"chat/selectByCodeAndPhone"         // 添加好友搜索
#define api_getUserInfoByUserId @"user/selectByUserid"            //根据userID查询用户基本信息
#define api_getCircleInfoById @"circle/selectByCircleId"          //根据circleID查询基本信息

#define api_inviteFriend        @"login/mailList"               //邀请好友
#define api_checkIfFollow       @"follow/selectByiffollow"      //查询是否关注 参数：coveruserid 【对方id】
#define api_addRemark           @"follow/addRemarks"            //添加备注
#define api_addCircleRemark     @"circle/insertCircleRemark"    //添加圈子备注 

#pragma mark - 红包

#define api_getCoinsRemain            @"red/redSelectByMoney"             //发送红包时，查询余额(已废弃)
#define api_sendPersonalRedPacket     @"red/insertRed"                     //发送个人红包
#define api_openPersonalRedPacket     @"red/robRed"                         // 领取个人红包
#define api_queryPersoanlRedpacket    @"red/selectRedByUid"                 //查询单个红包
#define api_queryGift                 @"gift/operationGift"                 // 查询礼物
#define api_recievedRedPacket         @"red/selectRedByAllCoverUserId"      //我抢过的红包
#define api_sendedRedPacket           @"red/selectRedByAllUserId"         //我发过的红包

#define api_groupSendingRed      @"red/groupSendingRed"                  //群发红包
#define api_checkGroupRed        @"red/selectByGroupSendingRed"         //查询群红包 参数：uid
#define api_openGroupRed         @"red/removeGroupSendingRed"           //打开群红包 参数：uid


#pragma mark -- 新红包接口
#define api_sendPersRedPacket       @"redWithCoin/sendRedPackage"      //发送个人红包
#define api_getPersRedPacket        @"redWithCoin/robRedPackage"       //抢个人红包
#define api_redPacketDetails        @"redWithCoin/redPackageDetail"    //红包详情
#define api_redPacketRecieve        @"redWithCoin/myRobRedPackage"     //收到的红包
#define api_redPacketPay            @"redWithCoin/mySendRedPackage"    //发出去的红包




#pragma mark -- 认证

#define api_ifAuthen                @"authentication/ifgoogleAndIdentity"   //是否认证
#define api_get_authen_key          @"authentication/googleKey"         //获取google认证key
#define api_google_authen           @"authentication/googleGetOk"       //确认google验证
#define api_checkPayPasswordSet     @"user/inspectPayment"         //检查用户是否设置支付密码

#define api_walletRecharge          @"wallet/recharge"      //充值查询
#define api_myWalletMoney           @"wallet/walletMoney" //查询个人金额
#define api_withdrawQuery            @"wallet/withdrawals" //提现查询
#define api_walletWithdraw          @"wallet/withdrawalsok"//提现确认 

#pragma mark - 账单

#define api_getAllBills             @"user/billAll"   //账单
#define api_myAllRedPacket           @"red/selectRedByAllId" //查看我所有红包记录
#define api_myAllTransaction         @"transaction/selectByUserId"//查询我充值或提现信息
#define api_myAllGift                @"gift/selectByMyGift"//查询所有与我相关的礼物
#define api_myAllIco                  @"ico/selectByPrimaryICOAndVote" //我发起与参与的ICO

#pragma mark - ICO

#define apiIcoDetail                 @"ico/selectByIcoId"      // 查询ICO详情
#define api_myJoinIco                @"ico/selectByMyICOVote"  //我参与的ICO
#define api_myLaunchIco              @"ico/selectByMyICO"      //我发起的ICO
#define api_joinIcoPay              @"ico/addVote"              //参投   icoid
#define api_getIcoRecord            @"ico/selectByVoteIcoAll"   //参投记录



#pragma mark -- TV回馈
#define api_feedBackLockTV          @"feedBack/lockTv"        //锁定钛值
#define api_feedBackLockRecords     @"feedBack/lockRecords"   //锁定记录
#define api_feedBackActivity        @"H5/Activity.html"       //活动页
#define api_feedBackPlain           @"H5/TvAbout.html"        //钛值回馈计划
#define api_feedBackTVReward        @"feedBack/tvFeedbackTotalAndNew"   //钛值奖励头部数据
#define api_feedBackRewardBills     @"feedBack/tvFeedbackRecords"       //钛值奖励明细


#pragma mark -- 支付宝
#define api_alipayMyMoney          @"wallet/myMoney"          //我的零钱
#define api_alipayBundleAccount    @"wallet/bindAccount"      //绑定支付宝
#define api_alipayUnBundleAcc      @"wallet/unbindAccount"    //解绑
#define api_alipayCharge           @"wallet/moneyRecharge"    //支付宝充值
#define api_alipayWithDraw         @"wallet/moneyWithdrawals" //支付宝提现
#define api_alipayBillsDetail      @"wallet/moneyBill"        //支付宝明细



#pragma mark -- 我的余额
#define api_myBalance             @"wallet/balance"        //我的余额





#pragma mark -- 资讯
//新闻列表
#define APINewsList    [BTC123APILOCAL stringByAppendingString:@"api/news/list"]
//新闻详情
#define APINewsDetail  [BTC123APILOCAL stringByAppendingString:@"api/news/detail"]



#define apiLogin            @"/auth/login/sms"
#define apiLoginOut         @"/auth/logout"
#define apiAuthInfo         @"/auth/info"
#define apiCompanyApply     @"/auth/company_apply"
#define apiAuthPushToken    @"/auth/pushtoken"
#define apiAuthStatusApply  @"/auth/status/apply"
#define apiAuthStatusConfim @"/auth/status/confirm"

#define apiImageUplode      @"/imageupload"
#define apiApply_result     @"/auth/status/apply_result"
#define apiHome             @"/home"


#pragma mark --- 跑步

#define api_run_record_list @"/run/mylist"  //跑步记录列表
#define api_run_detail      @"/run/detail/" //跑步记录详情

#pragma mark - 创建活动

#define api_create_activity @"/mission/manager/create"
#define api_update_activity @"/mission/manager/update"

#pragma mark -  摇一摇

#define api_mission_shake @"/mission/partner/shake"
#define api_partner_got   @"/mission/partner/got"
#define api_partner_comment @"/mission/partner/comment"

#pragma mark - 跑步任务状态

#define api_mission_ongoing @"/mission/ongoing/"
#define api_mission_signIn  @"/mission/ongoing/signin"
#define api_mission_signOut @"/mission/ongoing/signout"

//团队
#define api_Club_home       @"/team/home"
#define api_Club_absent     @"/team/absent"
#define api_Club_build      @"/team/build"
#define apu_club_finish_missions  @"/team/finish_missions"
#define api_get_manger_info @"/team/manager/info"
#define api_up_team_manager_info    @"/team/manager/info"
//获取消息列表
#define apiGetMsgList      @"/message/list"
//语音消息 - 播放
#define apiVoiceDownload   @"/message/voice/download"
//语音消息 - 播放记录
#define apiVoicePlayList   @"/message/voice/playlist"
//文本消息 - 发送
#define apiSendTextMsg     @"/message/create/text"
//语音消息 - 发送
#define apiSendVoiceMsg    @"/message/voice/upload"

#define apiMissionVoiceUpload  @"/mission/voice/upload"
#define apiMissionVoiceSync     @"/mission/voice/sync"
#define apiMissionVoiceDownload     @"/mission/voice/download"
#define apiDataAn           @"/team/manager/data_analysis"
#define apiteammanagerdata_analysisdistance @"/team/manager/data_analysis/distance"
#define apiteammanagerdata_analysisscore   @"/team/manager/data_analysis/score"
#define apiteamfilter       @"/team/filter"
#define apiTeamMemberMonth  @"/team/member/month"
#define apiTeamMemberList   @"/team/member/list"
#define apiteammemberscore_board  @"/team/member/score_board"
#define apiteammemberappoint   @"/team/member/appoint"

#define apiTeamdeleagterP   @"/team/member/delete"

//个人中心
#define apiMineHome     @"/auth/profiles"
#define api_mypn_receive     @"/auth/profiles/receive_push"
#define apiauthprofilessignature    @"/auth/profiles/signature"
//奖励
#define apirewardlist       @"/reward/list"
#define apirewardparam      @"/reward/param"
#define apiaddkilometre     @"/reward/add/kilometre"
#define apiaddtime          @"/reward/add/time"
#define apidelereward       @"/reward/delete"
#define apiresicedreward    @"/reward/receive"
#define apirewardupdatekilometre  @"/reward/update/kilometre"
#define apirewardupdatetime       @"/reward/update/time"

//消息
#define apimainmessagelist      @"/message/list"
#define apimainmessagelisttemplate  @"/message/list/template"
#define apimainmessagevoicedownload     @"/message/voice/download"
#define apimessageteammanagerhandleapply        @"/team/manager/handleapply"


//任务
#define apimissionmanagercancelcycle    @"/mission/manager/cancel/cycle"
#define apimissionmanagercancelonce    @"/mission/manager/cancel/once"









//活动详情
#define apiMission      @"/mission"
#define apimissiondata_analysisdistance     @"/mission/data_analysis/distance"
#define apimissiondata_analysisscore        @"/mission/data_analysis/score"
#define apimissionuserlist                  @"/mission/user/list"
#define apimissionphotodetail               @"/mission/photo/detail"
#define apimissionphotopraise               @"/mission/photo/praise"
#define apimissionphotoupload               @"/mission/photo/upload"

#define apiLoginWeixin      @"/auth/login/weixin"
#define apiauthphone_bandweixin @"/auth/phone_band/weixin"
#define api_my_info         @"/auth/info"
#define apiLoginRegister    @"/register/step1"
#define apiRegister         @"/register/step2"
#define apiLoginWeChatPhone @"/captcha/forgot"
#define apiLoginRegisternum @"/captcha/register"
#define apiCaptchaWeixin    @"/captcha/weixin"
#define api_captcha_changePassword @"/captcha/change_password"
#define api_captcha_changePhone @"/captcha/change_phone"
#define apiAuthPerfect      @"/auth/perfect"
#define api_GameOver        @"/auth/logout"
#define api_unBind_weChat   @"/auth/profiles/weixin/unbind"
#define api_get_num         @"/auth/findpwd"
#define apiPushToken        @"/auth/pushtoken"

#pragma mark - 融云

#define api_rongcloud_token @"/im/rong/token"   //获取融云Token
#define api_rongcloud_csid  @"/im/rong/csid"    //获取客服Id号

#define api_homepage        @"/home"
#define api_home_more       @"/home/more"
#define api_picker_list     @"/recomm/list"   //达人推荐
#define api_honorlist       @"/honorlist/more"
#define api_category_search @"/product/cate_search"
#define api_query_search    @"/product/query_search"

#define api_adress_list     @"/auth/address/list"
#define api_add_adress      @"/auth/address/create"
#define api_update_adress   @"/auth/address/update"
#define api_delete_adress   @"/auth/address/delete"

#define api_coupon_expired  @"/coupon/expired"  //已过期优惠券
#define api_coupon_untapped @"/coupon/untapped" //未使用优惠券
#define api_coupon_used     @"/coupon/used"     //已使用优惠券

#define api_order_confirm_coupon @"/order/confirm/coupon/"
#define api_post_order_confirm_coupon @"/order/confirm/coupon/"
//扫一扫

#define api_scan_barcode @"/scan/barcode"  //扫描条形码
#define api_qrcode_product @"/scan/qrcode/product" //扫描商品二维码
#define api_qrcode_activity @"/scan/qrcode/activity" //活动二维码

#define api_mynext_list     @"/mynext/list"//我的亲朋
#define api_invitecode_used_list    @"/invitecode/used/list"//我已使用邀请码
#define api_invitecode_untapped_list    @"/invitecode/untapped/list"//我未使用邀请码
#define api_invitecode_upgrade  @"/invitecode/upgrade"   //身份升级
#define api_invitecode_share @"/invitecode/share" //分享邀请码
#define api_sharpsighted    @"/auth/profiles/sharpsighted"

#define api_gold_main_list            @"/auth/profiles/gold/summary"// 我的金币
#define api_auth_profiles_gold_list     @"/auth/profiles/gold/list" //个人金币收支明细
#define api_system_contact_us       @"/system/contact_us"//联系我们
#define apiorderlogistics       @"/order/logistics"

#define  api_im_rong_token      @"/im/rong/token"
#define  api_im_rong_csid       @"/im/rong/csid"
#define api_im_rong_userinfo    @"/im/rong/userinfo"
#pragma mark 商品详情
#define api_product_detial  @"/product/detail/"

//商品标签搜索 - 筛选条件
#define api_label_filter     @"/product/label/filter"
//商品标签查找 - 结果
#define api_label_list      @"/product/label/list"

//商品搜索 - 筛选条件
#define api_query_filter              @"/product/query/filter"
//商品搜索 - 结果
#define api_query_list                  @"/product/query/list"


#define productDetailBuyerList      @"/product/detail/buyer/list"

#define api_IAP                     @"/payback/applepay.notify"


#pragma mark -  帮助中心 

#define api_help_index      @"/help/index.html"   //帮助中心首页
#define api_help_coin       @"/help/coin.html"    //金币帮助
#define api_help_coupon     @"/help/coupon.html"  //优惠劵帮助
#define api_help_invoice    @"/help/invoice.html"
#define api_help_contribution @"/help/ranking.html"
#define api_help_reward      @"/help/reward.html"
#define api_help_share       @"/share/share.html"    //个人中心分享APP给好友地址：
#define api_help_tycoon      @"/help/tycoon.html"    //土豪榜说明地址：

#pragma mark - SHOW

#define api_show_home       @"/show/home"
#define api_show_homeMore       @"/show/homemore"
#define api_show_detail      @"/show/detail/" 

#define api_show_like       @"/show/handle/praise/do"//点赞
#define api_show_unlike     @"/show/handle/praise/cancel" //取消点赞

#define api_show_stamp      @"/show/handle/stamp/do" //踩
#define api_show_unStamp    @"/show/handle/stamp/cancel" //取消踩

#define api_show_comment    @"/show/handle/comment/do" //评论
#define api_show_reply_comment    @"/show/handle/comment/reply" //回复评论
#define api_show_delete_comment    @"/show/handle/comment/delete" //删除评论

#define api_show_inform         @"/show/inform" //举报
#define api_show_reward         @"/show/handle/reward/do" //打赏
#define api_show_delete         @"/show/delete" //删除
#define api_show_reward_info    @"/show/handle/reward/info" //打赏 - 个人可打赏信息

#define api_show_product_goodcode       @"/product/detail/goodcode"  //商品详情 - 通过货号


#pragma mark - 奖励
#define api_reward_list     @"/reward/list"
#define api_reward_accept   @"/reward/accept"


#define api_recomend_praise @"/recomm/praise/do"
#define api_recomend_unPraise @"/recomm/praise/cancel"


#pragma mark 购物车
#define api_myShop_list     @"/cart/list"
#define api_add_shop        @"/cart/add"
#define api_delect_shopProduct  @"/cart/delete"
#define api_set_shop        @"/cart/set"

#define api_buy_arder       @"/order/confirm"
#define api_My_orderList    @"/order/list"
#define api_myOrder_detial  @"/order/detail/"

#define api_order_invoiceInfo   @"/order/invoice/get"
#define api_order_invoice_post          @"/order/invoice/post"


#define orderObligationList    @"/order/after_sales/list"
#define orderMommittedList    @"/order/after_sales/list"
#define orderHasReceivedGoodsList    @"/order/after_sales/list"
#define ordeBusinessList    @"/order/after_sales/list"
#define orderAfter_salesList    @"/order/after_sales/list"


#define api_after_sales     @"/order/after_sales/apply"
#define api_buyAgain        @"/order/buyagain"
#define api_cancle          @"/order/cancel"
#define api_pay             @"/order/pay"
#define api_set_receipt     @"/order/set_receipt"
#define api_atOnce_order    @"/order/save"


#pragma mark - 个人中心

//个人中心首页
#define api_mine_profile     @"/auth/profiles/info"
//修改手机号
#define api_change_phone    @"/auth/profiles/phone"
//修改密码
#define api_change_password @"/auth/profiles/pwd"
//个人资料编辑
#define api_modify_profile @"/auth/profiles/update"


//-------------------------------
// 修改密码
#define api_myChangePassword @"/auth/check/changePwd"
// 修改昵称
#define api_myChangeNickName @"/auth/check/changeNickname"
// 修改头像
#define api_myChangePortrait @"/auth/check/changePortrait"
// 修改性别
#define api_myChangeGender   @"/auth/check/changeGender"
// 获取用户信息
#define api_myPersonalCenter @"/auth/check/personalCenter"
// 修改头像
#define api_myChangePortrait @"/auth/check/changePortrait"
// 意见反馈
#define api_myFeedBack       @"/feedback"
// 获取订单消息和系统消息的个数
#define api_myType_List      @"/message/types"

#define api_system_message_list @"/message/system/list"

#define api_order_message_list @"/message/order/list"

#define api_relative_message_list @"/message/relative/list"

#define api_mynext_report    @"/mynext/report" //内购总额

#define api_mynext_detail    @"/mynext/detail/" 

#define api_setting_notice   @"/mynext/settings/notice" //开启/关闭某亲朋消息
#define api_delete_friend    @"/mynext/delete"  //解除关系


// 获取消息详情
#define api_myList           @"/message/type/list"
// 是否接受推送消息

#define api_upload_portrait   @"/auth/profiles/portrait"
#define apiIssueImage       @"/product/comment/image_upload"
#define apiPostImage        @"/imageupload"
#define apiUrlRegisterStep2 @"/auth/profiles"
#define api_change_image    @"/auth/profiles/change_portrait"


#pragma mark - 团队接口
#define api_group_main      @"/team/myTeamData"
#define apiGroupList        @"/team/list"
#define apiGrroupDist       @"/team/dist"
#define apiGroupJoin        @"/team/join"
#define api_group_list      @"/team/member/mylist"
#define api_group_up_info   @"/team/bulid"
#define api_group_standList @"/team/member/myranking"
#define api_group_get_i     @"/team/myTeamInfo"
#define api_group_new_info  @"/team/updateTeamInfo"
#define api_group_set_style @"/team/initiationSet"
#define api_group_over      @"/team/dismiss"
#define api_group_quit      @"/team/member/quit"
#define api_group_mem_in    @"/team/member/myRole"
#define api_group_people_u  @"/team/member/appoint"
#define api_group_people_d  @"/team/member/delete"
#define api_group_rank      @"/team/honorRank"

#define api_other_group_main      @"/team/nonmember/showTeamInfo"
#define api_other_group_list      @"/team/nonmember/list"
#define api_other_group_rank      @"/team/nonmember/ranking"
#define api_other_group_people    @"/team/nonmember/ranking"


#pragma mark 跑步上传
#define apiRunUplode_personal            @"/run/upload"
#define apiRunUplode_mission           @"/run/upload_mission"
#define api_run_list        @"/run/mylist"
#define api_myRun_d         @"/run/detail/"


#pragma mark 个人信息
#define api_profiles_get    @"/auth/profiles"
#define api_update_nickname @"/auth/profiles/change_nickname"
#define api_update_sex      @"/auth/profiles/change_gender"
#define api_update_headImage  @"/auth/profiles/change_portrait"
#define api_update_birth    @"/auth/profiles/change_birthyear"
#define api_update_sign     @"/auth/profiles/change_signature"
#define api_get_otherInfo   @"/auth/profiles/others"

#define api_feed_back       @"/feedback"
#define api_teamPeople_list @"/auth/record/partner"
#define api_miss_record     @"/auth/record/mission"
#define api_miss_recordInfo @"/auth/record/personalMissionDetail"
#define api_miss_recordInfo_two @"/auth/record/teamMissionDetail"

//点赞
#define api_come_listF      @"/praise/amount/first"
#define api_come_listS      @"/praise/amount/more"
#define api_drange_come     @"/praise/do"
//荣誉
#define api_honor_list      @"/mission/team/glory/first"
#define api_honor_more      @"/mission/team/glory/more"
#define api_other_honor_list    @"/mission/team/glory/otherfirst"
#define api_other_honor_more    @"/mission/team/glory/othermore"
#pragma mark 消息
#define api_message_main    @"/message/home"
#define api_message_list    @"/message/list"

#pragma mark 任务
#define api_mission_list    @"/mission/list"
//个人任务
#define api_personal_takein_list @"/mission/personal/takein_list"
#define api_onemission_out  @"/mission/personal/giveup"
#define api_noHave_missionInfo  @"/mission/personal/receivable"
#define api_haveMissionInfo @"/mission/personal/received"
#define api_get_mission     @"/mission/personal/receive"

//团队任务
#define api_get_team_misson      @"/mission/team/reveice"       //团队任务 - 团队日常任务领取
#define api_team_misson_received @"/mission/team/received"      //团队任务 - 已领团队日常任务详情展示
#define api_team_receivable      @"/mission/team/receivable"    //团队任务 - 未领团队日常任务详情展示
#define api_team_seek_partner    @"/mission/team/seekpartner"   //团队任务求搭档
#define api_team_seek_partner_count @"/mission/team/seekpartner/count" //团队任务 - 统计求搭档的人数
#define api_team_seek_partner_shake @"/mission/team/seekpartner/shake" //摇一摇
#define api_team_partner_record     @"/mission/team/partnerRecord" //搭档记录
#define api_team_takein_list        @"/mission/team/takein_list"       //参加团队列表


#pragma mark - 首页



//#define WAP_URL             @"http://192.168.0.24:8080/sporting-appapi"
#define apiUrlRegisterStep1 @"/register/step1"

#define apiFrgotPassWord    @"/captcha/forgotpwd"
#define apiFrgotUpdateWord  @"/forgotpwd/update"
#define api_profiles_get    @"/auth/profiles"
#define api_update_statues  @"/profiles/update/stature"
#define api_update_weight   @"/profiles/update/weight"
#define api_keep_step       @"/sync/todaystep"

#define api_list            @"/ranklist/all"
#define api_walk_list       @"/ranklist/walk"
#define api_run             @"/sync/freerun"
#define api_run_home        @"/freerun/home"


#define api_attition        @"/attention/recommend"
#define api_get_phone       @"/attention/mobile_contacts"
#define api_price_do        @"/praise/do"
#define api_game_run        @"/gamemap/forward"
#define api_attition_add    @"/attention/do"
#define api_attition_cancel @"/attention/cancel"
#define api_user_detial     @"/user/detail"
#define api_attitionList    @"/attention/list"
#define api_other_a         @"/user/attentionlist"
#define api_fans_list       @"/attention/fans"
#define api_other_f         @"/user/fans"
#define api_come_f          @"/praise/user/first"
#define api_come_s          @"/praise/user/list"


#define api_freeRun_list    @"/freerun/list"

#define api_group_join      @"/team/join"
#define api_group_numFirst  @"/team/ranklist_firstpage"
#define api_group_allList   @"/team/member/myranking"

#define api_group_scorerul  @"/team/scorerule/get"
#define api_group_souc_u    @"/team/scorerule/update"

#define api_start_day       @"/stat/run/day"
#define api_start_week      @"/stat/run/week"
#define api_start_mouth     @"/stat/run/month"

#define api_group_new       @"/team/notice/list"
#define api_group_issue     @"/team/notice/publish"
#define api_group_people_l  @"/team/member/list"
#define api_group_team      @"/team/punchcard/new"
#define api_group_team_r    @"/team/punchcard/refresh"
#define api_group_team_m    @"/team/punchcard/more"
#define api_activity_list   @"/activity/list"
#define api_activity_publ   @"/activity/publish"
#define api_activity_join   @"/activity/join"
#define api_activity_quit   @"/activity/quit"
#define api_activity_detial @"/activity/detail"
#define api_activity_status @"/activity/state"
#define api_activity_begin  @"/activity/begin"
#define api_activity_cancel @"/activity/cancel"
#define api_activity_gprs   @"/activity/checkin/gps"
#define api_activity_qrcode @"/activity/checkin/qrcode"
#define api_activity_Member @"/activity/members"
#define api_activity_getFB  @"/activity/pair/open"
#define api_activity_closeB @"/activity/pair/close"
#define api_activity_firInf @"/activity/pair/info"
#define api_activity_run_li @"/activity/result/list"
#define api_activity_run_up @"/activity/result/upload"

#define apiTokenKey         @"token"
#define apiVersionKey       @"api_version"
#define apiVersionValue     1
#define apiRongCloudToken   @"rcToken"
#define Version             @"version"
#define device              @"device"

#pragma mark SHOW
#define showProductCommentOrderlist     @"/product/comment/orderlist"
#define showPublishBuy_history  @"/show/publish/buy_history"
#define showPublish         @"/show/publish/create"
#define apiproductcommentpublish        @"/product/comment/publish"
#define apiproductcommentreply  @"/product/comment/reply"
#define showPublishImageUplode  @"/show/publish/image_upload"
#define showRank            @"/show/rank"
#define apiShowmessagelist  @"/show/message/list"
#define apiShowMine         @"/show/mine"
#define apiShowOther        @"/show/other"
#define apishowhandlepraiselist     @"/show/handle/praise/list"
#define apishowhandlerewardlist     @"/show/handle/reward/list"
#define apiShowHandleStampList      @"/show/handle/stamp/list"
#define apiproductdetailcomments    @"/product/detail/comments"
#define apishowhandlerewardinfo     @"/order/coin/info"
#define apiordercoinsave            @"/order/coin/save"
#define apiCoinHelpNotice               @"/help/notice.html"

#define apihelptycoon               @"/help/tycoon.html"
#define apiOrderCarriagePost        @"/order/carriage/post"

#define api_grade_html  @"/grade/index.html"

#endif /* HTTPApi_h */
