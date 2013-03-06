//
//  ManagedPool.m
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import <objc/runtime.h>

#import "ManagedObjectContextPool.h"

@interface NSThread (ManagedPool)
- (NSManagedObjectContext *)associatedContext;
- (void)setAssociatedContext:(NSManagedObjectContext *)ctx;
@end

@implementation NSThread (ManagedPool)
- (NSManagedObjectContext *)associatedContext {
    return objc_getAssociatedObject(self, @"threadContext");
}
- (void)setAssociatedContext:(NSManagedObjectContext *)ctx {
    objc_setAssociatedObject(self, @"threadContext", ctx, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation ManagedObjectContextPool

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    @throw InternalInconsistencyException(@"override in subclass");
}

- (NSManagedObjectContext *)threadContext
{
    NSManagedObjectContext *ctx = [[NSThread currentThread] associatedContext];
    if (ctx == nil) {
        ctx = [[NSManagedObjectContext alloc] init];
        [[NSThread currentThread] setAssociatedContext:ctx];
        ctx.persistentStoreCoordinator = [self persistentStoreCoordinator];
        if (NO == [NSThread isMainThread]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChangesWithMainContext:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:ctx];
        }
    }
    return ctx;
}

- (NSManagedObjectContext *)newChildContext
{
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
    ctx.persistentStoreCoordinator = [self persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChangesWithCurrentContext:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:ctx];
    return ctx;
}

- (void)mergeChangesWithMainContext:(NSNotification *)notification
{
    @synchronized(self) {
        NSManagedObjectContext *mainThreadCtx = [[NSThread mainThread] associatedContext];
        if (mainThreadCtx == nil)
            @throw InternalInconsistencyException(@"-threadContext at first time should be called from main thread");
        [self performSelector:@selector(mergeChanges:)
                     onThread:[NSThread mainThread]
                   withObject:@{@"context" : mainThreadCtx, @"context" : notification}
                waitUntilDone:NO];
    }
}

- (void)mergeChangesWithCurrentContext:(NSNotification *)notification
{
    @synchronized(self) {
        NSManagedObjectContext *ctx = [[NSThread currentThread] associatedContext];
        [self performSelector:@selector(mergeChanges:)
                     onThread:[NSThread currentThread]
                   withObject:@{@"context" : ctx, @"notification" : notification}
                waitUntilDone:YES];
    }
}

- (void)mergeChanges:(NSDictionary *)objects
{
    trace(@"thread %@; is main: %d", [NSThread currentThread], [NSThread isMainThread]);
    NSManagedObjectContext *ctx = objects[@"context"];
    NSNotification *notification = objects[@"notification"];
    [ctx mergeChangesFromContextDidSaveNotification:notification];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}

@end
