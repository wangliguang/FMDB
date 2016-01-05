//
//  ViewController.m
//  FMDB
//
//  Created by GG on 16/1/5.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
@interface ViewController ()
{
    FMDatabase *db;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    path = [path stringByAppendingString:@"/testDB.sqlite"];
    
    NSLog(@"%@",path);
    
    //指定路径创建一个数据库
    db = [FMDatabase databaseWithPath:path];
    
    //在数据库中创建一个表
    [self creatTable];
    
    
}

- (void)creatTable{
    
    if([db open]) { //打开数据库  open方法会返回一个BOOL值，返回YES表明数据库打开成功
        
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (name text, age integer);"]; //创建一个表，表里有名字和年龄
        
        if(result) {
            
            NSLog(@"建表成功");
            
        }else{
            
            NSLog(@"建表失败原因%@",[db lastErrorMessage]);
            
        }
        
        [db close]; //关闭数据库
        
    }else{
        
        NSLog(@"打开数据库失败原因%@",[db lastErrorMessage]);
    }
    
    [self insert:@"success" WithAge:@12];

}

- (void)insert:(NSString *)name WithAge:(NSNumber *)age{
    
    
    if([db open]) { //打开数据库  open方法会返回一个BOOL值，返回YES表明数据库打开成功
        
        //在表中插入数据
        BOOL result =  [db executeUpdate:@"INSERT INTO student (name, age) VALUES (?, ?);", name, age];
    
        
        if(result) {
            
            NSLog(@"插入数据成功");
            
        }else{
            
            NSLog(@"插入数据失败原因%@",[db lastErrorMessage]);
            
        }
        
        [db close]; //关闭数据库
        
    }else{
        
        NSLog(@"打开数据库失败原因%@",[db lastErrorMessage]);
    }
 
    
}

- (void)queryData{
    
    if([db open]) { //打开数据库  open方法会返回一个BOOL值，返回YES表明数据库打开成功
        
        //在表中插入数据，将查询到的结果都放在FMResultSet中
        FMResultSet *result =  [db executeQuery:@"SELECT * FROM student"];
        
        //通过结果集的next方法遍历结果
        while ([result next]) {
            
            //通过列名来取数据
            NSLog(@"%@",[result stringForColumn:@"name"]);
            //通过列的下标来取数据
            NSLog(@"%@",[result objectForColumnIndex:1]);
            
            
            
            
        }
        
        [db close]; //关闭数据库
        
    }else{
        
        NSLog(@"打开数据库失败原因%@",[db lastErrorMessage]);
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self queryData];
}

@end
