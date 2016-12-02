//
//  hFMManager.m
//  HomeForPets
//
//  Created by Admin on 2016/11/13.
//  Copyright © 2016年 侯迎春. All rights reserved.
//



#import "hFMManager.h"

static NSString *const com = @"Documents"; //文档夹
static NSString *const tmp = @"tmp";       //临时文件夹
static NSString *const lib = @"Library";   //资源文件夹

@interface hFMManager()



@property(nonatomic,strong,readwrite)NSFileManager *FM;
// 当前app的沙盒目录
@property(nonatomic,strong,readwrite)NSString * homePath;
// 临时文件夹
@property (nonatomic,strong,readwrite) NSString *temPath;

@end

@implementation hFMManager

+ (instancetype) shareFMManager{
    static hFMManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[hFMManager alloc]init];
        manager.FM = [NSFileManager defaultManager];
        manager.homePath = NSHomeDirectory();
        manager.temPath = [manager.homePath stringByAppendingPathComponent:tmp];
    });
    return manager;
}


// 判断文件是否有效
- (BOOL) hFileExistsAtPath:(NSString *)path {
    BOOL isValid;
    
    isValid = [self.FM fileExistsAtPath:path];
    
    return isValid;
}


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
- (BOOL) hFileExistsFolderAtPath:(NSString*)path isCreate:(BOOL)isCreate{
    BOOL isValid;
    
    isValid = [self.FM fileExistsAtPath:path isDirectory:&isValid];
    
    if (isCreate && !isValid) {
        isValid = [self hFileCreateFolderWithPath:path];
    }
    
    
    return isValid;
}


//创建文件夹
- (BOOL) hFileCreateFolderWithPath:(NSString*)path{
    BOOL isSuccess;
    isSuccess=  [self.FM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    return isSuccess;
    
   // attributes参数是一个字典类型。查看苹果官方文档的介绍，可以看到在NSFileManager.h头文件定义了很多常量字符串，用于作为attributes字典的键，针对于这个接口的键主要包括下面几个：
    
//    NSString * const NSFileType;
//    NSString * const NSFileSize;
//    NSString * const NSFileModificationDate;
//    NSString * const NSFileReferenceCount;
//    NSString * const NSFileDeviceIdentifier;
//    NSString * const NSFileOwnerAccountName;
//    NSString * const NSFileGroupOwnerAccountName;
//    NSString * const NSFilePosixPermissions;
//    NSString * const NSFileSystemNumber;
//    NSString * const NSFileSystemFileNumber;
//    NSString * const NSFileExtensionHidden;
//    NSString * const NSFileHFSCreatorCode;
//    NSString * const NSFileHFSTypeCode;
//    NSString * const NSFileImmutable;
//    NSString * const NSFileAppendOnly;
//    NSString * const NSFileCreationDate;
//    NSString * const NSFileOwnerAccountID;
//    NSString * const NSFileGroupOwnerAccountID;
//    NSString * const NSFileBusy;
//    本文不打算翻译苹果的官方文档，只把我们比较关心的几个键的意义说明如下：
//    
//    NSFileAppendOnly
//    这个键的值需要设置为一个表示布尔值的NSNumber对象，表示创建的目录是否是只读的。
//    
//    NSFileCreationDate
//    这个键的值需要设置为一个NSDate对象，表示目录的创建时间。
//    
//    NSFileOwnerAccountName
//    这个键的值需要设置为一个NSString对象，表示这个目录的所有者的名字。
//    
//    NSFileGroupOwnerAccountName
//    这个键的值需要设置为一个NSString对象，表示这个目录的用户组的名字。
//    
//    NSFileGroupOwnerAccountID
//    这个键的值需要设置为一个表示unsigned int的NSNumber对象，表示目录的组ID。
//    
//    NSFileModificationDate
//    这个键的值需要设置一个NSDate对象，表示目录的修改时间。
//    
//    NSFileOwnerAccountID
//    这个键的值需要设置为一个表示unsigned int的NSNumber对象，表示目录的所有者ID。
//    
//    NSFilePosixPermissions
//    这个键的值需要设置为一个表示short int的NSNumber对象，表示目录的访问权限。
//    
//    NSFileReferenceCount
//    这个键的值需要设置为一个表示unsigned long的NSNumber对象，表示目录的引用计数，即这个目录的硬链接数。
//    
//    这样，通过合理的设计attributes字典中的不同键的值，这个接口所创建的目录的属性就会基本满足我们的需求了。
}


- (NSString *)getPath:(NSString*)path{
    NSString * newPath = self.homePath;
    
    // 按照关键字"/" 分为数组
    NSArray  *pathArr = [path componentsSeparatedByString:@"/"];

    BOOL ishave = NO;
    for (int i = 0; i<pathArr.count; i++) {
        NSString *st = pathArr[i];
        if ([st isEqualToString:com] || [st isEqualToString:tmp]) {
            ishave = YES;
        }
        if (ishave) {
            newPath = [newPath stringByAppendingFormat:@"/%@",st];
        }
    }
    
    return newPath;
}
@end











