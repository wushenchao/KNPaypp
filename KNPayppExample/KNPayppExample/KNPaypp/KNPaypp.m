//
//  KNPaypp.m
//  KNPayppExample
//
//  Created by 吴申超 on 2017/4/5.
//  Copyright © 2017年 DengYun. All rights reserved.
//

#import "KNPaypp.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>

#define KNPayppAlipayKey @"safepay"

@interface KNPayWxRes : NSObject<WXApiDelegate>

+ (instancetype)shareInstance;

@end

@implementation KNPayWxRes

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static KNPayWxRes *instance;
    dispatch_once(&onceToken, ^{
        instance = [[KNPayWxRes alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeCommon:
                break;
            case WXErrCodeUserCancel:
                break;
            case WXErrCodeSentFail:
                break;
            case WXErrCodeAuthDeny:
                break;
            case WXErrCodeUnsupport:
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

@end

@interface KNPayppError ()

@property(nonatomic, readwrite) KNPayppErrorOption code;

@end

@implementation KNPayppError

- (NSString *)errMsg {
    return @"";
}

@end

@implementation KNPaypp

+ (BOOL)registerWxApp:(NSString *)appId {
    return [WXApi registerApp:appId];
}


/**
 支付调用接口(支付宝／微信)
 
 @param charge 支付charge
 @param scheme URL Scheme，支付宝渠道回调需要
 @param completion 支付结果回调
 */
+ (void)createPayment:(id)charge
         appURLScheme:(NSString *)scheme
       withCompletion:(KNPayppCompletion)completion {
    if ([charge isKindOfClass:[NSString class]]) {
        [[AlipaySDK defaultService] payOrder:charge fromScheme:scheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    else { //调起微信支付
        NSDictionary *dict = charge;
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = dict[@"partnerid"];
        req.prepayId = dict[@"prepayid"];
        req.nonceStr = dict[@"noncestr"];
        req.package = dict[@"package"];
        req.sign = dict[@"sign"];
        NSString *stamp = dict[@"timestamp"];
        req.timeStamp = stamp.intValue;
        [WXApi sendReq:req];
    }
}


/**
 回掉结果接口
 
 @param url 结果url
 @param completion 支付结果回掉
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(KNPayppCompletion)completion {
    NSString *urlHost = url.host;
    if ([urlHost isEqualToString:KNPayppAlipayKey]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    else {
        return [WXApi handleOpenURL:url delegate:[KNPayWxRes shareInstance]];
    }
    return YES;
}


@end
