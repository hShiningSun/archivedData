//
//  SignatureModel.h
//  savaDataDemo
//
//  Created by Admin on 2016/12/2.
//  Copyright © 2016年 侯迎春. All rights reserved.
//


#import <Foundation/Foundation.h>

//保存需要的签名model  保证通用使用nsstring
@interface SignatureModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString* userId;//用户id

@property (nonatomic, strong) NSString* clienteleId;//需要保存签名的客户id

@property (nonatomic, strong) NSData * signatureData;//签名内容


// 生成一条需要缓存的签名数据保存到本地，填上当前app的用户userid
+ (void)ifNeedSaveFileWithUserId:(NSString*)userId contentObj:(SignatureModel*)obj;

// 得到当前用户的 所有缓存签名对象组成的数组
+ (NSMutableArray<SignatureModel*>*) getSignatureModelArrayWithUserID:(NSString*)userId;

// 删除一条缓存的签名数组
+ (void) deleteObjWithContentPathAtUserId:(NSString *)userId contentObj:(SignatureModel*)obj;
@end
