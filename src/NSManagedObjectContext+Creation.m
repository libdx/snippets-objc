//
//  NSManagedObjectContext+Creation.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 3/2/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "NSManagedObjectContext+Creation.h"

@implementation NSManagedObjectContext (Creation)

+ (instancetype)rootManagedObjectContext {
    return [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
}

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator {
    @throw InternalInconsistencyException(StringWithFormat(@"overwrite %@ in subclass", NSStringFromSelector(_cmd)));
}

@end
