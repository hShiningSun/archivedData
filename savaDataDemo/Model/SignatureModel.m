//
//  SignatureModel.m
//  savaDataDemo
//
//  Created by Admin on 2016/12/2.
//  Copyright © 2016年 asd. All rights reserved.
//

#import "SignatureModel.h"
#import <objc/message.h>
#import "hFMManager.h"

static NSString * const Signature = @"Signature";

@implementation SignatureModel


/**
 *  归档
 *
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //归档存储自定义对象
    unsigned int count = 0;
    //获得指向该类所有属性的指针
    objc_property_t *properties =     class_copyPropertyList([SignatureModel class], &count);
    for (int i =0; i < count; i ++) {
        //获得
        objc_property_t property = properties[i];        //根据objc_property_t获得其属性的名称--->C语言的字符串
        const char *name = property_getName(property);
        NSString *key = [NSString   stringWithUTF8String:name];
        //      编码每个属性,利用kVC取出每个属性对应的数值
        [aCoder encodeObject:[self valueForKeyPath:key] forKey:key];
}
}


/**
 *  解档
 *
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    //归档存储自定义对象
    unsigned int count = 0;
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([SignatureModel class], &count);
    for (int i =0; i < count; i ++) {
        objc_property_t property = properties[i];        //根据objc_property_t获得其属性的名称--->C语言的字符串
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];        //解码每个属性,利用kVC取出每个属性对应的数值
        [self setValue:[aDecoder decodeObjectForKey:key] forKeyPath:key];
    }
    return self;
}



// 得到保存签名的路径，如果需要保存
+ (void)ifNeedSavePathWithUserId:(NSString*)userId contentObj:(SignatureModel*)obj{
    
    // 初始存放临时文件的路径
    NSString * originalTmpPath = kFMManager.temPath;
    
    // 需要保存的文件夹路径
    NSString * folderPath = [originalTmpPath stringByAppendingPathComponent:Signature];//Signature;;
    
    // 需要保存的文件路径
    NSString * filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@.dat",userId]];
    
    // 是否有这个文件夹了
    if ([kFMManager hFileExistsFolderAtPath:folderPath isCreate:YES]) {
        //判断是否有文件了
        if ([kFMManager hFileExistsAtPath:filePath]) {
            
            //获取已经保存的
            NSMutableArray<SignatureModel *> *oldFileArr = [SignatureModel analysisCodeWithPath:filePath];
            
            BOOL ishave = NO;//是否有这个客户的id
            
            //是否有重复的
            for (SignatureModel *currentObj in oldFileArr) {
                if ([obj.clienteleId isEqualToString:currentObj.clienteleId]) {
                    ishave = YES;
                }
            }
            
            //没有，添加归档
            if (!ishave) {
                [oldFileArr addObject:obj];
                //归档
                if([NSKeyedArchiver archiveRootObject:oldFileArr toFile:filePath]){
                    NSLog(@"归档成功");
                }
                else{
                    NSLog(@"归档失败");
                }
            }
            
            
        }
        else{
            // 还没有文件，创建归档保存
            NSMutableArray<SignatureModel *> *newFileArray = [NSMutableArray arrayWithCapacity:1];
            [newFileArray addObject:obj];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newFileArray];
            
            if ([kFMManager.FM createFileAtPath:filePath contents:data attributes:nil]){
                NSLog(@"保存陈宫");
            }
            else{
                NSLog(@"保存失败");
            }
            
        }
    }
    
    
}


+ (NSMutableArray<SignatureModel *>*) analysisCodeWithPath:(NSString*)path{
    //NSData *data = [NSData dataWithContentsOfFile:path];
    //装的是数组
    NSMutableArray<SignatureModel*> *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return arr;
}



+ (NSMutableArray<SignatureModel*>*) getSignatureModelArrayWithUserID:(NSString*)userId{
    // 初始存放临时文件的路径
    NSString * originalTmpPath = kFMManager.temPath;
    
    // 需要保存的文件夹路径
    NSString * folderPath = [originalTmpPath stringByAppendingPathComponent:Signature];//Signature;;
    
    // 需要保存的文件路径
    NSString * filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@.dat",userId]];
    
    
    NSMutableArray<SignatureModel *> *saveOldFileArr;
    //判断是否有文件了
    if ([kFMManager hFileExistsAtPath:filePath]) {
        
        //获取已经保存的
        saveOldFileArr = [SignatureModel analysisCodeWithPath:filePath];
    }
    
    return  saveOldFileArr;
}


+ (void) deleteObjWithContentPathAtUserId:(NSString *)userId contentObj:(SignatureModel*)obj{
    NSString * originalTmpPath = kFMManager.temPath;
    
    // 需要保存的文件夹路径
    NSString * folderPath = [originalTmpPath stringByAppendingPathComponent:Signature];//Signature;;
    
    // 需要保存的文件路径
    NSString * filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@.dat",userId]];
    
    
    NSMutableArray<SignatureModel *> *saveOldFileArr;
    //判断是否有文件了
    if ([kFMManager hFileExistsAtPath:filePath]) {
        
        //获取已经保存的
        saveOldFileArr = [SignatureModel analysisCodeWithPath:filePath];
        
        
        
        SignatureModel *deleteObj;
        //是否有重复的
        for (SignatureModel *currentObj in saveOldFileArr) {
            if ([obj.clienteleId isEqualToString:currentObj.clienteleId]) {
                deleteObj = currentObj;
            }
        }
        if (deleteObj) {
            [saveOldFileArr removeObject:deleteObj];
            
            if([NSKeyedArchiver archiveRootObject:saveOldFileArr toFile:filePath]){
                NSLog(@"删除归档的一条数据成功");
            }
            else{
                NSLog(@"删除归档的一条数据失败");
            }
        }

    }
    

}
@end








