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

static NSManagedObjectContext *getAssociatedContext(NSThread *thread, NSString *key)
{
    return objc_getAssociatedObject(thread, (__bridge const void *)key);
}

static void setAssociatedContext(NSThread *thread, NSManagedObjectContext *ctx, NSString *key)
{
    objc_setAssociatedObject(thread, (__bridge const void *)key, ctx, OBJC_ASSOCIATION_RETAIN);
}

+ (NSManagedObjectContext *)threadContext
{
    NSThread *thread = [NSThread currentThread];
    NSString *ThreadContextKey = [@"threadContext" stringByAppendingString:NSStringFromClass(self)];
    NSManagedObjectContext *ctx = getAssociatedContext(thread, ThreadContextKey);
    if (ctx == nil) {
        if (thread.isMainThread) {
            NSString *const RootContextKey = [@"rootContext" stringByAppendingString:NSStringFromClass(self)];
            ctx = getAssociatedContext(thread, RootContextKey);
            if (ctx == nil)
                ctx = [self rootManagedObjectContext];
            if (ctx.concurrencyType == NSPrivateQueueConcurrencyType) {
                // create one more context with NSMainQueueConcurrencyType
                // and assign them both to main thread instance
                setAssociatedContext(thread, ctx, RootContextKey);
                ctx = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            }
        } else {
            ctx = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            ctx.parentContext = objc_getAssociatedObject([NSThread mainThread], (__bridge const void *)ThreadContextKey);
        }
        objc_setAssociatedObject(thread, (__bridge const void *)ThreadContextKey, ctx, OBJC_ASSOCIATION_RETAIN);
    }
    return ctx;
}

- (instancetype)newChildContext
{
    NSManagedObjectContextConcurrencyType *ct = NSPrivateQueueConcurrencyType;
    if ([NSThread isMainThread])
        ct = NSMainQueueConcurrencyType;
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:ct];
    ctx.parentContext = self;
    return ctx;
}

- (instancetype)newBackgroundChildContext
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
