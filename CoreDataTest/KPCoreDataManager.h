//
//  KPCoreDataManager.h
//  KupingGame
//
//  Created by huayu on 15/3/16.
//  Copyright (c) 2015年 ZhuJiaQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KPCoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel          *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext        *mainManagedObjectContext;

+ (instancetype)shareInstance;

/**
 *  初始化CoreData
 *
 *  @param modelName 模型文件名
 */

- (void)setupWithModelName:(NSString *)modelName;

/**
 *  主线程使用
 *
 */
- (NSManagedObjectContext *)mainManagedObjectContext;

/**
 *  多线程使用
 *
 */
- (NSManagedObjectContext *)privateManagedObjectContext;

- (void)saveWithContext:(NSManagedObjectContext *)context;



@end
