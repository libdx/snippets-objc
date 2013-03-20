//
//  ExampleManagedPool.m
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import "ExampleManagedObjectContextPool.h"

@implementation ExampleManagedObjectContextPool
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

+ (ExampleManagedObjectContextPool *)sharedPool
{
    static ExampleManagedObjectContextPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[ExampleManagedObjectContextPool alloc] init];
    });
    return pool;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExampleModel" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSDictionary *opts = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                               NSInferMappingModelAutomaticallyOption : @YES};
        NSString *storePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        storePath = [storePath stringByAppendingPathComponent:@"ExampleDatabase.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        LogOnError(error, [store addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeURL
                                                    options:opts
                                                      error:&error]);
        _persistentStoreCoordinator = store;
    }
    return _persistentStoreCoordinator;
}

@end
