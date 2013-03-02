//
//  ExampleManagedObjectContext.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 3/2/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "ExampleManagedObjectContext.h"

@implementation ExampleManagedObjectContext (Creation)

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator {
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
    return store;
}

@end

@implementation ExampleManagedObjectContext

@end
