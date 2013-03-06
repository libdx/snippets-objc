//
//  ManagedPool.h
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedObjectContextPool : NSObject

- (NSManagedObjectContext *)threadContext;
- (NSManagedObjectContext *)newChildContext;

@end

@class ManagedObjectsFetcher;

@interface NSManagedObjectContext (Additions)
- (id)insertEntityWithName:(NSString *)name;
- (ManagedObjectsFetcher *)fetcherForEntityWithName:(NSString *)name;
@end

@interface ManagedObjectsFetcher
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSEntityDescription *entity;
- (NSArray *)fetchWithRequest:(NSFetchRequest *)request;
- (NSArray *)fetchWithSortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate;
- (NSArray *)fetchWithPredicate:(NSPredicate *)predicate;
// count
@end
