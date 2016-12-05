//
//  ViewController.m
//  savaDataDemo
//
//  Created by Admin on 2016/12/2.
//  Copyright © 2016年 asd. All rights reserved.
//

#import "ViewController.h"
#import "hFMManager.h"
#import "SignatureModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@""];
    NSData *data = UIImagePNGRepresentation(img);
    
    

    SignatureModel *obj = [[SignatureModel alloc]init];
    obj.userId = @"1";//这个是登陆app的id
    obj.clienteleId = @"1";//客户的id
    obj.signatureData = data;
    
        
        
    //先删除，如果以前缓存有这条数据
    [SignatureModel deleteObjWithContentPathAtUserId:@"1" contentObj:obj];
    //生成 签名对象 缓存
    [SignatureModel ifNeedSaveFileWithUserId:@"1" contentObj:obj];//这里传的是登陆用户的id
    
    
    
    //获取以前缓存的数据
    NSMutableArray *xx = [SignatureModel getSignatureModelArrayWithUserID:@"1"];
    SignatureModel *obj1 = xx[0];
    //好了，吧obj1的数据上传
    
    
    //这里上传成功，从缓存的数据删除这一条
    [SignatureModel deleteObjWithContentPathAtUserId:@"1" contentObj:obj1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
