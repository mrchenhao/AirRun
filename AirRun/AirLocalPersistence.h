//
//  AirLocalPersistence.h
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>
#import "BlockMacro.h"

/**
 *  本地持久化模型
 */
@interface AirLocalPersistence : NSObject

/**
 *  获得单例对象
 *
 *  @return 单例对象
 */
+ (instancetype)shareLocalPersistenceInstance;

- (void)createObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)deleteObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)updateObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)findAllObjects:(Class )cla WithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;


@end
