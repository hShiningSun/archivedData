//
//  hFMManager.h
//  HomeForPets
//
//  Created by Admin on 2016/11/13.
//  Copyright © 2016年 侯迎春. All rights reserved.
//

//宏
#define kFMManager    [hFMManager shareFMManager]
// 文件操作
#import <Foundation/Foundation.h>

@interface hFMManager : NSFileManager
//管理器
@property(nonatomic,strong,readonly)NSFileManager *FM;

//当前app的沙盒目录
@property(nonatomic,strong,readonly)NSString * homePath;

//临时文件夹
@property (nonatomic,strong,readonly) NSString *temPath;

//单例
+ (instancetype) shareFMManager;

/**
 *  文件是否有效
 *
 *  @param  path
 *  路径
 */
- (BOOL) hFileExistsAtPath:(NSString *)path;

/**
 *  判断文件夹是否有效
 *
 *  @param  path
 *  路径
 *
 *  @param  isCreate
 *  无效是否创建
 *
 */
- (BOOL) hFileExistsFolderAtPath:(NSString*)path isCreate:(BOOL)isCreate;

//创建文件夹
- (BOOL) hFileCreateFolderWithPath:(NSString*)path;

@end






