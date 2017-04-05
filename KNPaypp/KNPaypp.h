//
//  KNPaypp.h
//  KNPayppExample
//
//  Created by 吴申超 on 2017/4/5.
//  Copyright © 2017年 DengYun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KNPayppErrorOption) {
    KNPayppErrInvalidCharge,
    KNPayppErrInvalidCredential,
    KNPayppErrInvalidChannel,
    KNPayppErrWxNotInstalled,
    KNPayppErrWxAppNotSupported,
    KNPayppErrCancelled,
    KNPayppErrUnknownCancel,
    KNPayppErrViewControllerIsNil,
    KNPayppErrTestmodeNotifyFailed,
    KNPayppErrChannelReturnFail,
    KNPayppErrConnectionError,
    KNPayppErrUnknownError,
    KNPayppErrActivation,
    KNPayppErrRequestTimeOut,
    KNPayppErrProcessing,
    KNPayppErrQqNotInstalled,
};

@interface KNPayppError : NSObject

@property(nonatomic, readonly) KNPayppErrorOption code;

- (NSString *)errMsg;

@end

typedef void (^KNPayppCompletion)(NSString *result, KNPayppError *error);

@interface KNPaypp : NSObject


/**
 支付调用接口(支付宝／微信)

 @param charge 支付charge
 @param scheme URL Scheme，支付宝渠道回调需要
 @param completion 支付结果回调
 */
+ (void)createPayment:(NSObject *)charge
         appURLScheme:(NSString *)scheme
       withCompletion:(KNPayppCompletion)completion;



/**
 回掉结果接口

 @param url 结果url
 @param completion 支付结果回掉
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(KNPayppCompletion)completion;
@end
