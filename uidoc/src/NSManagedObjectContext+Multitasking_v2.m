//
//  NSManagedObjectContext+Multitasking.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 2/27/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <objc/runtime.h>
#import "NSManagedObjectContext+Multitasking.h"
#import "NSManagedObjectContext+Creation.h"

@implementation NSManagedObjectContext (Multitasking)

- (id)objectThroughContext:(NSManagedObject *)object
{
    return [self objectWithID:object.objectID];
}

+ (instancetype)mainContext
{
    id ctx;
    @synchronized(self) {
        const void *rootKey = (__bridge const void *)NSStringFromClass(self);
        id rootCtx = objc_getAssociatedObject([NSThread mainThread], rootKey);
        if (rootCtx == nil) {
            rootCtx = [self rootManagedObjectContext];
            objc_setAssociatedObject([NSThread mainThread], rootKey, rootCtx, OBJC_ASSOCIATION_RETAIN);
        }
        ctx = objc_getAssociatedObject(rootCtx, "mainContext");
        if (ctx == nil) {
            ctx = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [ctx setParentContext:rootCtx];
            objc_setAssociatedObject(rootCtx, "mainContext", ctx, OBJC_ASSOCIATION_RETAIN);
        }
    }
    return ctx;
}

- (NSManagedObjectContext *)newChildContext
{
    NSManagedObjectContextConcurrencyType *ct = NSPrivateQueueConcurrencyType;
    if ([NSThread isMainThread])
        ct = NSMainQueueConcurrencyType;
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:ct];
    ctx.parentContext = self;
    return ctx;
}

- (NSManagedObjectContext *)newBackgroundChildContext
{
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc]
                                   initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    ctx.parentContext = self;
    return ctx;
}

- (void)recursiveSaveTrackingErrors:(void (^)(NSError *error))tracker
{
    [self performBlock:^{
        NSError *error;
        if (![self save:&error]) {
            if (tracker) {
                tracker(error);
            }
        } else if (self.parentContext) {
            [self.parentContext recursiveSaveTrackingErrors:tracker];
        }
    }];
}
@end
