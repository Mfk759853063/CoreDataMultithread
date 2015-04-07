//
//  ViewController.m
//  CoreDataTest
//
//  Created by zhou Can on 15/3/15.
//  Copyright (c) 2015年 zhou Can. All rights reserved.
//

#import "ViewController.h"
#import "KPCoreDataManager.h"
#import "TestObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSManagedObjectContext *aa = [[KPCoreDataManager shareInstance] privateManagedObjectContext];
        [aa performBlock:^{
            __block int i = 0;
            while (i<100000) {
                
                TestObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"TestObject" inManagedObjectContext:aa];
                NSString *ident = [NSString stringWithFormat:@"%d",i];
                obj.name = ident;
                i++;
                
            }
            [[KPCoreDataManager shareInstance] saveWithContext:aa];
            NSLog(@"子线程aa中执行完成");
            NSManagedObjectContext *manContext = [[KPCoreDataManager shareInstance] mainManagedObjectContext];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestObject"];
            NSArray *fetchs = [manContext executeFetchRequest:request error:nil];
            NSLog(@"主线程aa中查询 %ld",(long)fetchs.count);
            
        }];
        
        NSManagedObjectContext *bb = [[KPCoreDataManager shareInstance] privateManagedObjectContext];
        [bb performBlock:^{
            __block int i = 0;
            while (i<1000) {
                NSString *ident = [NSString stringWithFormat:@"%d",i];
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestObject"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"self.name == %@",ident]];
                NSArray *fetchs = [bb executeFetchRequest:request error:nil];
                if (fetchs.firstObject) {
                    [bb deleteObject:fetchs.firstObject];
                }
                i++;
                
            }
            [[KPCoreDataManager shareInstance] saveWithContext:bb];
            NSLog(@"子线程bb中删除完成");
            NSManagedObjectContext *manContext = [[KPCoreDataManager shareInstance] mainManagedObjectContext];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestObject"];
            NSArray *fetchs = [manContext executeFetchRequest:request error:nil];
            NSLog(@"主线程bb中查询 %ld",(long)fetchs.count);
            
        }];

        
    });

    
}

-(void)dealloc
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
